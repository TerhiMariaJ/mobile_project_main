//
//  ContentView.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 9.5.2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image("background")
                    .resizable()
                    .scaledToFit()
                    .overlay(ImageOverlay(), alignment: .bottomTrailing)
            Spacer()
            
            
            Text("User manager")
            Spacer()
            NavigationStack{
                NavigationLink(destination: AllUsersView()){
                    Text("All users")
                    
                }
                NavigationLink(destination: SearchView()){
                    Text("Search")
                    
                }
                NavigationLink(destination: AllUsersView()){
                    Text("Add")
                    
                }
                NavigationLink(destination: AllUsersView()){
                    Text("Modify")
                    
                }
                NavigationLink(destination: RemoveUserView()){
                    Text("Remove")
                    
                }

            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
