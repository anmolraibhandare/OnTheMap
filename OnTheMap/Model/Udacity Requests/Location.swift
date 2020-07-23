//
//  Location.swift
//  OnTheMap
//
//  Created by Anmol Raibhandare on 7/23/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation

struct Location: Codable {

    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String?
    let updatedAt: String?

    // MARK: Combining first and last name of students
    var studentName: String {
       var name = ""
        let space = " "
        if let firstName = firstName {
            name = firstName
        }
        if let lastName = lastName {
            if name.isEmpty{
                name = lastName
            } else {
                name = name + space + "\(lastName)"
            }
        }
        if name.isEmpty {
            name = "Name"
        }
        return name
    }
}
