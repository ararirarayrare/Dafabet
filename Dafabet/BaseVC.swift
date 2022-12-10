import UIKit

class BaseVC: UIViewController {
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

class BaseNC: UINavigationController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            .foregroundColor : UIColor.dafaDarkRed
        ]
        appearance.titleTextAttributes = [
            .foregroundColor : UIColor.dafaDarkRed
        ]
        appearance.backgroundColor = .white
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
                
        navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor.dafaDarkRed
        ]
        navigationBar.largeTitleTextAttributes = [
            .foregroundColor : UIColor.dafaDarkRed
        ]
        
    }
}

class BaseTabBarController: UITabBarController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

