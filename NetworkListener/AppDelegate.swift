//
//  AppDelegate.swift
//  NetworkListener
//
//  Created by Ramakrishna UTTI on 24/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var rechabilityObserver: ReachabilityHandler?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ReachabilityHandler.shared.startNetworkReachabilityObserver { status in
            NotificationCenter.default.post(name: .networkChanged, object: nil)
            switch status {
            case .unknown:
                print("unknown")
                self.addInternetWarningLabel(text: "unknown")
            case .notReachable:
                print("not reachable")
                self.addInternetWarningLabel(text: "not reachable")
            case .reachable(.ethernetOrWiFi):
                print("wifi")
                self.addInternetWarningLabel(text: "wifi")
            case .reachable(.cellular):
                print("cellular")
                self.addInternetWarningLabel(text: "cellular")
            case .none:
                print("none")
                self.addInternetWarningLabel(text: "none")
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


extension UIApplication {

    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }

    class func topNavigation(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UINavigationController? {

        if let nav = viewController as? UINavigationController {
            return nav
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return selected.navigationController
            }
        }
        return viewController?.navigationController
    }
    
    static var buildType: String {
        #if DEBUG
            return "Debug"
        #else
            return "Release"
        #endif
    }
}

extension AppDelegate {
    /*
     Returns the view controller if it is embbedded in Tabbar & Navigation or Presented
    */
    func topViewController(in rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        if let tabBarController = rootViewController as? UITabBarController {
            return topViewController(in: tabBarController.selectedViewController)
        } else if let navigationController = rootViewController as? UINavigationController {
            return topViewController(in: navigationController.visibleViewController)
        } else if let presentedViewController = rootViewController.presentedViewController {
            return topViewController(in: presentedViewController)
        }
        return rootViewController
    }
}

extension AppDelegate {

    func addInternetWarningLabel(text: String) {
        let lblWarning : UILabel = UILabel(frame: CGRect(x: 50, y: 50, width: 150, height: 50))
        lblWarning.text = text
        lblWarning.textColor = UIColor.black
        lblWarning.textAlignment = .center
        lblWarning.backgroundColor = .lightGray
        lblWarning.font = UIFont.boldSystemFont(ofSize: 20)
        UIApplication.topViewController()?.view.addSubview(lblWarning)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            lblWarning.removeFromSuperview()
        })
    }

}
