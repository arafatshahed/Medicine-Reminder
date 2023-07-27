//
//  TabViews.swift
//  Medicine Reminder
//
//  Created by BJIT on 9/6/23.
//

import SwiftUI

struct TabViews: View {
    @Environment(\.colorScheme) var colorScheme
    @State var showAnimation: Bool = false
    @State var assetName = ""

    var body: some View {
        ZStack{
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "homekit")
                        Text("Home")
                    }
                AddMedicineView()
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Medicine")
                    }
                MedicinesView()
                    .tabItem {
                        Image(systemName: "pills.fill")
                        Text("Medications")
                    }
                MedicineScheduleView()
                    .tabItem {
                        Image(systemName: "clock.fill")
                        Text("Medicine Schedule")
                    }
            }
            .accentColor(Color("tealBlue"))
            if showAnimation{
                LottieView(name: assetName, show: $showAnimation)
                    .background(Color.primary.colorInvert())
            }
            
        }
        .onAppear(){
            if colorScheme == .light{
                assetName = "MedAnimationDark"
            } else{
                assetName = "MedAnimationLight"
            }
            showAnimation = true
        }
        
    }
}


struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViews()
    }
}
