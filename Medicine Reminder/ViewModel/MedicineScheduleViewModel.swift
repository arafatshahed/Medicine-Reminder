//
//  MedicineScheduleViewModel.swift
//  Medicine Reminder
//
//  Created by BJIT on 8/7/23.
//

import Foundation
import SwiftUI


class MedicineScheduleViewModel: ObservableObject {
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

    init() {
        morningMedicineTakingTime = UserDefaults.standard.object(forKey: "morningMedicineTakingTime") as? Date ?? Date()
        afternoonMedicineTakingTime = UserDefaults.standard.object(forKey: "afternoonMedicineTakingTime") as? Date ?? Date()
        nightMedicineTakingTime = UserDefaults.standard.object(forKey: "nightMedicineTakingTime") as? Date ?? Date()
    }
}
