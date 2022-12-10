import UIKit

class SearchTableViewBetButton: UIButton {
    
    var betTeam: Team!
    
    func setGradiet() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [
            UIColor.dafaRed.cgColor,
            UIColor.dafaDarkRed.cgColor
        ]
        
        layer.insertSublayer(gradient, at: 0)
    }
    
}
