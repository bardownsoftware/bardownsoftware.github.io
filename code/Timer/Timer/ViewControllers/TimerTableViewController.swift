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

        timerEntities = TimerEntity.MR_findAllSortedBy(
            "order", ascending: true) as! [TimerEntity]
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
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "TimerTableViewCell", forIndexPath: indexPath) as! TimerTableViewCell

        let timerEntity: TimerEntity = timerEntities[indexPath.row]

        let count: Int = (timerEntity.count?.integerValue)!
        let duration: Int = (timerEntity.duration?.integerValue)!
        let rest: Int = (timerEntity.rest?.integerValue)!

        cell.nameLabel.text = timerEntity.name
        cell.countLabel.text = "\(count)x"
        cell.durationLabel.text = NSString.timeString(duration) as String
        cell.restLabel.text = NSString.timeString(rest) as String

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let timerEntity = timerEntities[indexPath.row]

        delegate?.timerTableViewController(self,
                                           didSelectEntity: timerEntity,
                                           atIndex: indexPath.row)
    }

}
