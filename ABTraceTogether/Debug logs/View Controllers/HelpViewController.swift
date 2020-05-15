//
//  HelpViewController.swift
//  ABTraceTogether_AdHoc
//
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {
    
    let urlString = "https://www.yourPrivacyLink.com"
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        navigationController?.navigationBar.isHidden = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.bounces = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        webView.reload()
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    @objc
    func refreshWebView(_ sender: UIRefreshControl) {
        webView?.reload()
        sender.endRefreshing()
    }
}

extension HelpViewController: WKNavigationDelegate {
    
}
