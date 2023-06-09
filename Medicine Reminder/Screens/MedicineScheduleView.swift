//
//  MedicineScheduleView.swift
//  Medicine Reminder
//
//  Created by BJIT on 14/6/23.
//

import SwiftUI

struct MedicineScheduleView: View {
    @EnvironmentObject private var medicineScheduleVM: MedicineScheduleViewModel
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
                    
                    
                    Spacer()
                }
            }
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
