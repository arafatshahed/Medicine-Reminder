//
//  AddMedicineView.swift
//  Medicine Reminder
//
//  Created by BJIT on 25/7/23.
//

import SwiftUI

struct AddMedicineView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedMenu = false
    @State var scanEnable = true
    @State var medicine: Medicine?
    @State var showAlert = false
    @State var showTip = true
    var body: some View {
        VStack{
            Picker("Toggle", selection: $selectedMenu) {
                Text("Scan Prescription")
                    .tag(false)
                Text("Add Manually")
                    .tag(true)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .pickerStyle(SegmentedPickerStyle())
            if selectedMenu == true{
                VStack{
                    if let medicine = medicine{
                        MedicineDetailsView(medicine: medicine)
                    }
                    Text("")
                        .hidden()
                        .onAppear(){
                            let med = Medicine(context: viewContext)
                            med.medicineStartDate = Date()
                            med.medicineName = ""
                            med.medicineEndDate = Date()
                            med.morningMedicineCount = 0
                            med.noonMedicineCount = 0
                            med.nightMedicineCount = 0
                            med.beforeMeal = false
                            medicine = med
                        }
                        .onDisappear(){
                            viewContext.rollback()
                        }
                }
            }
            else{
                VStack(alignment: .leading){
                    if showTip{
                        Label("Crop the image properly for better results!", systemImage: "info.circle")
                            .font(.caption)
                            .padding(.leading)
                    }
                    
                        
                    if scanEnable{
                        makeScannerView()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.blue, lineWidth: 2)
                                
                            )
                            .padding(.horizontal)
                    }
                    Spacer()
                }
                
            }
        }
        .onAppear(){
            scanEnable = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.default){
                    showTip = false
                }
                
            }
        }
        .onDisappear(){
            scanEnable = false
        }
        .alert("Scan Completed", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                withAnimation(.default){
                    scanEnable = true
                    showTip = true
                }
            }
        }
        
    }
    private func makeScannerView()-> ScannerView {
        ScannerView(completion: {
            textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                print(outputText)
                let meds = MedicineParser.shared.convertToMedicineArray(data: outputText, viewContext: viewContext)
                PersistenceController.shared.save()
                Task{
                    MedicinesHelper.shared.setMedicineNotification(context: viewContext)
                }
                scanEnable = false
                showAlert = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
//                    scanEnable = true
//                }
            }
        })
    }
}

struct AddMedicineView_Previews: PreviewProvider {
    static var previews: some View {
        AddMedicineView()
            .environmentObject(MedicineScheduleViewModel())
    }
}
