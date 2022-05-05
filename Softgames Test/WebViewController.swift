

import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "sendToiOS")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        webView = WKWebView(frame: self.view.bounds, configuration: config)
        self.view.addSubview(self.webView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        webView.navigationDelegate = self
        
        if let indexURL = Bundle.main.url(forResource: "Form", withExtension: "html") {
            self.webView.loadFileURL(indexURL, allowingReadAccessTo: indexURL)
        }
    }
    
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(activityIndicator)
    }
    
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
    }
}



extension WebViewController : WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        var fullName = ""
        if let messageBody = message.body as? NSDictionary {
            let first_name = messageBody["firstName"] as! String
            let last_name = messageBody["lastName"] as! String
            fullName = first_name + " " + last_name
            
            self.webView.evaluateJavaScript("updateFullName('\(fullName)')") { (any, error) in
                print("Error : \(String(describing: error))")
            }
        }
        else {
            if let dob = message.body as? String {
                let age = Helper.calcAge(dob)
                
                showActivityIndicator(show: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.webView.evaluateJavaScript("updateAgeField('\(age)')") { [self] (any, error) in
                        print("Error : \(String(describing: error))")
                        showActivityIndicator(show: false)
                    }
                }
            }
        }
        
        if let msg = message.body as? Bool {
            if(msg == true) {
                triggerLocalNotification()
            }
        }
    }
}



extension WebViewController {
    
    func triggerLocalNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Solitaire smash"
        content.body = "Play again to smash your top score"
        content.sound = .default
        content.userInfo = ["value": "Data with local notification"]
        
        
        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(7))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
        //UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
        
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
    }
}
