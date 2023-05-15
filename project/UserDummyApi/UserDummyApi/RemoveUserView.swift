//
//  RemoveUserView.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 9.5.2023.
//

import Foundation
import SwiftUI
import Alamofire

struct RemoveUserView: View {
    @State var idString: String = ""
    @State var deleteMessage: String?
    
    
    
    var body: some View {
        VStack{
            Text("Remove by ID number")
            Spacer()
            HStack{
                TextField("Who do you want to remove?", text: $idString)
                Button(action: {
                    if let id = Int(idString){
                        AF.request("https://dummyjson.com/users/\(id)",
                                   method: .delete)
                        .responseDecodable(of: Users.self){
                            response in
                            if let result = response.value{
                                self.deleteMessage = "Removed: \(result.firstName) \(result.lastName)"
                            } else {
                                self.deleteMessage = "User ID not found"
                            }
                            
                        }
                        
                    } else {
                        self.deleteMessage = "Give a valid ID number"
                    }
                        
                    }){
                    Text("Delete")
                }
            }
            Spacer()
            if let deleteMessage = deleteMessage{
                Text(deleteMessage)
            }
            Spacer()
            
        }
        .padding()
        
    }
    }
