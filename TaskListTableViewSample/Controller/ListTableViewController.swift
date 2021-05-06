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
    private var itemList: [CheckListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListTableViewCell.nib, forCellReuseIdentifier: ListTableViewCell.identifier)
        
    }
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        let addTask = CheckListItem.init(itemName: addTaskTextField.text!, isChecked: false)
        itemList.append(addTask)
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
    
}
