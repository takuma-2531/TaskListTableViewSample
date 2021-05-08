//
//  ItemMock.swift
//  TaskListTableViewSample
//
//  Created by 小川卓馬 on 2021/05/08.
//

import Foundation

enum CheckListItemMock {
    static let a = CheckListItem(itemName: "test", isChecked: false)
    static let b = CheckListItem(itemName: "list", isChecked: true)
    static let c = CheckListItem(itemName: "item", isChecked: false)
    static let array: [CheckListItem] = [a, b, c]
}
