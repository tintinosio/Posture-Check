//
//  Date.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 9/30/22.
//

import Foundation

extension Date {
    func modifyDateFor(days: Int) -> Date {
        let secondsInADay = 86400
      return self.addingTimeInterval(Double(days * secondsInADay))
    }
    
    func modifyDateFor(hour: Int) -> Date {
        let secondsInAHour = 3600
        return self.addingTimeInterval(Double(hour * secondsInAHour))
    }
}
