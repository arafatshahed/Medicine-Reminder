//
//  MedicineScheduleView.swift
//  Medicine Reminder
//
//  Created by BJIT on 14/6/23.
//

import SwiftUI

struct MedicineScheduleView: View {
    @State private var dose1: Date = Date()
    @State var morningMedicineTakingTime = UserDefaults.standard.object(forKey: "morningMedicineTakingTime") as? Date ?? Date()
    @State var afternoonMedicineTakingTime = UserDefaults.standard.object(forKey: "afternoonMedicineTakingTime") as? Date ?? Date()
    @State var nightMedicineTakingTime = UserDefaults.standard.object(forKey: "nightMedicineTakingTime") as? Date ?? Date()
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
                        Text("Morning:")
                            .font(.title2)
                            .padding()
                        Spacer()
                        DatePicker("", selection: $morningMedicineTakingTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .onChange(of: morningMedicineTakingTime){newDate in
                                UserDefaults.standard.set(newDate, forKey: "morningMedicineTakingTime")
                            }
                    }
                    .padding()
                    HStack{
                        Text("Afternoon:")
                            .font(.title2)
                            .padding()
                        Spacer()
                        DatePicker("", selection: $afternoonMedicineTakingTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .onChange(of: afternoonMedicineTakingTime){newDate in
                                UserDefaults.standard.set(newDate, forKey: "afternoonMedicineTakingTime")
                            }
                    }
                    .padding()
                    HStack{
                        Text("Night:")
                            .font(.title2)
                            .padding()
                        Spacer()
                        DatePicker("", selection: $nightMedicineTakingTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .onChange(of: nightMedicineTakingTime){newDate in
                                UserDefaults.standard.set(newDate, forKey: "nightMedicineTakingTime")
                            }
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
        MedicineScheduleView()
    }
}
