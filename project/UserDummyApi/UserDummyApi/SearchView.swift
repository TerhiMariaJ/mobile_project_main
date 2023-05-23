//
//  SearchView.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 9.5.2023.
//

import Foundation
import SwiftUI
import Alamofire

struct SearchView: View{
    @State var search: String = ""
    @State var searchResult: String = ""
    @State var found: Array<Users>?
    var body: some View{
        VStack{
            Text("Search users")
            Spacer()
            HStack{
                TextField("Who do you want to find?", text: $search)
                Button(action: {
                    AF.request("https://dummyjson.com/users/search?q=\(search)")
                        .responseDecodable(of: Results.self){
                            response in
                            if let results = response.value{
                                self.found = results.users
                               
                            } else {
                                searchResult = "No user(s) found"
                            }
                        }
                }){
                    Text("Search")
                }
                
                
            }
            Spacer()
            if let found = found{
                List{
                    ForEach(found, id: \.firstName){ user in
                        Text("\(user.firstName) \(user.lastName)")
                        
                    }
                }
            } else {
                Text(searchResult)
            }
            Spacer()
            }
            .padding()
        
        }
        
    }

