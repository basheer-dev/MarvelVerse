//
//  WebVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 10/07/2023.
//

import UIKit
import WebKit


final class WebVC: UIViewController {
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.isHidden = true
        
        return view
    }()
    
    private let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.progressTintColor = .systemRed
        
        return view
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    func set(urlString: String) {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = Float(webView.estimatedProgress)
            progressView.progress = progress
            
            if progress > 0.75 {
                webView.isHidden = false
                progressView.isHidden = true
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(webView)
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
}
