//
//
//  Timer
//
//  Created by bwk on Sat.21.Jan.17.
//  Copyright © 2017 Bar Down Software. All rights reserved.
//

import UIKit

class NewStuffViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //  MARK: segue

    @IBAction func unwindFromNewTimer(_ sender: UIStoryboardSegue) {
        dismiss(animated: true) {
        }
    }

    @IBAction func unwindFromOther(_ sender: UIStoryboardSegue) {
        dismiss(animated: true) {
        }
    }

}
