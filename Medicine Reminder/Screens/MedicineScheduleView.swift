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
                    Image(systemName: "alarm.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(.bottom)
                        .padding(.horizontal, 20)
                    Text("Your Medicine schedule")
                        .foregroundColor(.white)
                        .font(.title3)
                        .padding(.horizontal, 20)
                    Rectangle()
                        .frame(height: 0)
                }
                .background(content: {
                    Color("tealBlue")
                        .ignoresSafeArea()
                })
                VStack(alignment: .center){
                    HStack{
                        Text("First Dose :")
                            .font(.title2)
                            .padding()
                        Spacer()
                        DatePicker("", selection: $medicineScheduleVM.morningMedicineTakingTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding()
                    HStack{
                        Text("Second Dose :")
                            .font(.title2)
                            .padding()
                        Spacer()
                        DatePicker("", selection: $medicineScheduleVM.afternoonMedicineTakingTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding()
                    HStack{
                        Text("Third Dose :")
                            .font(.title2)
                            .padding()
                        Spacer()
                        DatePicker("", selection: $medicineScheduleVM.nightMedicineTakingTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding()
                    HStack{
                        Text("Delay Before Meal :")
                            .font(.title2)
                            .padding()
                        Spacer()
                        Picker("", selection: $medicineScheduleVM.delayBeforeMeal) {
                            ForEach(5...60, id: \.self) { number in
                                if number % 5 == 0 {
                                    Text("\(number)")
                                        .font(.title2)
                                }
                            }
                        }
                        .labelsHidden()
                    }
                    .padding()
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
                    .padding(.bottom, 20)
                }
            }
//            .padding(.horizontal, 20)
            .toast(isPresenting: $showToast, duration: 0.7, tapToDismiss: true, alert: {
                AlertToast(type: .systemImage("checkmark.seal.fill", Color("tealBlue")), title: "Updated Information!")
                
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MedicineScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MedicineScheduleViewModel()
        MedicineScheduleView()
            .environmentObject(viewModel)
    }
}
