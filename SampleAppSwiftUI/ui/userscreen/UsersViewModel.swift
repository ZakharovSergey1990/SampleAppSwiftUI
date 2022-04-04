//
//  UsersViewModel.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 21.03.2022.
//

import Foundation
import Combine


class UsersViewModel: ObservableObject{
   
    private let userRepository: UserRepository
    
    @Published var users = [User]()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        userRepository.getUsers().assign(to:\.users, on: self).store(in: &self.cancellableSet)
    }
    
    
    func deleteUser(user: User){
        userRepository.deleteUser(user: user)
    }
}
