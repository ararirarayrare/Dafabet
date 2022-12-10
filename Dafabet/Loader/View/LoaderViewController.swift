import UIKit

class LoaderViewController: BaseVC {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: view.bounds.width * 0.35,
                                      height: view.bounds.width * 0.35)
        imageView.center = view.center
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var isAnimatingClockwise: Bool = true {
        didSet {
            animate(clockwise: isAnimatingClockwise)
        }
    }
    
    private lazy var loadShapeLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        let radius = logoImageView.bounds.width / 2 + 8
        shape.path = UIBezierPath(arcCenter: CGPoint(x: radius - 8, y: radius - 8),
                                  radius: radius,
                                  startAngle: 0,
                                  endAngle: 2 * .pi,
                                  clockwise: self.isAnimatingClockwise).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.dafaYellow.cgColor
        shape.lineWidth = 4.0
        return shape
    }()
    
    var viewModel: LoaderViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .dafaRed
        
        view.addSubview(logoImageView)
        logoImageView.layer.addSublayer(loadShapeLayer)
        
        viewModel.getMainViewModel { [weak self] mainViewModel, error in
            guard let mainViewModel = mainViewModel,  error == nil else {
                return
            }
            
            let mainTabBar = MainTabBarController()
            mainTabBar.mainViewController.viewModel = mainViewModel
            mainTabBar.savedViewController.viewModel = self?.viewModel.getSavedMatchesViewModel()
            mainTabBar.settingsViewController.viewModel = self?.viewModel.getSettingsViewModel()
                        
            (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = mainTabBar
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.isAnimatingClockwise = true
    }
    
    private func animate(clockwise: Bool) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fromValue = clockwise ? 0 : 1
        animation.toValue = clockwise ? 1 : 0
        animation.delegate = self
        animation.isRemovedOnCompletion = true
        
        loadShapeLayer.strokeEnd = clockwise ? 1 : 0
        loadShapeLayer.add(animation, forKey: "clockwise-\(clockwise)")
        
        UIView.animate(withDuration: animation.duration - 0.2, delay: 0.2) { [weak self] in
            self?.logoImageView.alpha = clockwise ? 1 : 0
        }
    }
    
}

extension LoaderViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isAnimatingClockwise = !self.isAnimatingClockwise

        let radius = logoImageView.bounds.width / 2 + 8
        loadShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: radius - 8, y: radius - 8),
                                           radius: radius,
                                           startAngle: 0,
                                           endAngle: 2 * .pi,
                                           clockwise: self.isAnimatingClockwise).cgPath
    }
}
