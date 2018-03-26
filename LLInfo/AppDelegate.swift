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

//    struct SettingKey {
//        static let remotePushAuthorizationKey = "remotePushAuthorizationKey"
//        static let cameraRollAccessKey = "cameraRollAccessKey"
//    }
    
    private let xgAppId = 2200276944
    private let xgAppKey = "I3X58G3SHJ5A"
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.setupApiHelper()
        self.setupXinge()
        self.setupApiHelper()
        self.setupCardCache()
        
        self.reportNotification(info: launchOptions)
        return true
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

// MARK: - User method
extension AppDelegate {
    
    func setupApiHelper() {
        #if arch(i386) || arch(x86_64)
            ApiHelper.shared.baseUrlPath = "http://127.0.0.1:3000/api/v1"
            SchoolIdolTomotachiApiHelper.shared.baseUrlPath = "http://schoolido.lu/api"
        #else
            ApiHelper.shared.baseUrlPath = "https://www.llinfo.club/api/v1"
            SchoolIdolTomotachiApiHelper.shared.baseUrlPath = "http://schoolido.lu/api"
            
        #endif
        
        ApiHelper.shared.taskWaitTime = 10
        SchoolIdolTomotachiApiHelper.shared.taskWaitTime = 10
    }
    
    func setupCardCache() {
        let cacheDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)[0].appendingPathComponent("resources")
        
        if FileManager.default.fileExists(atPath: cacheDir) {
            try? FileManager.default.createDirectory(atPath: cacheDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        let cache = SIFCacheHelper.shared
        cache.cacheDirectory = cacheDir
        
        if !cache.isCardsCached {
            assert(cache.unzipResourceData())
            cache.cards = cache.loadCardsJsonFile()
        }
    }
    
    func requestPushAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
//            let userDefaults = UserDefaults.standard
//            userDefaults.set(granted, forKey: SettingKey.remotePushAuthorizationKey)
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
//                    UserDefaults.standard.set(true, forKey: SettingKey.cameraRollAccessKey)
                } else {
//                    UserDefaults.standard.set(false, forKey: SettingKey.cameraRollAccessKey)
                }
            })
        }
    }
}


// MARK: - 信鸽推送相关方法
extension AppDelegate {
    
    /// 信鸽推送服务初始化
    func setupXinge() {
        #if arch(i386) || arch(x86_64)
            return
        #endif
        
        let manager = XGPush.defaultManager()
        #if DEBUG
            manager.isEnableDebug = true
        #else
            manager.isEnableDebug = false
        #endif
        
        manager.startXG(withAppID: UInt32(xgAppId), appKey: xgAppKey, delegate: self)
        
    }
    
    func reportNotification(info: Dictionary<AnyHashable, Any>?) {
        if let i = info {
            XGPush.defaultManager().reportXGNotificationInfo(i)
        }
    }
    
    func registerDeviceToken(data: Data) {
        XGPushTokenManager.default().registerDeviceToken(data)
    }
}

// MARK: 信鸽推送委托方法
extension AppDelegate: XGPushDelegate {
    func xgPush(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse?, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.reportNotification(info: response?.notification.request.content.userInfo)
        completionHandler()
    }
}

