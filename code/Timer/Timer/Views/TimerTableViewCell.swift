//
//  Created by bwk on Thu.22.Sep.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var restLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.textColor = UIColor.black
        countLabel.textColor = UIColor.ready()
        durationLabel.textColor = UIColor.go()
        restLabel.textColor = UIColor.rest()
    }

}
