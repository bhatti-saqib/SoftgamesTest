

import Foundation

class Helper: NSObject {
    
    class func calcAge(_ birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        let now = NSDate()
        let calcAge = calendar?.components(.year, from: birthdayDate!, to: now as Date, options: [])
        let age = calcAge?.year ?? 0
        
        return age
    }
}
