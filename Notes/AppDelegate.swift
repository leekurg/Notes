//
//  AppDelegate.swift
//  Notes
//
//  Created by Ильяяя on 05.06.2022.
//

import UIKit

let database = Database()
var passedShortcut: UIApplicationShortcutItem?

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var notificationManager: NotificationManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notificationManager = NotificationManager()
        UNUserNotificationCenter.current().delegate = self
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.banner)
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
        let nc = sceneDelegate.window?.rootViewController as? UINavigationController,
        let vc = nc.viewControllers.first as? ViewController {
            UIApplication.shared.applicationIconBadgeNumber = 0
            vc.handleScheduledNotification(id: notification.request.identifier)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
        let nc = sceneDelegate.window?.rootViewController as? UINavigationController,
        let vc = nc.viewControllers.first as? ViewController {
            if UIApplication.shared.applicationState == .inactive ||
                UIApplication.shared.applicationState == .background {
                vc.handleScheduledNotification(id: response.notification.request.identifier)
            }
            vc.showNoteControllerFromNotification(id: response.notification.request.identifier)
            let n = UIApplication.shared.applicationIconBadgeNumber
            if n > 0 {
                UIApplication.shared.applicationIconBadgeNumber = n - 1
            }
        }
    }
}
