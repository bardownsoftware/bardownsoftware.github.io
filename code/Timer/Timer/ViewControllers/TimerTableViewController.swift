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

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return timerEntities.count > 1
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }

    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                            forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == UITableViewCellEditingStyle.Delete {
            let timerEntity: TimerEntity = timerEntities[indexPath.row]

            //  Check if deleting the active timer entity.
            //
            let activeTimerEntity = DataModel.sharedInstance.activeTimerEntity()
            let chooseNewActiveTimer = timerEntity == activeTimerEntity

            //  Delete the entity from the table view source and the DataModel.
            //  Also remove the corresponding rows from the table view.
            //
            timerEntities.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            DataModel.sharedInstance.deleteTimerEntity(timerEntity)

            //  Choose a new active timer if necessary.
            //  The first one will do.
            //
            if chooseNewActiveTimer {
                DataModel.sharedInstance.setActiveTimerEntity(timerEntities[0])
            }
        }
    }

    override func tableView(tableView: UITableView,
                            moveRowAtIndexPath sourceIndexPath: NSIndexPath,
                            toIndexPath destinationIndexPath: NSIndexPath) {

        if sourceIndexPath.row == destinationIndexPath.row {
            //  Nothing to do.
            return
        }

        let timerEntity: TimerEntity = timerEntities[sourceIndexPath.row]

        timerEntities.removeAtIndex(sourceIndexPath.row)
        timerEntities.insert(timerEntity, atIndex: destinationIndexPath.row)

        DataModel.sharedInstance.reorderTimerEntities(timerEntities)
    }

}
