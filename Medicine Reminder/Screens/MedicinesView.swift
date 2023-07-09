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

    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { medicines[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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
