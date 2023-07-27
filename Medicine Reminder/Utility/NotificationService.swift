
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
    
    func scheduleNotification(title: String, subtitle: String, body: String, badge: Int?, sound: UNNotificationSound?, date: Date){
        //  print("time---\(date)")
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
            print(n.content.title)
            print(n.content.body)
            let trigger = n.trigger as! UNCalendarNotificationTrigger
           // let date = convertToLocalTimeZone(date: trigger.nextTriggerDate()!)
            print(trigger.nextTriggerDate()!)
            print()
            
        }
        return notificationRequests
    }
    
    func removePendingNotification(identifier: String){
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func removeAllPendingNotifications(){
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
//    func convertToLocalTimeZone(date: Date) -> Date {
//        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: date))
//        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: date) else {
//            return date
//        }
//        return localDate
//    }
}

