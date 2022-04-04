//
//  AlbumService.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 28.03.2022.
//

import Foundation
import RealmSwift
import Combine

protocol AlbumService {
  //  func getAlbumsByUserId(userId: Int) -> AnyPublisher<[Album], Never>
    func deleteAlbum(album: Album)
    func updateAlbums()
}

class AlbumServiceImpl: AlbumService{
    
    let albumRepository: AlbumsRepository
    
    let networkService: NetworkService
    
    private var cancellableSet: Set<AnyCancellable> = []
    

    
    init(networkService: NetworkService,
         albumRepository: AlbumsRepository
         ) {
        self.albumRepository = albumRepository
        self.networkService = networkService
    }
    
//    func getAlbumsByUserId(userId: Int, observeAlbums: @escaping ([Album])-> Void) {
//        albumRepository.getAlbumsByUserId(userId: userId, getAlbums: { result in
//            if(result.isEmpty){
//                print("getAlbumsByUserId isEmpty")
//
//
//
//                self.networkService.fetchAlbums(userId: userId).sink(receiveValue: { $0.forEach{album in
//                    self.albumRepository.addNewAlbum(album: album)
//                } }).store(in: &self.cancellableSet)
//            }
//            else{
//                print("getAlbumsByUserId result = \(result)")
//                observeAlbums(result)
//            }
//        })
//    }
    
//    func getAlbumsByUserId(userId: Int) -> AnyPublisher<[Album], Never> {
//        albumRepository.getAlbumsByUserId(userId: userId, getAlbums: { result in
//            if(result.isEmpty){
//                print("getAlbumsByUserId isEmpty")
//                self.networkService.fetchAlbums(userId: userId).sink(receiveValue: { $0.forEach{album in
//                    self.albumRepository.addNewAlbum(album: album)
//                } }).store(in: &self.cancellableSet)
//            }
//            else{
//                print("getAlbumsByUserId result = \(result)")
//                observeAlbums(result)
//            }
//        })
//    }
    
    
    func deleteAlbum(album: Album) {
        albumRepository.deleteAlbum(album: album)
    }
    
    func updateAlbums() {
        
    }
}
