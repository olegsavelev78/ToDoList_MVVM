//
//  Tasks.swift
//  ToDo List MVVM
//
//  Created by Олег Савельев on 05.08.2021.
//

import RealmSwift

enum StatusTaskType: Int {
    case active = 0, deleted, archived
}

struct Task {
    var headName: String = .init()
    var textTask: String = .init()
    var dateTask: Date = .init()
    var deadline: Date = .init()
    var statusTask: StatusTaskType = .active
    
    func toEntity() -> TaskEntity {
        let task = TaskEntity()
        task.headName = self.headName
        task.textTask = self.textTask
        task.dateTask = self.dateTask
        task.deadline = self.deadline
        task.statusTask = self.statusTask.rawValue
        return task
    }
}

@objcMembers
final class TaskEntity: Object {
    dynamic var headName = ""
    dynamic var textTask = ""
    dynamic var dateTask = Date()
    dynamic var deadline = Date()
    dynamic var statusTask = 0
    
    convenience init(headName: String,
                     textTask: String,
                     dateTask: Date,
                     deadline: Date,
                     statusTask: StatusTaskType) {
        self.init()
        self.headName = headName
        self.textTask = textTask
        self.dateTask = dateTask
        self.deadline = deadline
        self.statusTask = statusTask.rawValue
    }
    
    func toModel() -> Task {
        var task = Task()
        task.headName = self.headName
        task.textTask = self.textTask
        task.dateTask = self.dateTask
        task.deadline = self.deadline
        task.statusTask = StatusTaskType(rawValue: self.statusTask) ?? .active
        return task
    }
}
