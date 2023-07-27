//
//  LottieView.swift
//  Medicine Reminder
//
//  Created by BJIT on 27/7/23.
//

import SwiftUI
import Lottie

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

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(name: "MedAnimationDark", show: Binding.constant(true))
    }
}
