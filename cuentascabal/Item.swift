//
//  Item.swift
//  cuentascabal
//
//  Created by ivan aquino on 13/4/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
