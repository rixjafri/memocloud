//
//  AppUserDefaults.swift
//  MemoCloud
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
        case user
        case category
        
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
    
    
    
    
    
    
    func saveUserData(user: User) {
        let userDefaults = UserDefaults.standard
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            userDefaults.set(data, forKey: DefaultKeys.user.rawValue)
        } catch {
            print("Error saving user data: \(error)")
        }
    }
    
    func retrieveUserData() -> User? {
        let userDefaults = UserDefaults.standard
        
        guard let data = userDefaults.data(forKey: DefaultKeys.user.rawValue) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let userData = try decoder.decode(User.self, from: data)
            return userData
        } catch {
            print("Error retrieving user data: \(error)")
            return nil
        }
    }
    
    func removeUserData() {
        defaults.removeObject(forKey: DefaultKeys.user.rawValue)
    }
    
    
    func saveCategoriesData(categories: [Categories]) {
        let userDefaults = UserDefaults.standard
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(categories)
            userDefaults.set(data, forKey: DefaultKeys.category.rawValue)
        } catch {
            print("Error saving countries data: \(error)")
        }
    }

    func retrieveCategoriesData() -> [Categories]? {
        let userDefaults = UserDefaults.standard
        
        guard let data = userDefaults.data(forKey: DefaultKeys.category.rawValue) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let categories = try decoder.decode([Categories].self, from: data)
            return categories
        } catch {
            print("Error retrieving countries data: \(error)")
            return nil
        }
    }

    func removeCategoriesData() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: DefaultKeys.category.rawValue)
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
        defaults.removeObject(forKey: DefaultKeys.user.rawValue)
        defaults.removeObject(forKey: DefaultKeys.userToken.rawValue)
    }
    
    
    func clearAllUserData() {
        
        defaults.removeObject(forKey: DefaultKeys.isLoggedIn.rawValue)
        defaults.removeObject(forKey: DefaultKeys.user.rawValue)
        defaults.removeObject(forKey: DefaultKeys.userToken.rawValue)
    }
}
