//
//  UserRepository.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 28.03.2022.
//

import Foundation
import RealmSwift
import Combine

protocol UserRepository {
    func getUsers() -> CurrentValueSubject<[User], Never>
    func deleteUser(user: User)
    func addNewUser(user: User)
}

class UserRepositoryImpl: UserRepository{
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private var notificationToken: NotificationToken?
    
    private var usersList: CurrentValueSubject<[User], Never>  = .init([])
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    func addNewUser(user: User) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }
    }
    
    
    func getUsers() -> CurrentValueSubject<[User], Never>  {
        do {
            let realm = try Realm()
            let results = realm.objects(User.self)
            notificationToken = results.observe {  (changes: RealmCollectionChange) in
                
                switch changes {
                
                case .initial(let users):
                    self.usersList.value = users.map{$0.freeze()}.sorted(by:{$0.id > $1.id})
                    if self.usersList.value.isEmpty {
                        self.updateUsers()
                    }
                    
                case .update(let users, deletions: _, insertions: _, modifications: _):do {
                    self.usersList.value = users.map{$0.freeze()}.sorted(by:{$0.id > $1.id})
                }
                
                case .error(let error):do {}
                }
            }
            return usersList
        } catch let realmError {
            return usersList
        }
    }
    
    
    func deleteUser(user: User){
        let realm = try! Realm()
        try! realm.write({
            realm.delete(realm.objects(User.self).filter("id=%@", user.id))
        })
    }
    
    private func updateUsers(){
        networkService.fetchUsers()
            .sink(receiveValue: {$0.forEach{ user in self.addNewUser(user: user)}})
            .store(in: &self.cancellableSet)
    }
}
