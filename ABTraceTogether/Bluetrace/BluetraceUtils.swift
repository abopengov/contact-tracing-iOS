//
//  BluetraceUtils.swift
//  OpenTrace

import CoreBluetooth
import CoreData
import Foundation
import UIKit

class BluetraceUtils {
    static func removeData21DaysOld() {
        Logger.DLog("Removing 21 days old data from device!")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Encounter>(entityName: "Encounter")
        fetchRequest.includesPropertyValues = false

        // For e.g. 31st of March, we get reverseCutOffDate of 10th March
        let reverseCutOffDate: Date? = Calendar.current.date(byAdding: .day, value: BluetraceConfig.TTLDays, to: Date())
        if let validDate = reverseCutOffDate {
            let predicateForDel = NSPredicate(format: "timestamp < %@", validDate as NSDate)
            fetchRequest.predicate = predicateForDel
            do {
                let encounters = try managedContext.fetch(fetchRequest)
                for encounter in encounters {
                    managedContext.delete(encounter)
                }
                try managedContext.save()
            } catch {
                print("Could not perform delete of old data. \(error)")
            }
        }
    }
}
