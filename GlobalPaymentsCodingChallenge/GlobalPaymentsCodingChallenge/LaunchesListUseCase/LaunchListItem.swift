//
//  LaunchListItem.swift
//  GlobalPaymentsCodingChallenge
//
//  Created by Kevin Vu on 11/9/23.
//

import Foundation

struct LaunchListResponse: Decodable {
    let launches: [LaunchItem]
}

struct LaunchItem: Decodable {
    let missionName: String
    let rocket: Rocket
    let launchSite: LaunchSite
    let flightNumber: Int
    // maybe using the unix time in `Double` is better?
    // API returns list of launches from earliest to most recent
    let dateOfLaunch: String
    
    let launchLinks: LaunchLinks
    
    enum CodingKeys: String, CodingKey {
        case missionName = "mission_name"
        case rocket
        case launchSite = "launch_site"
        case flightNumber = "flight_number"
        case dateOfLaunch = "launch_date_utc"
        case launchLinks = "links"
    }
}

struct Rocket: Decodable {
    let rocketName: String
    
    enum CodingKeys: String, CodingKey {
        case rocketName = "rocket_name"
    }
}

struct LaunchSite: Decodable {
    let siteName: String
    let siteNameLong: String
    
    enum CodingKeys: String, CodingKey {
        case siteName = "site_name"
        case siteNameLong = "site_name_long"
    }
}

struct LaunchLinks: Decodable {
    // for detail view
    let missionPatchImageUrlString: String?
    // for list view
    let missionPatchSmallImageUrlString: String?
    
    enum CodingKeys: String, CodingKey {
        case missionPatchImageUrlString = "mission_patch"
        case missionPatchSmallImageUrlString = "mission_patch_small"
    }
}
