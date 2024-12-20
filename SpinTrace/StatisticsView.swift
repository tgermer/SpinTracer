//
//  StatisticsView.swift
//  SpinTrace
//
//  Created by Tristan Germer on 10.12.24.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("Test")
            }
            .navigationTitle("tab-statistics")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
        StatisticsView()
}
