//
//  DeletedTableViewCell.swift
//  ToDo List MVVM
//
//  Created by Олег Савельев on 19.03.2022.
//

import UIKit

class DeletedTableViewCell: UITableViewCell {
    
    static var identifier = "deletedCell"

    @IBOutlet weak var headLabel: UILabel!
    
    @IBOutlet weak var textTaskLabel: UILabel!
    
    @IBOutlet weak var dlLabel: UILabel!
    
    @IBOutlet weak var taskDateLabel: UILabel!
    
    func configure(_ item: Task?) {
        guard let item = item else { return }
        headLabel.text = item.headName
        textTaskLabel.text = item.textTask
        dlLabel.text = setupDate(item.deadline)
        taskDateLabel.text = setupDate(item.dateTask)
    }
    
    private func setupDate(_ item: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy HH:mm"
        return formatter.string(from: item as Date)
    }
}
