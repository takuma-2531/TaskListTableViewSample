//
//  ListTableViewController.swift
//  TaskListTableViewSample
//
//  Created by 小川卓馬 on 2021/05/06.
//

import UIKit

class ListTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskTextField: UITextField!
    private var itemList: [CheckListItem] = CheckListItemMock.array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.register(ListTableViewCell.nib, forCellReuseIdentifier: ListTableViewCell.identifier)
        // これなんだろ
        tableView.dragInteractionEnabled = true
        
    }
    
    @IBAction func tapAddTaskButton(_ sender: UIButton) {
        let addTask = CheckListItem.init(itemName: addTaskTextField.text!, isChecked: false)
        itemList.append(addTask)
        addTaskTextField.text = ""
        tableView.reloadData()
    }
    
    
}


extension ListTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        cell.taskLabel.text = itemList[indexPath.row].itemName
        cell.checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: UIControl.State.normal)
        return cell
    }
    
    
}

extension ListTableViewController: UITableViewDelegate {
    
    // スワイプで種々Actionさせる
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let downSectionAction = UIContextualAction(style: .normal, title: "down") { ctxAction, view, completionHandler in
            // ボタンを押した後にスワイプ状態を解除する
            completionHandler(true)
        }
        
        let downSectionImage = UIImage(systemName: "arrow.down.square")?.withTintColor(UIColor.white, renderingMode: .alwaysTemplate)
        downSectionAction.image = downSectionImage
        downSectionAction.backgroundColor = UIColor.blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { ctxAction, view, completionHandler in
            self.itemList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let deleteImage = UIImage(systemName: "trash.fill")?.withTintColor(UIColor.white, renderingMode: .alwaysTemplate)
        deleteAction.image = deleteImage
        deleteAction.backgroundColor = UIColor.red
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, downSectionAction])
        // デフォルトでtrue
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
    }
    
}

// ドラッグ＆ドロップを実装しようとしている
extension ListTableViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [itemList[indexPath.row].dragItem()]
    }
    
    
    
}

extension ListTableViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
    
}
