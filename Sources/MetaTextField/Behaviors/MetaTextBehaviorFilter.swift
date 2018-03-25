//
//  MetaTextBehaviorFilter
//  RxSwiftForms
//
//  Created by Michael Long on 7/19/17.
//  Copyright © 2017 Client Resources Inc. All rights reserved.
//

import UIKit

public class MetaTextBehaviorFilter: MetaTextBehaviorChanging {

    public static let name = "MetaTextBehaviorFilter"

    public var name: String? { return MetaTextBehaviorFilter.name }
    public var priority: MetaTextPriority { return .higher }

    public var set: CharacterSet

    public init(_ set: CharacterSet) {
        self.set = set
    }

    public func add(to textField: MetaTextField) -> Bool {
        return true
    }

    public func shouldChangeText(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool? {
        if string.rangeOfCharacter(from: set) != nil {
            return false
        }
        return nil
    }

}
