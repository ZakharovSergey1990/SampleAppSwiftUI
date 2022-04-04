//
//  ApplicationContainer.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 21.03.2022.
//

import Foundation


final class ApplicationFactory{
    
    fileprivate let networkService: NetworkService
    
    fileprivate let albumRepository: AlbumsRepository
    
    fileprivate let photoRepository: PhotoRepository
    
    fileprivate let userRepository: UserRepository
    
    
    init(){
        networkService = NetworkServiceImpl()
        albumRepository = AlbumRepositoryImpl(networkService: networkService)
        photoRepository = PhotoRepositoryImpl(networkService: networkService)
        userRepository = UserRepositoryImpl(networkService: networkService)
    }
    
    func getUsersViewModel()-> UsersViewModel{
        return UsersViewModel(userRepository: userRepository)
    }
    
    func getAlbumsViewModel(userId: Int)-> AlbumsViewModel{
        print("getAlbumsViewModel \(userId)")
        return AlbumsViewModel(albumRepository: albumRepository, userId: userId)
    }
    
    func getPhotoViewModel(albumId: Int)-> PhotoViewModel{
        print("getPhotoViewModel \(albumId)")
        return PhotoViewModel(photoRepository: photoRepository, albumId: albumId)
    }
}
