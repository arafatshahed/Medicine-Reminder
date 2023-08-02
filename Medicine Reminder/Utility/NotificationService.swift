
//  NotificationService.swift
//  Medicine Reminder
//
//  Created by MD SAKIBUL ALAM UTCHAS_0088 on 11/7/23.
//


import Foundation
import UserNotifications
import CoreData
import Foundation
import UIKit

class NotificationService:NSObject,  ObservableObject{
    var count = 0
    static let shared = NotificationService()
    let notificationCenter = UNUserNotificationCenter.current()
    override init(){
        super.init()
    }
    
    func requestAuthorization(){
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted{
                print("Permission granted")
                self.registerActions()
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
        content.userInfo = ["title" : title, "body" : body]
        content.categoryIdentifier = "snooze"
        print("categoryIdentifier", content.categoryIdentifier)
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
    
    func registerActions() {
        let snooze5Action = UNNotificationAction(identifier: "snooze5", title: "Snooze 5 minutes")
        let snooze10Action = UNNotificationAction(identifier: "snooze10", title: "Snooze 10 minutes")
        let snoozeCategory = UNNotificationCategory(identifier: "snooze",
                                                    actions: [snooze5Action, snooze10Action],
                                                    intentIdentifiers: [])
        notificationCenter.setNotificationCategories([snoozeCategory])
    }
    
//    func convertToLocalTimeZone(date: Date) -> Date {
//        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: date))
//        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: date) else {
//            return date
//        }
//        return localDate
//    }
}



class AppDelegate: NotificationService, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
//        UIApplication.shared.applicationIconBadgeNumber += 1
        if let body = response.notification.request.content.userInfo["body"] as? String, let title = response.notification.request.content.userInfo["title"] as? String {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIApplication.shared.applicationIconBadgeNumber -= 1
                AppState.shared.pageToNavigationTo = body
                AppState.shared.title = title
            }
        }
        var snoozeInterval: Double?
        if response.actionIdentifier == "snooze5" {
            snoozeInterval = 5 * 60
        } else {
            if response.actionIdentifier == "snooze10" {
                snoozeInterval = 10 * 60
            }
        }
        if let snoozeInterval = snoozeInterval {
            let content = response.notification.request.content
            let newContent = content.mutableCopy() as! UNMutableNotificationContent
            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: snoozeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: newContent,
                                                trigger: newTrigger)
            do {
                try await notificationCenter.add(request)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var pageToNavigationTo : String?
    @Published var title: String?
}
