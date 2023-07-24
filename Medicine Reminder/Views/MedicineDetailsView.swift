//
//  MedicineDetailsView.swift
//  Medicine Reminder
//
//  Created by BJIT on 8/7/23.
//

import SwiftUI
import CoreData
import AlertToast

struct MedicineDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var medicine: Medicine
    @State private var showMedicineName: Bool = true
    @State private var showToast = false
    @EnvironmentObject private var medicineScheduleVM: MedicineScheduleViewModel
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                HStack {
                    Text("Medication Name")
                        .font(.title2)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)){
                        showMedicineName.toggle()
                    }
                }
                if showMedicineName{
                    TextField("", text: Binding(
                        get: { medicine.medicineName ?? "" },
                        set: { medicine.medicineName = $0 }
                    ))
                    .textFieldStyle(.roundedBorder)
                }
            }
            
            HStack {
                Text("\(medicineScheduleVM.morningMedicineTakingTime, formatter: medicineScheduleVM.itemFormatter)")
                Spacer()
                Button("Take \(medicine.morningMedicineCount) pill"){
                    alertTF(title: "Morning medicine Count", value: medicine.morningMedicineCount, primaryTitle: "Update", secondaryTitle: "Cancel", primaryAction: { value in
                        medicine.morningMedicineCount = value
                        print(medicine.morningMedicineCount)
                    }, secondaryAction: {
                        print("Cancelled")
                    })
                }
                .foregroundColor(Color("tealBlue"))
            }
            .font(.title2)
            .padding(.vertical)
            HStack {
                Text("\(medicineScheduleVM.afternoonMedicineTakingTime, formatter: medicineScheduleVM.itemFormatter)")
                Spacer()
                Button("Take \(medicine.noonMedicineCount) pill"){
                    alertTF(title: "Afternoon medicine Count", value: medicine.noonMedicineCount, primaryTitle: "Update", secondaryTitle: "Cancel", primaryAction: { value in
                        print(value)
                        medicine.noonMedicineCount = value
                    }, secondaryAction: {
                        print("Cancelled")
                    })
                }
                .foregroundColor(Color("tealBlue"))
            }
            .font(.title2)
            .padding(.vertical)
            HStack {
                Text("\(medicineScheduleVM.nightMedicineTakingTime, formatter: medicineScheduleVM.itemFormatter)")
                Spacer()
                Button("Take \(medicine.nightMedicineCount) pill"){
                    alertTF(title: "Night medicine Count", value: medicine.nightMedicineCount, primaryTitle: "Update", secondaryTitle: "Cancel", primaryAction: { value in
                        print(value)
                        medicine.nightMedicineCount = value
                    }, secondaryAction: {
                        print("Cancelled")
                    })
                }
                .foregroundColor(Color("tealBlue"))
            }
            .font(.title2)
            .padding(.vertical)
            HStack{
                Text("Course end date: ")
                Spacer()
                DatePicker("", selection: Binding(
                    get: { medicine.medicineEndDate ?? Date() },
                    set: { medicine.medicineEndDate = $0 }
                ), in: Date()..., displayedComponents: .date)
                .labelsHidden()
            }
            .padding(.vertical)
            Picker("Toggle", selection: Binding(
                get: { medicine.beforeMeal },
                set: { medicine.beforeMeal = $0 }
            )) {
                Text("Before Meal").tag(false)
                Text("After Meal").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
            Button(action: {
                do {
                    try viewContext.save()
                    Task{
                        NotificationService.shared.setMedicineNotification(context: viewContext)
                    }
                    
                    self.showToast.toggle()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }, label: {
                Text("Save")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 80, height: 50, alignment: .center)
            })
            .buttonStyle(.borderless)
            .background(Color("tealBlue"), alignment: .center)
            .cornerRadius(25)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 20)
        .toast(isPresenting: $showToast, duration: 0.7, tapToDismiss: true, alert: {
            AlertToast(type: .systemImage("checkmark.seal.fill", Color("tealBlue")), title: "Updated Information!")
            
        }, completion: {
            print("completion called")
            self.presentationMode.wrappedValue.dismiss()
        })
        
    }
}



struct MedicineDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Medicine> = Medicine.fetchRequest()
        fetchRequest.fetchLimit = 1
        let viewModel = MedicineScheduleViewModel()
        
        if let medicine = try? context.fetch(fetchRequest).first {
            return AnyView(MedicineDetailsView(medicine: medicine)
                .environmentObject(viewModel))
        } else {
            // Handle the case when no medicine is available
            return AnyView(EmptyView())
        }
    }
}
