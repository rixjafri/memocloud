//
//  Validations.swift
//  JJSystems
//
//  Created by Rizwan Shah on 22/10/2024.
//

import Foundation


// Function to validate username
func validateUsername(_ username: String) -> Bool {
    // Check if the username is not empty and meets the regex criteria
    guard !username.isEmpty else {
        return false
    }
    
    return true
}

// Function to validate password
func validatePassword(_ password: String) -> Bool {
    // Check if the password is not empty and meets the regex criteria
    guard !password.isEmpty else {
        return false
    }

    
    return true
}

// Function to validate username
func validateCode(_ code: String) -> Bool {
    // Check if the username is not empty and meets the regex criteria
    guard !code.isEmpty else {
        return false
    }
    
    return true
}
