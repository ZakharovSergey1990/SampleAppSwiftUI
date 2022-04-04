//
//  ContentView.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 08.03.2022.
//

import SwiftUI

struct UsersScreen: View {
    
    @ObservedObject private var vm : UsersViewModel
    
    init(vm : UsersViewModel){
        self.vm = vm
    }
    
    var body: some View {
        NavigationView{
            List(vm.users){ user in
             //   UserItem(user: user, onClick: {})
                ZStack{
                    NavigationLink(destination: NavigationLazyView(screenFactory.makeAlbumsScreen(userId: user.id))) {
                    }.buttonStyle(PlainButtonStyle()).hidden()
                    UserItem(user: user) { vm.deleteUser(user: user) }
                }
            } .navigationBarTitle("Users", displayMode: .inline)
        }
    }
}

struct UserItem: View {
    let user: User
    var deleteUser:() -> Void
    
    @State private var isRotated = false
    @State var showsAlert = false
    
    var animation: Animation {
        Animation.easeOut
    }
    
    var body: some View{
        VStack{
            HStack{
                Text(user.name)
                Spacer()
                
                Image(systemName: "arrow.down.left.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .onTapGesture { isRotated.toggle() }
                    .rotationEffect(Angle.degrees(isRotated ? 180 : 0))
            }
            
            //  .animation(animation)
            if isRotated{
                HStack{
                    Text(user.website).lineLimit(1)
                    Spacer()
                    Text(user.email).lineLimit(1)
                }
            }
        }
        .alert(isPresented: self.$showsAlert) {
            Alert(title: Text("Delete \(user.name)"),
                  message: Text("Are you sure?"),
                  primaryButton: .default(Text("No")),
                  secondaryButton: .destructive(Text("Yes"), action: { deleteUser() })
                   )
        }
        .onLongPressGesture { showsAlert = true }
        .animation(animation)
        .frame(width: .infinity)
        .padding()
    }
}


struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
