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
    case updatePassword(params: [String : Any])
    case logout
    
    
}


extension Apis: TargetType {
    
    
    var baseURL: URL {
            return URL(string: "https://jjbackups.com/api")!
    }
    
    
    

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .updatePassword:
            return "/changePassword"
        case .logout:
            return "/logout"
        
        }
    }

    var method: Moya.Method {
        
        switch self {
        case .login, .updatePassword:
            return .post
        case .logout:
            return .get
        }
        
        
    }

    var task: Task {
        switch self {
        case .login(let params), .updatePassword(params: let params):
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .logout:
            return .requestPlain
        }
    }

    

    var headers: [String: String]? {
           
        return ["Content-Type": "application/json"]
        
        
    }
    
}
