//
//  Medicines.swift
//  Medicine Reminder
//
//  Created by MD SAKIBUL ALAM UTCHAS_0088 on 27/7/23.
//

import Foundation
import CoreData
import SwiftUI


class MedicinesHelper{
    
    static let shared = MedicinesHelper()
    var count = 0
    
    private init(){}
    
    func setMedicineNotification(context: NSManagedObjectContext){
        NotificationService.shared.removeAllPendingNotifications()
        count = 0
        let morningMedicineTakingTime = UserDefaults.standard.object(forKey: "morningMedicineTakingTime") as! Date
        let nightMedicineTakingTime = UserDefaults.standard.object(forKey: "nightMedicineTakingTime") as! Date
        let afternoonMedicineTakingTime = UserDefaults.standard.object(forKey: "afternoonMedicineTakingTime") as! Date
        let delayBeforeMeal = (UserDefaults.standard.object(forKey: "delayBeforeMeal") as? Int ?? 30) * -1
        
        let fetchRequest : NSFetchRequest<Medicine> = Medicine.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "medicineEndDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            let medicines = try context.fetch(fetchRequest)
            guard let endDate = (medicines.last?.medicineEndDate) else { return }
            var currentDate = Date()
            
            while  currentDate <= endDate{
                var morningBeforeMealMedicineList = [Medicine]()
                var afternoonBeforeMealMedicineList = [Medicine]()
                var nightBeforeMealMedicineList = [Medicine]()
                var morningAfterMealMedicineList = [Medicine]()
                var afternoonAfterMealMedicineList = [Medicine]()
                var nightAfterMealMedicineList = [Medicine]()
                
                for medicine in medicines {
                    if medicine.medicineStartDate! <= currentDate && medicine.medicineEndDate! >= currentDate{
                        if medicine.morningMedicineCount > 0 && medicine.beforeMeal{
                            morningBeforeMealMedicineList.append(medicine)
                        }
                        if medicine.noonMedicineCount > 0 && medicine.beforeMeal{
                            afternoonBeforeMealMedicineList.append(medicine)
                        }
                        if medicine.nightMedicineCount > 0 && medicine.beforeMeal{
                            nightBeforeMealMedicineList.append(medicine)
                        }
                        if medicine.morningMedicineCount > 0 && !medicine.beforeMeal{
                            morningAfterMealMedicineList.append(medicine)
                        }
                        if medicine.noonMedicineCount > 0 && !medicine.beforeMeal{
                            afternoonAfterMealMedicineList.append(medicine)
                        }
                        if medicine.nightMedicineCount > 0 && !medicine.beforeMeal{
                            nightAfterMealMedicineList.append(medicine)
                        }
                    }
                }
                if morningBeforeMealMedicineList.count > 0{
                    scheduleMedicineNotification(medicines: morningBeforeMealMedicineList, medicineTurn: .morning, date: currentDate, delayBeforeMeal: delayBeforeMeal, medicineTakingTime: morningMedicineTakingTime)
                }
                
                if morningAfterMealMedicineList.count > 0{
                    scheduleMedicineNotification(medicines: morningAfterMealMedicineList, medicineTurn: .morning, date: currentDate, delayBeforeMeal: delayBeforeMeal, medicineTakingTime: morningMedicineTakingTime)
                }
                if afternoonBeforeMealMedicineList.count > 0{
                    
                    scheduleMedicineNotification(medicines: afternoonBeforeMealMedicineList, medicineTurn: .afternoon, date: currentDate, delayBeforeMeal: delayBeforeMeal, medicineTakingTime: afternoonMedicineTakingTime)
                }
                
                if afternoonAfterMealMedicineList.count > 0{
                    scheduleMedicineNotification(medicines: afternoonAfterMealMedicineList, medicineTurn: .afternoon, date: currentDate, delayBeforeMeal: delayBeforeMeal, medicineTakingTime: afternoonMedicineTakingTime)
                }
                
                if nightBeforeMealMedicineList.count > 0{
                    scheduleMedicineNotification(medicines: nightBeforeMealMedicineList, medicineTurn: .night, date: currentDate, delayBeforeMeal: delayBeforeMeal, medicineTakingTime: nightMedicineTakingTime)
                }
                if nightAfterMealMedicineList.count > 0{
                    scheduleMedicineNotification(medicines: nightAfterMealMedicineList, medicineTurn: .night, date: currentDate, delayBeforeMeal: delayBeforeMeal, medicineTakingTime: nightMedicineTakingTime)
                }
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            }
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    
    func getMedicineTakingDateTime(currentDate : Date, medicineTakingTime : Date, beforeMeal : Bool, beforeMealTime: Int) -> Date{
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
        if beforeMeal{
            updatedDate = calendar.date(byAdding: .minute, value: beforeMealTime, to: updatedDate)!
        }
       // updatedDate = NotificationService.shared.convertToLocalTimeZone(date: updatedDate)
        //        print("currentDate -- \(currentDate)")
        //        print(("Taking Time -- \(medicineTakingTime)"))
        //        print("Updated Date-----\(updatedDate)")
        //        print()
        
        return updatedDate
    }
    
    func scheduleMedicineNotification(medicines: [Medicine], medicineTurn: MedicineTurn, date: Date, delayBeforeMeal: Int, medicineTakingTime: Date) {
        count += 1
        if (count > 40){
            return
        }
        var medicineName = ""
        var title = ""
        var subtitle = ""
        for medicine in medicines{
            medicineName += medicine.medicineName! + ", "
        }
        medicineName.removeLast(2)
        
        switch medicineTurn{
        case .morning:
            title = "Morning Medicine"
        case .afternoon:
            title = "Afternoon Medicine"
        case .night:
            title = "Night Medicine"
        }
        
        if medicines[0].beforeMeal{
            subtitle = "Take before meal."
        }
        else{
            subtitle = "Take after meal."
        }
        
        let medicineTakingTime = getMedicineTakingDateTime(currentDate: date, medicineTakingTime: medicineTakingTime, beforeMeal: medicines[0].beforeMeal, beforeMealTime: delayBeforeMeal)
//        print(title)
//        print(subtitle)
//        print(medicineName)
//        print(medicineTakingTime)
//        print()
        NotificationService.shared.scheduleNotification(title: title, subtitle: subtitle, body: "Take \(medicineName)", badge: 1, sound: .default, date: medicineTakingTime)
    }
}

