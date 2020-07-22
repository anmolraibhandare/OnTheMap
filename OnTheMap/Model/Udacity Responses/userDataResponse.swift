//
//  userDataResponse.swift
//  OnTheMap
//
//  Created by Anmol Raibhandare on 7/21/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation

struct userDataResponse: Codable {
    let firstName: String
    let lastName: String
    let nickName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickName = "nickname"
    }
}
