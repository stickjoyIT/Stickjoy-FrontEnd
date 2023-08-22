//
//  Stickjoy_First_EditionApp.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 08/08/23.
// Aquí será el Main! Aquí tengo que hacer lo de firebase.

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    return true
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
@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
        LaunchScreen()
      }
    }
  }
}
