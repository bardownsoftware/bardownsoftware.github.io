//
//  Created by bwk on Wed.24.Aug.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import XCTest

@testable import Timer

class TimerTests: XCTestCase {

    var entityCount: UInt = 0

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        entityCount = DataModel.sharedInstance.fetchTimerEntityCount()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

        XCTAssert(entityCount == DataModel.sharedInstance.fetchTimerEntityCount())
    }

    func testTotalTime() {
        let timerEngine = TimerEngine()

        var timerEntities: [TimerEntity] = []

        //  Count, duration, rest, delay, expected total time.
        //
        let testValues: [(Int, Int, Int, Int, Int)] = [
            (1, 60,  0, 0, 60),
            (5, 40,  0, 0, 200),
            (9, 30, 10, 0, 350),

            (1, 60,  0, 10, 70),
            (5, 40,  0, 20, 220),
            (9, 30, 10, 30, 380),

            (3, 20,  5, 5, 75),
            (2, 10,  4, 10, 34)
        ]

        var index: Int = 0
        for (count, duration, rest, delay, expectedTotalTime) in testValues {

            let timerEntity = DataModel.sharedInstance.createTimerEntity(
                "Test Timer \(index)",
                count: count, duration: duration, rest: rest, delay: delay)!
            timerEngine.timerEntity = timerEntity
            let totalTime = timerEngine.getTotalTime()
            XCTAssert(expectedTotalTime == totalTime, "# EXPECTED \(expectedTotalTime) GOT \(totalTime)")

            timerEntities.append(timerEntity)

            index = index + 1
        }

        //  Remove all test entities.
        //
        for timerEntity in timerEntities {
            DataModel.sharedInstance.deleteTimerEntity(timerEntity)
        }
    }

    func assertTimer(count: Int, duration: Int, rest: Int, delay: Int,
                 totalTime: Int,
                 testValues: [([Double], TimerEngineState, Int)]) {

        let timerEngine = TimerEngine()

        let timerEntity = DataModel.sharedInstance.createTimerEntity(
            "Test Timer",
            count: count, duration: duration, rest: rest, delay: delay)!

        timerEngine.timerEntity = timerEntity

        XCTAssert(totalTime == timerEngine.getTotalTime());

        for (intervals, expectedState, expectedRound) in testValues {
            for interval in intervals {
                let (state, round) = timerEngine.getState(fromInterval: interval)
                XCTAssert(state == expectedState && round == expectedRound)
            }
        }

        DataModel.sharedInstance.deleteTimerEntity(timerEntity)
    }

    func testTimerEngine() {

        assertTimer(count: 1, duration: 50, rest: 0, delay: 0,
                    totalTime: 50,
                    testValues: [
                        ([-0.01, 50.01], .idle, 0),
                        ([0, 0.01, 49.99, 50], .go, 0),
            ])

        assertTimer(count: 10, duration: 10, rest: 0, delay: 0,
                    totalTime: 100,
                    testValues: [
                        ([-0.01, 100.01], .idle, 0),
                        ([0, 0.01, 9.99, 10], .go, 0),
                        ([10.01, 19.99, 20], .go, 1),
                        ([20.01, 29.99, 30], .go, 2),
                        ([30.01, 39.99, 40], .go, 3),
                        ([40.01, 49.99, 50], .go, 4),
                        ([50.01, 59.99, 60], .go, 5),
                        ([60.01, 69.99, 70], .go, 6),
                        ([70.01, 79.99, 80], .go, 7),
                        ([80.01, 89.99, 90], .go, 8),
                        ([90.01, 99.99, 100], .go, 9),
            ])

        assertTimer(count: 3, duration: 20, rest: 5, delay: 5,
                    totalTime: 75,
                    testValues: [
                        ([-10.0, -1.9, -0.01, 75.01, 80], .idle, 0),
                        ([0, 0.01, 4.99, 5], .getReady, 0),
                        ([5.01, 24.99, 25], .go, 0),
                        ([25.01, 29.99, 30], .rest, 0),
                        ([30.01, 49.99, 50.0], .go, 1),
                        ([50.01, 54.99, 55], .rest, 1),
                        ([55.01, 74.99, 75], .go, 2),
            ])

        assertTimer(count: 1, duration: 60, rest: 0, delay: 10,
                    totalTime: 70,
                    testValues: [
                        ([-0.01, 70.01], .idle, 0),
                        ([0, 0.01, 9.99, 10], .getReady, 0),
                        ([10.01, 69.99, 70], .go, 0),
            ])
    }
    
}
