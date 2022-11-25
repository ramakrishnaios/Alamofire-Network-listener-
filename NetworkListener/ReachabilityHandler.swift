//
//  ReachabilityHandler.swift
//  NetworkListener
//
//  Created by Ramakrishna UTTI on 24/11/22.
//

import Foundation
import Alamofire
import SystemConfiguration

final class ReachabilityHandler {

    static let shared = ReachabilityHandler()
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

    func startNetworkReachabilityObserver(completion: @escaping ( (NetworkReachabilityManager.NetworkReachabilityStatus?) -> Void)) {
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            switch status {
            case .notReachable:
                debugPrint("The network is not reachable")
                completion(.notReachable)
            case .unknown :
                debugPrint("It is unknown whether the network is reachable")
                completion(.unknown)
            case .reachable(.ethernetOrWiFi):
                debugPrint("The network is reachable over the WiFi connection")
                completion(.reachable(.ethernetOrWiFi))
            case .reachable(.cellular):
                debugPrint("The network is reachable over the cellular connection")
                completion(.reachable(.cellular))
            }
        })
    }

}

protocol ReachabilityChanged {
    func networkConnectionChanged()
}

extension ReachabilityChanged where Self: NSObjectProtocol {

    func startObservingNetwork() {
        stopObservingNetwork()
        NotificationCenter.default.addObserver(forName: .networkChanged, object: nil, queue: nil) { [weak self] _ in
            self?.networkConnectionChanged()
        }
        self.networkConnectionChanged()
    }

    func stopObservingNetwork() {
        NotificationCenter.default.removeObserver(self, name: .networkChanged, object: nil)
    }

}

extension Notification.Name {
    static let networkChanged = Notification.Name("networkChanged")
}
