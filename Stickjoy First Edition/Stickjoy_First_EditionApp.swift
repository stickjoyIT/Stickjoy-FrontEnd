//
//  Stickjoy_First_EditionApp.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
// Aquí será el Main! Aquí tengo que hacer lo de firebase.

import SwiftUI
import Firebase
import FirebaseMessaging
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication,
                       didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
            NotificationCenter.default.post(name: Notification.Name("PushNotificationTapped"), object: nil, userInfo: ["tabNumber": 4])
        }
        print("notificacion")
        //if let tabNumber = userInfo["tab"] as? Int {
            // Envía una notificación con un diccionario que contiene el número de tab correspondiente
            
        //}

        // Print full message.
        print("user info:",userInfo)
      }
    
    func application(_ application: UIApplication,
                       didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
      }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}


/*@main
struct Stickjoy_First_EditionApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LaunchScreen()
            }
        }
    }
}
*/

//Dom 13 de Ago: Cambiamos ContentView por LaunchScreen
@available(iOS 16.0, *)
@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var store = Store()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView().environmentObject(store)
            }
        }
    }
}


// [START ios_10_message_handling]

extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
        NotificationCenter.default.post(name: Notification.Name("PushNotificationTapped"), object: nil, userInfo: ["tabNumber": 4])
    } else {
        NotificationCenter.default.post(name: Notification.Name("PushNotificationTapped"), object: nil, userInfo: ["tabNumber": 2])
    }
    // [END_EXCLUDE]

    // Print full message.
    print("user infom",userInfo)
        
    // Change this to your preferred presentation option
    return [[.alert, .sound]]
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo

    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
        NotificationCenter.default.post(name: Notification.Name("PushNotificationTapped"), object: nil, userInfo: ["tabNumber": 4])
    }
    // [END_EXCLUDE]

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
      
    // Print full message.
    print("user info:", userInfo)
  }
}

// [END ios_10_message_handling]

extension AppDelegate: MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")

    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }

  // [END refresh_token]
}
