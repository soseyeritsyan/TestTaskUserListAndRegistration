//
//  SignUpViewController.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 24.10.24.
//

import UIKit
import AVFoundation
import Photos

class SignUpViewController: CustomViewController {

    // Name field
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameRequiredLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    // Email field
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailRequiredLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    // Phone field
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneRequiredLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    
    // Upload field
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var uploadLabel: UILabel!

    // Positions table
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var signupButton: UIButton!
    
    var positions: [Position] = []
    var selectedPosition: Position?
    
    // Loading View
    private var loadingView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    
    // Enable/disable signupButton, update UI
    var isButtonEnabled: Bool = false {
        didSet {
            signupButton.isEnabled = isButtonEnabled
            signupButton.backgroundColor = isButtonEnabled ? .appYellow: .appGray
            signupButton.alpha = isButtonEnabled ? 1: 0.48

        }
    }
    
    // Save selected image from gallery/camera
    var selectedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPositions()
        setupInterface()
        hideKeyboarOnTap()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    func setupInterface() {
        // Make views rounded
        nameView.layer.cornerRadius = 4
        emailView.layer.cornerRadius = 4
        uploadView.layer.cornerRadius = 4
        phoneView.layer.cornerRadius = 4
        
        // Add border
        nameView.layer.borderWidth = 1
        nameView.layer.borderColor = UIColor.appGray.cgColor
        emailView.layer.borderWidth = 1
        emailView.layer.borderColor = UIColor.appGray.cgColor
        uploadView.layer.borderWidth = 1
        uploadView.layer.borderColor = UIColor.appGray.cgColor
        phoneView.layer.borderWidth = 1
        phoneView.layer.borderColor = UIColor.appGray.cgColor
        
        // Hide labels
        nameLabel.isHidden = true
        emailLabel.isHidden = true
        phoneLabel.isHidden = true
        
        // Hide required labels
        nameRequiredLabel.isHidden = true
        emailRequiredLabel.isHidden = true
        
        // make rounded corners for signup button
        signupButton.layer.cornerRadius = signupButton.frame.height / 2
        
        phoneRequiredLabel.text = "+38 (XXX) XXX - XX - XX"
    }
    
    
    @IBAction func uploadAction(_ sender: Any) {
        // Configure actionSheet
        let actionSheet = UIAlertController(title: "Choose how you want to add a photo", message: nil, preferredStyle: .actionSheet)
        
        // Setup camera action
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            print("Camera")
            self.requestCameraAuthorization()
            
        }
        
        // Setup gallery action
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.requestPhotoLibraryAuthorization()
        }
        
        // Setup cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("didPress cancel")
        }
        
        // Add actions to actionsheet
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        // Present the controller
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        // First check if data is filled
        showLoadingIndicator()
        if let name = nameTextField.text, name.isEmpty {
            nameView.layer.borderColor = UIColor.appRed.cgColor
            nameLabel.isHidden = false
            nameRequiredLabel.isHidden = false
        }
        
        if let email = emailTextField.text, email.isEmpty {
            emailView.layer.borderColor = UIColor.appRed.cgColor
            emailLabel.isHidden = false
            emailRequiredLabel.isHidden = false
            
            if isValidEmail(email) == false {
                emailRequiredLabel.text = "Invalid email format"
            }
        }
        
        if let phone = phoneTextField.text, phone.isEmpty {
            phoneView.layer.borderColor = UIColor.appRed.cgColor
            phoneLabel.isHidden = false
            phoneRequiredLabel.isHidden = false
            phoneRequiredLabel.text = "Required field"
        }
        
        if selectedImage == nil {
            uploadView.layer.borderColor = UIColor.red.cgColor
            uploadLabel.textColor = .appRed
        }
        
        // If all required data is filled, try to register
        if let name = nameTextField.text,
           let email = emailTextField.text,
           let phone = phoneTextField.text,
           let id = selectedPosition?.id,
           let image = selectedImage {
            // sign up request
            DataManager.shared.registerUser(name: name,
                                            email: email,
                                            phone: phone,
                                            positionID: id,
                                            photo: image) { result in
                DispatchQueue.main.async {
                    self.hideLoadingIndicator()
                    switch result {
                    case .success(let result):
                        self.performSegue(withIdentifier: "openResultFromSignUp", sender: result)
                        
                    case .failure(let error):
                        print("Error", error)
                        self.showAlert(title: "Error", message: "\(error)")
                    }
                }
            }
        }
    }
    
    
    // Hide keyboard when user taps around
    func hideKeyboarOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAction))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    
    @objc private func hideKeyboardAction() {
        self.view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ResultViewController, let result = sender as? RegisterUserResponse {
            vc.registerUserResponse = result
        }
    }
    
    
    // Alert view if user denied access
    func showAlertForSettings(_ accessType: String) {
        let alert = UIAlertController(
            title: "\(accessType.capitalized) Access Needed",
            message: "Please enable access to your \(accessType) in Settings to use this feature.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    
    // Ajust table view's height based on the content size
    func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableViewHeight.constant = contentHeight
    }
    
    
    // Email validation check
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        
    }
    
    
    // Phone number validation check
    func isValidPhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = "^\\+38 \\(\\d{3}\\) \\d{3} - \\d{2} - \\d{2}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    
    // Get positions list from api
    func getPositions() {
        showLoadingIndicator()
        DataManager.shared.getPositions { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.hideLoadingIndicator()
                
                switch result {
                case .success(let response):
                    if response.success, let positions = response.positions {
                        self.positions = positions
                        self.tableView.reloadData()
                        self.updateTableViewHeight()
                    } else if let message = response.message {
                        self.showAlert(title: "Error", message: message)
                    }
                    
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    
    // Show basic alert view with title and message
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    // Show loading view
    func showLoadingIndicator() {
        // Create the loading view if it doesn't exist
        if loadingView == nil {
            loadingView = UIView(frame: self.view.bounds)
            loadingView?.backgroundColor = UIColor(white: 0, alpha: 0.5)  // Semi-transparent background
        }
        
        // Check if the activity indicator exist
        if activityIndicator == nil {
            // Create the activity indicator if it doesn't exist
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator?.color = .white
            activityIndicator?.center = loadingView!.center
            loadingView?.addSubview(activityIndicator!)
        }
        
        // Add loadingView to the view hierarchy and start animating
        if let loadingView = loadingView {
            self.view.addSubview(loadingView)
            activityIndicator?.startAnimating()
        }
    }

    
    // Hide loading view
    func hideLoadingIndicator() {
        // Stop animating and remove from the view hierarchy
        activityIndicator?.stopAnimating()
        loadingView?.removeFromSuperview()
    }
}


// MARK: Table view methods
extension SignUpViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PositionTableViewCell.identifier, for: indexPath) as? PositionTableViewCell else { return UITableViewCell() }
        
        let element = positions[indexPath.row]
        cell.configure(with: element, isSelected: selectedPosition == element)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPosition = positions[indexPath.row]
        tableView.reloadData()
    }
}


// MARK: Text Field Delegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isButtonEnabled = textField.text?.isEmpty == false
        return true
    }
}


// MARK: ImagePickerController Delegate
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Request camera autorization if it's not allowed
    func requestCameraAuthorization() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }
            }
        case .restricted, .denied:
            showAlertForSettings("camera")
        @unknown default:
            break
        }
    }
    
    
    // Request photo library autorization if its not allowed
    func requestPhotoLibraryAuthorization() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            openGallery()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { granted in
                if granted.rawValue == 3 || granted.rawValue == 4 {
                    DispatchQueue.main.async {
                        self.openGallery()
                    }
                }
            }
        case .restricted, .denied:
            showAlertForSettings("photo library")
    
        @unknown default:
            break
        }
    }
    
    
    // Open camera actoin
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    // Open photo gallery action
    func openGallery (){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            present(myPickerController, animated: true, completion: nil)
        }
    }
    
    // ImagePickerController delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            uploadLabel.text = "Uploaded"
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
