//
//  ViewController.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 6/15/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var weeklyStepsLabel: UILabel!
  
    var val: Int? = 0
    var weeklyVal: Int? = 0
    var totalWeekSteps = 0
    let healthStore = HKHealthStore()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
        self.getTodayTotalStepCounts()
        self.getWeeklyStepCounts()
       
        // returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday
        if (Date().dayNumberOfWeek() == 1) {
            // weekly steps = 0 to database
            // enter historical data
        }
        // send in total steps of the day
    }
    
    func authorizeHealthKit(){
        let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk, error) in
            if(chk) {
                print("permission granted")
            }
        }
    }

    func getTodayTotalStepCounts() {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        var interval = DateComponents()
     
        interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)
        query.initialResultsHandler = {
            query,result,error in

            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to: Date()) { (statistic, value) in
                    if let count = statistic.sumQuantity() {
                        self.val = Int(count.doubleValue(for: HKUnit.count()))
                    }
                }
            }
        }
        DispatchQueue.main.async {
            print("Total step taken today is \(self.val ?? 0) steps")
         //   if String(self.val) != nil {
            self.stepsLabel.text = "\(self.val ?? 0)"
          //  }
        }
        healthStore.execute(query)
    }
   
    func getWeeklyStepCounts() {
          guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
              return
          }
          // let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
          let date = Calendar.current.startOfDay(for: Date())
          let modifiedDate = Calendar.current.date(byAdding: .day, value: -(Date().dayNumberOfWeek()! - 1), to:date)!
          let predicate = HKQuery.predicateForSamples(withStart: modifiedDate, end: Date(), options: .strictEndDate)
          var interval = DateComponents()
       
          interval.day = 1
          let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: modifiedDate, intervalComponents: interval)
          query.initialResultsHandler = {
              query,result,error in

              if let myresult = result {
                  myresult.enumerateStatistics(from: modifiedDate, to: Date()) { (statistic, value) in
                        if let count = statistic.sumQuantity() {
                            self.weeklyVal! += Int(count.doubleValue(for: HKUnit.count()))
                        // print("Total steps taken this week is \(self.weeklyVal) steps")
                     }
                  }
              }
          }
        DispatchQueue.main.async {
            print("TOTAL WEEK IS \(self.weeklyVal ?? 0)")
            self.weeklyStepsLabel.text = "\(self.weeklyVal ?? 0)"
        }
          healthStore.execute(query)
      }
    
//    Total step taken today is 143 steps
//    Total steps taken this week is 2665 steps
//    Total steps taken this week is 3570 steps
//    Total steps taken this week is 143 steps
    
//    @IBAction func reloadSteps(_ sender: Any) {
//        getTodayTotalStepCounts()
//        getWeeklyStepCounts()
//        // today
//        stepsLabel.text = String(val)
//    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}


