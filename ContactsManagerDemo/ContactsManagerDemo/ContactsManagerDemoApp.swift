//
//  ContactsManagerDemoApp.swift
//  ContactsManagerDemo
//
//  Created by Arpit Agarwal on 3/5/25.
//

import SwiftUI
import ContactsManager

@main
struct ContactsManagerDemoApp: App {
    init() {
      ContactService.configure(withApiKey: "cm_live_12345abcdef")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
