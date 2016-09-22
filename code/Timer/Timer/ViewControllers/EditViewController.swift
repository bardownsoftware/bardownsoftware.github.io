//
//  Created by bwk on Wed.24.Aug.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var progressDial: KDGProgressDial!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var restView: UIView!
    @IBOutlet weak var valueLabel: UILabel!

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var restLabel: UILabel!

    var timerEntity: TimerEntity? = nil

    let activeViewOffset: CGFloat = 4.0

    let countValues = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

    let durationValues = [10, 15, 30, 45,
                          1 * 60,
                          2 * 60,
                          3 * 60,
                          4 * 60,
                          5 * 60,
                          10 * 60,
                          15 * 60,
                          20 * 60,
                          30 * 60,
                          45 * 60,
                          60 * 60]

    let restValues = [0, 5, 10, 15, 20, 30, 45,
                      1 * 60,
                      2 * 60,
                      3 * 60,
                      4 * 60,
                      5 * 60]

    var activeView: UIView? = nil
    var selectView: UIView

    required init?(coder aDecoder: NSCoder) {
        selectView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        progressDial.progress = 0.0

        activeView = countView

        countLabel.textColor = UIColor.readyColor()
        durationLabel.textColor = UIColor.goColor()
        restLabel.textColor = UIColor.restColor()

        setUpSelectView()

        nameField.text = timerEntity?.name
        nameField.delegate = self

        valueLabel.textColor = UIColor.readyColor()

        updateInfo()
        updateDial(false)
        updateValueLabel()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateActiveView(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setUpSelectView() {
        selectView.backgroundColor = UIColor.clearColor()
        selectView.hidden = true

        let borderWidth: CGFloat = 0.5
        let borderRect = CGRectInset(selectView.bounds, 1.0, 1.0)
        let borderView = UIView(frame: borderRect)
        borderView.layer.borderColor = UIColor.lightGrayColor().CGColor
        borderView.layer.borderWidth = borderWidth
        borderView.layer.cornerRadius = 0.5 * borderView.bounds.size.width
        selectView.addSubview(borderView)

        view.insertSubview(selectView, atIndex: 0)
    }

    func isNameOkay(name: String) -> Bool {
        return !name.isEmpty
    }

    func updateInfo() {
        let title = timerEntity?.name
        let count = (timerEntity?.getCount())!
        let duration = (timerEntity?.getDuration())!
        let rest = (timerEntity?.getRest())!

        let durationString: String = NSString.timeString(duration) as String
        let restString: String = NSString.timeString(rest) as String

        titleLabel.text = title
        countLabel.text = "\(count)x"
        durationLabel.text = durationString
        restLabel.text = restString
    }

    func updateActiveView(firstTime: Bool = false) {

        if activeView == countView {
            valueLabel.textColor = UIColor.readyColor()
            progressDial.numberOfStops = countValues.count

        } else if activeView == durationView {
            valueLabel.textColor = UIColor.goColor()
            progressDial.numberOfStops = durationValues.count

        } else if activeView == restView {
            valueLabel.textColor = UIColor.restColor()
            progressDial.numberOfStops = restValues.count
        }

        activateView(activeView!, firstTime: firstTime)
    }

    func activateView(viewToActivate: UIView, firstTime: Bool = true) {

        var point = view.convertPoint(viewToActivate.center,
                                      fromView: viewToActivate.superview)

        point.y = point.y + activeViewOffset

        self.selectView.hidden = false

        if firstTime {
            self.selectView.center = point
            self.selectView.alpha = 0.0

            UIView.animateWithDuration(0.1,
                                       delay: 0.0,
                                       options: .CurveEaseOut,
                                       animations: {
                                        self.selectView.alpha = 1.0
            }) { (finished) in
            }

        } else {
            UIView.animateWithDuration(0.2,
                                       delay: 0.0,
                                       options: .CurveEaseInOut,
                                       animations: {
                                        self.selectView.center = point
            }) { (finished) in
            }
        }
    }

    func updateDial(animated: Bool = true) {

        var value: CGFloat = 0.0

        if activeView == countView {
            let count = (timerEntity?.getCount())!
            if let index = countValues.indexOf(count) {
                value = CGFloat(index) / CGFloat(countValues.count)
            }

        } else if activeView == durationView {
            let duration = (timerEntity?.getDuration())!
            if let index = durationValues.indexOf(duration) {
                value = CGFloat(index) / CGFloat(durationValues.count)
            }

        } else if activeView == restView {
            let rest = (timerEntity?.getRest())!
            if let index = restValues.indexOf(rest) {
                value = CGFloat(index) / CGFloat(restValues.count)
            }
        }

        progressDial.setProgress(value, animated: animated)
    }

    func updateValueLabel() {
        let count = (timerEntity?.getCount())!
        let duration = (timerEntity?.getDuration())!
        let rest = (timerEntity?.getRest())!

        var value = progressDial.progress
        if value >= 1.0 {
            value = 0.0
        }

        if activeView == countView {
            valueLabel.text = "\(count)x"

        } else if activeView == durationView {
            let durationString: String = NSString.timeString(duration) as String
            valueLabel.text = durationString

        } else if activeView == restView {
            let restString: String = NSString.timeString(rest) as String
            valueLabel.text = restString
        }
    }

    //  MARK: actions

    @IBAction func dialChanged(sender: KDGProgressDial) {

        var value = sender.progress
        if value >= 1.0 {
            value = 0.0
        }

        if activeView == countView {
            let index = Int(value * CGFloat(countValues.count))
            let countValue = countValues[index]
            timerEntity!.count = countValue

        } else if activeView == durationView {
            let index = Int(value * CGFloat(durationValues.count))
            let duration = durationValues[index]
            timerEntity!.duration = duration

        } else if activeView == restView {
            let index = Int(value * CGFloat(restValues.count))
            let rest = restValues[index]
            timerEntity!.rest = rest
        }

        updateValueLabel()
        updateInfo()
    }

    @IBAction func countAction(sender: UITapGestureRecognizer) {
        activeView = sender.view
        updateActiveView()
        updateDial()
        updateValueLabel()
    }

    @IBAction func durationAction(sender: UITapGestureRecognizer) {
        activeView = sender.view
        updateActiveView()
        updateDial()
        updateValueLabel()
    }

    @IBAction func restAction(sender: UITapGestureRecognizer) {
        activeView = sender.view
        updateActiveView()
        updateDial()
        updateValueLabel()
    }
}

extension EditViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == nameField {
            textField.textAlignment = .Left
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {

        if textField == nameField {
            textField.textAlignment = .Center
            timerEntity!.name = textField.text
            DataModel.sharedInstance.save()
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var shouldReturn = true

        if textField == nameField {
            shouldReturn = isNameOkay(textField.text!)
        }

        if shouldReturn {
            textField.resignFirstResponder()
        }

        return shouldReturn
    }
}
