//
//  MedicineScheduleView.swift
//  Medicine Reminder
//
//  Created by BJIT on 14/6/23.
//

import SwiftUI

struct MedicineScheduleView: View {
    @State private var dose1: Date = Date()
    @State private var buttonWidth = UIScreen.main.bounds.width - 80
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                VStack(alignment: .leading){
                    Image(systemName: "alarm.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(.bottom)
                        .padding(.horizontal, 20)
                    Text("When do you need to take the first dose?")
                        .foregroundColor(.white)
                        .font(.title3)
                        .padding(.horizontal, 20)
                    Rectangle()
                        .frame(height: 50)
                        .foregroundColor(Color("itemBG"))
                    
                        .mask(RoundedCornerMask(cornerRadius: 20, corners: [.topLeft, .topRight]))
                        .overlay{
                            HStack{
                                Spacer()
                                Text("Take")
                                Spacer()
                                Text("1 Pill(s)")
                                    .font(.system(size: 17, weight: .bold))
                                Spacer()
                                Button(action: {
                                    
                                }, label: {
                                    Image(systemName: "highlighter")
                                })
                                .buttonStyle(.plain)
                                
                                Spacer()
                            }
                        }
                }
                .background(content: {
                    Color("tealBlue")
                        .ignoresSafeArea()
                })
                VStack(alignment: .center){
                    
                    DatePicker("", selection: $dose1, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                    Spacer()
                    Button(action: {
                        //                        isonBoardingViewActive = false
                    }, label: {
                        Text("Next")
                            .foregroundColor(.white)
                            .frame(width: buttonWidth, height: 50, alignment: .center)
                        
                        Image(systemName: "chevron.right")
                            .offset(x: -40)
                            .foregroundColor(.white)
                    })
                    .buttonStyle(.borderless)
                    .background(Color("tealBlue"), alignment: .center)
                    .cornerRadius(25)
                    .padding(.bottom, 20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MedicineScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        MedicineScheduleView()
    }
}
struct RoundedCornerMask: Shape {
    var cornerRadius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        return Path(path.cgPath)
    }
}
