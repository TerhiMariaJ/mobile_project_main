//
//  Users.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 9.5.2023.
//

struct Users: Decodable{
    let id: Int
    let firstName: String
    let lastName: String

    
}

struct Results: Decodable{
    let users: Array<Users>
}
