//
//  Created by bwk on Wed.21.Sep.16.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SessionEntity {

    @NSManaged var counter: NSNumber?
    @NSManaged var soundOn: NSNumber?
    @NSManaged var activeTimer: TimerEntity?

}
