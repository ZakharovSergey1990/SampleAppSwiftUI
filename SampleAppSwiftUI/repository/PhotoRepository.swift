//
//  PhotoRepository.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 04.04.2022.
//

import Foundation
import RealmSwift
import Combine

protocol PhotoRepository {
    func getPhotosByAlbumId(albumId: Int) -> CurrentValueSubject<[Photo], Never>
    func deletePhoto(photo: Photo)
    func addNewPhoto(photo: Photo)
}

class PhotoRepositoryImpl: PhotoRepository{
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private var notificationToken: NotificationToken?
    
    private var photosList: CurrentValueSubject<[Photo], Never>  = .init([])
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    func addNewPhoto(photo: Photo) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(photo)
        }
    }
    
    
    func getPhotosByAlbumId(albumId: Int) -> CurrentValueSubject<[Photo], Never>  {
        do {
            let realm = try Realm()
            let results = realm.objects(Photo.self)
            notificationToken = results.observe {  (changes: RealmCollectionChange) in
                
                switch changes {
                
                case .initial(let photos):
                    self.photosList.value = photos.map{$0.freeze()}.filter{$0.albumId == albumId}.sorted(by:{$0.id > $1.id})
                    if self.photosList.value.isEmpty {
                        self.updatePhotos(albumId: albumId)
                    }
                    
                case .update(let photos, deletions: _, insertions: _, modifications: _):do {
                    self.photosList.value = photos.map{$0.freeze()}.filter{$0.albumId == albumId}.sorted(by:{$0.id > $1.id})
                }
                
                case .error(let error):do {}
                }
            }
            return photosList
        } catch let realmError {
            return photosList
        }
    }
    
    
    func deletePhoto(photo: Photo){
        let realm = try! Realm()
        try! realm.write({
            realm.delete(realm.objects(Album.self).filter("id=%@", photo.id))
        })
    }
    
    private func updatePhotos(albumId: Int){
        networkService.fetchPhotos(albumId: albumId)
            .sink(receiveValue: {$0.forEach{ photo in self.addNewPhoto(photo: photo)}})
            .store(in: &self.cancellableSet)
    }
}
