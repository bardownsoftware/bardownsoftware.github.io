//
//  Created by bwk on Thu.25.Aug.16.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TimerEntity {

    @NSManaged var alert: NSNumber?
    @NSManaged var count: NSNumber?
    @NSManaged var delay: NSNumber?
    @NSManaged var duration: NSNumber?
    @NSManaged var interval: NSNumber?
    @NSManaged var name: String?
    @NSManaged var rest: NSNumber?
    @NSManaged var order: NSNumber?

}
