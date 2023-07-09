//
//  MedicinePerser.swift
//  data process
//
//  Created by MD SAKIBUL ALAM UTCHAS_0088 on 6/7/23.
//

import Foundation
import CoreData

class MedicineParser{
    
    static let shared  = MedicineParser()
    
    private init (){
        
    }
    
    func convertToMedicineArray(data: String, viewContext: NSManagedObjectContext)->[Medicine]{
        var medicineArray = [Medicine]()
        var medicineData = data.components(separatedBy: "\n")
        
        medicineData.removeFirst(4)
        
        for i in 0..<medicineData.count{
            if i%4 == 0{
                let medicine = Medicine(context: viewContext)
                medicine.medicineName = medicineData[i]
                let routine = medicineData[i+1].replacingOccurrences(of: " ", with: "")
                let routineData = routine.components(separatedBy: "+")
                medicine.morningMedicineCount = Int16(routineData[0]) ?? 0
                medicine.noonMedicineCount = Int16(routineData[1]) ?? 0
                medicine.nightMedicineCount = Int16(routineData[2]) ?? 0
                var medicineEndDate = medicineData[i+2]
                let convertedDay = convertToDays(dateString: medicineEndDate)
                medicine.medicineStartDate = Date()
                medicineEndDate = medicineEndDate.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                medicine.medicineEndDate = Date().addingTimeInterval(TimeInterval(60*60*24*(Int(convertedDay) )))
                medicine.beforeMeal = medicineData[i+3] == "Yes" ? true : false
                medicineArray.append(medicine)
            }
        }
        return medicineArray
    }
    
    func convertToDays(dateString: String) -> Int {
        
        var dateString = dateString.replacingOccurrences(of: " ", with: "")
        dateString = dateString.lowercased()
        var day = 0
        var month = 0
        var year = 0
        var dayString = ""
        var monthString = ""
        var yearString = ""
        
        if dateString.contains("year"){
            yearString = dateString.components(separatedBy: "year")[0]
            dateString = dateString.replacingOccurrences(of: yearString, with: "")
            for char in dateString{
                if char.isNumber{
                    break
                }
                dateString.removeFirst()
            }
            yearString = yearString.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            year = Int(yearString) ?? 0
        }
        
        if dateString.contains("month"){
            monthString = dateString.components(separatedBy: "month")[0]
            dateString = dateString.replacingOccurrences(of: monthString, with: "")
            for char in dateString{
                if char.isNumber{
                    break
                }
                dateString.removeFirst()
            }
            monthString = monthString.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            month = Int(monthString) ?? 0
        }
        
        if dateString.contains("day"){
            dayString = dateString.components(separatedBy: "day")[0]
            dateString = dateString.replacingOccurrences(of: dayString, with: "")
            for char in dateString{
                if char.isNumber{
                    break
                }
                dateString.removeFirst()
            }
            dayString = dayString.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            day = Int(dayString) ?? 0
        }
        
        return day + month*30 + year*365
    }
}


