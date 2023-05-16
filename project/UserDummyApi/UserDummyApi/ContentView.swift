//
//  ContentView.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 9.5.2023.
//

import SwiftUI
import Alamofire

struct ContentView: View {
        
    @State var firstN: String = ""
    @State var lastN: String = ""
    @State var search: String = ""
    @State var found: Array<Users>?
    @State var 🧑‍🌾: Bool = false
    @State var 🙋: Bool = false
    @ObservedObject var fetchUsers = FetchUsers.shared
    

    func removeUser(at offsets: IndexSet){
        fetchUsers.fetched?.remove(atOffsets: offsets)
    }
    
    func searchUser(){
        🙋.toggle()
        AF.request("https://dummyjson.com/users/search?q=\(search)")
            .responseDecodable(of: Results.self){
                response in
                if let results = response.value{
                    self.found = results.users
                    
                }
            }
    }
    
    func addUser(){
        if firstN != "" && lastN != "" {
            let info: [String: Any] = [
                "firstName": firstN,
                "lastName": lastN
            ]
            
            AF.request("https://dummyjson.com/users/add",
                       method: .post,
                       parameters: info)
            .responseDecodable(of: Users.self){
                response in
                if let results = response.value{
                    let newUser = results
                    
                    fetchUsers.fetched?.append(newUser)
                        
                    
                    
                    firstN = ""
                    lastN = ""
                                        
                    
                }
                
            }
        }
    }
    
    var body: some View {
        
            VStack {
                HStack{
                    Text("Users")
                    Spacer()
                    Button{
                        🧑‍🌾.toggle()
                        
                    }label: {
                        Image(systemName: "plus")
                    }
                    .alert("New user", isPresented: $🧑‍🌾){
                        TextField("First name", text: $firstN)
                        TextField("Last name", text: $lastN)
                        Button("Add", action: addUser)
                        Button("Cancel", role: .cancel){}
                    } message: {
                        Text("Add a new user")
                    }
                }
                .padding()
                
                HStack{
                    TextField("Who do you want to find?", text: $search)
                    Button(action: {
                        searchUser()
                        
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
                .padding()
                if(🙋 == false){
                    if let fetched = fetchUsers.fetched{
                        List{
                            ForEach(fetched, id: \.id){ user in
                                Text("\(user.id). \(user.firstName) \(user.lastName)")
                                
                            }
                            .onDelete(perform: removeUser)
                            
                        }
                        
                    }
                } else {
                    if let found = found{
                        List{
                            ForEach(found, id: \.id) { found in
                                Text("\(found.id). \(found.firstName) \(found.lastName)")
                            }
                        }
                        Button(action: {
                            🙋 = false
                            search = ""
                        }) {
                            Text("Clear search")
                        }
                        .padding()
                        
                    }
                }
                
            }
            .padding()
            
            .onAppear(){
                fetchUsers.fetchAllUsers()
                
            }
           
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
