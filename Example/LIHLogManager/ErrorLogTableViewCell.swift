//
//  ErrorLogTableViewCell.swift
//  Smart Office
//
//  Created by Lasith Hettiarachchi on 10/23/15.
//  Copyright © 2015 fidenz. All rights reserved.
//

import UIKit
import LIHLogManager

class ErrorLogTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setValues(log: LIHLog) {
        
        self.lblTitle.text = log.title
        self.lblMessage.text = log.message
        self.lblDateTime.text = "\(log.date)  \(log.time)"
    }
}
