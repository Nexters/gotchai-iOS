//
//  DateManager.swift
//  Common
//
//  Created by 가은 on 8/17/25.
//

import Foundation

public final class DateManager {
    public static let shared = DateManager()
    private let formatter: DateFormatter = {
        let format = DateFormatter()
        format.locale   = Locale(identifier: "en_US_POSIX")
        format.calendar = Calendar(identifier: .gregorian)
        format.timeZone = TimeZone(identifier: "Asia/Seoul")
        return format
    }()
    
    private init() { }
    
    public func parseISO(_ dateString: String) -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        let date = formatter.date(from: dateString) ?? Date()
        formatter.dateFormat = "M월 d일"
        
        return formatter.string(from: date)
    }
}
