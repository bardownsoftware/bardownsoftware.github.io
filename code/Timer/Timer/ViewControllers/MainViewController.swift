//
//  Created by bwk on Wed.24.Aug.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!

    var listViewController: ListViewController?
    var editViewController: EditViewController?
    var settingsViewController: SettingsViewController?

    var timerEntity: TimerEntity?

    override func viewDidLoad() {
        super.viewDidLoad()

        let timerEntities = DataModel.sharedInstance.fetchAllTimerEntities()
        timerEntity = timerEntities[0]

        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func update() {
        titleLabel.text = timerEntity?.name
    }

    //  MARK: segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ListSegue" {
            listViewController = (segue.destinationViewController as! ListViewController)
            listViewController!.delegate = self;

        } else if segue.identifier == "EditSegue" {
            editViewController = (segue.destinationViewController as! EditViewController)
            //editViewController!.delegate = self;

        } else if segue.identifier == "SettingsSegue" {
            settingsViewController = (segue.destinationViewController as! SettingsViewController)
            //settingsViewController!.delegate = self;
        }
    }

    //  MARK: actions

    @IBAction func unwindFromEdit(sender: UIStoryboardSegue) {
        /*
        if let infoViewController = sender.sourceViewController as? InfoViewController {
            print ("infoViewController = \(infoViewController)")
        }
         */
        [self .dismissViewControllerAnimated(true, completion: { 
        })]
    }

    @IBAction func unwindFromList(sender: UIStoryboardSegue) {
        /*
         if let infoViewController = sender.sourceViewController as? InfoViewController {
         print ("infoViewController = \(infoViewController)")
         }
         */
        [self .dismissViewControllerAnimated(true, completion: {
        })]
    }

    @IBAction func unwindFromSettings(sender: UIStoryboardSegue) {
        /*
         if let infoViewController = sender.sourceViewController as? InfoViewController {
         print ("infoViewController = \(infoViewController)")
         }
         */
        [self .dismissViewControllerAnimated(true, completion: {
        })]
    }
}

extension MainViewController: ListViewControllerDelegate {

    func listViewController(viewController: ListViewController, didSelectEntity timerEntity: TimerEntity, atIndex: Int) {
        self.timerEntity = timerEntity

        update()

        [self .dismissViewControllerAnimated(true, completion: {
        })]
    }
}


