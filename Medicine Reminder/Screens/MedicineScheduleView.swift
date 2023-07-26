//
//  MedicineScheduleView.swift
//  Medicine Reminder
//
//  Created by BJIT on 14/6/23.
//

import SwiftUI
import AlertToast

struct MedicineScheduleView: View {
    @EnvironmentObject private var medicineScheduleVM: MedicineScheduleViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @State private var buttonWidth = UIScreen.main.bounds.width - 80
    @State private var number: Int = 1
    @State private var showToast = false
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                VStack(alignment: .leading){
                    Image("medicineBackground")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        .overlay(content: {
                            Circle()
                                .trim(from: 0.5, to: 0.65)
                                .scaleEffect(5)
                                .rotationEffect(.degrees(63))
                                .colorInvert()
                                .offset(y: UIScreen.main.bounds.width / 0.54)
                            VStack{
                                Text("Your Medicine schedule")
                                    .font(.title2)
                                    .padding(.horizontal, 20)
                                Text("Set Medication Reminder Notification Schedule")
                                    .font(.caption)
                                    .padding(.horizontal)
                                    
                                    .background(Color("itemBG"))
                                    .cornerRadius(10)
                                    
                            }
                            .offset(y: UIScreen.main.bounds.width / 3.5)
                        })
                        .offset(y: -100)
                }

                VStack(alignment: .center){
                    ScheduleCardView(title: "First Dose :", time: $medicineScheduleVM.morningMedicineTakingTime, cardBGColor: Color("cardColor1"), bgImageName: "Component 4", imageScale: 0.3)
                    ScheduleCardView(title: "Second Dose :", time: $medicineScheduleVM.afternoonMedicineTakingTime, cardBGColor: Color("cardColor2"), bgImageName: "Component 2", imageScale: 0.5)
                    ScheduleCardView(title: "Third Dose :", time: $medicineScheduleVM.nightMedicineTakingTime, cardBGColor: Color("cardColor3"), bgImageName: "Component 1", imageScale: 0.5)
                    
                    HStack{
                        Text("Delay Before Meal :")
                            .font(.title2)
                            .padding(.vertical)
                            .foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $medicineScheduleVM.delayBeforeMeal) {
                            ForEach(5...60, id: \.self) { number in
                                if number % 5 == 0 {
                                    Text("\(number) min")
                                        .font(.title2)
                                }
                            }
                        }
                        .labelsHidden()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Color("cardColor2"))
                    .cornerRadius(10)
                    .padding(.horizontal, 5)
                    
                    Spacer()
                    Button(action: {
                        Task{
                            NotificationService.shared.setMedicineNotification(context: viewContext)
                        }
                        showToast.toggle()
                    }, label: {
                        Text("Save")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 80, height: 50, alignment: .center)
                    })
                    .buttonStyle(.borderless)
                    .background(Color("tealBlue"), alignment: .center)
                    .cornerRadius(25)
                }
                .offset(y: -60)
            }
            .toast(isPresenting: $showToast, duration: 0.7, tapToDismiss: true, alert: {
                AlertToast(type: .systemImage("checkmark.seal.fill", Color("tealBlue")), title: "Updated Information!")
                
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
struct ScheduleCardView: View {
    @State var title: String
    @Binding var time: Date
    @State var cardBGColor: Color
    @State var bgImageName: String
    @State var imageScale: Double
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .font(.title2)
                    .padding(.vertical)
                Spacer()
                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                    .background()
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .labelsHidden()
            }
            .foregroundColor(.white)
            .padding(.vertical, 5)
            .padding(.horizontal)
            .background(content: {
                HStack(spacing: 0){
                    Spacer()
                    Image(bgImageName).scaledToFill()
                        .scaleEffect(imageScale)
                }
            })
            .background(cardBGColor)
            .cornerRadius(10)
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
        }
    }
}

struct MedicineScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MedicineScheduleViewModel()
        MedicineScheduleView()
            .environmentObject(viewModel)
    }
}
