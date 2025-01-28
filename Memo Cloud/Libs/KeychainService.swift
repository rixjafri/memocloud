//
//  KeychainService.swift
//  JJSystems
//
//  Created by Rizwan Shah on 22/10/2024.
//

import Foundation
import KeychainAccess


class KeychainService {
    private let keychain: Keychain

    // Initialize with a unique service identifier
    init(service: String) {
        keychain = Keychain(service: service)
    }

    // Save credentials
    func saveCredentials(username: String, password: String) {
        do {
            try keychain.set(username, key: "username")
            try keychain.set(password, key: "password")
            print("Credentials saved successfully!")
        } catch {
            print("Error saving credentials: \(error)")
        }
    }

    // Retrieve credentials
    func getCredentials() -> (username: String?, password: String?) {
        do {
            let username = try keychain.get("username")
            let password = try keychain.get("password")
            return (username, password)
        } catch {
            print("Error retrieving credentials: \(error)")
            return (nil, nil)
        }
    }

    // Delete credentials
    func deleteCredentials() {
        do {
            try keychain.remove("username")
            try keychain.remove("password")
            print("Credentials deleted successfully!")
        } catch {
            print("Error deleting credentials: \(error)")
        }
    }
    
    func getDeviceId() -> String {
            let deviceIdKey = "deviceId"

            do {
                // Try to retrieve the existing device ID from Keychain
                if let existingId = try keychain.get(deviceIdKey) {
                    return existingId
                }

                // Generate a new UUID if no ID exists
                let newId = UUID().uuidString
                try keychain.set(newId, key: deviceIdKey)
                return newId

            } catch {
                print("Error retrieving or saving device ID: \(error)")
                // Fallback to a temporary UUID in case of an error
                return UUID().uuidString
            }
        }

        // Delete the device ID (Optional, for reset purposes)
        func deleteDeviceId() {
            do {
                try keychain.remove("deviceId")
                print("Device ID deleted successfully!")
            } catch {
                print("Error deleting device ID: \(error)")
            }
        }
    
    
}
