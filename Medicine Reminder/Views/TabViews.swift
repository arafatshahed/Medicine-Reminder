//
//  TabViews.swift
//  Medicine Reminder
//
//  Created by BJIT on 9/6/23.
//

import SwiftUI

struct TabViews: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "homekit")
                    Text("Home")
                }
            Text("Scan Prescription")
                .tabItem {
                    Image(systemName: "scanner.fill")
                    Text("Scan Prescription")
                }
            Text("Medications")
                .tabItem {
                    Image(systemName: "pills.fill")
                    Text("Medications")
                }
            MedicineScheduleView()
                .tabItem {
                    Image(systemName: "ellipsis")
                    Text("More")
                }
        }
        .accentColor(Color("tealBlue"))
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViews()
    }
}
