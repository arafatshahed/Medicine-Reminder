//
//  AppEnums.swift
//  Medicine Reminder
//
//  Created by BJIT on 9/7/23.
//

import Foundation

enum MedicineTurn{
    case morning
    case afternoon
    case night
}
enum NotificationIdentifier: String{
    case morningNotificationIdentifier = "morningNotificationIdentifier"
    case afternoonNotificationIdentifier = "afternoonNotificationIdentifier"
    case nightNotificationIdentifier = "nightNotificationIdentifier"
}

struct Schedule: Hashable{
    var turn: MedicineTurn
    var hasPassed: Bool
}
