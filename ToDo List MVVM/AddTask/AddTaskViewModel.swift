//
//  TaskModel.swift
//  ToDo List MVVM
//
//  Created by Олег Савельев on 05.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class AddTaskModel {
    let storageSerice: StorageManager!
    
    public var task: TaskEntity! {
        didSet {
            self.saveTask(task)
        }
    }
    
    let bag = DisposeBag()
    
    var input: Input
    
    init(storageSerice: StorageManager = StorageManagerService()) {
        self.storageSerice = storageSerice
        
        input = Input(task: PublishRelay<TaskEntity>())
        
        setUpBindings()
    }
    
    func setUpBindings() {
        input.task.bind { [weak self] in
            guard let self = self else { return }
            self.task = $0
        }
        .disposed(by: bag)
    }
    
    private func saveTask(_ task: TaskEntity) {
        storageSerice.saveTask(task)
    }
}

extension AddTaskModel {
    struct Input {
        var task: PublishRelay<TaskEntity>
    }
}
