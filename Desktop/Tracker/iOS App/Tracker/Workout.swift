//
//  Workout.swift
//  Tracker
//
//  Created by Toby Satterthwaite on 11/22/17.
//

import Foundation

class Workout {
    
    var time: Int
    var distance: Int
    var averageSpeed: Double
    var points: [Point]
    var date: Date
    
    init(time: Int, distance: Int, points: [Point], date: Date) {
        self.time = time
        self.distance = distance
        self.points = points
        self.date = date
        
        // Calculate average speed
        self.averageSpeed = Double(distance) / Double(time)
        // Check that averageSpeed is not NaN (0 time)
        if (self.averageSpeed.isNaN) {
            self.averageSpeed = 0
        }
    }
    
    // Format time to user readable format (hrs:mins:secs)
    func formattedTime() -> String {
        let hours = (time / 3600) % 3600
        let minutes = (time / 60) % 60
        let seconds = time % 60
        
        return String(format: "%i:%02i:%02i", hours, minutes, seconds)
    }
    
    // Formate date to SQL date for uploading
    func sqlDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
}
