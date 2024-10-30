//
//  UsersViewController.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 21.10.24.
//

import UIKit

class UsersViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noUsersLabel: UILabel!
    
    var isLoading = false
    var nextURL: String? = nil
    var prevURL: String? = nil
    
    var usersArray: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: UserTableViewCell.identifier)
        
        setupInterface()
        
        // Fetch users list
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show Tabbar
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupInterface() {
        noUsersLabel.font = UIFont(name: "Nunito-SemiBold", size: 20)
    }
   
    // Fetch users list from api
    func fetchUsers(using url: String? = nil) {
        // Set loaging state
        guard !isLoading else { return }
        isLoading = true
        
        DataManager.shared.fetchUsers(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let usersResponse):
                    // Append new users or set to new data if reloading
                    self.usersArray.append(contentsOf: usersResponse.users)
                    
                    // Update links for navigation
                    self.nextURL = usersResponse.links.nextUrl
                    self.prevURL = usersResponse.links.prevUrl
                    
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("Error fetching users:", error)
                }
                
                self.isLoading = false
            }
        }
    }

}

// MARK: Table view methods
extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        let user = usersArray[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Fetch next page of users
        if offsetY > contentHeight - height * 2 {
            if let nextURL = nextURL {
                fetchUsers(using: nextURL)
            }
        }
    }
}

