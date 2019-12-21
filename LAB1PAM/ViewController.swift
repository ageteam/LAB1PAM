//
//  ViewController.swift
//  LAB1PAM
//
//  Created by Cristian Bularu on 12/18/19.
//  Copyright © 2019 Cristian Bularu. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet weak var InputField: UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InputField.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func Notify(_ sender: Any) {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        
        notificationCenter.getNotificationSettings { (settings) in
          if settings.authorizationStatus != .authorized {
            // Notifications not allowed
          }
        }
        
        let notificationContent = UNMutableNotificationContent()

        // Configure Notification Content
        notificationContent.title = InputField.text ?? "Empty input field"
        notificationContent.subtitle = "Received Nofif LAB1"
        notificationContent.body = "And this is the body where can be added more text than title or subtitle"

        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)

        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)

        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    @IBAction func Search(_ sender: Any) {
        let searchItem = InputField.text ?? ""
        let escapedString = searchItem.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print(escapedString!)
        if let url = URL(string: "https://www.google.com/search?q=" + (escapedString ?? "")) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func TakePhoto(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        photoImageView.image = image;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

