import UIKit

class SearchTableViewHeaderButton: UIButton {
    
    var isOpen: Bool = false {
        didSet {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 28)
            let image = UIImage(systemName: isOpen ? "chevron.up" : "chevron.down",
                                withConfiguration: imageConfig)
            setImage(image, for: .normal)
        }
    }
    
}
