//
//  UserTableViewCell.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 22.10.24.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "UserTableViewCell"
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    func configure(with user: UserModel) {
        // Configure UserTableViewCell based on user model
        let url = URL(string: user.photo)
        userImageView.kf.setImage(with: url)
        nameLabel.text = user.name
        professionLabel.text = user.position
        emailLabel.text = user.email
        phoneLabel.text = user.phone
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
