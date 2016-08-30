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

    weak var delegate: ListViewControllerDelegate?

    var timerTableViewController: TimerTableViewController?

    required init?(coder aDecoder: NSCoder) {
        timerTableViewController = nil
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        print ("addAction...")

        if let timerEntity = DataModel.sharedInstance.createTimerEntity(
            "New Timer",
            count: 3,
            duration: 20) {
            DataModel.sharedInstance.insertTimerEntity(timerEntity, index: 0)
        }
    }

    @IBAction func editAction(sender: UIButton) {
        print ("editAction...")
    }
}

extension ListViewController: TimerTableViewControllerDelegate {

    func timerTableViewController(viewController: TimerTableViewController,
                                  didSelectEntity timerEntity: TimerEntity,
                                                  atIndex: Int) {
        delegate?.listViewController(self, didSelectEntity: timerEntity, atIndex: atIndex)
    }
}

