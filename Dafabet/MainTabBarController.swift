import UIKit

class MainTabBarController: BaseTabBarController {
    
    private(set) lazy var mainViewController: MainViewController = {
        let mainVC = MainViewController()
        mainVC.tabBarItem.title = "Matches"
        mainVC.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle.fill")
        return mainVC
    }()
    
    private(set) lazy var savedViewController: SavedMatchesViewController = {
        let savedVC = SavedMatchesViewController()
        savedVC.tabBarItem.title = "Your bets"
        savedVC.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle.fill")
        return savedVC
    }()
    
    private(set) lazy var newsViewController: WebViewController = {
        let url = URL(string: "https://www.espncricinfo.com/latest-cricket-news")
        let newsVC = WebViewController(url: url)
        newsVC.tabBarItem.title = "News"
        newsVC.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle.fill")
        return newsVC
    }()
    
    private(set) lazy var settingsViewController: SettingsViewController = {
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem.title = "Settings"
        settingsVC.tabBarItem.image = UIImage(systemName: "slider.horizontal.3")
        return settingsVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            mainViewController,
            BaseNC(rootViewController: savedViewController),
            BaseNC(rootViewController: newsViewController),
            BaseNC(rootViewController: settingsViewController)
        ]
        
        setupAppearace()
    }

    
    private func setupAppearace() {
        tabBar.barStyle = .black
        tabBar.backgroundColor = .dafaDarkRed
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.itemSpacing = tabBar.bounds.width / 8
        tabBar.itemWidth = tabBar.bounds.width / 5
        tabBar.itemPositioning = .centered
    }
}
