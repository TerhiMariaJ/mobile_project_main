//
//  AllUsersView.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 9.5.2023.
//

import Foundation
import SwiftUI

struct AllUsersView: View {
    @ObservedObject var fetchUsers = FetchUsers.shared
    
    var body: some View {
        VStack{
            Text("Users")
            if let fetched = fetchUsers.fetched{
                List{
                    ForEach(fetched, id: \.id){ user in
                        Text("\(user.id). \(user.firstName) \(user.lastName), \(user.username)")
                        
                    }
                }
            }

            
        }
        .onAppear(){
            fetchUsers.fetchAllUsers()
            
        }
        
    }
    }
