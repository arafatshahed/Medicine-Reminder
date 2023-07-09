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
                            if let medName = medicine.medicineName{
                                Text(medName)
                                    .font(.title2)
                            }
                            
                            if medicinesTurn == .morning{
                                Text("Take \(medicine.morningMedicineCount) Pill(s)")
                            }else if medicinesTurn == .afternoon{
                                Text("Take \(medicine.noonMedicineCount) Pill(s)")
                            } else if medicinesTurn == .night{
                                Text("Take \(medicine.nightMedicineCount) Pill(s)")
                            } else{
                                Text("Take \(medicine.morningMedicineCount + medicine.noonMedicineCount + medicine.nightMedicineCount) Pill(s) daily")
                            }
                            
                        }
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



