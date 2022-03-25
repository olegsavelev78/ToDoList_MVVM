//
//  StorageManager.swift
//  ToDo List MVVM
//
//  Created by Олег Савельев on 05.08.2021.
//

import RealmSwift

protocol StorageManager {
    func fetchTask() -> Results<TaskEntity>
    func saveTask(_ task: TaskEntity)
    func deleteTask(item: TaskEntity?)
    func activeTask(item: TaskEntity?)
    func closeTask(item: TaskEntity?)
}

final class StorageManagerService: StorageManager {
    
    let realm = try! Realm()
    
    func fetchTask() -> Results<TaskEntity> {
        realm.objects(TaskEntity.self)
    }
    
    func saveTask(_ task: TaskEntity) {
        try! realm.write{
            realm.add(task)
        }
    }
    
    func closeTask(item: TaskEntity?) {
        try! realm.write {
            item?.statusTask = 2
        }
    }
    
    func deleteTask(item: TaskEntity?) {
        try! realm.write {
            item?.statusTask = 1
        }
    }
    
    func activeTask(item: TaskEntity?) {
        try! realm.write {
            item?.statusTask = 0
        }
    }
}

