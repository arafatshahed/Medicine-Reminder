//
//  HomeView.swift
//  Medicine Reminder
//
//  Created by BJIT on 9/6/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.medicineStartDate, ascending: true)],
        animation: .default)
    private var medicines: FetchedResults<Medicine>
    @State private var showScannerView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(medicines) { medicine in
                    Text("\(medicine.medicineStartDate ?? Date(), formatter: itemFormatter)")
                        .font(.title)
                        .deleteDisabled(true)
    
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
                    .listRowSeparator(.hidden)
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
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
