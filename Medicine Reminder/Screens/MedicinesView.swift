//
//  MedicinesView.swift
//  Medicine Reminder
//
//  Created by BJIT on 8/7/23.
//

import SwiftUI

struct MedicinesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var medicineScheduleVM: MedicineScheduleViewModel

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.medicineStartDate, ascending: true)],
        animation: .default)
    private var medicines: FetchedResults<Medicine>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(medicines) { medicine in
                    MedicineCardView(medicine: medicine, isDeleteDisabled: false)
                        .environmentObject(medicineScheduleVM)
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("All Medicines")
            .listStyle(PlainListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .onAppear(){
            viewContext.rollback()
        }

    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { medicines[$0] }.forEach(viewContext.delete)

            PersistenceController.shared.save()
        }
    }

}

struct MedicinesView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MedicineScheduleViewModel()
        MedicinesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(viewModel)
    }
}
