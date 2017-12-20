//
//  Point.swift
//  Tracker
//
//  Created by Toby Satterthwaite on 11/22/17.
//

import Foundation
import CoreLocation

class Point {
    var location: CLLocationCoordinate2D
    var time: Int
    var distance: Int
    var speed: CLLocationSpeed
    var date: Date
    
    init(time: Int, distance: Int, speed: CLLocationSpeed, location: CLLocationCoordinate2D, date: Date) {
        self.time = time
        self.distance = distance
        self.speed = speed
        self.location = location
        self.date = date
    }
    
    // Print variables (for debugging purposes)
    func printInfo() {
        print("Latitude: \(location.latitude)")
        print("Longitude: \(location.longitude)")
        print("Speed: \(speed)")
        print("Split: \(getSplit())")
        print("Elapsed Time: \(time)")
        print("Elapsed Distance: \(distance)")
        print("Date and time: \(date)")
    }
    
    // Return speed in split (time for 500m) as user readable string (mins:secs)
    func getSplit() -> String {
        // Check that speed is nonzero
        if (speed == 0) {
            return "0:00"
        }
        
        var seconds = Int((1 / speed) * 500)
        let minutes = Int(seconds/60)
        seconds -= minutes * 60
        return String(format: "%i:%02i", minutes, seconds)
    }
    
    // Formate date to SQL date for uploading
    func sqlDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
