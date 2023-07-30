//
//  MedicineCardView.swift
//  Medicine Reminder
//
//  Created by BJIT on 7/7/23.
//

import SwiftUI
import CoreData

struct MedicineCardView: View {
    @ObservedObject var medicine: Medicine
    @State var isDeleteDisabled: Bool
    @State var medicinesTurn: MedicineTurn?
    var body: some View {
        NavigationLink {
            MedicineDetailsView(medicine: medicine)
        } label: {
            Rectangle()
                .frame(height: 60)
                .cornerRadius(10)
                .foregroundColor(Color("itemBG"))
                .overlay(content: {
                    HStack{
                        Image(systemName: "pills")
                            .font(.system(size: 25))
                            .padding(.leading, 15)
                        Rectangle()
                            .frame(width: 3, height: 35)
                            .padding(.horizontal, 10)
                        VStack(alignment: .leading, spacing: 2){
                            if let medName = medicine.medicineName{
                                Text(medName)
                                    .font(.system(size: 19, weight: .semibold))
                            }
                            if medicinesTurn == .morning{
                                Text("Take \(medicine.morningMedicineCount) Pill(s) \(medicine.beforeMeal ? "before meal" : "")")
                            }else if medicinesTurn == .afternoon{
                                Text("Take \(medicine.noonMedicineCount) Pill(s) \(medicine.beforeMeal ? "before meal" : "")")
                            } else if medicinesTurn == .night{
                                Text("Take \(medicine.nightMedicineCount) Pill(s) \(medicine.beforeMeal ? "before meal" : "")")
                            } else{
                                Text("Take \(medicine.morningMedicineCount + medicine.noonMedicineCount + medicine.nightMedicineCount) Pill(s) daily")
                            }
                            
                        }
                        .font(.system(size: 15, weight: .light))
                        Spacer()
                    }
                })
        }
        .deleteDisabled(isDeleteDisabled)
        .listRowSeparator(.hidden)
    }
}

struct MedicineCardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Medicine> = Medicine.fetchRequest()
        fetchRequest.fetchLimit = 1

        if let medicine = try? context.fetch(fetchRequest).first {
            return AnyView(MedicineCardView(medicine: medicine, isDeleteDisabled: false))
        } else {
            // Handle the case when no medicine is available
            return AnyView(EmptyView())
        }
    }
}



