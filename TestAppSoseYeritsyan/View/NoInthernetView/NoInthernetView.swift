//
//  NoInthernetView.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 21.10.24.
//

import UIKit

protocol NoInternetViewDelegate: AnyObject {
    func didTapTryAgain()
}

class NoInthernetView: UIView {
    weak var delegate: NoInternetViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NoInthernetView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tryAgainButton.layer.cornerRadius = tryAgainButton.frame.height / 2
    }
    
    @IBAction func tryAgainAction(_ sender: Any) {
        delegate?.didTapTryAgain()
    }
    
}
