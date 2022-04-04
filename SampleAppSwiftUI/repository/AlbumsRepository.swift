//
//  AlbumsRepository.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 28.03.2022.
//

import Foundation
import RealmSwift
import Combine

protocol AlbumsRepository {
    func getAlbumsByUserId(userId: Int) -> CurrentValueSubject<[Album], Never>
    func deleteAlbum(album: Album)
    func addNewAlbum(album: Album)
}

class AlbumRepositoryImpl: AlbumsRepository{
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private var notificationToken: NotificationToken?
    
    private var albumsList: CurrentValueSubject<[Album], Never>  = .init([])
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    func addNewAlbum(album: Album) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(album)
        }
    }
    
    
    func getAlbumsByUserId(userId: Int) -> CurrentValueSubject<[Album], Never>  {
        do {
            let realm = try Realm()
            let results = realm.objects(Album.self)
            notificationToken = results.observe {  (changes: RealmCollectionChange) in
                
                switch changes {
                
                case .initial(let albums):
                    self.albumsList.value = albums.map{$0.freeze()}.filter{$0.userId == userId}.sorted(by:{$0.id > $1.id})
                    if self.albumsList.value.isEmpty {
                        self.updateAlbums(userId: userId)
                    }
                    
                case .update(let albums, deletions: _, insertions: _, modifications: _):do {
                    self.albumsList.value = albums.map{$0.freeze()}.filter{$0.userId == userId}.sorted(by:{$0.id > $1.id})
                }
                
                case .error(let error):do {}
                }
            }
            return albumsList
        } catch let realmError {
            return albumsList
        }
    }
    
    
    func deleteAlbum(album: Album){
        let realm = try! Realm()
        try! realm.write({
            realm.delete(realm.objects(Album.self).filter("id=%@", album.id))
        })
    }
    
    private func updateAlbums(userId: Int){
        networkService.fetchAlbums(userId: userId)
            .sink(receiveValue: {$0.forEach{ album in self.addNewAlbum(album: album)}})
            .store(in: &self.cancellableSet)
    }
}
