//
//  Created by bwk on Wed.24.Aug.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

protocol ListViewControllerDelegate: class {

    func listViewController(viewController: ListViewController,
                            didSelectEntity timerEntity: TimerEntity,
                                            atIndex: Int)
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

        doneButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        doneButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        editButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        editButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)

        updateEditButton()

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(ListViewController.deleteTimerEntityNotification(_:)),
            name: DataModel.DeleteTimerEntityNotification,
            object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func deleteTimerEntityNotification(sender: NSNotification) {
        updateEditButton()
    }

    func updateEditButton() {
        let count = timerTableViewController?.tableView(
            (timerTableViewController?.tableView)!,
            numberOfRowsInSection: 0)

        editButton.enabled = count > 1
    }

    //  MARK: segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "TimerTableSegue" {
            timerTableViewController = (segue.destinationViewController as! TimerTableViewController)
            timerTableViewController!.delegate = self;
        }
    }

    //  MARK: actions

    @IBAction func addAction(sender: UIButton) {
    }

    @IBAction func editAction(sender: UIButton) {
        let isEditing = timerTableViewController?.editing
        timerTableViewController?.setEditing(!isEditing!, animated: true)
    }
}

extension ListViewController: TimerTableViewControllerDelegate {

    func timerTableViewController(viewController: TimerTableViewController,
                                  didSelectEntity timerEntity: TimerEntity,
                                                  atIndex: Int) {
        delegate?.listViewController(self, didSelectEntity: timerEntity, atIndex: atIndex)
    }
}

