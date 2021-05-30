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
        // ドラッグ＆ドロップを可能にする
        tableView.dragInteractionEnabled = true
        
    }
    
    @IBAction func tapAddTaskButton(_ sender: UIButton) {
        let addTask = CheckListItem.init(itemName: addTaskTextField.text!, isChecked: false)
        taskList.append(addTask)
        addTaskTextField.text = ""
        tableView.reloadData()
    }
    
    
}

// MARK: - UITableViewDataSource
extension ListTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        cell.taskLabel.text = taskList[indexPath.row].taskName
        
        let checkButtonImage = taskList[indexPath.row].isChecked ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        cell.checkButton.setImage(checkButtonImage, for: UIControl.State.normal)
        
        // セルのタグに行番号を入力
        cell.tag = indexPath.row
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = self
        
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension ListTableViewController: UITableViewDelegate {
    
    // スワイプで種々Actionさせる
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let changeCellColorAction = UIContextualAction(style: .normal, title: "color") { action, view, completionHandler in
            
            let color = tableView.cellForRow(at: indexPath)?.backgroundColor
            
            if color == .yellow {
                tableView.cellForRow(at: indexPath)?.backgroundColor = .none
            } else {
                tableView.cellForRow(at: indexPath)?.backgroundColor = .yellow
            }
            
            // ボタンを押した後にスワイプ状態を解除する
            completionHandler(true)
        }
        
        let changeCellColorImage = UIImage(systemName: "exclamationmark.circle.fill")
        changeCellColorAction.image = changeCellColorImage
        changeCellColorAction.backgroundColor = UIColor.systemYellow
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { action, view, completionHandler in
            self.taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let deleteImage = UIImage(systemName: "trash.fill")
        deleteAction.image = deleteImage
        deleteAction.backgroundColor = UIColor.red
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, changeCellColorAction])
        // デフォルトでtrue
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
    }
    
}

// MARK: - UITableViewDragDelegate
// これでドラッグ操作はできるようになる
extension ListTableViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
//        return [taskList[indexPath.row].dragItem()]
        
        // わざわざCheckListItemにdragItem()を書かないで、ここに直書きでも良いのでは？
        // ModelにUIKitをimportするのってやっぱ変な気がするし。
        let itemProvider = NSItemProvider(object: taskList[indexPath.row].taskName as NSString)
        
        // NSItemProviderはドラッグ&ドロップでテキストフィールドなどにドロップした時に与える文字列情報
        // 別にこれが空文字であろうが、TableView内でのドラッグ&ドロップは成立する。
//        let itemProvider = NSItemProvider(object: "first" as NSString)
        return [UIDragItem(itemProvider: itemProvider)]
        
        // 配列を返すのは、複数の値をドラッグできるようにするため
//        return [UIDragItem(itemProvider: NSItemProvider(object: "first" as NSString)), UIDragItem(itemProvider: NSItemProvider(object: "second" as NSString))]
        
    }
 
}

// MARK: - UITableViewDropDelegate
// 多くの処理はドロップの方で記述する感じ
extension ListTableViewController: UITableViewDropDelegate {
    // 視覚的なフィードバックと公式ドキュメントには書かれていた
    // operationの.moveを.copyに変えるとプラスマークが表示され、動作には変化は起こらない（多分）
    // .forbiddenにすると、ドロップ禁止のようなマークが表示され、実際にドロップすることはできなくなる
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
            // 複数Sectionを使う場合、reloadData()ではエラーとなった
            // 両方実行すると、並び替えの際表示がギクシャクする
            // reloadData()だけでOK?
            // reloadData()しないとtagがおかしくなる
            // completionを使えば良いんだ。解決（多分）
        }, completion: {_ in
            tableView.reloadData()
        })
        // これなくても正常に動くが、アニメーションが直感的ではなくなる
        // dropしたものがtoRowAtに落ちていくってイメージ
        // toRowAtをsourceIndexPathに変えてみると分かりやすい
        coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
    }
    
}
// MARK: - ListTableViewCellDelegate
extension ListTableViewController: ListTableViewCellDelegate {
    func toggleCheckButton(cell: ListTableViewCell) {
        taskList[cell.tag].isChecked.toggle()
        tableView.reloadData()
    }
}
