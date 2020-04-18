//
//  SyncStatus.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 4/18/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import UIKit

enum SyncStatus {
    case synced, notSynced
}

extension SyncStatus {
    var color: UIColor {
        switch self {
            case .synced:
                return AppColors.syncColor
            default:
                return AppColors.notSyncColor
        }
    }
}
