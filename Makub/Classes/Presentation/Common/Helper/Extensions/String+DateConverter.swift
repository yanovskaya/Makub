//
//  String+DateConverter.swift
//  Makub
//
//  Created by Елена Яновская on 18.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation.NSString

enum TimePeriod {
    case future
    case past
}

extension String {
    
    // MARK: - Public Method
    
    func dateConverter() -> (String, TimePeriod)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let convertedDate = dateFormatter.date(from: self) else { return nil }
        let dateForNow = Date()
        let components = Calendar.current.dateComponents([.year, .day], from: convertedDate, to: dateForNow)
        guard let day = components.day,
            let year = components.year else { return nil }
        let fixedMonth = Calendar.current.component(.month, from: convertedDate)
        if year > 0 {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return (dateFormatter.string(from: convertedDate), .past)
        } else if convertedDate == dateForNow {
            return ("Cегодня", .future)
        } else if day == -1 {
            return ("Завтра", .future)
        } else {
            dateFormatter.dateFormat = "dd"
            let month = getMonth(num: fixedMonth)
            if day > 0 {
            return (dateFormatter.string(from: convertedDate) + " " + month, .past)
            } else {
                 return (dateFormatter.string(from: convertedDate) + " " + month, .future)
            }
        }
    }
    
    // MARK: - Private Method
    
    private func getMonth(num: Int) -> String {
        if num == 1 { return "января" }
        if num == 2 { return "февраля" }
        if num == 3 { return "марта" }
        if num == 4 { return "апреля" }
        if num == 5 { return "мая" }
        if num == 6 { return "июня" }
        if num == 7 { return "июля" }
        if num == 8 { return "августа" }
        if num == 9 { return "сентября" }
        if num == 10 { return "октября" }
        if num == 11 { return "ноября" }
        if num == 12 { return "декабря" } else { return "" }
    }
}
