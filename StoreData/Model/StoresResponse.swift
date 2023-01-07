//
//  StoresResponse.swift
//  StoreData
//
//  Created by Ditha Nurcahya Avianty on 05/01/23.
//

import Foundation

// MARK: - StoresResponse

struct StoresResponse: Codable {
    let stores: [StoreDatum]
    let status, message: String
}

// MARK: - Store

struct StoreDatum: Codable {
    let storeID, storeCode, storeName, address: String
    let dcID, dcName, accountID, accountName: String
    let subchannelID, subchannelName, channelID, channelName: String
    let areaID, areaName, regionID, regionName: String
    let latitude, longitude: String

    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case storeCode = "store_code"
        case storeName = "store_name"
        case address
        case dcID = "dc_id"
        case dcName = "dc_name"
        case accountID = "account_id"
        case accountName = "account_name"
        case subchannelID = "subchannel_id"
        case subchannelName = "subchannel_name"
        case channelID = "channel_id"
        case channelName = "channel_name"
        case areaID = "area_id"
        case areaName = "area_name"
        case regionID = "region_id"
        case regionName = "region_name"
        case latitude, longitude
    }
}
