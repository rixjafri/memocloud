//
//  UIDate+EX.swift
//  VoipBussiness
//
//  Created by Muhammad Nouman on 09/07/2021.
//

import Foundation
extension Date {

    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
   
    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    func timeIn12HourFormat() -> (String,String) {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = .none
        formatter.dateFormat = "hh:mm a"
        let d = formatter.string(from: self)
        let value = d.split(separator: " ")
        return (String(value[0]),String(value[1]))
    }
    
    
    
    var startOfWeek: Date? {
            let gregorian = Calendar(identifier: .gregorian)
            guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
            return gregorian.date(byAdding: .day, value: 1, to: sunday)
        }

    var endOfWeek: Date? {
            let gregorian = Calendar(identifier: .gregorian)
            guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
            return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func startOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year,.month], from: self)
        components.day = 1
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func nextDate() -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return nextDate ?? Date()
    }
    
    func previousDate() -> Date {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return previousDate ?? Date()
    }
    
    func addMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: -numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeYears(numberOfYears: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .year, value: -numberOfYears, to: self)
        return endDate ?? Date()
    }
    
    func getHumanReadableDayString() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar = Calendar.current.component(.weekday, from: self)
        return weekdays[calendar - 1]
    }
    
    
    func timeSinceDate(fromDate: Date) -> String {
        let currentDt = fromDate.toString(format: "yyyy-MM-dd hh:mm:ss")
        
        let dt = currentDt.toDate(withFormat: "yyyy-MM-dd hh:mm:ss")
        let earliest = self < dt ? self  : dt
        let latest = (earliest == self) ? dt : self
    
        let components:DateComponents = Calendar.current.dateComponents([.minute,.hour,.day,.weekOfYear,.month,.year,.second], from: earliest, to: latest)
        let year = components.year  ?? 0
        let month = components.month  ?? 0
        let week = components.weekOfYear  ?? 0
        let day = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        
        if year >= 2{
            return "\(year) years ago"
        }else if (year >= 1){
            return "1 year ago"
        }else if (month >= 2) {
             return "\(month) months ago"
        }else if (month >= 1) {
         return "1 month ago"
        }else  if (week >= 2) {
            return "\(week) weeks ago"
        } else if (week >= 1){
            return "1 week ago"
        } else if (day >= 2) {
            return "\(day) days ago"
        } else if (day >= 1){
           return "1 day ago"
        } else if (hours >= 2) {
            return "\(hours) hours ago"
        } else if (hours >= 1){
            return "1 hour ago"
        } else if (minutes >= 2) {
            return "\(minutes) minutes ago"
        } else if (minutes >= 1){
            return "1 minute ago"
        } else if (seconds >= 3) {
            return "\(seconds) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    func adding(minutes: Int) -> Date {
            return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
        }
    
    func nearestFiveMin() -> Date {
        var cal = Calendar.current
            cal.timeZone = TimeZone.current
            let minutes = cal.component(.minute, from: self)
            // Compute nearest multiple of 5:
            let roundedMinutes = lrint(Double(minutes) / 5) * 5
            return cal.date(byAdding: .minute, value: roundedMinutes - minutes, to: self)!
        }
    
}
extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
}
