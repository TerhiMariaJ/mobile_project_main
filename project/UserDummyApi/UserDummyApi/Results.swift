//
//  Results.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 24.5.2023.
//

import Foundation

/**
 ### Results
 -Parameter users: Takes users and makes them an array.
 */
struct Results: Decodable{
    let users: Array<Users>
}
