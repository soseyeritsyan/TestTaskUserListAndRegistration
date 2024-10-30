//
//  ResultViewController.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 26.10.24.
//

import UIKit

class ResultViewController: CustomViewController {
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var registerUserResponse: RegisterUserResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    
    func setupInterface() {
        // Hide Tab bar
        tabBarController?.tabBar.isHidden = true
        
        // Configure resultButton
        resultButton.layer.cornerRadius = resultButton.frame.height / 2
        
        guard let registerUserResponse else { return }
        
        let isSuccess = registerUserResponse.success
        let message = registerUserResponse.message
        
        // Update interface based on signup result
        resultImageView.image = isSuccess ? UIImage(named: "successImage") : UIImage(named: "failureImage")
        resultButton.setTitle(isSuccess ? "Got it" : "Try again", for: .normal)
        messageLabel.text = message
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        // pop back
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func resultAction(_ sender: Any) {
        // pop back
        navigationController?.popViewController(animated: true)
    }
}
