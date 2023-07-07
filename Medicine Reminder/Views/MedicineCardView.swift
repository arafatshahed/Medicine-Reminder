//
//  MedicineCardView.swift
//  Medicine Reminder
//
//  Created by BJIT on 7/7/23.
//

import SwiftUI
import CoreData

struct MedicineCardView: View {
    @State var medicine: Medicine
    var body: some View {
        NavigationLink {
            Text("Name of medicine is :  \(medicine.medicineName!)")
            Text("Time added: \(medicine.medicineStartDate ?? Date())")
            Text("Consume till: \(medicine.medicineEndDate ?? Date())")
            Text(medicine.beforeMeal ? "Before meal" : "After meal")
        } label: {
            Rectangle()
                .frame(height: 80)
                .cornerRadius(10)
                .foregroundColor(Color("itemBG"))
                .overlay(content: {
                    HStack{
                        Image(systemName: "pills")
                            .font(.system(size: 30))
                            .padding(20)
                        Rectangle()
                            .frame(width: 3, height: 50)
                            .padding(.trailing)
                        VStack(alignment: .leading){
                            Text(medicine.medicineName!)
                                .font(.title2)
                            Text("Take \(medicine.morningMedicineCount + medicine.noonMedicineCount + medicine.nightMedicineCount) Pill(s)")
                        }
                        Spacer()
                    }
                })
        }
        .deleteDisabled(true)
        .listRowSeparator(.hidden)
    }
}

struct MedicineCardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Medicine> = Medicine.fetchRequest()
        fetchRequest.fetchLimit = 1

        if let medicine = try? context.fetch(fetchRequest).first {
            return AnyView(MedicineCardView(medicine: medicine))
        } else {
            // Handle the case when no medicine is available
            return AnyView(EmptyView())
        }
    }
}



