//
//  Created by bwk on Wed.24.Aug.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

protocol ListViewControllerDelegate: class {

    func listViewController(_ viewController: ListViewController,
                            didSelect timerEntity: TimerEntity,
                            at index: Int)
}

class ListViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editButton: UIButton!

    weak var delegate: ListViewControllerDelegate?

    var timerTableViewController: TimerTableViewController?

    required init?(coder aDecoder: NSCoder) {
        timerTableViewController = nil
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.setTitleColor(UIColor.black, for: .normal)
        doneButton.setTitleColor(UIColor.lightGray, for: .disabled)
        editButton.setTitleColor(UIColor.black, for: .normal)
        editButton.setTitleColor(UIColor.lightGray, for: .disabled)

        updateEditButton()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ListViewController.deleteTimerEntityNotification(_:)),
            name: NSNotification.Name(rawValue: DataModel.DeleteTimerEntityNotification),
            object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func deleteTimerEntityNotification(_ sender: Notification) {
        updateEditButton()
    }

    func updateEditButton() {
        let count = timerTableViewController?.tableView(
            (timerTableViewController?.tableView)!,
            numberOfRowsInSection: 0)

        editButton.isEnabled = count > 1
    }

    //  MARK: segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "TimerTableSegue" {
            timerTableViewController = (segue.destination as! TimerTableViewController)
            timerTableViewController!.delegate = self;
        }
    }

    //  MARK: actions

    @IBAction func addAction(_ sender: UIButton) {
    }

    @IBAction func editAction(_ sender: UIButton) {
        let isEditing = timerTableViewController?.isEditing
        timerTableViewController?.setEditing(!isEditing!, animated: true)
    }
}

extension ListViewController: TimerTableViewControllerDelegate {

    func timerTableViewController(_ viewController: TimerTableViewController,
                                  didSelect timerEntity: TimerEntity,
                                                  at index: Int) {
        delegate?.listViewController(self, didSelect: timerEntity, at: index)
    }
}

