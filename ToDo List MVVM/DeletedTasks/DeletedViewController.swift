//
//  DeletedViewController.swift
//  ToDo List MVVM
//
//  Created by Олег Савельев on 19.03.2022.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class DeletedTasksViewController: UIViewController {
    
    //MARK: - UI
    @IBOutlet var tasksTableView: UITableView!
    
    private let bag = DisposeBag()
    private var viewModel = DeletedTasksViewModel()
    
    private var tasks: Results<TaskEntity>?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.input.fetchTasks.accept(())
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }
    
    //MARK: - Bind
    private func bind() {
        viewModel.output.tasks.subscribe { [weak self] tasks in
            self?.tasks = tasks.element
            self?.tasksTableView.reloadData()
        }.disposed(by: bag)
    }
    
    //MARK: Alert
    private func showAlert(task: TaskEntity?, index: IndexPath){
        let ac = UIAlertController(title: "Выберите действие", message: nil, preferredStyle: .actionSheet)
        
        let restoreTask = UIAlertAction(title: "Восстановить задачу", style: .default) { [weak self] (action) in
            self?.viewModel.input.activeTask.accept(task)
            self?.viewModel.input.fetchTasks.accept(())
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        ac.addAction(restoreTask)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}

extension DeletedTasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deletedCell", for: indexPath) as! DeletedTableViewCell
        cell.configure(tasks?[indexPath.row].toModel())
        return cell
    }
}

extension DeletedTasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = tasks?[indexPath.row]
        showAlert(task: item, index: indexPath)
    }
}
