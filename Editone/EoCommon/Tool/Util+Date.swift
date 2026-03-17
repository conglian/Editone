//
//  Util+Date.swift
//
//

import Foundation

extension Util {
    
    /// 时间戳转时间
    class func timeIntervalToString(timeInterval: TimeInterval, format: String = "yyyy-MM-dd HH:mm") -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    /// 当前时间前year年的时间
    class func dateBeforeNow(year: Int) -> Date {
        let currentDate = Date()
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: 0, day: 0)
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        return minDate!
    }
    
    /// dateComponent转时间
    class func dateComponentsToString(dateComponent: DateComponents, format: String) -> String {
        let date = Calendar.current.date(from: dateComponent) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let string = formatter.string(from: date)
        return string
    }
    
    /// 时间转换，秒->时分秒
    class func getMMSSFromSS(seconds: Int) -> String{
        if seconds <= 0 {
            return "00:00:00"
        }
        ///format hour
        let hour = String(format: "%02ld", seconds/3600)
        ///format minute
        let minute = String(format: "%02ld", (seconds%3600)/60)
        ///format second
        let second = String(format: "%02ld", seconds%60)
        return "\(hour):\(minute):\(second)"
    }
    
    /// 时间转字符串
    class func dateToString(date: Date = Date(), format: String = "MMdd")-> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    /// 时间转字符串
    class func dateinstallToString(date: Date, format: String = "yyyy-MM-dd")-> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    /// 字符串转date
    class func stringToDate(string: String, format: String = "yyyy-MM-dd HH:mm") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: string)
        return date ?? Date()
    }
    
    /// 时间格式化，比如 70秒，转换成00:01:10
    class func formatTime(_ value: Int) -> String {
        let seconds = value % 60
        let minutes = (value / 60) % 60
        let hours = value / 3600
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// 传入秒数，返回分钟，不满1分钟算1分钟
    class func convertToMinutes(_ seconds: Int) -> Int {
        let roundingUp = (seconds + 59) / 60
        return max(roundingUp, 1)
    }
    
    /// 判断两个日期是否为同一天
    class func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        return components1.year == components2.year && components1.month == components2.month && components1.day == components2.day
    }
    
    /// 判断时间是否在数组内
    class func isSameDay(dateArray: [Date], dateToCheck: Date) -> Bool {
        for date in dateArray {
            if Util.isSameDay(date1: date, date2: dateToCheck) {
                return true
            }
        }
        return false
    }
    
    /// 传入一个时间，计算出月初和月末时间
    class func getStartAndEndOfMonth(for date: Date) -> (start: String, end: String) {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: date)))!
        //获取月初时间
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        //获取月末时间
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let startString = formatter.string(from: startOfMonth)
        let endString = formatter.string(from: endOfMonth)
        return (startString, endString)
    }
    
    /// 判断日期是否为今天之后的日期
    class func isAfterToday(for date: Date) -> Bool {
//        print(date)
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let otherDay = calendar.startOfDay(for: date)
//        print(today)
//        print(otherDay)
        return today < otherDay
    }
    
    /// 判断今天是否是过去某个时间增加n天后的日期
    class func isDateBeyond(_ pastDate: Date, addingDays days: Int) -> Bool {
        // 根据过去日期组成的 DateComponents 创建一个新的 Date，并加上指定的天数
        guard let futureDate = Calendar.current.date(byAdding: .day, value: days == 0 ? 0 : days + 1, to: Calendar.current.startOfDay(for: pastDate)) else { return false }
        // 比较当前日期是否大于未来日期
        if Calendar.current.startOfDay(for: Date()) >= futureDate {
            return true
        } else {
            return false
        }
    }
    
    /// 传入一个时间，小时，判断是否是多少小时之前的时间
    class func wasLoadTimeLessThanNHoursAgo(hour: Int, time: Date) -> Bool {
        let date = Date()
        let timeIntervalBetweenNowAndLoadTime = date.timeIntervalSince(time)
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour;
        return intervalInHours < Double(hour)
    }
    
    /// 传入一个时间，分钟，判断是否是多少分钟之前的时间
    class func wasLoadTimeLessThanNminutesAgo(miu: Int, time: Date) -> Bool {
        let date = Date()
        let timeIntervalBetweenNowAndLoadTime = date.timeIntervalSince(time)
        return timeIntervalBetweenNowAndLoadTime < Double(miu * 60)
    }
    
    /// 传入一个时间，计算年龄
    class func calculateAge(birthDate: Date) -> Int {
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        let age = ageComponents.year ?? 0
        
        return age
    }
    
    /// 格式化时间
    /// - Parameter milliseconds: 毫秒
    /// - Returns: 字符串
    class func formatMilliseconds(_ milliseconds: Int64) -> String {
        let millisecsPerSec: Int64 = 1000
        let secsPerMin: Int64 = 60
        let minsPerHr: Int64 = 60
        let hoursPerDay: Int64 = 24
        
        var secs = milliseconds / millisecsPerSec
        var mins = secs / secsPerMin
        var hrs = mins / minsPerHr
        
        secs = secs % secsPerMin
        mins = mins % minsPerHr
        hrs = hrs % hoursPerDay
        
        if hrs >= 1 {
            return String(format: "%ld hr %02ld min %02ld sec", hrs, mins, secs)
        } else if mins >= 1 {
            return String(format: "%ld min %02ld sec", mins, secs)
        } else {
            return String(format: "%ld sec", secs)
        }
    }
    
}
extension Date {
    // 转换为当前时区时间
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone    = TimeZone.current
        let seconds     = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
extension String {
    // 根据时间字符串返回周几
    func featureWeekday() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let formatDate = dateFormatter.date(from: self) else { return 1 }
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: formatDate)
        switch weekDay {
        case 1:
            return 7
        case 2:
            return 1
        case 3:
            return 2
        case 4:
            return 3
        case 5:
            return 4
        case 6:
            return 5
        case 7:
            return 6
        default:
            return 1
        }
    }
}
