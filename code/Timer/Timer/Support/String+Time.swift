//
//  Created by bwk on Fri.09.Sep.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import Foundation

extension NSString {

    class func timeString(seconds: Int) -> NSString {
        var timeString: String = "0s"

        if seconds <= 60 {
            timeString = "\(seconds)s"

        } else {
            let minutes = seconds / 60
            let seconds = seconds % 60

            if 0 == seconds {
                timeString = "\(minutes)m"
            } else {
                timeString = "\(minutes)m \(seconds)s"
            }
        }
        
        return timeString
    }

}
