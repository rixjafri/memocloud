//
//  AppUserDefaults.swift
//  JJSystems
//
//  Created by Rizwan Shah on 26/09/2024.
//

import Foundation


class AppUserDefaults {
    
    // Singleton instance for global access
    static let shared = AppUserDefaults()
    private let defaults = UserDefaults.standard

    private init() {}  // Prevents instantiation outside this class

    
    // MARK: - Keys
    public enum DefaultKeys: String {
        case isLoggedIn
        case isRememberMe
        case userToken
        case userData
        
    }

    
    func setLoggedIn(_ loggedIn: Bool) {
        defaults.set(loggedIn, forKey: DefaultKeys.isLoggedIn.rawValue)
        
        
    }
    
    func isLoggedIn() -> Bool {
        return defaults.bool(forKey: DefaultKeys.isLoggedIn.rawValue)
    }
    
    func removeisLoggedIn() {
        defaults.removeObject(forKey: DefaultKeys.isLoggedIn.rawValue)
    }
    
    
    
    
    
    
    func saveUserData(userData: UserData) {
        let userDefaults = UserDefaults.standard
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userData)
            userDefaults.set(data, forKey: DefaultKeys.userData.rawValue)
        } catch {
            print("Error saving user data: \(error)")
        }
    }
    
    func retrieveUserData() -> UserData? {
        let userDefaults = UserDefaults.standard
        
        guard let data = userDefaults.data(forKey: DefaultKeys.userData.rawValue) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let userData = try decoder.decode(UserData.self, from: data)
            return userData
        } catch {
            print("Error retrieving user data: \(error)")
            return nil
        }
    }
    
    func removeUserData() {
        defaults.removeObject(forKey: DefaultKeys.userData.rawValue)
    }
    
    
    func updateDefaultCountryId(newCountryId: Int) {
        // Retrieve existing UserData
        guard var userData = AppUserDefaults.shared.retrieveUserData() else {
            print("No user data found.")
            return
        }
        
        // Update the defaultCountryId
        userData.user.defaultCountryId = newCountryId
        
        // Save the updated UserData back to UserDefaults
        AppUserDefaults.shared.saveUserData(userData: userData)
        
        print("Updated default country ID to \(newCountryId)")
    }
    
    func setUserToken(_ userToken: String) {
        defaults.set(userToken, forKey: DefaultKeys.userToken.rawValue)
        
        
    }
    
    func userToken() -> String {
        return defaults.string(forKey: DefaultKeys.userToken.rawValue) ?? ""
    }
    
    
    func removeuserToken() {
        defaults.removeObject(forKey: DefaultKeys.userToken.rawValue)
    }
    
    
    
    
    func clearAllData() {
        
        defaults.removeObject(forKey: DefaultKeys.isLoggedIn.rawValue)
        defaults.removeObject(forKey: DefaultKeys.isRememberMe.rawValue)
        defaults.removeObject(forKey: DefaultKeys.userData.rawValue)
        defaults.removeObject(forKey: DefaultKeys.userToken.rawValue)
    }
    
    
    func clearAllUserData() {
        
        defaults.removeObject(forKey: DefaultKeys.isLoggedIn.rawValue)
        defaults.removeObject(forKey: DefaultKeys.userData.rawValue)
        defaults.removeObject(forKey: DefaultKeys.userToken.rawValue)
    }
}
