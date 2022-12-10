import UIKit
import WebKit

class WebViewController: BaseVC {
    
    private var webView: WKWebView!
    
    let url: URL?
    
    var prefersNavBarHidden = true
    
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        view.backgroundColor = .white
        
        guard let url = url else {
            return
        }
        
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.load(URLRequest(url: url))
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = prefersNavBarHidden

    }
}
