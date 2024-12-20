//
//  SettingsView.swift
//  SpinTrace
//
//  Created by Tristan Germer on 10.12.24.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("settings-categories") {
                    NavigationLink(destination: RideCategoriesView()) {
                        Label("set-categories", systemImage: "list.dash")
                    }
                }
            }
            .navigationTitle("tab-settings")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
