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
    case tokenRights(params: [String : Any])
    case verifyOtp(params: [String : Any])
    case verifyOtpForgotPassword(params: [String : Any])
    case forgotPassword(params: [String : Any])
    case resetForgotPassword(params: [String : Any])
    case updatePassword(params: [String : Any])
    case carList(params: [String : Any])
    case favoriteCarList(params: [String : Any])
    case saleReport(params: [String : Any])
    case purchaseReport(params: [String : Any])
    case ttSummaryReport(params: [String : Any])
    case ttListReport(params: [String : Any])
    case carDetail(params: [String : Any])
    case addFavouriteCar(params: [String : Any])
    case deleteFavouriteCar(params: [String : Any])
    case updateDefaultCountry(params: [String : Any])
    case fetchManufacturingYear(params: [String : Any])
    case fetchPurchaseList(params: [String : Any])
    case fetchBiddingList(params: [String : Any])
    case makeModelChassis(params: [String : Any])
    case bodyType(params: [String : Any])
    case minMaxYearRange(params: [String : Any])
    case vehicleAttributes(params: [String : Any])
    case logout
    case country
    case configuration
    case getCurrentVersion
    
    
}


extension Apis: TargetType {
    
    
    var baseURL: URL {
            switch self {
            case .getCurrentVersion:
                return URL(string: "https://appho.st/api")! // Custom base URL for this specific API
            default:
                return URL(string: "https://jjbackups.com/api")! // Default base URL for other APIs
            }
        }
    
    
    var token: String {
        // The base URL
        return "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZjUzYjA0NTAyZmRiYThiNjgxNDA1OGRiODZiM2JlYjc4NWY1ZTI5ZjMzYmQ2MTE5ZDNlYTNhNTc1YmRkMzcxZGM3YjY2NGFhNDdhNDllN2YiLCJpYXQiOjE2ODQzODkzNjkuMTM4MzA0LCJuYmYiOjE2ODQzODkzNjkuMTM4MzEzLCJleHAiOjE2ODYxMTczNjkuMDc0MjQ0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.QYJXQ99ZzWpDhM0tSJTHoVLsGtitnGUCXyrqljm6KC5DJnJEmT0sq6XOWNYwdZjopwz2rRKYK3IoVesNIPNfDDIk6O6aNCRwchofkVFzzPUGOiVtOHBgyQYRN_OIUQ-dBsGp6MGtPSp9t0ILgNdhpw1ykB22NLHWkHlpFJ-2BVrvx70HnJKOyI2OhYTeoNXbfDMzNUyUrZ_c91NRDyCIVZ0bufriw41NhEBkRiWY97i--wazVJF2Qdghx5Ybj5D5dWsdbeGbvy8fbpAX0tXgPCu2znm2yRn8eQc63UfGh_nLViTxtdfp2rjJCQhaiP8H4H0QQAplGJMKB0D97x2LU2R6AJudByWG1mIl4fUXn7s55lM5OI_1fhH2TbGB2bJHKMHi3zJHdANNTUQpBx5lWwvOISExbaF924c7gvjqMWmRlRIkVouaodBfzsjtPy23pReF4B12ZqQBcIDE8t6c92UJ6wOoLHAjUdPdvEP6ju2AZ-MUUidCLl1lBvZucAEUKeBDtySNWvImiM2GG3zr8s3PHrBdT2BUVjazJBN2sfzumNvQP9Fiz8usTVCRpGdBiX0yTOcG0dlhsBd-drN-aVdm9ZsY25KK06nNa92s_76aGU9HIXlpCt7kQnqQj6jw9rVHHeVaOAbOZ05GPo7xN2q5EwQTcxUrVQIubfzQLXg"
    }

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .verifyOtp:
            return "/verifyOtp"
        case .forgotPassword:
            return "/forgotPassword"
        case .verifyOtpForgotPassword:
            return "/optValidateForgotPassword"
        case .resetForgotPassword:
            return "/resetForgotPassword"
        case .logout:
            return "/logout"
        case .carList:
            return "/carList"
        case .carDetail:
            return "/carDetail"
        case .country:
            return "/country"
        case .configuration:
            return "/configuration"
        case .updateDefaultCountry:
            return "/updateDefaultCountry"
        case .fetchManufacturingYear:
            return "/fetchManufacturingYear"
        case .fetchPurchaseList:
            return "/fetchPurchaseList"
        case .favoriteCarList:
            return "/favoriteCarList"
        case .makeModelChassis:
            return "/makeModel"
        case .getCurrentVersion:
            return "/get_current_version/"
        case .bodyType:
            return "/bodyType"
        case .minMaxYearRange:
            return "/fetchMaxMinYear"
        case .vehicleAttributes:
            return "/fetchSteeringTransFuel"
        case .fetchBiddingList:
            return "/fetchBiddingList"
        case .saleReport:
            return "/fetchSaleReservationDeliveredReport"
        case .purchaseReport:
            return "/fetchMukechiPurchaseReport"
        case .addFavouriteCar:
            return "/addFavouriteCar"
        case .deleteFavouriteCar:
            return "/deleteFavouriteCar"
        case .updatePassword:
            return "/changePassword"
        case .tokenRights:
            return "/fetchTokenRights"
        case .ttSummaryReport:
            return "/tt_summary_report"
        case .ttListReport:
            return "/tt_listing_report"
            
            
            
        }
    }

    var method: Moya.Method {
        
        switch self {
        case .login, .verifyOtp, .forgotPassword, .verifyOtpForgotPassword, .resetForgotPassword, .updateDefaultCountry, .addFavouriteCar, .deleteFavouriteCar, .updatePassword, .ttSummaryReport, .ttListReport:
            return .post
        case .logout, .carList, .carDetail, .country, .configuration, .fetchManufacturingYear, .fetchPurchaseList, .favoriteCarList, .makeModelChassis, .getCurrentVersion, .bodyType, .minMaxYearRange, .vehicleAttributes, .fetchBiddingList, .saleReport, .purchaseReport, .tokenRights:
            return .get
        }
        
        
    }

    var task: Task {
        switch self {
        case .login(let params), .verifyOtp(let params), .forgotPassword(let params), .verifyOtpForgotPassword(params: let params), .resetForgotPassword(params: let params), .updatePassword(params: let params), .addFavouriteCar(params: let params), .deleteFavouriteCar(params: let params), .updateDefaultCountry(params: let params), .ttSummaryReport(params: let params), .ttListReport(params: let params):
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .logout, .country, .configuration, .tokenRights:
            return .requestPlain
        case .fetchManufacturingYear(let params), .fetchPurchaseList(let params):
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .makeModelChassis(let params), .carList(let params), .carDetail(let params), .bodyType(let params), .minMaxYearRange(let params), .vehicleAttributes(let params), .fetchBiddingList(let params), .saleReport(let params), .purchaseReport(let params), .favoriteCarList(let params):
            // Convert the `params` dictionary to query parameters
            var queryParams: [String: String] = [:]
            
            for (key, value) in params {
                if let array = value as? [Int] {
                    // Convert array to a comma-separated string
                    queryParams[key] = array.map { String($0) }.joined(separator: ",")
                } else if let stringValue = value as? String {
                    queryParams[key] = stringValue
                } else if let intValue = value as? Int {
                    queryParams[key] = String(intValue)
                }
            }

            // Log queryParams for debugging
            print("Constructed Query Params: \(queryParams)")
            
            // Use URLEncoding.queryString for the request
            return .requestParameters(parameters: queryParams, encoding: URLEncoding.queryString)
        case .getCurrentVersion:
                    // Pass query parameters
                    let parameters: [String: String] = [
                        "u": "OioCKLiaR9SzDpTk4t3jk6NO2au1",
                        "a": "FitJba1l8nT7nnH7Weee",
                        "platform": "ios"
                    ]
                    return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    

    var headers: [String: String]? {
           
        switch self {
        case .getCurrentVersion:
            return ["Content-Type": "application/json"]
        default:
            
            
            
            
            return ["token": "\(token)", "Content-Type": "application/json"]
        }
        
        
        
        }
    
}
