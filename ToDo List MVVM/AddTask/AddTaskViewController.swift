//
//  AddTaskViewController.swift
//  ToDo List MVVM
//
//  Created by Олег Савельев on 06.08.2021.
//

import UIKit
import RxRelay

protocol AddTaskViewControllerDelegate {
    func updateTasks()
}

class AddTaskViewController: UIViewController {
    //MARK: -UI
    @IBOutlet weak var headNameTask: UITextField!
    @IBOutlet weak var taskTextview: UITextView!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var saveTaskButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let viewModel = AddTaskModel()
    private var delegate: AddTaskViewControllerDelegate?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setDelegate(_ delegate: AddTaskViewControllerDelegate) {
        self.delegate = delegate
    }
    
    private func setupView() {
        headNameTask.placeholder = "Введите заголовок"
        
        taskTextview.layer.cornerRadius = 5
        taskTextview.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        taskTextview.layer.borderWidth = 1
        taskTextview.delegate = self
        taskTextview.text = "Введите описание"
        taskTextview.textColor = UIColor.lightGray
        
        saveTaskButton.setTitle("Сохранить", for: .normal)
        saveTaskButton.layer.cornerRadius = 10
        
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.layer.cornerRadius = 10
    }
    
    //MARK: - Action
    @IBAction func saveItemButton(_ sender: Any) {
        guard let headName = headNameTask.text else { return }
        
        viewModel.task = TaskEntity(headName: headName,
                              textTask: taskTextview.text,
                              dateTask: Date(),
                              deadline: dataPicker.date,
                              statusTask: .active)
        
        delegate?.updateTasks()
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension AddTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if taskTextview.text == "Введите описание" && taskTextview.textColor == UIColor.lightGray {
            taskTextview.text = ""
            taskTextview.textColor = UIColor.darkGray
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if taskTextview.text.isEmpty {
            taskTextview.text = "Введите описание"
            taskTextview.textColor = UIColor.lightGray
        }
    }
}
