//
//  TabViews.swift
//  Medicine Reminder
//
//  Created by BJIT on 9/6/23.
//

import SwiftUI
import CoreData

struct TabViews: View {
    @Environment(\.colorScheme) var colorScheme
    @State var showAnimation: Bool = false
    @State var assetName = ""
    @ObservedObject var appState = AppState.shared
    @State var navigate = false
    
    var pushNavigationBinding : Binding<Bool> {
        .init { () -> Bool in
            appState.pageToNavigationTo != nil
        } set: { (newValue) in
            if !newValue { appState.pageToNavigationTo = nil }
        }
    }

    var body: some View {
        ZStack{
            if pushNavigationBinding.wrappedValue{
                NotificationActionView(message: appState.pageToNavigationTo ?? "", title: appState.title ?? "", pushNavigationBinding: pushNavigationBinding)
            } else{
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
            }
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
        let viewModel = MedicineScheduleViewModel()
        return AnyView(TabViews()
            .environmentObject(viewModel))
    }
}
