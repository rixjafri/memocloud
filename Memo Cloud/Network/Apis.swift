//
//  AppContent.swift
//  Quick Tire
//
//  Created by Rizwan Shah on 19/09/2024.
//

import Moya
import Foundation

enum Apis {
    case login(params: [String : Any])
    case signup(params: [String : Any])
    case updatePassword(params: [String : Any])
    case logout(params: [String : Any])
    case addContent(params: [String : Any])
    case getContent(params: [String : Any])
    case getCategories
    
    
}


extension Apis: TargetType {
    
    
    var baseURL: URL {
            return URL(string: "https://memocloud.software-compilers.com/api/")!
    }
    
    
    

    var path: String {
        switch self {
        case .login:
            return "login"
        case .signup:
            return "signup"
        case .updatePassword:
            return "changePassword"
        case .logout:
            return "logout"
        case .addContent:
            return "addContent"
        case .getContent:
            return "getContent"
        case .getCategories:
            return "getCategories"
        
        }
    }

    var method: Moya.Method {
        
        switch self {
        case .login, .signup, .updatePassword, .logout, .addContent, .getContent:
            return .post
        case .getCategories:
            return .get
        }
        
        
    }

    var task: Task {
        switch self {
        case .login(let params), .updatePassword(params: let params), .signup(let params), .logout(let params), .addContent(let params), .getContent(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getCategories:
            return .requestPlain
    
        }
    }

    

    var headers: [String: String]? {
           
        return ["Authorization": "Bearer \(AppUserDefaults.shared.userToken())", "Content-Type": "application/json"]
        
       
        
    }
    
}
