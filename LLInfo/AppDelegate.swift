//
//  AppDelegate.swift
//  LLInfo
//
//  Created by CmST0us on 2017/11/13.
//  Copyright © 2017年 eki. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import PushKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    struct SettingKey {
        //[TODO] add a switch than user can modify the remote push authorization
        static let remotePushAuthorizationKey = "remotePushAuthorizationKey"
        static let cameraRollAccessKey = "cameraRollAccessKey"
    }
    
    var window: UIWindow?

    func setupApiHelper() {
        #if arch(i386) || arch(x86_64)
            ApiHelper.shared.baseUrlPath = "http://127.0.0.1:3000/api/v1"
        #else
            ApiHelper.shared.baseUrlPath = "https://hk.cmst0us.me/api/v1"
        #endif
    }
    
    func requestPushAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            let userDefaults = UserDefaults.standard
            userDefaults.set(granted, forKey: SettingKey.remotePushAuthorizationKey)
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func requestCameraRollAccess() {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization({ (state) in
                if state == PHAuthorizationStatus.authorized {
                    UserDefaults.standard.set(true, forKey: SettingKey.cameraRollAccessKey)
                } else {
                    UserDefaults.standard.set(false, forKey: SettingKey.cameraRollAccessKey)
                }
            })
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setupApiHelper()
        self.requestPushAuthorization()
        self.requestCameraRollAccess()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("did register remote notification\ndeviceToken(Base64): \(deviceToken.base64EncodedString())")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("register remote notification fail\(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

