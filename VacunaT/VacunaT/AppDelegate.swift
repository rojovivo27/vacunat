//
//  AppDelegate.swift
//  Vacuna-T
//
//  Created by Aldo on 04/11/17.
//  Copyright © 2017 Aldo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let db = SQLiteDB.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3383512806298757~6749002146")
        
        //OpenDB
        _ = db.openDB(copyFile: false)
        
        
        //Globals
        //GoalID
        if((UserDefaults.standard.object(forKey: "ProfileCreated")) != nil){
            //Do nothing
        } else {
            UserDefaults.standard.set(false, forKey: "ProfileCreated")
        }
        
        if((UserDefaults.standard.object(forKey: "DontShowAgain")) != nil){
            //Do nothing
        } else {
            UserDefaults.standard.set(false, forKey: "DontShowAgain")
        }
        
        //Notifications
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { (granted, error) in
            if(!granted){
                print("Something went wrong")
            } else {
                if(!UserDefaults.standard.bool(forKey: "DontShowAgain")){
                    let content = UNMutableNotificationContent()
                    content.title = "Cuida tu salud"
                    content.body = "Recuerda tomar las vacunas contra la influenza y Antineumocócica 23-valente, recomendadas mayormente para adultos mayores y niños"
                    var triggerYearly = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: Date())
                    triggerYearly.month = 10
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerYearly, repeats: true)
                    let identifier = "VacunateYearly"
                    let request = UNNotificationRequest(identifier: identifier,
                                                        content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        if let error = error {
                            // Something went wrong
                            print("Error: \(error)")
                        }
                    })
                    print("General Anual alerts created")
                }
            }
        }
        
        return true
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

