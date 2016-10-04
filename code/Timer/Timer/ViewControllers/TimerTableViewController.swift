//
//  Created by bwk on Wed.24.Aug.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

protocol TimerTableViewControllerDelegate: class {

    func timerTableViewController(_ viewController: TimerTableViewController,
                                  didSelect timerEntity: TimerEntity,
                                  at index: Int)
}

class TimerTableViewController: UITableViewController {

    weak var delegate: TimerTableViewControllerDelegate?

    var timerEntities: [TimerEntity]!

    override func viewDidLoad() {
        super.viewDidLoad()

        timerEntities = TimerEntity.mr_findAllSorted(
            by: "order", ascending: true) as! [TimerEntity]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerEntities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TimerTableViewCell", for: indexPath) as! TimerTableViewCell

        let timerEntity: TimerEntity = timerEntities[(indexPath as NSIndexPath).row]

        let count: Int = (timerEntity.count?.intValue)!
        let duration: Int = (timerEntity.duration?.intValue)!
        let rest: Int = (timerEntity.rest?.intValue)!

        cell.nameLabel.text = timerEntity.name
        cell.countLabel.text = "\(count)x"
        cell.durationLabel.text = NSString.timeString(seconds: duration) as String
        cell.restLabel.text = NSString.timeString(seconds: rest) as String

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timerEntity = timerEntities[(indexPath as NSIndexPath).row]

        delegate?.timerTableViewController(self,
                                           didSelect: timerEntity,
                                           at: (indexPath as NSIndexPath).row)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return timerEntities.count > 1
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {

        if editingStyle == UITableViewCellEditingStyle.delete {
            let timerEntity: TimerEntity = timerEntities[(indexPath as NSIndexPath).row]

            //  Check if deleting the active timer entity.
            //
            let activeTimerEntity = DataModel.sharedInstance.activeTimerEntity()
            let chooseNewActiveTimer = timerEntity == activeTimerEntity

            //  Delete the entity from the table view source and the DataModel.
            //  Also remove the corresponding rows from the table view.
            //
            timerEntities.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            DataModel.sharedInstance.deleteTimerEntity(timerEntity)

            //  Choose a new active timer if necessary.
            //  The first one will do.
            //
            if chooseNewActiveTimer {
                DataModel.sharedInstance.setActiveTimerEntity(timerEntities[0])
            }
        }
    }

    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {

        if (sourceIndexPath as NSIndexPath).row == (destinationIndexPath as NSIndexPath).row {
            //  Nothing to do.
            return
        }

        let timerEntity: TimerEntity = timerEntities[(sourceIndexPath as NSIndexPath).row]

        timerEntities.remove(at: (sourceIndexPath as NSIndexPath).row)
        timerEntities.insert(timerEntity, at: (destinationIndexPath as NSIndexPath).row)

        DataModel.sharedInstance.reorderTimerEntities(timerEntities)
    }

}
