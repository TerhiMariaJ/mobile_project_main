//
//  FetchUsers.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 9.5.2023.
//


import Foundation
import SwiftUI
import Alamofire

/**
 ### Fetchusers
 The class for fetching all users. In different class because of
 older UI.
 -Parameters:
 -fetchAllUsers:Returns the data from backend with Alamofire.
 -shared: Shares the function to other structs/classes.
 */
class FetchUsers: ObservableObject{
    
    @Published var fetched: Array<Users>? = nil
    static let shared = FetchUsers()
    
    func fetchAllUsers(){
        AF.request("https://dummyjson.com/users")
            .responseDecodable(of: Results.self){
                response in
                if let result = response.value{
                    self.fetched = result.users
                }
            }
            
    }
    

}
