//
//  Created by bwk on Wed.24.Aug.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var restLabel: UILabel!

    @IBOutlet weak var soundButton: UIButton!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    @IBOutlet weak var progressDial: KDGProgressDial!

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    let startRoundSoundEffect = KDGSoundEffect(soundNamed: "OneBell.aiff")
    let endRoundSoundEffect = KDGSoundEffect(soundNamed: "TwoBells.aiff")
    let doneSoundEffect = KDGSoundEffect(soundNamed: "ThreeBells.aiff")

    let kCornerRadius: CGFloat = 32.0
    let kNumberOfRounds: Int = 2

    var listViewController: ListViewController?
    var editViewController: EditViewController?

    var timerEntity: TimerEntity?

    let timerEngine = TimerEngine()

    var hidingCounter = false

    override func viewDidLoad() {
        super.viewDidLoad()

        progressDial.progress = 0.0;
        progressDial.userInteractionEnabled = false;

        countLabel.textColor = UIColor.readyColor()

        durationLabel.textColor = UIColor.goColor()
        restLabel.textColor = UIColor.restColor()

        timerEntity = DataModel.sharedInstance.activeTimerEntity()

        timerEngine.timerEntity = timerEntity
        timerEngine.delegate = self

        startButton.selected = false
        startButton.setTitleColor(UIColor.goColor(), forState: .Normal)
        startButton.setTitleColor(UIColor.appRedColor(), forState: .Selected)

        resetButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        resetButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)

        updateTimerInfo()
        updateToolbar()
        updateSoundButton()

        resetButton.enabled = false
        hideTimeLabel()

        counterLabel.hidden = true
        counterLabel.textColor = UIColor.readyColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getReady() {
        setStateText("Ready")
        stateLabel.textColor = UIColor.readyColor()
    }

    func updateTimerInfo() {
        let count: Int = (timerEntity!.count?.integerValue)!
        let duration: Int = (timerEntity!.duration?.integerValue)!
        let rest: Int = (timerEntity!.rest?.integerValue)!

        titleLabel.text = timerEntity!.name

        countLabel.text = "\(count)x"
        durationLabel.text = NSString.timeString(duration) as String
        restLabel.text = NSString.timeString(rest) as String

        getReady()
    }

    func updateToolbar() {
        let enabled = timerEngine.timerState == .Idle
        listButton.enabled = enabled
        editButton.enabled = enabled
        addButton.enabled = enabled
    }

    func updateSoundButton() {
        soundButton.selected = !DataModel.sharedInstance.isSoundOn()
    }

    func running() -> Bool {
        return startButton.selected
    }

    func setRunning(running: Bool) {
        startButton.selected = running

        if running {
            timerEngine.start()
        } else {
            timerEngine.stop()
        }
    }

    func showTimeLabel() {
        UIView.kdg_animateWithDuration(1.0,
                                       delay: 0.0,
                                       options: .CurveEaseInOut,
                                       views: [timeLabel],
                                       style: KDGAnimationStyle.FadeIn) { (finished) in
        }
    }

    func hideTimeLabel() {
        timeLabel.hidden = true
    }

    func showCounter() {
        self.hidingCounter = false
        UIView.kdg_animateWithDuration(0.4,
                                       delay: 0.0,
                                       options: .CurveEaseInOut,
                                       views: [counterLabel],
                                       style: KDGAnimationStyle.FadeIn) { (finished) in
        }
    }

    func hideCounter() {
        let hide = !hidingCounter
        hidingCounter = true
        if hide {
            UIView.kdg_animateWithDuration(0.15,
                                           delay: 0.0,
                                           options: .CurveEaseInOut,
                                           views: [counterLabel],
                                           style: KDGAnimationStyle.FadeOut) { (finished) in
            }
        }
    }

    func setStateText(text: String) {
        if stateLabel.text != text {
            stateLabel.text = text
            UIView.kdg_scaleView(stateLabel,
                                 scaleDuration: 0.2,
                                 returnDuration: 0.2,
                                 delay: 0.0,
                                 scale: 1.1,
                                 completion: { 
                                    //  completed...
            })
        }
    }

    func setTimeInterval(interval: Int) {
        timeLabel.text = NSString.timeString(interval) as String
    }

    func playSoundEffect(soundEffect: KDGSoundEffect) {
        if DataModel.sharedInstance.isSoundOn() {
            soundEffect.play()
        }
    }

    //  MARK: segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ListSegue" {
            listViewController = (segue.destinationViewController as! ListViewController)
            listViewController!.delegate = self;

        } else if segue.identifier == "EditSegue" {
            editViewController = (segue.destinationViewController as! EditViewController)
            editViewController!.timerEntity = timerEntity

        } else if segue.identifier == "AddSegue" {
            if let newTimerEntity = DataModel.sharedInstance.createTimerEntity(
                "New Timer",
                count: 3,
                duration: 30,
                rest: 5,
                delay: 5) {
                DataModel.sharedInstance.insertTimerEntity(newTimerEntity, index: 0)
                timerEntity = newTimerEntity
                editViewController = (segue.destinationViewController as! EditViewController)
                editViewController!.timerEntity = timerEntity
            }
        }
    }

    @IBAction func unwindFromEdit(sender: UIStoryboardSegue) {
        DataModel.sharedInstance.save()
        updateTimerInfo()

        [self .dismissViewControllerAnimated(true, completion: {
        })]
    }

    @IBAction func unwindFromList(sender: UIStoryboardSegue) {

        timerEntity = DataModel.sharedInstance.activeTimerEntity()
        timerEngine.timerEntity = timerEntity
        updateTimerInfo()

        [self .dismissViewControllerAnimated(true, completion: {
        })]
    }

    @IBAction func unwindFromSettings(sender: UIStoryboardSegue) {
        [self .dismissViewControllerAnimated(true, completion: {
        })]
    }

    //  MARK: actions

    @IBAction func startAction(sender: UIButton) {
        if running() {
            setRunning(false)
            resetButton.enabled = true
        } else {
            setRunning(true)
            resetButton.enabled = false
        }
        updateToolbar()
    }

    @IBAction func resetAction(sender: UIButton) {
        setRunning(false)
        timerEngine.reset()

        getReady()

        progressDial.progress = 0
        hideTimeLabel()
        hideCounter()
        resetButton.enabled = false

        updateToolbar()
    }

    @IBAction func soundAction(sender: UIButton) {
        let soundOn = DataModel.sharedInstance.isSoundOn()
        DataModel.sharedInstance.setSoundOn(!soundOn)
        updateSoundButton()
    }

    func doneAction(sender: AnyObject) {
        getReady()

        progressDial.progress = 0
        hideTimeLabel()
        resetButton.enabled = false
    }
}

extension MainViewController: TimerEngineDelegate {

    func timerEngineDidBegin(timerEngine: TimerEngine,
                             state: TimerEngineState,
                             round: Int,
                             duration: NSTimeInterval) {

        if .GetReady != state {
            showTimeLabel()
        }

        if .GetReady != state {
            setStateText("\(state)")
        }

        let count: Int = (timerEntity!.count?.integerValue)!
        counterLabel.text = "\(round + 1)/\(count)"

        if .Go == state {
            showCounter()
        }

        var color = UIColor.readyColor()
        if state == .GetReady {
            color = UIColor.blackColor()
        } else if state == .Go {
            color = UIColor.goColor()
        } else if state == .Rest {
            color = UIColor.restColor()
        }
        stateLabel.textColor = color

        progressDial.progressColor = color
        progressDial.progress = 0
    }

    func timerEngineDidProgress(timerEngine: TimerEngine,
                                state: TimerEngineState,
                                round: Int,
                                progress: Float,
                                duration: NSTimeInterval) {

        if .GetReady != state {
            progressDial.progress = CGFloat(progress)
        }

        let timeRemaining: Double = duration * (1.0 - Double(progress))
        if timeRemaining < 0.2 {
            setTimeInterval(0)
            if .Go == state {
                hideCounter()
            }

        } else {
            let number = NSDecimalNumber(double: duration * (1.0 - Double(progress)))

            let roundingBehaviour
                = NSDecimalNumberHandler(roundingMode: .RoundUp,
                                         scale: 0,
                                         raiseOnExactness: false,
                                         raiseOnOverflow: false,
                                         raiseOnUnderflow: false,
                                         raiseOnDivideByZero: false)
            let roundedNumber
                = number.decimalNumberByRoundingAccordingToBehavior(roundingBehaviour)

            setTimeInterval(roundedNumber.integerValue)

            if .GetReady == state {
                setStateText("\(roundedNumber.integerValue)")
            }
        }
    }

    func timerEngineDidEnd(timerEngine: TimerEngine,
                           state: TimerEngineState,
                           round: Int,
                           duration: NSTimeInterval) {

        let count: Int = (timerEntity!.count?.integerValue)!

        if .GetReady == state {
            playSoundEffect(startRoundSoundEffect)
        }

        if .Go == state && round == count - 1 {
            playSoundEffect(doneSoundEffect)
            setStateText("Done")
            stateLabel.textColor = UIColor.readyColor()
            setRunning(false)
            timerEngine.reset()
            progressDial.progress = 0
            hideTimeLabel()

            updateToolbar()

            performSelector(#selector(MainViewController.doneAction(_:)),
                            withObject: self,
                            afterDelay: 2)

        } else if .Go == state {
            let rest: Int = (timerEntity!.rest?.integerValue)!
            if rest > 0 {
                playSoundEffect(endRoundSoundEffect)

            } else {
                playSoundEffect(startRoundSoundEffect)
            }

        } else if .Rest == state {
            playSoundEffect(startRoundSoundEffect)
        }
    }
}

extension MainViewController: ListViewControllerDelegate {

    func listViewController(viewController: ListViewController,
                            didSelectEntity timerEntity: TimerEntity,
                                            atIndex: Int) {
        self.timerEntity = timerEntity
        DataModel.sharedInstance.setActiveTimerEntity(timerEntity)
        timerEngine.timerEntity = timerEntity

        updateTimerInfo()

        [self .dismissViewControllerAnimated(true, completion: {
        })]
    }
}


