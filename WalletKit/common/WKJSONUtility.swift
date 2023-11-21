//
//  WKJSONUtility.swift
//  WalletKit
//
//

import Foundation

struct JSON {
    
    static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
       return formatter
   }()
    
    typealias Dict = [String:Any]

    let dict: Dict

    init (dict: Dict) {
        self.dict = dict
    }

    internal func asString (name: String) -> String? {
        return dict[name] as? String
    }

    internal func asBool (name: String) -> Bool? {
        return dict[name] as? Bool
    }

    internal func asInt64 (name: String) -> Int64? {
        return (dict[name] as? NSNumber)
            .flatMap { Int64 (exactly: $0)}
    }

    internal func asUInt64 (name: String) -> UInt64? {
        return (dict[name] as? NSNumber)
            .flatMap { UInt64 (exactly: $0)}
    }

    internal func asUInt32 (name: String) -> UInt32? {
        return (dict[name] as? NSNumber)
            .flatMap { UInt32 (exactly: $0)}
    }

    internal func asUInt8 (name: String) -> UInt8? {
        return (dict[name] as? NSNumber)
            .flatMap { UInt8 (exactly: $0)}
    }

    internal func asDate (name: String) -> Date? {
        return (dict[name] as? String)
            .flatMap { JSON.dateFormatter.date (from: $0) }
    }

    internal func asData (name: String) -> Data? {
        return (dict[name] as? String)
            .flatMap { Data (base64Encoded: $0)! }
    }

    internal func asArray (name: String) -> [Dict]? {
        return dict[name] as? [Dict]
    }

    internal func asDict (name: String) -> Dict? {
        return dict[name] as? Dict
    }

    internal func asStringArray (name: String) -> [String]? {
        return dict[name] as? [String]
    }

    internal func asJSON (name: String) -> JSON? {
        return asDict(name: name).map { JSON (dict: $0) }
    }
    
    static func deserializeAsJSON<T> (_ data: Data?) -> Result<T, SystemClientError> {
       guard let data = data else {
           return Result.failure (SystemClientError.noData);
       }

       do {
           guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? T
               else {
                   print ("SYS: BDB:API: ERROR: JSON.Dict: '\(data.map { String(format: "%c", $0) }.joined())'")
                   return Result.failure(SystemClientError.jsonParse(nil)) }

           return Result.success (json)
       }
       catch let jsonError as NSError {
           print ("SYS: BDB:API: ERROR: JSON.Error: '\(data.map { String(format: "%c", $0) }.joined())'")
           return Result.failure (SystemClientError.jsonParse (jsonError))
       }
   }
}

