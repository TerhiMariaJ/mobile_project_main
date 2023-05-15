//
//  AddUserView.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 15.5.2023.
//

import Foundation
import SwiftUI
import Alamofire


struct AddUserView: View{
    @State var firstN: String = ""
    @State var lastN: String = ""
    @State var userN: String = ""
    @State var userMessage: String = ""
    @State var newUser: Users?
    @ObservedObject var fetchList = FetchUsers.shared
    
    var body: some View{
        VStack{
            Text("Fill in user info")
            TextField("First name", text: $firstN)
            TextField("Last name", text: $lastN)
            TextField("Username", text: $userN)
            Button(action: {
                if firstN != "" && lastN != "" && userN != ""{
                    let info: [String: Any] = [
                        "firstName": firstN,
                        "lastName": lastN,
                        "username": userN
                    ]
                    
                    AF.request("https://dummyjson.com/users/add",
                               method: .post,
                               parameters: info)
                    .responseDecodable(of: Users.self){
                        response in
                        if let results = response.value{
                            self.newUser = results
                            fetchList.fetched?.append(newUser!)
                            
                            
                        }
                        
                    }
                } else {
                    userMessage = "Give valid data"
                }
                    
               
                    
                }){
                Text("Add")
            }
            if let newUser = newUser{
                Text("This was added:")
                Text("ID: \(newUser.id)")
                Text("Name: \(newUser.firstName) \(newUser.lastName)")
                
               
                
            } else {
                
                    Text(userMessage)
                
                
            }
            
        }
        .padding()
    }
    
    
}
