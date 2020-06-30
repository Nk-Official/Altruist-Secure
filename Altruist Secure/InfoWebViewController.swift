//
//  InfoWebViewController.swift
//  DosaApp
//
//  Created by Namrata Khanduri on 15/01/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import UIKit
import WebKit

class InfoWebViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var webView : WKWebView!
    
    //MARK: - IBACTION
    @IBAction func backbtn(_ sender : UIButton){
    }
    
    //MARK: - VARIABLE
    var urlString: String = "https://www.google.com"
    //MARK: - OVERRIDE
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        openUrlOnWebView()
        webView.addObserver(self, forKeyPath: "URL", options: [.new, .old], context: nil)

    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] as? Int, let oldValue = change?[.oldKey] as? Int, newValue != oldValue {
            //Value Changed
            print("cehguhdfh",change?[.newKey])
        }else{
            //Value not Changed
            print("dsfkhkhdfh",change?[.oldKey])
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //MARK: - CONFIGURE VIEWS
    func openUrlOnWebView(){
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func setUI(){
        webView.navigationDelegate = self
    }
}
//MARK: - WKNavigationDelegate
extension InfoWebViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("dfgsjjdhjhj",webView.url)
        if let url = navigationAction.request.url{
            print("absoulte str", url,url.baseURL?.absoluteString)
                
        }
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
}
