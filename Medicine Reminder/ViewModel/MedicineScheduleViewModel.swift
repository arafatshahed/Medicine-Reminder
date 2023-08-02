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
            UserDefaults.standard.set(morningMedicineTakingTime, forKey: morningMedicineTakingTimeKey)
        }
    }

    @Published var afternoonMedicineTakingTime: Date {
        didSet {
            UserDefaults.standard.set(afternoonMedicineTakingTime, forKey: afternoonMedicineTakingTimeKey)
        }
    }

    @Published var nightMedicineTakingTime: Date {
        didSet {
            UserDefaults.standard.set(nightMedicineTakingTime, forKey: nightMedicineTakingTimeKey)
        }
    }
    
    @Published var delayBeforeMeal: Int {
        didSet {
            UserDefaults.standard.setValue(delayBeforeMeal, forKey: delayBeforeMealKey)
        }
    }

    init() {
        morningMedicineTakingTime = MedicineScheduleViewModel.generateDefaultDateIfNotSet(key: morningMedicineTakingTimeKey, hour: 8, minute: 0, second: 0)
        afternoonMedicineTakingTime = MedicineScheduleViewModel.generateDefaultDateIfNotSet(key: afternoonMedicineTakingTimeKey, hour: 13, minute: 0, second: 0)
        nightMedicineTakingTime = MedicineScheduleViewModel.generateDefaultDateIfNotSet(key: nightMedicineTakingTimeKey, hour: 21, minute: 0, second: 0)
        delayBeforeMeal = MedicineScheduleViewModel.generateDefaultDelayIfNotSet()
    }
    
    static func generateDefaultDelayIfNotSet()-> Int{
        if let delayBeforeMeal = UserDefaults.standard.object(forKey: delayBeforeMealKey) as? Int{
            return delayBeforeMeal
        }
        UserDefaults.standard.setValue(30, forKey: delayBeforeMealKey)
        return 30
    }
    
    static func generateDefaultDateIfNotSet(key: String, hour: Int, minute: Int, second: Int)->Date{
        if let medTime = UserDefaults.standard.object(forKey: key) as? Date{
            return medTime
        }
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
            UserDefaults.standard.set(updatedDate, forKey: key)
            return updatedDate // Output: 2023-07-08 08:00:00 +0000
        }
        UserDefaults.standard.set(Date(), forKey: key)
        return Date()
    }
    
    func calculateShecduleSerial()->[Schedule]{
        var timeYetToArrive = [Schedule]()
        var timeAlreadyPassed = [Schedule]()
        if timehasPassed(date: morningMedicineTakingTime){
            timeAlreadyPassed.append(Schedule(turn: .morning, hasPassed: true))
        } else{
            timeYetToArrive.append(Schedule(turn: .morning, hasPassed: false))
        }
        if timehasPassed(date: afternoonMedicineTakingTime){
            timeAlreadyPassed.append(Schedule(turn: .afternoon, hasPassed: true))
        } else{
            timeYetToArrive.append(Schedule(turn: .afternoon, hasPassed: false))
        }
        if timehasPassed(date: nightMedicineTakingTime){
            timeAlreadyPassed.append(Schedule(turn: .night, hasPassed: true))
        } else{
            timeYetToArrive.append(Schedule(turn: .night, hasPassed: false))
        }
        timeYetToArrive.append(contentsOf: timeAlreadyPassed)
        return timeYetToArrive
    }
    
    func timehasPassed(date: Date)->Bool{
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.date(from: f.string(from: date))! < f.date(from: f.string(from: Date()))!
    }
}
