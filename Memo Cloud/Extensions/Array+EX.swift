//
//  Array+EX.swift
//  VoipBussiness
//
//  Created by Muhammad Nouman on 12/07/2021.
//

import Foundation
extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
    func toJSONString() -> String? {
            if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
                return String(data: data, encoding: .utf8)
            }
            return nil
        }
}
