//
//  RealmCache.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmCache<T> where T: Object {
    
    // MARK: - Private Properties
    
    private var realm: Realm? {
        return try? Realm()
    }
    
    // MARK: - Public Methods
    
    func getCachedObject() -> T? {
        print("get")
        guard let realm = realm, !realm.objects(T.self).isEmpty else { return nil }
        return Array(realm.objects(T.self)).first
    }
    
    func getCachedArray() -> [T]? {
        guard let realm = realm, !realm.objects(T.self).isEmpty else { return nil }
        return Array(realm.objects(T.self))
    }
    
    func refreshCache(_ object: T) {
        do {
            print("refresh")
            try? realm?.write {
                cleanCache()
                realm?.add(object)
            }
        }
    }
    
    func refreshCache(_ array: [T]) {
        let cacheList = List<T>()
        do {
            try? realm?.write {
                cleanCache()
                cacheList.append(objectsIn: array)
                realm?.add(cacheList)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func cleanCache() {
        print("clean")
        guard let realm = realm, !realm.objects(T.self).isEmpty else { return }
        let objects = realm.objects(T.self)
        realm.delete(objects)
    }
}
