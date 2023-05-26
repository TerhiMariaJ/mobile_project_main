//
//  Users.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 9.5.2023.
//

/**
 ### Users
 Takes the info of a singular user in backend and
 filters the wanted data.
 */
struct Users: Decodable, Equatable{
    let firstName: String
    let lastName: String
}


