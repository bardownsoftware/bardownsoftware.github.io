//
//  Created by bwk on Wed.24.Aug.16.
//

import Foundation
import CoreData


class TimerEntity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func getCount() -> Int {
        return (count?.integerValue)!
    }

    func getDuration() -> Int {
        return (duration?.integerValue)!
    }

    func getRest() -> Int {
        return (rest?.integerValue)!
    }

    func getDelay() -> Int {
        return (delay?.integerValue)!
    }

}
