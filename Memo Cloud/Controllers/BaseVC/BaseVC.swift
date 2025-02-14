//
//  BaseVC.swift
//  MemoCloud
//
//  Created by Rizwan Shah on 26/09/2024.
//

import UIKit
import Loaf
import AudioToolbox
import AVFoundation


struct MenuOpt: Codable {
    let id: String
    let name: String
    let image: String
    let description: String
}

enum ConfigType {
    case categories
}

enum ListType {
    case gallry
    case list
    case text
    
}

class BaseVC: UIViewController {

    static let shared = BaseVC()
    var window: UIWindow?
    
    var downloadBottom: NSLayoutConstraint?
    var page = 1
    var perPage = 20
    var isLoadingMore = false
    
    
    var observerBtn: UIButton!
    var audioPlayer: AVAudioPlayer?
    
    var categories : [Categories] = AppUserDefaults.shared.retrieveCategoriesData() ?? []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideNavigationBar()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func getAppVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    
    
    func keyboardObserver(sender: UIButton){
        
        
        self.observerBtn = sender
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Move button above the keyboard when it appears
        @objc private func keyboardWillShow(_ notification: Notification) {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            let keyboardHeight = keyboardFrame.height

            UIView.animate(withDuration: 0.3) {
                self.observerBtn.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 200) // Adjust the value for spacing if needed
            }
        }
        
        // Move button back to its original position when keyboard hides
        @objc private func keyboardWillHide(_ notification: Notification) {
            UIView.animate(withDuration: 0.3) {
                self.observerBtn.transform = .identity
            }
        }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
    }
    
    func showMessage(title: String, state: Loaf.State){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            Loaf(title,state: state,location: .top,
                 presentingDirection: .vertical,
                 dismissingDirection: .vertical,
                 sender: self).show(.short)
            
        }
        
    }
    
    func fourcefullLogout(viewController: UIViewController, message: String){
        
        
        self.showAlert(on: viewController, message: message) {
                AppUserDefaults.shared.clearAllUserData()
//                SceneDelegate.sharedInstance.pushToLoginRoot(isAnimate: false)
            }
        
                
    }
    
    
    func showAlert(on viewController: UIViewController, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okayAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func dismissMessage(){
        
        Loaf.dismiss(sender: self)
    }
    
    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func dismissKeyboard() {
            // Dismiss the keyboard
            view.endEditing(true)
        }
        
    
    
    func buttonPressAnimation(sender: UIButton) {
        sender.addShadow(radius: 10, offset: CGSize(width: 5, height: 5))
        sender.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        sender.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
            // Scale down the button slightly when pressed
            UIView.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            })
        
        self.vibrate()
        
        }

    @objc func buttonReleased(_ sender: UIButton) {
        // Restore the button to its original size when released
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform.identity
        })
    }
    
    func vibrate() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    
    func greetingBasedOnTime() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())

        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        case 17..<21:
            return "Good evening"
        default:
            return "Good night"
        }
    }
    
    func getJapanDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM hh:mm a"
        
        // Set the time zone to Japan Standard Time (JST)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        // Get the current date and time
        let japanDate = dateFormatter.string(from: Date())
        return japanDate
    }
    
    func formatTotal(total: Int?) -> String {
        guard let total = total else {
            return "N/A" // or handle the nil case as needed
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        
        return numberFormatter.string(from: NSNumber(value: total)) ?? "\(total)"
    }

    func playScreenshotCaptureSound() {
        // Screenshot capture sound system sound ID
        let soundID: SystemSoundID = 1108
        AudioServicesPlaySystemSound(soundID)
    }
    
    func loadImage(from url: URL, into imageView: UIImageView) {
        // Asynchronously load the image
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
    
    
    func encodeReceiptsToJSON(ids: [Int]) -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601 // Format dates in ISO 8601 format (adjust as needed)
        do {
            let jsonData = try encoder.encode(ids)
            return jsonData
        } catch {
            print("Failed to encode receipts: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    
    
}

//MARK: API
extension BaseVC {
    
    
    
}


    
    

