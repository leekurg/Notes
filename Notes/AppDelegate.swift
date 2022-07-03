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
            vc.handleScheduledNotification(id: notification.request.identifier)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
        let nc = sceneDelegate.window?.rootViewController as? UINavigationController,
        let vc = nc.viewControllers.first as? ViewController {
            vc.showNoteController(id: response.notification.request.identifier)
        }
    }
}
