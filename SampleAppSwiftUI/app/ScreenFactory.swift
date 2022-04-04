//
//  ScreenFactory.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 21.03.2022.
//

import Foundation

let screenFactory: ScreenFactory = ScreenFactory()

final class ScreenFactory{
    
    fileprivate let applicationFactory = ApplicationFactory()
    
    fileprivate init(){}
    
    func makeUsersScreen() -> UsersScreen{
        return UsersScreen(vm: applicationFactory.getUsersViewModel())
    }
    
    func makeAlbumsScreen(userId: Int) -> AlbumsScreen{
        print("makeAlbumsScreen \(userId)")
        let vm = applicationFactory.getAlbumsViewModel(userId: userId)
        return AlbumsScreen(vm: vm)
    }
    
    func makePhotosScreen(albumId: Int) -> PhotoScreen{
        print("makePhotosScreen \(albumId)")
        return PhotoScreen(vm: applicationFactory.getPhotoViewModel(albumId: albumId))
    }
}
