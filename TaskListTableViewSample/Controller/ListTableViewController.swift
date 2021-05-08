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
    private var taskList: [CheckListItem] = CheckListItemMock.array
    
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
        taskList.append(addTask)
        addTaskTextField.text = ""
        tableView.reloadData()
    }
    
    
}


extension ListTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        cell.taskLabel.text = taskList[indexPath.row].taskName
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
            self.taskList.remove(at: indexPath.row)
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

// これでドラッグ操作はできるようになる
extension ListTableViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [taskList[indexPath.row].dragItem()]
    }
 
}

// 多くの処理はドロップの方で記述する感じ
extension ListTableViewController: UITableViewDropDelegate {
    // 何じゃこりゃ
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let item = coordinator.items.first,
              let destinationIndexPath = coordinator.destinationIndexPath,
              let sourceIndexPath = item.sourceIndexPath else {
            return
        }
        
        // strong weak は勉強しないと
        tableView.performBatchUpdates({ [weak self] in
            guard let strongSelf = self else { return }
            
            let task = strongSelf.taskList.remove(at: sourceIndexPath.row)
            taskList.insert(task, at: destinationIndexPath.row)
            
            tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
            tableView.insertRows(at: [destinationIndexPath], with: .automatic)
            // 上2行なしでreloadData()でも同じように動くが、何が問題あるのだろうか？
//            tableView.reloadData()
        }, completion: nil)
        coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
    }
    
    
}
