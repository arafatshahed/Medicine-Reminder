//
//  NotificationService.swift
//  Medicine Reminder
//
//  Created by MD SAKIBUL ALAM UTCHAS_0088 on 11/7/23.
//


import Foundation
import UserNotifications
import CoreData

class NotificationService{
    var count = 0
    static let shared = NotificationService()
    let notificationCenter = UNUserNotificationCenter.current()
    private init(){
        
    }
    
    func requestAuthorization(){
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted{
                print("Permission granted")
            }
            else{
                print(error?.localizedDescription ?? "Error")
            }
        }
    }
    
    func setMedicineNotification(context: NSManagedObjectContext){
        removeAllPendingNotifications()
        
        let morningMedicineTakingTime = UserDefaults.standard.object(forKey: "morningMedicineTakingTime") as! Date
        let nightMedicineTakingTime = UserDefaults.standard.object(forKey: "nightMedicineTakingTime") as! Date
        let afternoonMedicineTakingTime = UserDefaults.standard.object(forKey: "afternoonMedicineTakingTime") as! Date
  
        let fetchRequest : NSFetchRequest<Medicine> = Medicine.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "medicineEndDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            let medicines = try context.fetch(fetchRequest)
            guard let endDate = (medicines.last?.medicineEndDate) else { return }
            var currentDate = Date()
            while  currentDate <= endDate{
                var morningMedicineList = [Medicine]()
                var afternoonMedicineList = [Medicine]()
                var nightMedicineList = [Medicine]()
                for medicine in medicines {
                    if medicine.medicineStartDate! <= currentDate && medicine.medicineEndDate! >= currentDate{
                        if medicine.morningMedicineCount > 0{
                            morningMedicineList.append(medicine)
                        }
                        if medicine.noonMedicineCount > 0{
                            afternoonMedicineList.append(medicine)
                        }
                        if medicine.nightMedicineCount > 0{
                            nightMedicineList.append(medicine)
                        }
                    }
                }
                    if morningMedicineList.count > 0{
                        var medicineName = ""
                        for medicine in morningMedicineList{
                            medicineName += medicine.medicineName! + ", "
                        }
                        medicineName.removeLast(2)
                        let medicineTakingTime = getMedicineTakingDateTime(currentDate: currentDate, medicineTakingTime: morningMedicineTakingTime)
                        scheduleNotification(title: "Morning Medicine", subtitle: "Time to take medicine", body: "Take \(medicineName)", badge: 1, sound: .default, date: medicineTakingTime)
                        
                    }
                    if afternoonMedicineList.count > 0{
                        var medicineName = ""
                        for medicine in afternoonMedicineList{
                            medicineName += medicine.medicineName! + ", "
                        }
                        medicineName.removeLast(2)
                        let medicineTakingTime = getMedicineTakingDateTime(currentDate: currentDate, medicineTakingTime: afternoonMedicineTakingTime)
                        scheduleNotification(title: "Afternoon Medicine", subtitle: "Time to take medicine", body: "Take \(medicineName)", badge: 1, sound: .default, date: medicineTakingTime)
                    }
                    if nightMedicineList.count > 0{
                        var medicineName = ""
                        for medicine in nightMedicineList{
                            medicineName += medicine.medicineName! + ", "
                        }
                        medicineName.removeLast(2)
                        let medicineTakingTime = getMedicineTakingDateTime(currentDate: currentDate, medicineTakingTime: nightMedicineTakingTime)
                        scheduleNotification(title: "Night Medicine", subtitle: "Time to take medicine", body: "Take \(medicineName)", badge: 1, sound: .default, date: medicineTakingTime)
                    }
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            }
            
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func scheduleNotification(title: String, subtitle: String, body: String, badge: Int?, sound: UNNotificationSound?, date: Date){
      //  print("time---\(date)")
        count += 1
        if count>10{
            return
        }
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = NSNumber(value: badge ?? 0)
        content.sound = sound
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    
    func retrievePendingNotifications() async -> [UNNotificationRequest]{
        let notificationRequests = await notificationCenter.pendingNotificationRequests()
        for n in notificationRequests{
           // print(n.content.title)
            //print(n.content.body)
            //print time
            let trigger = n.trigger as! UNCalendarNotificationTrigger
            let date = trigger.nextTriggerDate()
           // print(date)
           // print()
            
        }
        return notificationRequests
    }
    
    func removePendingNotification(identifier: String){
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func removeAllPendingNotifications(){
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    
    func getMedicineTakingDateTime(currentDate : Date, medicineTakingTime : Date) -> Date{
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: medicineTakingTime)
        let minute = calendar.component(.minute, from: medicineTakingTime)
        let second = calendar.component(.second, from: medicineTakingTime)
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)


        var updatedComponents = DateComponents()
        updatedComponents.hour = hour
        updatedComponents.minute = minute
        updatedComponents.second = second

        var updatedDate = calendar.date(bySettingHour: updatedComponents.hour ?? 0,
                                        minute: updatedComponents.minute ?? 0,
                                        second: updatedComponents.second ?? 0,
                                        of: calendar.date(from: components) ?? Date()) ?? Date()

//        updatedDate = convertToLocalTimeZone(date: updatedDate)
//        print("currentDate -- \(currentDate)")
//        print(("Taking Time -- \(medicineTakingTime)"))
//        print("Updated Date-----\(updatedDate)")
        print()

        return updatedDate
    }

    func convertToLocalTimeZone(date: Date) -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: date))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: date) else {
            return date
        }
        return localDate
    }
}

