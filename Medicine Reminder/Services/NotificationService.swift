//
//  NotificationService.swift
//  Medicine Reminder
//
//  Created by MD SAKIBUL ALAM UTCHAS_0088 on 13/6/23.
//

import Foundation
import UserNotifications


class NotificationService{

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
        return notificationRequests
    }

    func removePendingNotification(identifier: String){
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}
