//
//  Created by bwk on Wed.24.Aug.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

protocol TimerTableViewControllerDelegate: class {

    func timerTableViewController(viewController: TimerTableViewController,
                                  didSelectEntity timerEntity: TimerEntity,
                                                  atIndex: Int)
}

class TimerTableViewController: UITableViewController {

    weak var delegate: TimerTableViewControllerDelegate?

    var timerEntities: [TimerEntity]!

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.pagingEnabled = false
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        tableView.showsVerticalScrollIndicator = false
         */

        timerEntities = TimerEntity.MR_findAllSortedBy("order", ascending: true) as! [TimerEntity]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerEntities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCellWithIdentifier("BattleListTableViewCell",
        //                                                               forIndexPath: indexPath) as! BattleListTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("TimerTableViewCell",
                                                               forIndexPath: indexPath)

        let timerEntity: TimerEntity = timerEntities[indexPath.row]

        cell.textLabel!.text = timerEntity.name

        //cell.selectionStyle = .None

        //cell.textLabel?.text = items[indexPath.row]
        /*
         cell.resultLabel.text = items[indexPath.row]
         cell.expressionLabel.text = "exp"

         cell.resultLabel.textColor = UIColor.whiteColor()
         cell.expressionLabel.textColor = UIColor.grayColor()
         cell.dateLabel.textColor = UIColor.grayColor()
         cell.backgroundColor = UIColor.clearColor()
         */

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let timerEntity = timerEntities[indexPath.row]

        delegate?.timerTableViewController(self,
                                           didSelectEntity: timerEntity,
                                           atIndex: indexPath.row)
    }

}
