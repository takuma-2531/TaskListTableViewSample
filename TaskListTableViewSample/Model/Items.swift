//
//  Items.swift
//  TaskListTableViewSample
//
//  Created by 小川卓馬 on 2021/05/06.
//


// ModelにUIKitをimportするのはおかしいのか？
import UIKit

struct CheckListItem {
    var taskName: String
    var isChecked: Bool
    
    init(itemName: String, isChecked: Bool) {
        self.taskName = itemName
        self.isChecked = isChecked
    }
}

extension CheckListItem {
    func dragItem() -> UIDragItem {
        // isCheckedも触らないとあかんよな -> No
        let itemProvider = NSItemProvider(object: taskName as NSString)
        return UIDragItem(itemProvider: itemProvider)
    }
}
