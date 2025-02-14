//
//  PreviewVC.swift
//  JJSystems
//
//  Created by Rizwan Shah on 15/11/2024.
//

import UIKit
import WebKit

class PreviewVC: BaseVC {

    
    
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var webView: WKWebView!
    
    @IBOutlet var screenTitle: UILabel!
    
    
    var url: String?
    var titleName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.buttonPressAnimation(sender: self.cancelBtn)
        self.screenTitle.text = self.titleName
        webView.isOpaque = false
        webView.navigationDelegate = self
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        
        if let url = URL(string: self.url ?? "") {
                    let request = URLRequest(url: url)
                    webView.load(request)
                }

        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.vibrate()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        self.view.aj_showDotLoadingIndicator()
        self.vibrate()
        
        
    }

}

extension PreviewVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started loading")
        self.view.aj_showDotLoadingIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
        self.view.aj_hideDotLoadingIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed loading: \(error.localizedDescription)")
        self.view.aj_hideDotLoadingIndicator()
    }
}
