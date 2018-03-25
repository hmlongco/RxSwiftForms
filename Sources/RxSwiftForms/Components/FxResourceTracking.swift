//
//  FxResourceTracking.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/26/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

#if DEBUG

/// Debugging extension used to help insure no retain cycles are introduced into fields and forms.
public struct FxResourceTracking {

    public static var map = [Int:String]()
    public static var count: Int { return map.count }
    public static var details = false

    /// Show tracking status.
    public static func status() {
        let message = count == 0 ? "FXRT: Tracking zero resources" : "FXRT: Still tracking \(count) resources!"
        print(message)
        if details && count > 0 {
            print("FXRT: (\(map))")
        }
    }

    /// Tracks a new resource.
    public static func track(_ key: Int, _ value: String) {
        map[key] = value
        if details {
            print("FXRT: Tracking \(value.uppercased()) (\(count - 1))")
        }
    }

    /// Releases a resource.
    public static func release(_ key: Int) {
        if details {
            let value = map[key]?.uppercased()  ?? "UNKNOWN"
            print("FXRT: Released \(value) (\(count - 1))")
        }
        map.removeValue(forKey: key)
    }

}

#endif
