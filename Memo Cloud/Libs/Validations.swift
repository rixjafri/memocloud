//
//  Validations.swift
//  MemoCloud
//
//  Created by Rizwan Shah on 22/10/2024.
//

import Foundation

// Function to validate name
func validateName(_ name: String) -> Bool {
    // Check if the password is not empty and meets the regex criteria
    guard !name.isEmpty else {
        return false
    }

    
    return true
}

// Function to validate username
func validateEmail(_ email: String) -> Bool {
    guard !email.isEmpty else {
        return false
    }
    
    let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    
    return emailPredicate.evaluate(with: email)
}

func validateEmpty(_ text: String) -> Bool {
    // Check if the password is not empty and meets the regex criteria
    guard !text.isEmpty else {
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
