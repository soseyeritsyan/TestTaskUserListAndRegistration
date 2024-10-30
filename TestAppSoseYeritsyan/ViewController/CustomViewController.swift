//
//  CustomViewController.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 30.10.24.
//

import UIKit

class CustomViewController: UIViewController {
    
    var noInternetView: NoInthernetView?

    override func viewDidLoad() {
        super.viewDidLoad()
        observeNetworkChanges()
        addNoInternet()
        
        //Start monitoring
        NetworkMonitor.shared.startMonitoring()
        
    }
    
    func observeNetworkChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectionRestored), name: .connected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectionLost), name: .disconnected, object: nil)
    }
    
    
    func addNoInternet() {
        if noInternetView == nil {
            // Initialize the noInternetView
            noInternetView = NoInthernetView(frame: self.view.bounds)
        }
        
        guard let noInternetView = noInternetView else { return }
        
        // Add delegate
        noInternetView.delegate = self
        
        // Add the noInternetView as a subview
        view.addSubview(noInternetView)
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.topAnchor.constraint(equalTo: view.topAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        noInternetView.isHidden = NetworkMonitor.shared.isReachable
    }
    
    @objc func handleConnectionRestored() {
        DispatchQueue.main.async {
            self.noInternetView?.isHidden = true
            print("Internet connection restored.")
        }
    }
    
    @objc func handleConnectionLost() {
        DispatchQueue.main.async {
            self.noInternetView?.isHidden = false
            print("No Internet connection.")
        }
    }
}

extension CustomViewController: NoInternetViewDelegate {
    func didTapTryAgain() {
        if NetworkMonitor.shared.isReachable {
            noInternetView?.isHidden = true
        } else {
            print("Still no connection.")
            noInternetView?.isHidden = false
        }
    }
}
