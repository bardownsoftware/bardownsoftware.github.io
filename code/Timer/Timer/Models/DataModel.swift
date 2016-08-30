//
//  Created by bwk on Mon.20.Jun.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import Foundation
import MagicalRecord

class DataModel {

    static let InsertTimerEntityNotification = "DataModelInsertTimerEntityNotification"

    let kAppName: String
    //let kNumberOfCreditsKey = "NumberOfCredits"

    static let sharedInstance: DataModel = {
        let instance = DataModel()
        return instance
    } ()

    //  This prevents others from using the default '()' initializer
    //  for this class.
    //
    private init() {
        kAppName = NSBundle.mainBundle().infoDictionary![kCFBundleNameKey as String] as! String
    }

    func setUp() {
        print("*** DataModel setUp...")
        MagicalRecord.setupAutoMigratingCoreDataStack()
    }

    func cleanUp() {
        print("*** DataModel cleanUp...")
        MagicalRecord.cleanUp()
    }

    func save() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    func fetchAllTimerEntities() -> [TimerEntity] {
        let entities = TimerEntity.MR_findAllSortedBy("order", ascending: true) as! [TimerEntity]
        return entities
    }

    func fetchTimerEntityCount() -> UInt {
        let count = TimerEntity.MR_countOfEntities()
        return count
    }

    func createTimerEntity(name: String,
                           count: Int,
                           duration: Int,
                           interval: Int = 0,
                           rest: Int = 0,
                           alert: Int = 0,
                           delay: Int = 0
                           ) -> TimerEntity? {
        if let timerEntity = TimerEntity.MR_createEntity() {
            timerEntity.name = name
            timerEntity.order = 0
            timerEntity.count = count
            timerEntity.duration = duration
            timerEntity.interval = interval
            timerEntity.rest = rest
            timerEntity.alert = alert
            timerEntity.delay = delay
            save()
            return timerEntity

        } else {
            assert(true, "# error: couldn't create timer entity!")
            return nil
        }
    }

    func insertTimerEntity(timerEntity: TimerEntity, index: Int) {
        let userInfo: [String: AnyObject] = ["entity" : timerEntity,
                                             "position" : index]

        NSNotificationCenter.defaultCenter().postNotificationName(DataModel.InsertTimerEntityNotification,
                                                                  object: self,
                                                                  userInfo: userInfo)
    }

    func reorderTimerEntities(timerEntities: [TimerEntity]) {
        var index: Int = 0
        for timerEntity in timerEntities {
            timerEntity.order = index
            index = index + 1
        }
        save()
    }

    func createDefaultData() {
        if let timerEntity1 = TimerEntity.MR_createEntity() {
            timerEntity1.name = "Timer 1"
            timerEntity1.order = 1
            timerEntity1.count = 3
            timerEntity1.duration = 60
            timerEntity1.interval = 20
            timerEntity1.alert = 0
            timerEntity1.delay = 0
            timerEntity1.rest = 0
        }

        if let timerEntity2 = TimerEntity.MR_createEntity() {
            timerEntity2.name = "Timer 2"
            timerEntity2.order = 2
            timerEntity2.count = 5
            timerEntity2.duration = 120
            timerEntity2.interval = 30
            timerEntity2.alert = 0
            timerEntity2.delay = 0
            timerEntity2.rest = 10
        }

        if let timerEntity3 = TimerEntity.MR_createEntity() {
            timerEntity3.name = "Timer 3"
            timerEntity3.order = 3
            timerEntity3.count = 4
            timerEntity3.duration = 30
            timerEntity3.interval = 15
            timerEntity3.alert = 0
            timerEntity3.delay = 0
            timerEntity3.rest = 5
        }

        save()
    }

//    func numberOfCredits() -> Int {
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        let numberOfCredits = userDefaults.integerForKey(massageKey(kNumberOfCreditsKey))
//        return numberOfCredits;
//    }
//
//    func setNumberOfCredits(numberOfCredits: Int) {
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        userDefaults.setInteger(numberOfCredits, forKey: massageKey(kNumberOfCreditsKey))
//        userDefaults.synchronize()
//    }
//
//    func addCredit() {
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        var numberOfCredits = userDefaults.integerForKey(massageKey(kNumberOfCreditsKey))
//        numberOfCredits = numberOfCredits + 1
//        userDefaults.setInteger(numberOfCredits, forKey: massageKey(kNumberOfCreditsKey))
//        userDefaults.synchronize()
//    }
//
//    func useCredit() {
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        var numberOfCredits = userDefaults.integerForKey(massageKey(kNumberOfCreditsKey))
//        numberOfCredits = numberOfCredits - 1
//        userDefaults.setInteger(numberOfCredits, forKey: massageKey(kNumberOfCreditsKey))
//        userDefaults.synchronize()
//    }

    func massageKey(key: String) -> String {
        return kAppName + key
    }
}

