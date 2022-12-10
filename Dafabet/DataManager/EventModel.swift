import UIKit

class EventModel: Hashable, Codable {
    let sport: String
    
    let eventTitle: String
        
    let homeTitle: String
    let homeOdd: String
    
    let awayTitle: String
    let awayOdd: String
    
    let dateString: String
    
    let timeString: String
        
    init(sport: String?,
         eventTitle: String?,
         homeTitle: String?,
         awayTitle: String?,
         dateString: String?,
         timeString: String?) {
        
        self.sport = sport ?? "Sport"
        self.eventTitle = eventTitle ?? "Home vs Away"
                
        self.homeTitle = homeTitle ?? "Home team"
        self.awayTitle = awayTitle ?? "Away team"
        
        let amount = Double.random(in: 1.1...1.9)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        self.homeOdd = formatter.string(from: amount as NSNumber) ?? "1.3"
        self.awayOdd = formatter.string(from: Double.random(in: 2.1...2.5) / amount as NSNumber) ?? "1.3"
        
        self.dateString = dateString ?? "2022-11-11"
        self.timeString = timeString ?? "13:25"
    }
    
    static func == (lhs: EventModel, rhs: EventModel) -> Bool {
        lhs.homeTitle == rhs.homeTitle &&
        lhs.awayTitle == rhs.awayTitle &&
        lhs.dateString == rhs.dateString
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
