//
//  Created by bwk on Wed.31.Aug.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

enum TimerEngineState {
    case Idle
    case GetReady
    case Go
    case Rest
}

protocol TimerEngineDelegate: class {

    func timerEngineDidBegin(timerEngine: TimerEngine,
                             state: TimerEngineState,
                             round: Int,
                             duration: NSTimeInterval)

    func timerEngineDidProgress(timerEngine: TimerEngine,
                             state: TimerEngineState,
                             round: Int,
                             progress: Float,
                             duration: NSTimeInterval)

    func timerEngineDidEnd(timerEngine: TimerEngine,
                           state: TimerEngineState,
                           round: Int,
                           duration: NSTimeInterval)
}

class TimerEngine: NSObject {

    weak var delegate: TimerEngineDelegate?

    var timer = NSTimer()
    var timerDate = NSDate()
    var timerDuration: NSTimeInterval = 0
    var timerState: TimerEngineState = .Idle
    var timerRound: Int = 0
    var timerElapsed: NSTimeInterval = 0

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

        if .Idle == timerState {

            let delay = getDelay()

            timerRound = 0

            if delay > 0 {
                delegate?.timerEngineDidBegin(self,
                                              state: .GetReady,
                                              round: timerRound,
                                              duration: NSTimeInterval(delay))
                startTimer(delay, state: .GetReady)

            } else {
                let duration = getDuration()
                delegate?.timerEngineDidBegin(self,
                                              state: .Go,
                                              round: timerRound,
                                              duration: NSTimeInterval(duration))
                startTimer(duration, state: .Go)
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
        timerState = .Idle
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

    func getState(interval: NSTimeInterval) -> (TimerEngineState, Int) {
        var state: TimerEngineState = .Idle
        var round: Int = 0

        let count = getCount()
        let delay = getDelay()
        let duration = getDuration()
        let rest = getRest()
        let totalTime = getTotalTime()

        if interval < 0.0 || interval > NSTimeInterval(totalTime) {
            state = .Idle

        } else if delay > 0 && interval <= NSTimeInterval(delay) {
            state = .GetReady

        } else {
            //
            //  Last round.
            //
            if interval > NSTimeInterval(totalTime - duration) {
                state = .Go
                round = count - 1

            } else {
                round = Int(
                    ceil((interval - NSTimeInterval(delay))
                        / NSTimeInterval(duration + rest))
                    )

                if round > 0 {
                    round = round - 1
                }

                let goStart = NSTimeInterval(delay + round * (duration + rest))

                if interval <= goStart + NSTimeInterval(duration) {
                    state = .Go
                } else {
                    state = .Rest
                }
            }
        }

        return (state, round)
    }

    //  MARK: timer

    func startTimer(duration: Int, state: TimerEngineState) {
        timerDate = NSDate()
        timerDuration = NSTimeInterval(duration)
        timerState = state

        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(
            0.01,
            target: self,
            selector: #selector(TimerEngine.timerAction(_:)),
            userInfo: ["custom" : "data"],
            repeats: true)
    }

    func resumeTimer() {
        timerDate = NSDate(timeIntervalSinceNow: -timerElapsed)

        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(
            0.01,
            target: self,
            selector: #selector(TimerEngine.timerAction(_:)),
            userInfo: ["custom" : "data"],
            repeats: true)
    }

    func stopTimer() {
        timerElapsed = NSDate().timeIntervalSinceDate(timerDate)
        timer.invalidate()
    }

    func timerAction(timer: NSTimer!) {
        let elapsed = NSDate().timeIntervalSinceDate(timerDate)

        if elapsed >= timerDuration {
            timer.invalidate()
            delegate?.timerEngineDidEnd(self,
                                        state: timerState,
                                        round: timerRound,
                                        duration: timerDuration)

            if timerState == .GetReady {
                let duration = getDuration()
                timerRound = 0
                delegate?.timerEngineDidBegin(self,
                                              state: .Go,
                                              round: timerRound,
                                              duration: NSTimeInterval(duration))
                startTimer(duration, state: .Go)

            } else if timerState == .Go {

                if timerRound >= getCount() - 1 {
                    //
                    //  Last round. We are done.
                    //
                    timerState = .Idle

                } else {
                    let rest = getRest()

                    if rest > 0 {
                        delegate?.timerEngineDidBegin(self,
                                                      state: .Rest,
                                                      round: timerRound,
                                                      duration: NSTimeInterval(rest))
                        startTimer(rest, state: .Rest)

                    } else {
                        //
                        //  Next round.
                        //
                        let duration = getDuration()

                        timerRound = timerRound + 1
                        delegate?.timerEngineDidBegin(self,
                                                      state: .Go,
                                                      round: timerRound,
                                                      duration: NSTimeInterval(duration))
                        startTimer(duration, state: .Go)
                    }
                }

            } else if timerState == .Rest {
                //
                //  Next round.
                //
                let duration = getDuration()

                timerRound = timerRound + 1
                delegate?.timerEngineDidBegin(self,
                                              state: .Go,
                                              round: timerRound,
                                              duration: NSTimeInterval(duration))
                startTimer(duration, state: .Go)
           }

        } else {
            let progress: Double = elapsed / timerDuration
            delegate?.timerEngineDidProgress(self,
                                             state: timerState,
                                             round: timerRound,
                                             progress: Float(progress),
                                             duration: timerDuration)
        }
    }
}
