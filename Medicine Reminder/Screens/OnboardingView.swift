//
//  OnboardingView.swift
//  Medicine Reminder
//
//  Created by BJIT on 8/6/23.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("onboarding") var isonBoardingViewActive: Bool = true
    
    var body: some View {
        GeometryReader { screen in
            ZStack(alignment: .top){
                Image("onboardingImage")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .offset(y: -(screen.size.height/8))
                Rectangle()
                    .foregroundColor(.clear)
                    .background(LinearGradient(gradient: Gradient(colors: [.clear, Color("tealBlue"), Color("tealBlue"), Color("tealBlue"), Color("tealBlue")]), startPoint: .top, endPoint: .bottom))
                    .frame(height: screen.size.height * 1.5)
                    .position(x: screen.size.width / 2, y: screen.size.height)
                Text("""
                     Medication Reminders.
                     And so much more.
""")
                .font(.system(size: 22))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .transition(.opacity)
                .padding(.vertical, 10)
                .multilineTextAlignment(.center)
                .position(x: screen.size.width / 2.8, y: screen.size.height/1.7)
                Button(action: {
                    isonBoardingViewActive = false
                }, label: {
                    Text("Get Started")
                        .font(.system(size: 17))
                        .fontWeight(.medium)
                        .foregroundColor(Color("tealBlue"))
                        .textCase(.uppercase)
                        .frame(width: screen.size.width - 50, height: 50, alignment: .center)
                })
                .buttonStyle(.borderless)
                .background(Color.white, alignment: .center)
                .cornerRadius(25)
                .padding(.horizontal, 20)
                .position(x: screen.size.width / 2, y: screen.size.height/1.3)
                Text("By proceeding, you agree to our **Terms** and that you have read our **Privacy Policy**")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(25)
                    .position(x: screen.size.width / 2, y: screen.size.height - 25)
            }
        }
        .preferredColorScheme(.light)
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
