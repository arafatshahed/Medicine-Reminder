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
        animation: .default) private var medicines: FetchedResults<Medicine>
    
    @State private var showScannerView = false
    
    @State var medicineTurns = [Schedule]()
    
    var body: some View {
        NavigationView {
            List(medicineTurns, id: \.self) {t in
                if t.turn == .morning{
                    Text("\(t.hasPassed ? "Tomorrow" : "" ) \(medicineScheduleVM.morningMedicineTakingTime, formatter: medicineScheduleVM.itemFormatter)") //Your Morning Medicines at
                        .font(.title)
                    ForEach(medicines.filter { $0.morningMedicineCount != 0 }) { medicine in
                        MedicineCardView(medicine: medicine, isDeleteDisabled: true, medicinesTurn: .morning)
                    }
                    .listRowBackground(Color.clear)
                }
                if t.turn == .afternoon{
                    Text("\(t.hasPassed ? "Tomorrow" : "" ) \(medicineScheduleVM.afternoonMedicineTakingTime , formatter: medicineScheduleVM.itemFormatter)") //Your Afternoon Medicines at
                        .font(.title)
                    ForEach(medicines.filter { $0.noonMedicineCount != 0 }) { medicine in
                        MedicineCardView(medicine: medicine, isDeleteDisabled: true, medicinesTurn: .afternoon)
                    }
                    .listRowBackground(Color.clear)
                }
                if t.turn == .night{
                    Text("\(t.hasPassed ? "Tomorrow" : "" ) \(medicineScheduleVM.nightMedicineTakingTime , formatter: medicineScheduleVM.itemFormatter)") //Your Night Medicines at
                        .font(.title)
                    ForEach(medicines.filter { $0.nightMedicineCount != 0 }) { medicine in
                        MedicineCardView(medicine: medicine, isDeleteDisabled: true, medicinesTurn: .night)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Medicine Schedule")
            .onAppear(){
                medicineTurns =  medicineScheduleVM.calculateShecduleSerial()
                NotificationService.shared.requestAuthorization()
            }
            
            .listStyle(PlainListStyle())
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showScannerView = true
                    }) {
                        Label("Add Item", systemImage: "doc.viewfinder")
                    }
                    .sheet(isPresented: $showScannerView, content: {
                        self.makeScannerView()
                    })
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
                do {
                    try viewContext.save()
                    Task{
                        await NotificationService.shared.setMedicineNotification(context: viewContext)
                    }
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
    
struct MedicineListView: View{
    @State var medicines: [FetchedResults<Medicine>.Element]
    @Binding var medicineTakingTime: Date
    let itemFormatter: DateFormatter
    let turn: MedicineTurn
    var body: some View{
        Text("\(medicineTakingTime , formatter: itemFormatter)")
            .font(.title)
            .opacity(medicines.count == 0 ? 0: 1)
        ForEach(medicines) { medicine in
            MedicineCardView(medicine: medicine, isDeleteDisabled: true, medicinesTurn: turn)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MedicineScheduleViewModel()
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(viewModel)
    }
}
