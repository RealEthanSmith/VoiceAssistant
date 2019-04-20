//
//  PHSBridgeInfo.swift
//  Voice Assist
//
//  Created by Emmett Shaughnessy on 4/19/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import Foundation

struct PHBridgeInfo {
    let ipAddress: String
    let uniqueID: String
}

typealias PHBridgeInfoDiscoveryResult = PHBridgeInfo
extension PHBridgeInfoDiscoveryResult {
    init(withDiscoveryResult discoveryResult:PHSBridgeDiscoveryResult) {
        self.ipAddress = discoveryResult.ipAddress
        self.uniqueID = discoveryResult.uniqueId
    }
}
