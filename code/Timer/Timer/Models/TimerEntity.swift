//
//  Created by bwk on Wed.24.Aug.16.
//

import Foundation
import CoreData


class TimerEntity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func getCount() -> Int {
        return (count?.intValue)!
    }

    func getDuration() -> Int {
        return (duration?.intValue)!
    }

    func getRest() -> Int {
        return (rest?.intValue)!
    }

    func getDelay() -> Int {
        return (delay?.intValue)!
    }

}
