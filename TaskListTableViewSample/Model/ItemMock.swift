//
//  ItemMock.swift
//  TaskListTableViewSample
//
//  Created by 小川卓馬 on 2021/05/08.
//

import Foundation

enum CheckListItemMock {
    static let one = CheckListItem(itemName: "One", isChecked: false)
    static let two = CheckListItem(itemName: "Two", isChecked: true)
    static let three = CheckListItem(itemName: "Three", isChecked: false)
    static let four = CheckListItem(itemName: "four", isChecked: false)
    static let five = CheckListItem(itemName: "five", isChecked: true)
    
    static let array: [CheckListItem] = [one, two, three, four, five]
}
