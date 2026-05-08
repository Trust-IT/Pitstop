//
//  ServiceCategory+Icon.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import ChassisUI
import PitstopData

extension ServiceCategory {
    var icon: ChassisUIImages {
        switch self {
        case .maintenance: ChassisUIAsset.wrench
        case .insurance: ChassisUIAsset.insurance
        case .roadTax: ChassisUIAsset.roadTax
        case .tolls: ChassisUIAsset.tolls
        case .fines: ChassisUIAsset.fines
        case .parking: ChassisUIAsset.parking
        case .other: ChassisUIAsset.other
        }
    }
}
