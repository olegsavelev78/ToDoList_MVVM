//
//  TaskTableViewCell.swift
//  ToDo List MVVM
//
//  Created by Олег Савельев on 05.08.2021.
//

import UIKit
import RxSwift

class TaskTableViewCell: UITableViewCell {
    
    static var identifier = "task"
    
    //MARK: - UI
    @IBOutlet weak var headNameLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - Setup
    func configure(_ task: TaskEntity?) {
        guard let task = task else { return }
        headNameLabel.text = task.headName
        taskLabel.text = task.textTask
        deadlineLabel.text = setupDate(task.deadline)
        dateLabel.text = setupDate(task.dateTask)
    }
    
    private func setupDate(_ item: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy  HH:mm"
        return formatter.string(from: item as Date)
    }
}
