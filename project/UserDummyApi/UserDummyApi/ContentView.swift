//
//  ContentView.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 9.5.2023.
//

import SwiftUI
import Alamofire

/**
 ContentView
 ### States and ObservedObject
 Used for user handling user's actions.
 ###Strings
 State strings are used for users written
 input.
 ###Array
 Used for search results.
 ###Int
 Used instead of id so adding can be done
 multiple times. Needed for deleting and
 updating a certain user.
 ###Bools
 All needed for showing something after a
 certain action is performed. Two of them
 for separate alerts, one of them for
 search results and one of them for
 actionsheet.
 ###ObservedObject
 It is used for the FetchUsers so
 all users can be accessed.
 */
struct ContentView: View {
    
    
        
    @State var firstN: String = ""
    @State var lastN: String = ""
    @State var search: String = ""
    @State var found: Array<Users>?
    @State var selected: Int = 0
    @State var 🧑‍🌾: Bool = false
    @State var 🙋: Bool = false
    @State var 👽: Bool = false
    @State var actionSheetBool: Bool = false
    @ObservedObject var fetchUsers = FetchUsers.shared
    
    /**
     removeUser:
     Function for removing a user.
     - Parameter index: - works as an id in UI.
        Changed in the function so it works as wished.
     */
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
    
    /**
     updateUser:
     Updates the info of the chosen user.
     - Parameter index: - works as an id in UI.
     Changed in the function so it works as wished.
     */
    func updateUser(at index: Int){
        let userIndex = index + 1
        if lastN != "" || firstN != ""{
            let user = fetchUsers.fetched?[index]
            let info: [String: Any] = [
                "firstName": firstN.isEmpty ? user!.firstName : firstN,
                "lastName": lastN.isEmpty ? user!.lastName : lastN
            ]
            
            AF.request("https://dummyjson.com/users/\(userIndex)",
                       method: .put,
                       parameters: info)
            .responseDecodable(of: Users.self) { response in
                if let results = response.value {
                    let updatedUser = results
                    fetchUsers.fetched?[index] = updatedUser
                    
                }
                firstN = ""
                lastN = ""
                selected = 0
                fetchUsers.objectWillChange.send()
            }
        }
            
    }

    /**
     searchUser:
     Searches the wanted user(s)
     and toggles the bool for showing
     the found users in said search
     */
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
    
    
     /**
      addUser:
      Adds a new user with given input.
      */
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
    
    /**
     View:
     the UI for the app.
     Calls all the above functions when needed.
     */
    var body: some View {
        
            VStack {
                HStack{
                    Spacer()
                    Text("Users")
                    .font(.custom("Copperplate", size: 30))
                    .fontWeight(.semibold)
                    Spacer()
                    Button{
                        🧑‍🌾.toggle()
                        
                    }label: {
                        Image(systemName: "plus")
                    }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(30)
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
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    
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
                                        TextField("First name", text: $firstN)
                                        TextField("Last name", text: $lastN)
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
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(30)
                        
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
