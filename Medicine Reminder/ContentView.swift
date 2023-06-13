//
//  ContentView.swift
//  Medicine Reminder
//
//  Created by BJIT on 8/6/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("onboarding") var isonBoardingViewActive: Bool = true
    var body: some View {
        if isonBoardingViewActive{
            OnboardingView()
        } else{
            TabViews()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
