//
//  AddMedicineView.swift
//  Medicine Reminder
//
//  Created by BJIT on 25/7/23.
//

import SwiftUI

struct AddMedicineView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var medicine: Medicine?
    var body: some View {
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
}

struct AddMedicineView_Previews: PreviewProvider {
    static var previews: some View {
        AddMedicineView()
    }
}
