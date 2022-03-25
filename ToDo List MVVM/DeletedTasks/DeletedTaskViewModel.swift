//
//  DeletedTaskViewModel.swift
//  ToDo List MVVM
//
//  Created by Олег Савельев on 19.03.2022.
//

import RxSwift
import RxCocoa
import RealmSwift

final class DeletedTasksViewModel {
    let storageSerice: StorageManager!
    
    let bag = DisposeBag()
    
    var input: Input
    var output: Output
    
    init(storageSerice: StorageManager = StorageManagerService()) {
        self.storageSerice = storageSerice
        
        input = Input(fetchTasks: PublishRelay<Void>(),
                      activeTask: PublishRelay<TaskEntity?>())
        
        output = Output(tasks: PublishRelay<Results<TaskEntity>>())
        
        setUpBindings()
    }
    
    func setUpBindings() {
        input.fetchTasks.bind { [weak self] in
            guard let self = self else { return }
            self.output.tasks.accept(self.fetchTasks())
        }.disposed(by: bag)
        
        input.activeTask.subscribe { [weak self] in
            self?.storageSerice.activeTask(item: $0)
        }.disposed(by: bag)
    }
    
    func fetchTasks() -> Results<TaskEntity> {
        storageSerice.fetchTask().filter("statusTask != 0")
    }
}

extension DeletedTasksViewModel {
    struct Input {
        var fetchTasks: PublishRelay<Void>
        var activeTask: PublishRelay<TaskEntity?>
    }
    
    struct Output {
        var tasks: PublishRelay<Results<TaskEntity>>
    }
}

