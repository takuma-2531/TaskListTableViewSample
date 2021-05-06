//
//  ListTableViewCell.swift
//  TaskListTableViewSample
//
//  Created by 小川卓馬 on 2021/05/06.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
//    private var isChecked = false
    
    static var identifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapCheckButton(_ sender: UIButton) {
        
//        isChecked.toggle()
//
//        let image = isChecked ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
//        let state = UIControl.State.normal
//
//        sender.setImage(image, for: state)
        
    }
    
    
}
