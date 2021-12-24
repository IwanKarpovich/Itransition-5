//
//  MailTableViewCell.swift
//  login and password
//
//  Created by Ivan Karpovich on 22.12.21.
//

import UIKit

class MailTableViewCell: UITableViewCell {

    @IBOutlet weak var Nameuser: UILabel!
    @IBOutlet weak var Statususer: UILabel!
    @IBOutlet weak var Textuser: UILabel!
    @IBOutlet weak var TextuserCreate: UILabel!
    @IBOutlet weak var TextuserLastLogin: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
