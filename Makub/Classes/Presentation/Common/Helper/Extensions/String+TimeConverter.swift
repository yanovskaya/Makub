//
//  String+TimeConverter.swift
//  Makub
//
//  Created by Елена Яновская on 15.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation.NSString

extension String {
    
    func timeConverter() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let convertedDate = formatter.date(from: self) else { return nil }
        let secondsAgo = Int(Date().timeIntervalSince(convertedDate))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        
        let currentHour = Calendar.current.component(.hour, from: Date())
        let fixedHour = Calendar.current.component(.hour, from: convertedDate)
        let currentMinute = Calendar.current.component(.minute, from: Date())
        let fixedMinute = Calendar.current.component(.minute, from: convertedDate)
        let currentSecond = Calendar.current.component(.second, from: Date())
        let fixedSecond = Calendar.current.component(.second, from: convertedDate)
        
        if secondsAgo < minute {
            return "\(secondsAgo) секунд назад"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) минут назад"
        } else if secondsAgo < hour * 2 {
            return "Час назад"
        } else if secondsAgo < hour * 4 {
            return "\(secondsAgo / hour) часа назад"
        } else if secondsAgo < day && (currentHour > fixedHour ||
            (currentHour == fixedHour && currentMinute > fixedMinute)
            || (currentHour == fixedHour && currentMinute == fixedMinute && currentSecond > fixedSecond)) {
            formatter.dateFormat = "HH:mm"
            return "Сегодня в \(formatter.string(from: convertedDate))"
        } else if secondsAgo == day || (secondsAgo < day * 2 && (currentHour > fixedHour ||
            (currentHour == fixedHour && currentMinute > fixedMinute)
            || (currentHour == fixedHour && currentMinute == fixedMinute && currentSecond > fixedSecond))) {
            formatter.dateFormat = "HH:mm"
            return "Вчера в \(formatter.string(from: convertedDate))"
        } else {
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: convertedDate)
        }
    }
}
