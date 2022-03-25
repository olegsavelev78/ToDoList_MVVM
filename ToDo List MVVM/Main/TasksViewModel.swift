//
//  TasksViewModel.swift
//  ToDo List MVVM
//
//  Created by Олег Савельев on 12.08.2021.
//

import RealmSwift
import RxSwift
import RxCocoa

final class TasksViewModel {
    let storageSerice: StorageManager!
    
    let bag = DisposeBag()
    
    var input: Input
    var output: Output
    
    init(storageSerice: StorageManager = StorageManagerService()) {
        self.storageSerice = storageSerice
        
        input = Input(fetchTasks: PublishRelay<Void>(),
                      cancelTask: PublishRelay<TaskEntity?>(),
                      deleteTask: PublishRelay<TaskEntity?>())
        
        output = Output(tasks: PublishRelay<Results<TaskEntity>>())
        
        setUpBindings()
    }
    
    func setUpBindings() {
        input.fetchTasks.bind { [weak self] in
            guard let self = self else { return }
            self.output.tasks.accept(self.fetchTasks())
        }.disposed(by: bag)
        
        input.cancelTask.subscribe { [weak self] in
            self?.storageSerice.closeTask(item: $0)
        }.disposed(by: bag)
        
        input.deleteTask.subscribe { [weak self] in
            self?.storageSerice.deleteTask(item: $0)
        }.disposed(by: bag)
    }
    
    //MARK: - Private
    private func fetchTasks() -> Results<TaskEntity> {
        storageSerice.fetchTask().filter("statusTask == 0")
    }
}

extension TasksViewModel {
    struct Input {
        var fetchTasks: PublishRelay<Void>
        var cancelTask: PublishRelay<TaskEntity?>
        var deleteTask: PublishRelay<TaskEntity?>
    }
    
    struct Output {
        var tasks: PublishRelay<Results<TaskEntity>>
    }
}

