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
    @State var 🧑‍🌾: Bool = false
    @State var newUser: Users?
    @ObservedObject var fetchUsers = FetchUsers.shared
    

    func removeUser(at offsets: IndexSet){
        fetchUsers.fetched?.remove(atOffsets: offsets)
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
                    self.newUser = results
                    fetchUsers.fetched?.append(newUser!)
                    
                    
                }
                
            }
        }
    }
    
    var body: some View {
        TabView{
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
                Spacer()
                if let fetched = fetchUsers.fetched{
                    List{
                        ForEach(fetched, id: \.id){ user in
                            Text("\(user.id). \(user.firstName) \(user.lastName)")
                            
                        }
                        .onDelete(perform: removeUser)
                        
                    }
                    
                }
                
            }
            .padding()
            
            .onAppear(){
                fetchUsers.fetchAllUsers()
                
            }
            .tabItem{
                Text("Home")
            }
            SearchView()
                .tabItem{
                    
                    Text("Search")
                }
            
            
            
        }
        
            
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
