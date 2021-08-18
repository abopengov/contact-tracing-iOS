import Foundation

extension Date {
    func todayWithTime() -> Date? {
        let calendar = Calendar.current
        let selfComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        var currentDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        currentDateComponents.hour = selfComponents.hour
        currentDateComponents.minute = selfComponents.minute
        currentDateComponents.second = 0
        return calendar.date(from: currentDateComponents)
    }

    func setTime(hour: Int, minute: Int) -> Date? {
        let calendar = Calendar.current
        var currentDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        currentDateComponents.hour = hour
        currentDateComponents.minute = minute
        currentDateComponents.second = 0
        return calendar.date(from: currentDateComponents)
    }

    func withinTimePeriod(startTime: Date, endTime: Date) -> Bool {
        guard let startTime = startTime.todayWithTime(), let endTime = endTime.todayWithTime() else {
            return false
        }

        if startTime < endTime {
            return startTime <= self && endTime > self
        } else {
            return startTime <= self || endTime > self
        }
    }

    var nextTime: Date? {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: self)
        return Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)
    }

    func getHourMinuteString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }

    func getDayMonthYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}
