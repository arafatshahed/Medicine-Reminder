//
//  ContentView.swift
//  Medicine Reminder
//
//  Created by BJIT on 8/6/23.
//

import SwiftUI
import CoreData
/*
 struct ContentView: View {
 @Environment(\.managedObjectContext) private var viewContext
 
 @FetchRequest(
 sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
 animation: .default)
 private var items: FetchedResults<Item>
 
 var body: some View {
 NavigationView {
 List {
 ForEach(items) { item in
 NavigationLink {
 Text("Item at \(item.timestamp ?? Date(), formatter: itemFormatter)")
 } label: {
 Text(item.timestamp ?? Date(), formatter: itemFormatter)
 }
 }
 .onDelete(perform: deleteItems)
 }
 .toolbar {
 ToolbarItem(placement: .navigationBarTrailing) {
 EditButton()
 }
 ToolbarItem {
 Button(action: addItem) {
 Label("Add Item", systemImage: "plus")
 }
 }
 }
 Text("Select an item")
 }
 }
 
 private func addItem() {
 withAnimation {
 let newItem = Item(context: viewContext)
 newItem.timestamp = Date()
 
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
 offsets.map { items[$0] }.forEach(viewContext.delete)
 
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
 
 private let itemFormatter: DateFormatter = {
 let formatter = DateFormatter()
 formatter.dateStyle = .short
 formatter.timeStyle = .medium
 return formatter
 }()
 */

struct ContentView: View {
    @AppStorage("onboarding") var isonBoardingViewActive: Bool = true
    init(){
        NotificationService.shared.requestAuthorization()
        //set notification after 60 seconds
        NotificationService.shared.scheduleNotification(title: "Medicine Reminder2", subtitle: "Medicine Reminder2", body: "Medicine Reminder2", badge: 1, sound: .default, date: Date().addingTimeInterval(60))
        NotificationService.shared.scheduleNotification(title: "Medicine Reminder3", subtitle: "Medicine Reminder", body: "Medicine Reminder", badge: 1, sound: .default, date: Date().addingTimeInterval(60))
        // view all pending notification
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            Task{
                let notifications = await NotificationService.shared.retrievePendingNotifications()
                for notification in notifications{
                    // print identifier
                    print(notification.identifier)
                }
            }
        }
        
        
    }
    var body: some View {
        if isonBoardingViewActive{
            //            OnboardingView()
        } else{
            TabViews()
        }
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
