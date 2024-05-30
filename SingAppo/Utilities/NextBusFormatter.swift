//
//  NextBusFormatter.swift
//  SingAppo
//
//  Created by Zachary on 30/5/24.
//

import Foundation


func formattedEstimatedArrival(_ estimatedArrival: String?) -> String {
    guard let estimatedArrival = estimatedArrival else {
        return "N/A"
    }
    
    let dateFormatter = ISO8601DateFormatter()
    guard let date = dateFormatter.date(from: estimatedArrival) else {
        return "Invalid Date"
    }
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm"
    let timeString = timeFormatter.string(from: date)
    
    let now = Date()
    let timeDifference = Int(date.timeIntervalSince(now) / 60)
    let minutesString = timeDifference > 0 ? "\(timeDifference) min" : "Arriving"
    
    return "\(timeString) (\(minutesString))"
}
