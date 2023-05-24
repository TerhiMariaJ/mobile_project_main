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
    @State var newFirstN: String = ""
    @State var newLastN: String = ""
    @State var found: Array<Users>?
    @State var selected: Int = 0
    @State var 🧑‍🌾: Bool = false
    @State var 🙋: Bool = false
    @State var 👽: Bool = false
    @State var actionSheetBool: Bool = false
    @ObservedObject var fetchUsers = FetchUsers.shared
    

    func removeUser(at index: Int){
        let userIndex = index + 1
        AF.request("https://dummyjson.com/users/\(userIndex)",
                   method: .delete)
        .responseDecodable(of: Users.self){
            response in
            if response.value != nil{
                fetchUsers.fetched?.remove(at: index)
            }
        }
        
    }
    
    func updateUser(at index: Int){
        let userIndex = index + 1
        if newLastN != "" || newFirstN != ""{
            let user = fetchUsers.fetched?[index]
            let info: [String: Any] = [
                "firstName": newFirstN.isEmpty ? user!.firstName : newFirstN,
                "lastName": newLastN.isEmpty ? user!.lastName : newLastN
            ]
            
            
            
            AF.request("https://dummyjson.com/users/\(userIndex)",
                       method: .put,
                       parameters: info)
            .responseDecodable(of: Users.self) { response in
                if let results = response.value {
                    let updatedUser = results
                    fetchUsers.fetched?[index] = updatedUser
                    
                }
                newFirstN = ""
                newLastN = ""
                selected = 0
                fetchUsers.objectWillChange.send()
            }
        }
            
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
                            ForEach(fetched.indices, id: \.self){ index in
                                let user = fetched[index]
                                HStack{
                                    Text("\(user.firstName) \(user.lastName)")
                                    Spacer()
                                    Button{
                                        selected = index
                                        actionSheetBool.toggle()
                                            
                                    } label: {
                                        Image(systemName: "ellipsis")
                                    }.actionSheet(isPresented: $actionSheetBool){
                                        ActionSheet(title: Text("Options"), message: Text("Edit or delete"), buttons: [
                                                .default(Text("Edit"), action: {
                                                    👽.toggle()
                                                }),
                                                .destructive(Text("Delete"), action: {
                                                    
                                                        removeUser(at: selected)
                                                    
                                                }),
                                                .cancel()
                                            ])
                                    }
                                    .alert("Update", isPresented: $👽){
                                        TextField("First name", text: $newFirstN)
                                        TextField("Last name", text: $newLastN)
                                        Button(action: {
                                            
                                                updateUser(at: selected)
                                            
                                                                                
                                        }){
                                            Text("Update")
                                        }
                                        Button("Cancel", role: .cancel){}
                                    } message: {
                                        Text("Update user")
                                    }
                                    
                                
                                
                                
                            }
                            
                            }
                                                        
                            
                            
                            
                            
                        }
                        .listStyle(PlainListStyle())
                        
                        
                    }
                } else {
                    if let found = found{
                        List{
                            ForEach(found, id: \.firstName) { found in
                                Text("\(found.firstName) \(found.lastName)")
                            }
                        }
                        Button(action: {
                            🙋.toggle()
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
