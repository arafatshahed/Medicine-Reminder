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

let morningMedicineTakingTimeKey = "morningMedicineTakingTime"
let afternoonMedicineTakingTimeKey = "afternoonMedicineTakingTime"
let nightMedicineTakingTimeKey = "nightMedicineTakingTime"
let delayBeforeMealKey = "delayBeforeMeal"

let medicineEndDatePredicate = NSPredicate(format: "medicineEndDate > %@", Date() as NSDate)
//let morningMedicinePredicate = NSPredicate(format: "morningMedicineCount > %@", 0 as NSNumber)
//let afternoonMedicinePredicate = NSPredicate(format: "noonMedicineCount > %@", 0 as NSNumber)
//let nightMedicinePredicate = NSPredicate(format: "nightMedicineCount > %@", 0 as NSNumber)
//let beforeMealPredicate = NSPredicate(format: "beforeMeal == %@", true as NSNumber)
//let afterMealPredicate = NSPredicate(format: "beforeMeal == %@", false as NSNumber)
//let morningMedicineEndDatePredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [medicineEndDatePredicate, morningMedicinePredicate])
//let afternoonMedicineEndDatePredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [medicineEndDatePredicate, afternoonMedicinePredicate])
//let nightMedicineEndDatePredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [medicineEndDatePredicate, nightMedicinePredicate])

