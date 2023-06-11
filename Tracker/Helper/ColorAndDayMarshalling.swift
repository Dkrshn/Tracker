//
//  ColorAndDayMarshalling.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 31.05.2023.
//

import UIKit

final class ColorAndDayMarshalling {
    
    static let shared = ColorAndDayMarshalling()
    
    func hexString(from color: UIColor) -> String {
        let components = color.cgColor.components
        let r = components?[0] ?? 0.0
        let g = components?[1] ?? 0.0
        let b = components?[2] ?? 0.0
        
        return String.init(format: "%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }
    
    func color(from hexString: String) -> UIColor {
        var rgbValue:UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func dayString(from day: [WeekDay]) -> String {
        var stringDay = ""
        for i in day {
            switch i {
            case WeekDay.monday: stringDay += "Пн, "
            case WeekDay.tuesday: stringDay += "Вт, "
            case WeekDay.wednesday: stringDay += "Ср, "
            case WeekDay.thursday: stringDay += "Чт, "
            case WeekDay.friday: stringDay += "Пт, "
            case WeekDay.saturday: stringDay += "Сб, "
            case WeekDay.sunday: stringDay += "Вс"
            default: break
            }
        }
        return stringDay
    }
    
    func day(from stringDay: String) -> [WeekDay] {
        var arrayDay = [WeekDay]()
        let substrings = stringDay.components(separatedBy: ", ")
        for i in substrings {
            switch i {
            case "Пн": arrayDay.append(WeekDay.monday)
            case "Вт": arrayDay.append(WeekDay.tuesday)
            case "Ср": arrayDay.append(WeekDay.wednesday)
            case "Чт": arrayDay.append(WeekDay.thursday)
            case "Пт": arrayDay.append(WeekDay.friday)
            case "Сб": arrayDay.append(WeekDay.saturday)
            case "Вс": arrayDay.append(WeekDay.sunday)
            default: break
            }
        }
        return arrayDay
    }
}
