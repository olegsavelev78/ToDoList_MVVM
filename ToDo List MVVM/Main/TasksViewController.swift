//
//  TasksViewController.swift
//  ToDo List MVVM
//
//  Created by Олег Савельев on 05.08.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class TasksViewController: UIViewController {
    
    //MARK: - UI
    @IBOutlet var tasksTableView: UITableView!
    @IBOutlet var addTaskButton: UIButton!
    
    private let bag = DisposeBag()
    private var viewModel = TasksViewModel()
    
    private var tasks: Results<TaskEntity>?
    
    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.fetchTasks.accept(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupButton()
    }
    
    private func setupButton() {
        addTaskButton.setTitle("Новая задача", for: .normal)
    }
    
    //MARK: - Bind
    private func bind() {
        viewModel.output.tasks.subscribe { [weak self] tasks in
            self?.tasks = tasks.element
            self?.tasksTableView.reloadData()
        }.disposed(by: bag)
        
        addTaskButton.rx.tap.bind { [weak self] in
            self?.routeToAddTask()
        }.disposed(by: bag)
    }
    
    //MARK: - Private
    private func routeToAddTask() {
        guard let vcAdd = self.storyboard?.instantiateViewController(identifier: "AddTask") as? AddTaskViewController else { return }
        vcAdd.setDelegate(self)
        self.present(vcAdd, animated: true, completion: nil)
    }
    
    //MARK: Alert
    private func showAlert(task: TaskEntity?, index: IndexPath){
        let ac = UIAlertController(title: "Выберите действие", message: nil, preferredStyle: .actionSheet)
        
        let cancelTask = UIAlertAction(title: "Закрыть задачу", style: .default) { [weak self] (action) in
            self?.viewModel.input.cancelTask.accept(task)
            self?.viewModel.input.fetchTasks.accept(())
        }
        
        let deletedTask = UIAlertAction(title: "Удалить задачу", style: .default) { [weak self] (action) in
            self?.viewModel.input.deleteTask.accept(task)
            self?.viewModel.input.fetchTasks.accept(())
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        ac.addAction(cancelTask)
        ac.addAction(deletedTask)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TaskTableViewCell
        cell.configure(tasks?[indexPath.row])
        return cell
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = tasks?[indexPath.row]
        showAlert(task: item, index: indexPath)
    }
}

extension TasksViewController: AddTaskViewControllerDelegate {
    func updateTasks() {
        viewModel.input.fetchTasks.accept(())
    }
}
