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
        progressDial.isUserInteractionEnabled = false;

        countLabel.textColor = UIColor.ready()

        durationLabel.textColor = UIColor.go()
        restLabel.textColor = UIColor.rest()

        timerEntity = DataModel.sharedInstance.activeTimerEntity()

        timerEngine.timerEntity = timerEntity
        timerEngine.delegate = self

        startButton.isSelected = false
        startButton.setTitleColor(UIColor.go(), for: .normal)
        startButton.setTitleColor(UIColor.appRed(), for: .selected)

        resetButton.setTitleColor(UIColor.black, for: .normal)
        resetButton.setTitleColor(UIColor.lightGray, for: .disabled)

        updateTimerInfo()
        updateToolbar()
        updateSoundButton()

        resetButton.isEnabled = false
        hideTimeLabel()

        counterLabel.isHidden = true
        counterLabel.textColor = UIColor.ready()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getReady() {
        setStateText(String.ready())
        stateLabel.textColor = UIColor.ready()
    }

    func updateTimerInfo() {
        let count: Int = (timerEntity!.count?.intValue)!
        let duration: Int = (timerEntity!.duration?.intValue)!
        let rest: Int = (timerEntity!.rest?.intValue)!

        titleLabel.text = timerEntity!.name

        countLabel.text = "\(count)x"
        durationLabel.text = NSString.timeString(seconds: duration) as String
        restLabel.text = NSString.timeString(seconds: rest) as String

        getReady()
    }

    func updateToolbar() {
        let enabled = timerEngine.timerState == .idle
        listButton.isEnabled = enabled
        editButton.isEnabled = enabled
        addButton.isEnabled = enabled
    }

    func updateSoundButton() {
        soundButton.isSelected = !DataModel.sharedInstance.isSoundOn()
    }

    func running() -> Bool {
        return startButton.isSelected
    }

    func setRunning(_ running: Bool) {
        startButton.isSelected = running

        if running {
            timerEngine.start()
        } else {
            timerEngine.stop()
        }
    }

    func showTimeLabel() {
        UIView.kdg_animate(withDuration: 1.0,
                                       delay: 0.0,
                                       options: .curveEaseInOut,
                                       views: [timeLabel],
                                       style: .fadeIn) { (finished) in
        }
    }

    func hideTimeLabel() {
        timeLabel.isHidden = true
    }

    func showCounter() {
        self.hidingCounter = false
        UIView.kdg_animate(withDuration: 0.4,
                                       delay: 0.0,
                                       options: .curveEaseInOut,
                                       views: [counterLabel],
                                       style: .fadeIn) { (finished) in
        }
    }

    func hideCounter() {
        let hide = !hidingCounter
        hidingCounter = true
        if hide {
            UIView.kdg_animate(withDuration: 0.15,
                                           delay: 0.0,
                                           options: .curveEaseInOut,
                                           views: [counterLabel],
                                           style: .fadeOut) { (finished) in
            }
        }
    }

    func setStateText(_ text: String) {
        if stateLabel.text != text {
            stateLabel.text = text
            UIView.kdg_scale(stateLabel,
                                 scaleDuration: 0.2,
                                 returnDuration: 0.2,
                                 delay: 0.0,
                                 scale: 1.1,
                                 completion: { 
                                    //  completed...
            })
        }
    }

    func set(timeInterval: Int) {
        timeLabel.text = NSString.timeString(seconds: timeInterval) as String
    }

    func play(soundEffect: KDGSoundEffect) {
        if DataModel.sharedInstance.isSoundOn() {
            soundEffect.play()
        }
    }

    //  MARK: segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ListSegue" {
            listViewController = (segue.destination as! ListViewController)
            listViewController!.delegate = self;

        } else if segue.identifier == "EditSegue" {
            editViewController = (segue.destination as! EditViewController)
            editViewController!.timerEntity = timerEntity

        } else if segue.identifier == "AddSegue" {
            if let newTimerEntity = DataModel.sharedInstance.createTimerEntity(
                String.newTimer(),
                count: 3,
                duration: 30,
                rest: 5,
                delay: 5) {
                DataModel.sharedInstance.insertTimerEntity(newTimerEntity, index: 0)
                timerEntity = newTimerEntity
                editViewController = (segue.destination as! EditViewController)
                editViewController!.timerEntity = timerEntity
            }
        }
    }

    @IBAction func unwindFromEdit(_ sender: UIStoryboardSegue) {
        DataModel.sharedInstance.save()
        updateTimerInfo()

        dismiss(animated: true) { 
        }
    }

    @IBAction func unwindFromList(_ sender: UIStoryboardSegue) {

        timerEntity = DataModel.sharedInstance.activeTimerEntity()
        timerEngine.timerEntity = timerEntity
        updateTimerInfo()

        dismiss(animated: true) { 
        }
    }

    @IBAction func unwindFromSettings(_ sender: UIStoryboardSegue) {
        dismiss(animated: true) { 
        }
    }

    //  MARK: actions

    @IBAction func startAction(_ sender: UIButton) {
        if running() {
            setRunning(false)
            resetButton.isEnabled = true
        } else {
            setRunning(true)
            resetButton.isEnabled = false
        }
        updateToolbar()
    }

    @IBAction func resetAction(_ sender: UIButton) {
        setRunning(false)
        timerEngine.reset()

        getReady()

        progressDial.progress = 0
        hideTimeLabel()
        hideCounter()
        resetButton.isEnabled = false

        updateToolbar()
    }

    @IBAction func soundAction(_ sender: UIButton) {
        let soundOn = DataModel.sharedInstance.isSoundOn()
        DataModel.sharedInstance.set(soundOn: !soundOn)
        updateSoundButton()
    }

    func doneAction(_ sender: AnyObject) {
        getReady()

        progressDial.progress = 0
        hideTimeLabel()
        resetButton.isEnabled = false
    }
}

extension MainViewController: TimerEngineDelegate {

    func timerEngine(_ timerEngine: TimerEngine,
                     didBegin state: TimerEngineState,
                     round: Int,
                     duration: TimeInterval) {

        if .getReady != state {
            showTimeLabel()
        }

        if .go == state {
            setStateText(String.go())
        } else if .rest == state {
            setStateText(String.rest())
        }

        let count: Int = (timerEntity!.count?.intValue)!
        counterLabel.text = "\(round + 1)/\(count)"

        if .go == state {
            showCounter()
        }

        var color = UIColor.ready()
        if state == .getReady {
            color = UIColor.black
        } else if state == .go {
            color = UIColor.go()
        } else if state == .rest {
            color = UIColor.rest()
        }
        stateLabel.textColor = color

        progressDial.progressColor = color
        progressDial.progress = 0
    }

    func timerEngine(_ timerEngine: TimerEngine,
                     didProgress progress: Float,
                     state: TimerEngineState,
                     round: Int,
                     duration: TimeInterval) {

        if .getReady != state {
            progressDial.progress = CGFloat(progress)
        }

        let timeRemaining: Double = duration * (1.0 - Double(progress))
        if timeRemaining < 0.2 {
            set(timeInterval: 0)
            if .go == state {
                hideCounter()
            }

        } else {
            let number = NSDecimalNumber(value: duration * (1.0 - Double(progress)) as Double)

            let roundingBehaviour
                = NSDecimalNumberHandler(roundingMode: .up,
                                         scale: 0,
                                         raiseOnExactness: false,
                                         raiseOnOverflow: false,
                                         raiseOnUnderflow: false,
                                         raiseOnDivideByZero: false)
            let roundedNumber
                = number.rounding(accordingToBehavior: roundingBehaviour)

            set(timeInterval: roundedNumber.intValue)

            if .getReady == state {
                setStateText("\(roundedNumber.intValue)")
            }
        }
    }

    func timerEngine(_ timerEngine: TimerEngine,
                     didEnd state: TimerEngineState,
                     round: Int,
                     duration: TimeInterval) {

        let count: Int = (timerEntity!.count?.intValue)!

        if .getReady == state {
            play(soundEffect: startRoundSoundEffect!)
        }

        if .go == state && round == count - 1 {
            play(soundEffect: doneSoundEffect!)
            setStateText(String.done())
            stateLabel.textColor = UIColor.ready()
            setRunning(false)
            timerEngine.reset()
            progressDial.progress = 0
            hideTimeLabel()

            updateToolbar()

            perform(#selector(MainViewController.doneAction(_:)),
                            with: self,
                            afterDelay: 2)

        } else if .go == state {
            let rest: Int = (timerEntity!.rest?.intValue)!
            if rest > 0 {
                play(soundEffect: endRoundSoundEffect!)

            } else {
                play(soundEffect: startRoundSoundEffect!)
            }

        } else if .rest == state {
            play(soundEffect: startRoundSoundEffect!)
        }
    }
}

extension MainViewController: ListViewControllerDelegate {

    func listViewController(_ viewController: ListViewController,
                            didSelect timerEntity: TimerEntity,
                            at index: Int) {
        self.timerEntity = timerEntity
        DataModel.sharedInstance.setActiveTimerEntity(timerEntity)
        timerEngine.timerEntity = timerEntity

        updateTimerInfo()

        dismiss(animated: true) {
        }
    }
}


