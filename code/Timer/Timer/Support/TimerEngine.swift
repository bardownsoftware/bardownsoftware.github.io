//
//  Created by bwk on Wed.31.Aug.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

enum TimerEngineState {
    case idle
    case getReady
    case go
    case rest
}

protocol TimerEngineDelegate: class {

    func timerEngine(_ timerEngine: TimerEngine,
                     didBegin state: TimerEngineState,
                     round: Int,
                     duration: TimeInterval)

    func timerEngine(_ timerEngine: TimerEngine,
                     didProgress progress: Float,
                     state: TimerEngineState,
                     round: Int,
                     duration: TimeInterval)

    func timerEngine(_ timerEngine: TimerEngine,
                     didEnd state: TimerEngineState,
                     round: Int,
                     duration: TimeInterval)
}

class TimerEngine: NSObject {

    weak var delegate: TimerEngineDelegate?

    var timer = Foundation.Timer()
    var timerDate = Date()
    var timerDuration: TimeInterval = 0
    var timerState: TimerEngineState = .idle
    var timerRound: Int = 0
    var timerElapsed: TimeInterval = 0

    var timerEntity: TimerEntity? {
        didSet {
        }
    }

    override init() {
        super.init()
    }

    func start() {
        if timerEntity == nil {
            return
        }

        if .idle == timerState {

            let delay = getDelay()

            timerRound = 0

            if delay > 0 {
                delegate?.timerEngine(self,
                                      didBegin: .getReady,
                                      round: timerRound,
                                      duration: TimeInterval(delay))
                startTimer(duration: delay, state: .getReady)

            } else {
                let duration = getDuration()
                delegate?.timerEngine(self,
                                      didBegin: .go,
                                      round: timerRound,
                                      duration: TimeInterval(duration))
                startTimer(duration: duration, state: .go)
            }

        } else {
            resumeTimer()
        }
    }

    func stop() {
        stopTimer()
    }

    func reset() {
        stopTimer()
        timerState = .idle
    }

    func getCount() -> Int {
        return (timerEntity?.getCount())!
    }

    func getDelay() -> Int {
        return (timerEntity?.getDelay())!
    }

    func getDuration() -> Int {
        return (timerEntity?.getDuration())!
    }

    func getRest() -> Int {
        return (timerEntity?.getRest())!
    }

    func getTotalTime() -> Int {
        let count = getCount()
        let delay = getDelay()
        let duration = getDuration()
        let rest = getRest()

        return delay + count * duration + (count - 1) * rest
    }

    func getState(fromInterval interval: TimeInterval) -> (TimerEngineState, Int) {
        var state: TimerEngineState = .idle
        var round: Int = 0

        let count = getCount()
        let delay = getDelay()
        let duration = getDuration()
        let rest = getRest()
        let totalTime = getTotalTime()

        if interval < 0.0 || interval > TimeInterval(totalTime) {
            state = .idle

        } else if delay > 0 && interval <= TimeInterval(delay) {
            state = .getReady

        } else {
            //
            //  Last round.
            //
            if interval > TimeInterval(totalTime - duration) {
                state = .go
                round = count - 1

            } else {
                round = Int(
                    ceil((interval - TimeInterval(delay))
                        / TimeInterval(duration + rest))
                    )

                if round > 0 {
                    round = round - 1
                }

                let goStart = TimeInterval(delay + round * (duration + rest))

                if interval <= goStart + TimeInterval(duration) {
                    state = .go
                } else {
                    state = .rest
                }
            }
        }

        return (state, round)
    }

    //  MARK: timer

    func startTimer(duration: Int, state: TimerEngineState) {
        timerDate = Date()
        timerDuration = TimeInterval(duration)
        timerState = state

        timer.invalidate()
        timer = Foundation.Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(TimerEngine.timerAction(_:)),
            userInfo: ["custom" : "data"],
            repeats: true)
    }

    func resumeTimer() {
        timerDate = Date(timeIntervalSinceNow: -timerElapsed)

        timer.invalidate()
        timer = Foundation.Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(TimerEngine.timerAction(_:)),
            userInfo: ["custom" : "data"],
            repeats: true)
    }

    func stopTimer() {
        timerElapsed = Date().timeIntervalSince(timerDate)
        timer.invalidate()
    }

    func timerAction(_ timer: Foundation.Timer!) {
        let elapsed = Date().timeIntervalSince(timerDate)

        if elapsed >= timerDuration {
            timer.invalidate()
            delegate?.timerEngine(self,
                                  didEnd: timerState,
                                  round: timerRound,
                                  duration: timerDuration)

            if timerState == .getReady {
                let duration = getDuration()
                timerRound = 0
                delegate?.timerEngine(self,
                                      didBegin: .go,
                                      round: timerRound,
                                      duration: TimeInterval(duration))
                startTimer(duration: duration, state: .go)

            } else if timerState == .go {

                if timerRound >= getCount() - 1 {
                    //
                    //  Last round. We are done.
                    //
                    timerState = .idle

                } else {
                    let rest = getRest()

                    if rest > 0 {
                        delegate?.timerEngine(self,
                                              didBegin: .rest,
                                              round: timerRound,
                                              duration: TimeInterval(rest))
                        startTimer(duration: rest, state: .rest)

                    } else {
                        //
                        //  Next round.
                        //
                        let duration = getDuration()

                        timerRound = timerRound + 1
                        delegate?.timerEngine(self,
                                              didBegin: .go,
                                              round: timerRound,
                                              duration: TimeInterval(duration))
                        startTimer(duration: duration, state: .go)
                    }
                }

            } else if timerState == .rest {
                //
                //  Next round.
                //
                let duration = getDuration()

                timerRound = timerRound + 1
                delegate?.timerEngine(self,
                                      didBegin: .go,
                                      round: timerRound,
                                      duration: TimeInterval(duration))
                startTimer(duration: duration, state: .go)
           }

        } else {
            let progress: Double = elapsed / timerDuration
            delegate?.timerEngine(self,
                                  didProgress: Float(progress),
                                  state: timerState,
                                  round: timerRound,
                                  duration: timerDuration)
        }
    }
}
