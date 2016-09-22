//
//  Created by bwk on Mon.20.Jun.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import Foundation
import MagicalRecord

class DataModel {

    static let InsertTimerEntityNotification = "DataModelInsertTimerEntityNotification"

    let kAppName: String

    static let sharedInstance: DataModel = {
        let instance = DataModel()
        return instance
    } ()

    //  Prevent usage of the default () initializer.
    //
    private init() {
        kAppName = NSBundle.mainBundle().infoDictionary![kCFBundleNameKey as String] as! String
    }

    func setUp() {
        MagicalRecord.setupAutoMigratingCoreDataStack()
    }

    func cleanUp() {
        MagicalRecord.cleanUp()
    }

    func save() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    func fetchSessionEntity() -> SessionEntity {
        let entities = SessionEntity.MR_findAll() as! [SessionEntity]
        return entities[0]
    }

    func isSoundOn() -> Bool {
        let sessionEntity = fetchSessionEntity()
        return (sessionEntity.soundOn?.boolValue)!
    }

    func setSoundOn(soundOn: Bool) {
        let sessionEntity = fetchSessionEntity()
        sessionEntity.soundOn = soundOn
        save()
    }

    func activeTimerEntity() -> TimerEntity {
        let sessionEntity = fetchSessionEntity()
        return sessionEntity.activeTimer!
    }

    func setActiveTimerEntity(timerEntity: TimerEntity) {
        let sessionEntity = fetchSessionEntity()
        sessionEntity.activeTimer = timerEntity
        save()
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
                           rest: Int = 0,
                           delay: Int = 0,
                           interval: Int = 0,
                           alert: Int = 0
                           ) -> TimerEntity? {
        if let timerEntity = TimerEntity.MR_createEntity() {
            timerEntity.name = name
            timerEntity.order = 0
            timerEntity.count = count
            timerEntity.duration = duration
            timerEntity.rest = rest
            timerEntity.delay = delay
            timerEntity.interval = interval
            timerEntity.alert = alert
            save()
            return timerEntity

        } else {
            assert(true, "# error: couldn't create timer entity!")
            return nil
        }
    }

    func deleteTimerEntity(timerEntity: TimerEntity) {
        timerEntity.MR_deleteEntity()
        save()
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

        var activeTimerEntity: TimerEntity? = nil

        if let timerEntity = TimerEntity.MR_createEntity() {
            timerEntity.name = "Timer A"
            timerEntity.order = 1
            timerEntity.count = 5
            timerEntity.duration = 10
            timerEntity.rest = 5
            timerEntity.delay = 5
            timerEntity.interval = 0
            timerEntity.alert = 0
            activeTimerEntity = timerEntity
        }

        if let timerEntity = TimerEntity.MR_createEntity() {
            timerEntity.name = "Timer B"
            timerEntity.order = 2
            timerEntity.count = 5
            timerEntity.duration = 5
            timerEntity.rest = 0
            timerEntity.delay = 5
            timerEntity.interval = 0
            timerEntity.alert = 0
        }

        if let timerEntity = TimerEntity.MR_createEntity() {
            timerEntity.name = "Timer C"
            timerEntity.order = 3
            timerEntity.count = 1
            timerEntity.duration = 15
            timerEntity.rest = 0
            timerEntity.delay = 5
            timerEntity.interval = 0
            timerEntity.alert = 0
        }

        if let timerEntity = TimerEntity.MR_createEntity() {
            timerEntity.name = "Timer D"
            timerEntity.order = 4
            timerEntity.count = 4
            timerEntity.duration = 15
            timerEntity.rest = 0
            timerEntity.delay = 5
            timerEntity.interval = 0
            timerEntity.alert = 0
        }

        if let timerEntity = TimerEntity.MR_createEntity() {
            timerEntity.name = "Timer E"
            timerEntity.order = 5
            timerEntity.count = 3
            timerEntity.duration = 60
            timerEntity.rest = 5
            timerEntity.delay = 5
            timerEntity.interval = 0
            timerEntity.alert = 0
        }

        if let sessionEntity = SessionEntity.MR_createEntity() {
            sessionEntity.counter = 0
            sessionEntity.soundOn = true
            sessionEntity.activeTimer = activeTimerEntity
        }

        save()
    }

    func massageKey(key: String) -> String {
        return kAppName + key
    }
}

