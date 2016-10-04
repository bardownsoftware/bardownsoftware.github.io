//
//  Created by bwk on Sun.04.Sep.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import XCTest

@testable import Timer

class TimeStringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeString() {

        let testValues: [(Int, String)] = [
            ( 0, "0s"),
            (10, "10s"),
            (60, "60s"),
            (61, "1m 1s"),
            (90, "1m 30s"),
            (120, "2m"),
            (600, "10m"),
        ]

        for (interval, expectedString) in testValues {
            let result = NSString.timeString(seconds: interval) as String
            XCTAssert(result == expectedString, "# expected \(expectedString) got \(result)")
        }
    }

}
