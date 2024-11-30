//
//  mygrocerylistApp.swift
//  mygrocerylist
//
//  Created by Jean on 30/11/24.
//

import SwiftUI
import SwiftData

@main
struct mygrocerylistApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Item.self)
        }
    }
}
