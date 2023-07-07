//
//  HomeView.swift
//  Medicine Reminder
//
//  Created by BJIT on 9/6/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var medicineScheduleVM: MedicineScheduleViewModel

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.medicineStartDate, ascending: true)],
        predicate: NSPredicate(format: "morningMedicineCount != %d", 0),
        animation: .default) private var morningMedicines: FetchedResults<Medicine>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.medicineStartDate, ascending: true)],
        predicate: NSPredicate(format: "noonMedicineCount != %d", 0),
        animation: .default) private var noonMedicines: FetchedResults<Medicine>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.medicineStartDate, ascending: true)],
        predicate: NSPredicate(format: "nightMedicineCount != %d", 0),
        animation: .default) private var nightMedicines: FetchedResults<Medicine>
    
    @State private var showScannerView = false
    
    var body: some View {
        NavigationView {
            List {
                Text("\(medicineScheduleVM.morningMedicineTakingTime, formatter: itemFormatter)") //Your Morning Medicines at
                    .font(.title)
                    .opacity(morningMedicines.count == 0 ? 0: 1)
                ForEach(morningMedicines) { medicine in
                    MedicineCardView(medicine: medicine)
                }
                .onDelete(perform: deleteItems)
                
                Text("\(medicineScheduleVM.afternoonMedicineTakingTime , formatter: itemFormatter)") //Your Afternoon Medicines at
                    .font(.title)
                    .opacity(noonMedicines.count == 0 ? 0: 1)
                ForEach(noonMedicines) { medicine in
                    MedicineCardView(medicine: medicine)
                }
                .onDelete(perform: deleteItems)
                Text("\(medicineScheduleVM.nightMedicineTakingTime , formatter: itemFormatter)") //Your Night Medicines at
                    .font(.title)
                    .opacity(nightMedicines.count == 0 ? 0: 1)
                ForEach(nightMedicines) { medicine in
                    MedicineCardView(medicine: medicine)
                }
                .onDelete(perform: deleteItems)
            }
            
            .listStyle(PlainListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        showScannerView = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .sheet(isPresented: $showScannerView, content: {
                        self.makeScannerView()
                    })
                }
            }
        }

    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { morningMedicines[$0] }.forEach(viewContext.delete)

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
    private func makeScannerView()-> ScannerView {
        ScannerView(completion: {
            textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let meds = MedicineParser.shared.convertToMedicineArray(data: outputText, viewContext: viewContext)
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
            self.showScannerView = false
        })
    }
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MedicineScheduleViewModel()
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(viewModel)
    }
}
