//
//  RealmManager.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/22.
//

import Foundation
import RealmSwift
import RxSwift

protocol RealmManagerDataSource {
    func saveLanguageInfo(withInfo data: Language) -> Completable
    func fetchLanguageInfo() -> Single<Language>
}

struct RealmManager: RealmManagerDataSource {
    private var queueScheduler: SchedulerType!

    init(withQueueScheduler queueScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)) {
        self.queueScheduler = queueScheduler
    }

    /// clear and save language info to DB
    func saveLanguageInfo(withInfo info: Language) -> Completable {
        return deleteLanguageInfo()
        .andThen(saveInfo(withInfo: info))
    }

    /// Save language info to DB
   private func saveInfo(withInfo data: Language) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                let realmLanguage = RealmLanguage()

                try realm.write {
                    realmLanguage.update(withLanguageModel: data)
                    realm.add(realmLanguage)
                }
                completable(.completed)
                return Disposables.create {}
            } catch {
                completable(.error(error))
                return Disposables.create {}
            }
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: DispatchQoS.default))
    }

    /// get language info from DB
    func fetchLanguageInfo() -> Single<Language> {
        return Single<Language>.create { single in
            do {
            let realm = try Realm()
                let realmLanguage = RealmLanguage(value: realm.objects(RealmLanguage.self))
                
                let result = Language(withRealmLanguage: realmLanguage)
                single(.success(result))

            } catch {
                single(.failure(error))
            }
            return Disposables.create {}
        }.subscribe(on: self.queueScheduler)
    }

    /// clear language info from DB
    private func deleteLanguageInfo() -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                let realmLanguage = realm.objects(RealmLanguage.self)
                try realm.write {
                    realm.delete(realmLanguage)
                }
                completable(.completed)
                return Disposables.create {}
            } catch {
                completable(.error(error))
                return Disposables.create {}
            }
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
    }
}
