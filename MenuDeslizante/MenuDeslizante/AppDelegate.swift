//
//  AppDelegate.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 17/11/15.
//  Copyright (c) 2015 sergio ivan lopez monzon. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseTwitterUtils
import FBSDKCoreKit
import ParseFacebookUtilsV4
import Fabric
import TwitterKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("Rv2InCwEE4RJowtNJVaYqlLw0VpjPLEePcfpHMsw",
            clientKey: "oYALR4CrZhDOYlrOk7zCLszZXixJEXsDtOV4e0zt")
        
        //saber si es la primera vez o no
        //let defaults = NSUserDefaults.standardUserDefaults()
        //defaults.setObject("Coding Explorer", forKey: "userNameKey")
        //if ... let name = defaults.stringForKey("userNameKey")
        
        // print("defaults.name "+name!)
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : UIViewController
        
        //if PFUser.currentUser() == nil {
        //    vc = storyboard.instantiateViewControllerWithIdentifier("Login")
        //} else {
        vc = storyboard.instantiateViewControllerWithIdentifier("Login")
        //}in
        
        self.window?.rootViewController = vc
        
        PFTwitterUtils.initializeWithConsumerKey("MMWC6DUWHTHQHoa10u4ZU0tRh",  consumerSecret:"teJtkCAvVvcLQoba6JTMdzTG53YuuWyTolBJ0CDFxaLO8vmdMa")
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        
        Fabric.with([Twitter.self])
        
        // Store the deviceToken in the current Installation and save it to Parse
        /*        */
        
        
      
    
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        let notificationType: UIUserNotificationType = [.Alert, .Badge, .Sound]
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let settings = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            
            application.registerForRemoteNotificationTypes([.Badge , .Alert , .Sound])
        }

        
        
        
        
        return true
    }

    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
        
        
        /*let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : UIViewController
        
        vc = storyboard.instantiateViewControllerWithIdentifier("ViralizacionControlerID")
        
        self.window?.rootViewController = vc
        */
        
        let installation = PFInstallation.currentInstallation()
        installation.badge = installation.badge + 1
        installation.saveEventually()

    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        let installation = PFInstallation.currentInstallation()
        
        if installation.badge != 0{
            installation.badge = 0
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        /*let push = PFPush()
        push.setMessage("The Giants just scored!")
        push.sendPushInBackground()
*/
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
    }


}

