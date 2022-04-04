//
//  SampleAppSwiftUIApp.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 08.03.2022.
//

import SwiftUI
import Swinject

@main
struct SampleAppSwiftUIApp: App {
    
    var body: some Scene {
        WindowGroup {
            screenFactory.makeUsersScreen()
        }
    }
}
