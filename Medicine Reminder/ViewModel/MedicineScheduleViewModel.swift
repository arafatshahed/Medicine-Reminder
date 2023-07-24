//
//  MedicineScheduleViewModel.swift
//  Medicine Reminder
//
//  Created by BJIT on 8/7/23.
//

import Foundation
import SwiftUI


class MedicineScheduleViewModel: ObservableObject {
    let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    @Published var morningMedicineTakingTime: Date {
        didSet {
            UserDefaults.standard.set(morningMedicineTakingTime, forKey: "morningMedicineTakingTime")
        }
    }

    @Published var afternoonMedicineTakingTime: Date {
        didSet {
            UserDefaults.standard.set(afternoonMedicineTakingTime, forKey: "afternoonMedicineTakingTime")
        }
    }

    @Published var nightMedicineTakingTime: Date {
        didSet {
            UserDefaults.standard.set(nightMedicineTakingTime, forKey: "nightMedicineTakingTime")
        }
    }
    
    @Published var delayBeforeMeal: Int {
        didSet {
            UserDefaults.standard.set(delayBeforeMeal, forKey: "delayBeforeMeal")
        }
    }

    init() {
        morningMedicineTakingTime = UserDefaults.standard.object(forKey: "morningMedicineTakingTime") as? Date ?? MedicineScheduleViewModel.generateDefaultDate(hour: 8, minute: 0, second: 0)
        afternoonMedicineTakingTime = UserDefaults.standard.object(forKey: "afternoonMedicineTakingTime") as? Date ?? MedicineScheduleViewModel.generateDefaultDate(hour: 13, minute: 0, second: 0)
        nightMedicineTakingTime = UserDefaults.standard.object(forKey: "nightMedicineTakingTime") as? Date ?? MedicineScheduleViewModel.generateDefaultDate(hour: 21, minute: 0, second: 0)
        delayBeforeMeal = 30
    }
    static func generateDefaultDate(hour: Int, minute: Int, second: Int)->Date{
        let calendar = Calendar.current

        // Get the current date
        let currentDate = Date()

        // Get the components of the current date
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)

        // Set the time components to 8:00 AM
        var updatedComponents = DateComponents()
        updatedComponents.year = dateComponents.year
        updatedComponents.month = dateComponents.month
        updatedComponents.day = dateComponents.day
        updatedComponents.hour = hour
        updatedComponents.minute = minute
        updatedComponents.second = second

        // Create a new date with the updated components
        if let updatedDate = calendar.date(from: updatedComponents) {
            return updatedDate // Output: 2023-07-08 08:00:00 +0000
        }
        return Date()
    }
}
