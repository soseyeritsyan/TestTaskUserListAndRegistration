//
//  ProfecionTableViewCell.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 24.10.24.
//

import UIKit

class PositionTableViewCell: UITableViewCell {
    
    static let identifier: String = "ProfecionTableViewCell"
    
    @IBOutlet weak var profecionLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    
    func configure(with position: Position, isSelected: Bool) {
        // Configure PositionTableViewCell based on position
        profecionLabel.text = position.name

        if isSelected {
            selectionImageView.image = UIImage(named: "selectIcon")
        } else {
            selectionImageView.image = UIImage(named: "unselectIcon")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
