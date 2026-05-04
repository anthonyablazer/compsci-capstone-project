//
//  HealthKitManager.swift
//  Nutrients Defficiency Tracker

// This is THE file that manages interactions between Small But Essential and Apple HealthKit. This is home to all the functions needed to verify, fetch, and read all micronutrient information that the user has stored in their HealthKit

//  Created by Anthony Blazer.
//

import HealthKit

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

class HealthKitManager {
    static let shared = HealthKitManager() //initiates a HealthKitManager()
    let healthStore = HKHealthStore() // Initialize a HealthKit store

    // The types we care about
    let nutrientTypes: Set<HKObjectType> = [
        // Minerals
        HKObjectType.quantityType(forIdentifier: .dietaryIron)!,
        HKObjectType.quantityType(forIdentifier: .dietaryMagnesium)!,
        HKObjectType.quantityType(forIdentifier: .dietaryZinc)!,
        HKObjectType.quantityType(forIdentifier: .dietaryCalcium)!,
        HKObjectType.quantityType(forIdentifier: .dietarySelenium)!,
        HKObjectType.quantityType(forIdentifier: .dietaryIodine)!,
        HKObjectType.quantityType(forIdentifier: .dietaryCopper)!,
        HKObjectType.quantityType(forIdentifier: .dietaryPotassium)!,
        HKObjectType.quantityType(forIdentifier: .dietaryManganese)!,
        HKObjectType.quantityType(forIdentifier: .dietaryPhosphorus)!,
        HKObjectType.quantityType(forIdentifier: .dietaryChromium)!,
        
        // Vitamins
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminA)!,
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminD)!,
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminE)!,
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminK)!,
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminC)!,
        HKObjectType.quantityType(forIdentifier: .dietaryThiamin)!,      // B1
        HKObjectType.quantityType(forIdentifier: .dietaryRiboflavin)!,   // B2
        HKObjectType.quantityType(forIdentifier: .dietaryNiacin)!,       // B3
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminB6)!,
        HKObjectType.quantityType(forIdentifier: .dietaryFolate)!,       // B9
        HKObjectType.quantityType(forIdentifier: .dietaryVitaminB12)!,
        HKObjectType.quantityType(forIdentifier: .dietaryBiotin)!,       // B7
        HKObjectType.quantityType(forIdentifier: .dietaryPantothenicAcid)!, // B5
    ]
    
    // Check if HealthKit is available
    func isHealthDataAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    // Request authorization for the micronutrients passed in
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(toShare: nil, read: nutrientTypes) { success, _ in
            DispatchQueue.main.async { completion(success) }
        }
    }
    
    //  Fetch the sum of a nutrient for today
    func fetchTodaysSum(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let sum = result?.sumQuantity()?.doubleValue(for: unit) ?? 0.0
            DispatchQueue.main.async {
                completion(sum)
            }
        }
        healthStore.execute(query)
    }
    
    func enableBackgroundDelivery(for type: HKSampleType, frequency: HKUpdateFrequency = .immediate) {
        healthStore.enableBackgroundDelivery(for: type, frequency: frequency) { success, error in
            if let error = error {
                print("Failed to enable background delivery for \(type): \(error.localizedDescription)")
            } else {
                print("Background Delivery enabled (success=\(success)) for \(type)")
            }
        }
    }
    
    
    // Fetches the sum of a nutrient over a specific number of days
    func fetchSumForLast(days: Int, for identifier: HKQuantityTypeIdentifier, unit: HKUnit, completion: @escaping (Double) -> Void) {
        // 1. Define the timeframe
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: now)!
        
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(0)
            return
        }
        
        // 2. Create a "Predicate" (a filter) for the date range
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        // 3. Create the query to sum the data
        let query = HKStatisticsQuery(quantityType: quantityType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, error in
            
            // 4. Get the sum and convert it to a Double
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0)
                return
            }
            
            let totalValue = sum.doubleValue(for: unit)
            completion(totalValue)
        }
        
        healthStore.execute(query)
    }
    
    
}

// MARK: Background Delivery Implementation

extension HealthKitManager {
    func fetchChartData(for identifier: HKQuantityTypeIdentifier,
                        unit: HKUnit,
                        range: String,
                        isPrevious: Bool = false, // Added parameter with default value
                        completion: @escaping ([ChartDataPoint]) -> Void) {
            
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Maintain a consistent anchor so bar alignments match
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: now)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)!
        
        var interval = DateComponents()
        var startDate: Date
        var endDate: Date = now
        
        switch range {
        case "Today":
            interval.hour = 1
            startDate = calendar.startOfDay(for: now)
            if isPrevious {
                // Shift back exactly 24 hours
                startDate = calendar.date(byAdding: .day, value: -1, to: startDate)!
                endDate = calendar.startOfDay(for: now)
            }
            
        case "Week":
            interval.day = 1
            startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now))!
            if isPrevious {
                // Shift back exactly 7 days
                startDate = calendar.date(byAdding: .day, value: -7, to: startDate)!
                endDate = calendar.date(byAdding: .day, value: -7, to: now)!
            }
            
        case "Month":
            interval.day = 7
            startDate = calendar.date(byAdding: .month, value: -1, to: calendar.startOfDay(for: now))!
            if isPrevious {
                // Shift back exactly 1 month
                startDate = calendar.date(byAdding: .month, value: -1, to: startDate)!
                endDate = calendar.date(byAdding: .month, value: -1, to: now)!
            }
            
        default:
            interval.day = 1
            startDate = now
        }
        
        let query = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: interval
        )
        
        query.initialResultsHandler = { _, results, _ in
            var points: [ChartDataPoint] = []
            // We enumerate from the calculated startDate to the calculated endDate
            results?.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                let value = statistics.sumQuantity()?.doubleValue(for: unit) ?? 0
                points.append(ChartDataPoint(date: statistics.startDate, value: value))
            }
            DispatchQueue.main.async { completion(points) }
        }
        
        healthStore.execute(query)
    }
    
    
    func startObservingQuantityType(_ identifier: HKQuantityTypeIdentifier) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else { return }
        
        let observerQuery = HKObserverQuery(sampleType: quantityType, predicate: nil) { [weak self] _, completionHandler, error in
            if let error = error {
                print("Observer error for \(identifier.rawValue): \(error.localizedDescription)")
                completionHandler()
                return
            }
            
            // Fetch only the new/changed samples since last anchor
            self?.fetchIncrementalUpdates(for: quantityType) {
                // Always call the completion handler when you're done
                completionHandler()
            }
        }
        
        healthStore.execute(observerQuery)
    }
    
    // Store an anchor per type so you only fetch deltas. You can persist anchors (e.g., UserDefaults or disk).
    private func anchorKey(for type: HKSampleType) -> String {
        return "HKAnchor-\(type.identifier)"
    }
    
    private func loadAnchor(for type: HKSampleType) -> HKQueryAnchor? {
        if let data = UserDefaults.standard.data(forKey: anchorKey(for: type)) {
            return try? NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: data)
        }
        return nil
    }
    
    private func saveAnchor(_ anchor: HKQueryAnchor?, for type: HKSampleType) {
        guard let anchor else {
            UserDefaults.standard.removeObject(forKey: anchorKey(for: type))
            return
        }
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true) {
            UserDefaults.standard.set(data, forKey: anchorKey(for: type))
        }
    }
    
    // Query to fetch only changes since last run
    func fetchIncrementalUpdates(for type: HKSampleType, completion: @escaping () -> Void) {
        let previousAnchor = loadAnchor(for: type)
        
        let query = HKAnchoredObjectQuery(type: type,
                                          predicate: nil,
                                          anchor: previousAnchor,
                                          limit: HKObjectQueryNoLimit) { [weak self] _, samplesOrNil, deletedObjectsOrNil, newAnchor, error in
            if let error = error {
                print("Anchored query error for \(type.identifier): \(error.localizedDescription)")
                completion()
                return
            }
            
            _ = samplesOrNil as? [HKQuantitySample] ?? []
            let deleted = deletedObjectsOrNil ?? []
            
            if !deleted.isEmpty {
            }
            
            self?.saveAnchor(newAnchor, for: type)
            DispatchQueue.main.async {
                // Notify the app that new data has arrived
                NotificationCenter.default.post(name: NSNotification.Name("HKDataChanged"), object: nil)
            }
            completion()
        }
        
        healthStore.execute(query)
    }
    
    // Fetches the sum for a specific date range (Fixes Date Drift)
    func fetchSum(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, start: Date, end: Date, completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let sum = result?.sumQuantity()?.doubleValue(for: unit) ?? 0.0
            DispatchQueue.main.async { completion(sum) }
        }
        healthStore.execute(query)
    }
}
