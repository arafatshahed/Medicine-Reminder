//
//  TabViews.swift
//  Medicine Reminder
//
//  Created by BJIT on 9/6/23.
//

import SwiftUI
import Lottie

struct TabViews: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var medicineScheduleVM = MedicineScheduleViewModel()
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
            .environmentObject(medicineScheduleVM)
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

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .playOnce
    @Binding var show: Bool
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView(name: name, bundle: Bundle.main)
        print("LottieAnimationView name: ", name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = 1.5
        animationView.play{(status) in
            if status{
                withAnimation(.interactiveSpring(response:0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                    show = false
                }
            }
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViews()
    }
}
