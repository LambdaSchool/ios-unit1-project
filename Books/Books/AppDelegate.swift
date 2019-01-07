
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

       var window: UIWindow?
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
  
    // MARK: - URL Handling
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GoogleBooksAuthorizationClient.shared.resumeAuthorizationFlow(with: url)
    }
}

