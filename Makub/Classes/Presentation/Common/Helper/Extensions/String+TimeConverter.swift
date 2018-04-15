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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let convertedDate = dateFormatter.date(from: self) else { return nil }
        let dateForNow = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: convertedDate, to: dateForNow)
        guard let day = components.day,
            let hour = components.hour else { return nil }
        if day > 1 {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: convertedDate)
        } else if day > 0 {
            dateFormatter.dateFormat = "dd.MM"
            return "Вчера в" + " " + dateFormatter.string(from: convertedDate)
        } else if hour > 3 {
            dateFormatter.dateFormat = "HH:mm"
            return "Cегодня в" + " " + dateFormatter.string(from: convertedDate)
        } else if hour > 1 {
            dateFormatter.dateFormat = "HH"
            return dateFormatter.string(from: convertedDate) + "часа назад"
        } else if hour == 1 {
            return "Час назад"
        } else {
            dateFormatter.dateFormat = "mm"
            return dateFormatter.string(from: convertedDate) + " " + "мин назад"
        }
    }
}
