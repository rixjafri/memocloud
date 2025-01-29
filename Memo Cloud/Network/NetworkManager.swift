//
//  NetworkManager.swift
//  Quick Tire
//
//  Created by Rizwan Shah on 19/09/2024.
//

import Moya
import Alamofire
import Foundation


enum NetworkError: Error {
    case timeout
    case noInternet
    case cannotConnect
    case decodingError
    case unauthorized
    case forbidden
    case serverError(Int)
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .timeout:
            return "The request timed out. Please try again later."
        case .noInternet:
            return "No internet connection. Please check your network settings."
        case .cannotConnect:
            return "Cannot connect to the server. Please try again later."
        case .decodingError:
            return "Failed to parse response from server."
        case .unknown(let message):
            return message
        case .unauthorized:
            return "Error: Unauthorized (401)"
        case .forbidden:
            return "Error: Forbidden (403)"
        case .serverError(_):
            return "Error: Server returned error"
        }
    }
}

struct RequestResponse<T: Codable>: Codable {
    let success: Bool
    let totalStock: Int?
    let data: T?
    let message: String
}






typealias SimpleResponse = RequestResponse<EmptyData>

struct EmptyData: Codable {}


class NetworkManager {
    static let shared = NetworkManager()
    
    private let provider: MoyaProvider<Apis>
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60 // Increase to 30 seconds
        configuration.timeoutIntervalForResource = 60 // Increase to 30 seconds
        
        let session = Session(configuration: configuration)
        provider = MoyaProvider<Apis>(session: session)
    }
    
    func call<T: Codable>(target: TargetType, completion: @escaping (Result<RequestResponse<T>, NetworkError>) -> Void) {
        provider.request(target as! Apis) { result in
            switch result {
            case .success(let response):
                print("Raw Response: \(String(data: response.data, encoding: .utf8) ?? "No Data")")
                
                // Check the status code
                let statusCode = response.statusCode
                guard 200..<300 ~= statusCode else {
                    switch statusCode {
                    case 401:
                        
                        if AppUserDefaults.shared.isLoggedIn() {
//                            AppUserDefaults.shared.clearAllUserData()
//                            SceneDelegate.sharedInstance.pushToLoginRoot(isAnimate: false)
                        }
                        
                        do {
                            
                            let detectionResponse = try JSONDecoder().decode(RequestResponse<T>.self, from: response.data)
                            completion(.success(detectionResponse))
                        } catch {
                            print("Decoding error: \(error)") // Optional: Log the error for debugging
                            completion(.failure(.decodingError))
                        }
                        
                        
                        
                    case 403:
                        
                        if AppUserDefaults.shared.isLoggedIn() {
                            AppUserDefaults.shared.clearAllUserData()
                            SceneDelegate.sharedInstance.pushToLoginRoot(isAnimate: false)
                        }
                        completion(.failure(.forbidden))
                    default:
                        completion(.failure(.serverError(statusCode)))
                    }
                    return
                }
                
                // If status code is valid, attempt to decode the response
                do {
                    
                    
                    let detectionResponse = try JSONDecoder().decode(RequestResponse<T>.self, from: response.data)
                    completion(.success(detectionResponse))
                } catch {
                    print("Decoding error: \(error)") // Optional: Log the error for debugging
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                let networkError: NetworkError
                print("Error: \(error.localizedDescription)")
                switch error {
                case .underlying(let nsError as NSError, _):
                    switch nsError.code {
                    case NSURLErrorTimedOut:
                        networkError = .timeout
                    case NSURLErrorNotConnectedToInternet:
                        networkError = .noInternet
                    case NSURLErrorCannotConnectToHost:
                        networkError = .cannotConnect
                    default:
                        networkError = .unknown("An unexpected error occurred: \(error.localizedDescription)")
                    }
                default:
                    networkError = .unknown("An unexpected error occurred: \(error.localizedDescription)")
                }
                completion(.failure(networkError))
            }
        }
    }
    
}
