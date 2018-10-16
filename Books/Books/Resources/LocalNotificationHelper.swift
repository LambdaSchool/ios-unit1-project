//
//  LocalNotificationHelper.swift
//  Memories
//
//  Created by Farhan on 9/5/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationHelper: NSObject, UNUserNotificationCenterDelegate{
    
    // This class will help facilitate the process of requesting notification authorization from the user, checking the authorization status, and actually creating a notification.
    
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    func stopNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if let error = error { NSLog("Error requesting authorization status for local notifications: \(error)") }
            
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func scheduleDailyReminderNotification(with bookName: String) {
        
        // Notification Setup
        let identifier = "DailyNotification"
        let content = UNMutableNotificationContent()
        content.title = "Time to read!"
        content.body = "Try to finish a chapter of \(bookName)!"
        
        // Setting up everyday at 8AM
        var date = DateComponents()
        date.hour = 8  // 8 AM
        date.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        //Add the notification request to the notification center for activation
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
}
