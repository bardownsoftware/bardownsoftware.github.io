//
//  Created by bwk on Mon.20.Jun.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import Foundation
import MagicalRecord

class DataModel {

    static let InsertTimerEntityNotification = "DataModelInsertTimerEntityNotification"
    static let DeleteTimerEntityNotification = "DataModelDeleteTimerEntityNotification"

    let kAppName: String

    static let sharedInstance: DataModel = {
        let instance = DataModel()
        return instance
    } ()

    //  Prevent usage of the default () initializer.
    //
    fileprivate init() {
        kAppName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    }

    func setUp() {
        MagicalRecord.setupAutoMigratingCoreDataStack()
    }

    func cleanUp() {
        MagicalRecord.cleanUp()
    }

    func save() {
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }

    func fetchSessionEntity() -> SessionEntity {
        let entities = SessionEntity.mr_findAll() as! [SessionEntity]
        return entities[0]
    }

    func isSoundOn() -> Bool {
        let sessionEntity = fetchSessionEntity()
        return (sessionEntity.soundOn?.boolValue)!
    }

    func set(soundOn: Bool) {
        let sessionEntity = fetchSessionEntity()
        sessionEntity.soundOn = soundOn as NSNumber?
        save()
    }

    func activeTimerEntity() -> TimerEntity {
        let sessionEntity = fetchSessionEntity()
        return sessionEntity.activeTimer!
    }

    func setActiveTimerEntity(_ timerEntity: TimerEntity) {
        let sessionEntity = fetchSessionEntity()
        sessionEntity.activeTimer = timerEntity
        save()
    }

    func fetchAllTimerEntities() -> [TimerEntity] {
        let entities = TimerEntity.mr_findAllSorted(by: "order", ascending: true) as! [TimerEntity]
        return entities
    }

    func fetchTimerEntityCount() -> UInt {
        let count = TimerEntity.mr_countOfEntities()
        return count
    }

    func createTimerEntity(_ name: String,
                           count: Int,
                           duration: Int,
                           rest: Int = 0,
                           delay: Int = 0,
                           interval: Int = 0,
                           alert: Int = 0
                           ) -> TimerEntity? {
        if let timerEntity = TimerEntity.mr_createEntity() {
            timerEntity.name = name
            timerEntity.order = 0
            timerEntity.count = count as NSNumber?
            timerEntity.duration = duration as NSNumber?
            timerEntity.rest = rest as NSNumber?
            timerEntity.delay = delay as NSNumber?
            timerEntity.interval = interval as NSNumber?
            timerEntity.alert = alert as NSNumber?
            save()
            return timerEntity

        } else {
            assert(true, "# error: couldn't create timer entity!")
            return nil
        }
    }

    func deleteTimerEntity(_ timerEntity: TimerEntity) {
        timerEntity.mr_deleteEntity()
        save()

        NotificationCenter.default.post(name: Notification.Name(rawValue: DataModel.DeleteTimerEntityNotification),
                                                                  object: self,
                                                                  userInfo: nil)
    }

    func insertTimerEntity(_ timerEntity: TimerEntity, index: Int) {
        let userInfo: [String: AnyObject] = ["entity" : timerEntity,
                                             "position" : index as AnyObject]

        NotificationCenter.default.post(name: Notification.Name(rawValue: DataModel.InsertTimerEntityNotification),
                                                                  object: self,
                                                                  userInfo: userInfo)
    }

    func reorderTimerEntities(_ timerEntities: [TimerEntity]) {
        var index: Int = 0
        for timerEntity in timerEntities {
            timerEntity.order = index as NSNumber?
            index = index + 1
        }
        save()
    }

    func createDefaultData() {

        var activeTimerEntity: TimerEntity? = nil

        if let timerEntity = TimerEntity.mr_createEntity() {
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

        if let timerEntity = TimerEntity.mr_createEntity() {
            timerEntity.name = "Timer B"
            timerEntity.order = 2
            timerEntity.count = 5
            timerEntity.duration = 10
            timerEntity.rest = 0
            timerEntity.delay = 5
            timerEntity.interval = 0
            timerEntity.alert = 0
        }

        if let timerEntity = TimerEntity.mr_createEntity() {
            timerEntity.name = "Timer C"
            timerEntity.order = 3
            timerEntity.count = 1
            timerEntity.duration = 15
            timerEntity.rest = 0
            timerEntity.delay = 5
            timerEntity.interval = 0
            timerEntity.alert = 0
        }

        if let timerEntity = TimerEntity.mr_createEntity() {
            timerEntity.name = "Timer D"
            timerEntity.order = 4
            timerEntity.count = 4
            timerEntity.duration = 15
            timerEntity.rest = 0
            timerEntity.delay = 5
            timerEntity.interval = 0
            timerEntity.alert = 0
        }

        if let timerEntity = TimerEntity.mr_createEntity() {
            timerEntity.name = "Timer E"
            timerEntity.order = 5
            timerEntity.count = 3
            timerEntity.duration = 60
            timerEntity.rest = 5
            timerEntity.delay = 5
            timerEntity.interval = 0
            timerEntity.alert = 0
        }

        if let sessionEntity = SessionEntity.mr_createEntity() {
            sessionEntity.counter = 0
            sessionEntity.soundOn = true
            sessionEntity.activeTimer = activeTimerEntity
        }

        save()
    }

    func massageKey(_ key: String) -> String {
        return kAppName + key
    }
}

