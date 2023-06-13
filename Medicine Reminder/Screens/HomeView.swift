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
        sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.timestamp, ascending: true)],
        animation: .default)
    private var medicines: FetchedResults<Medicine>
    @State private var presentAlert = false
    @State var medName = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(medicines) { medicine in
                    Text("\(medicine.timestamp ?? Date(), formatter: itemFormatter)")
                        .font(.title)
    
                    NavigationLink {
                        Text("Name of medicine is :  \(medicine.medicineName!)")
                        Text("Timed added: \(medicine.timestamp ?? Date(), formatter: itemFormatter)")
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
                                        Text("Take 1 Pill(s)")
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
                        presentAlert = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .sheet(isPresented: $presentAlert, content: {
                        self.makeScannerView()
                    })
                }
            }
            Text("Select an item")
        }

    }
    private func addItem(medicineName: String) {
        withAnimation {
            let newItem = Medicine(context: viewContext)
            newItem.timestamp = Date()
            newItem.medicineName = medicineName

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
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines){
                addItem(medicineName: outputText)
            }
            self.presentAlert = false
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
