//
//  Extensions.swift
//  iListen
//
//  Created by 林祐正 on 2021/4/15.
//  Copyright © 2021 SmartFun. All rights reserved.
//

import Foundation

extension String {
    func toEntity<T: Decodable>(to type: T.Type) -> T? {
        let jsonData = Data(self.utf8)
        let decoder = JSONDecoder()
        do {
            let entity = try decoder.decode(type, from: jsonData)
            return entity
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    func toArrayOrDictionary<T>(to type: T.Type) -> T? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? T
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
protocol Convertable: Codable {
}
extension Convertable {
    func toDictionary() -> Dictionary<String, Any>? {
        var dict: Dictionary<String, Any>? = nil
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            dict =
                try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
        } catch {
            print(error)
        }
        
        return dict
    }
    func toJson() -> String {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString ?? ""
        } catch {
            debugPrint(error)
        }
        return ""
    }
}

public protocol JSONEmptyRepresentable {
  associatedtype CodingKeyType: CodingKey
}

extension KeyedDecodingContainer {
  public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable & JSONEmptyRepresentable {
    if contains(key) {
      let container = try nestedContainer(keyedBy: type.CodingKeyType.self,
                                          forKey: key)
      if container.allKeys.isEmpty {
        return nil
      }
    } else {
      return nil
    }
    return try decode(T.self, forKey: key)
  }
}

//func beEntityToJson<T: Codable>(
//    from entity: T,
//    _ complete: @escaping (String) -> Void){
//    DispatchQueue.global().async {
//        do {
//            let jsonData = try JSONEncoder().encode(entity)
//            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
//            complete(jsonString)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//}
