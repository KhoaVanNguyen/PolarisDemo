//
//  HelperFunctions.swift
//  ClientApp
//
//  Created by Khoa Nguyen on 1/4/18.
//  Copyright © 2018 Khoa Nguyen. All rights reserved.
//

import Foundation
import UIKit
extension Date {
    
    func sharedCalendar(){
        
    }
    
    func firstDayOfMonth () -> Date {
        let calendar = Calendar.current
        var dateComponent = (calendar as NSCalendar).components([.year, .month, .day ], from: self)
        dateComponent.day = 1
        return calendar.date(from: dateComponent)!
    }
    
    init(year : Int, month : Int, day : Int) {
        
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = day
        self = calendar.date(from: dateComponent)!
    }
    
    func dateByAddingMonths(_ months : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.month = months
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    func dateByAddingDays(_ days : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.day = days
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    func hour() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.hour, from: self)
        return dateComponent.hour!
    }
    
    func second() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.second, from: self)
        return dateComponent.second!
    }
    
    func minute() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.minute, from: self)
        return dateComponent.minute!
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.day, from: self)
        return dateComponent.day!
    }
    
    func weekday() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.weekday, from: self)
        return dateComponent.weekday!
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.month, from: self)
        return dateComponent.month!
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.year, from: self)
        return dateComponent.year!
    }
    
    func numberOfDaysInMonth() -> Int {
        let calendar = Calendar.current
        let days = (calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self)
        return days.length
    }
    
    func dateByIgnoringTime() -> Date {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components([.year, .month, .day ], from: self)
        return calendar.date(from: dateComponent)!
    }
    
    func monthNameFull() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: self)
    }
    
    func isSunday() -> Bool
    {
        return (self.getWeekday() == 1)
    }
    
    func isMonday() -> Bool
    {
        return (self.getWeekday() == 2)
    }
    
    func isTuesday() -> Bool
    {
        return (self.getWeekday() == 3)
    }
    
    func isWednesday() -> Bool
    {
        return (self.getWeekday() == 4)
    }
    
    func isThursday() -> Bool
    {
        return (self.getWeekday() == 5)
    }
    
    func isFriday() -> Bool
    {
        return (self.getWeekday() == 6)
    }
    
    func isSaturday() -> Bool
    {
        return (self.getWeekday() == 7)
    }
    
    func getWeekday() -> Int {
        let calendar = Calendar.current
        return (calendar as NSCalendar).components( .weekday, from: self).weekday!
    }
    
    func isToday() -> Bool {
        return self.isDateSameDay(Date())
    }
    
    func isDateSameDay(_ date: Date) -> Bool {
        
        return (self.day() == date.day()) && (self.month() == date.month() && (self.year() == date.year()))
        
    }
    
    static func ==(lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == ComparisonResult.orderedSame
    }
    
    static func <(lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == ComparisonResult.orderedAscending
    }
    
    static func >(lhs: Date, rhs: Date) -> Bool {
        return rhs.compare(lhs) == ComparisonResult.orderedAscending
    }
}

func formatDayAndMonth(date: Date) -> String{
    
    
    let year = date.year()
    let month = date.month()
    let day = date.day()
    
    
    var newDay = "\(day)"
    var newMonth = "\(month)"
    
    if day < 10 {
        newDay = "0\(day)"
    }
    if month < 10 {
        newMonth = "0\(month)"
    }
    return "\(newDay)/\(newMonth)/\(year)"
    
}
func getImageFrom(base64Encode strBase64: String) -> UIImage?{
    let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
    let decodedimage = UIImage(data: dataDecoded)
    return decodedimage
}
