//
//  TabViews.swift
//  Medicine Reminder
//
//  Created by BJIT on 9/6/23.
//

import SwiftUI

struct TabViews: View {
    @StateObject private var medicineScheduleVM = MedicineScheduleViewModel()
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "homekit")
                    Text("Home")
                }
                .environmentObject(medicineScheduleVM)
            PrescriptionScanView()
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
                    Image(systemName: "clock.fill")
                    Text("Medicine Schedule")
                }
                .environmentObject(medicineScheduleVM)
        }
        .accentColor(Color("tealBlue"))
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViews()
    }
}
