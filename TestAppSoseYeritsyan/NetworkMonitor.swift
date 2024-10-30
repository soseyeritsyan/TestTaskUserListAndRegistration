//
//  NetworkMonitor.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 26.10.24.
//

import Network
import UIKit

class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("We're connected!")
                    NotificationCenter.default.post(name: .connected, object: nil)
                } else {
                    print("No connection.")
                    NotificationCenter.default.post(name: .disconnected, object: nil)
                }
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

extension Notification.Name {
    static let connected = Notification.Name("NetworkConnected")
    static let disconnected = Notification.Name("NetworkDisconnected")
}
