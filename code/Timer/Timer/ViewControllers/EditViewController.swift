//
//  Created by bwk on Wed.24.Aug.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var progressDial: KDGProgressDial!
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

        countLabel.textColor = UIColor.ready()
        durationLabel.textColor = UIColor.go()
        restLabel.textColor = UIColor.rest()

        setUpSelectView()

        nameField.text = timerEntity?.name
        nameField.delegate = self

        valueLabel.textColor = UIColor.ready()

        updateInfo()
        updateDial(animated: false)
        updateValueLabel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateActiveView(firstTime: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setUpSelectView() {
        selectView.backgroundColor = UIColor.clear
        selectView.isHidden = true

        let borderWidth: CGFloat = 0.5
        let borderRect = selectView.bounds.insetBy(dx: 1.0, dy: 1.0)
        let borderView = UIView(frame: borderRect)
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.borderWidth = borderWidth
        borderView.layer.cornerRadius = 0.5 * borderView.bounds.size.width
        selectView.addSubview(borderView)

        view.insertSubview(selectView, at: 0)
    }

    func isNameOkay(name: String) -> Bool {
        return !name.isEmpty
    }

    func updateInfo() {
        let count = (timerEntity?.getCount())!
        let duration = (timerEntity?.getDuration())!
        let rest = (timerEntity?.getRest())!

        let durationString: String = NSString.timeString(seconds: duration) as String
        let restString: String = NSString.timeString(seconds: rest) as String

        countLabel.text = "\(count)x"
        durationLabel.text = durationString
        restLabel.text = restString
    }

    func updateActiveView(firstTime: Bool = false) {

        if activeView == countView {
            valueLabel.textColor = UIColor.ready()
            progressDial.numberOfStops = countValues.count

        } else if activeView == durationView {
            valueLabel.textColor = UIColor.go()
            progressDial.numberOfStops = durationValues.count

        } else if activeView == restView {
            valueLabel.textColor = UIColor.rest()
            progressDial.numberOfStops = restValues.count
        }

        activate(viewToActivate: activeView!, firstTime: firstTime)
    }

    func activate(viewToActivate: UIView, firstTime: Bool = true) {

        var point = view.convert(viewToActivate.center, from: viewToActivate.superview)

        point.y = point.y + activeViewOffset

        selectView.isHidden = false

        let animate = true

        if firstTime {
            selectView.center = point

            if animate {
                selectView.alpha = 0.0

                UIView.animate(withDuration: 0.1,
                               delay: 0.0,
                               options: .curveEaseOut,
                               animations: {
                                self.selectView.alpha = 1.0
                }) { (finished) in
                }

            } else {
            }

        } else {
            if animate {
                UIView.animate(withDuration: 0.2,
                               delay: 0.0,
                               options: .curveEaseOut,
                               animations: {
                                self.selectView.center = point
                }) { (finished) in
                }

            } else {
                selectView.center = point
            }
        }
    }

    func updateDial(animated: Bool = true) {

        var value: CGFloat = 0.0

        if activeView == countView {
            let count = (timerEntity?.getCount())!
            if let index = countValues.index(of: count) {
                value = CGFloat(index) / CGFloat(countValues.count)
            }

        } else if activeView == durationView {
            let duration = (timerEntity?.getDuration())!
            if let index = durationValues.index(of: duration) {
                value = CGFloat(index) / CGFloat(durationValues.count)
            }

        } else if activeView == restView {
            let rest = (timerEntity?.getRest())!
            if let index = restValues.index(of: rest) {
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
            let durationString: String = NSString.timeString(seconds: duration) as String
            valueLabel.text = durationString

        } else if activeView == restView {
            let restString: String = NSString.timeString(seconds: rest) as String
            valueLabel.text = restString
        }
    }

    //  MARK: actions

    @IBAction func dialChanged(_ sender: KDGProgressDial) {

        var value = sender.progress
        if value >= 1.0 {
            value = 0.0
        }

        if activeView == countView {
            let index = Int(value * CGFloat(countValues.count))
            let countValue = countValues[index]
            timerEntity!.count = countValue as NSNumber?

        } else if activeView == durationView {
            let index = Int(value * CGFloat(durationValues.count))
            let duration = durationValues[index]
            timerEntity!.duration = duration as NSNumber?

        } else if activeView == restView {
            let index = Int(value * CGFloat(restValues.count))
            let rest = restValues[index]
            timerEntity!.rest = rest as NSNumber?
        }

        updateValueLabel()
        updateInfo()
    }

    @IBAction func countAction(_ sender: UITapGestureRecognizer) {
        activeView = sender.view
        updateActiveView()
        updateDial()
        updateValueLabel()
    }

    @IBAction func durationAction(_ sender: UITapGestureRecognizer) {
        activeView = sender.view
        updateActiveView()
        updateDial()
        updateValueLabel()
    }

    @IBAction func restAction(_ sender: UITapGestureRecognizer) {
        activeView = sender.view
        updateActiveView()
        updateDial()
        updateValueLabel()
    }
}

extension EditViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameField {
            //textField.textAlignment = .left
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField == nameField {
            //textField.textAlignment = .center
            timerEntity!.name = textField.text
            DataModel.sharedInstance.save()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var shouldReturn = true

        if textField == nameField {
            shouldReturn = isNameOkay(name: textField.text!)
        }

        if shouldReturn {
            textField.resignFirstResponder()
        }

        return shouldReturn
    }
}
