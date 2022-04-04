//
//  AlbumsViewModel.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 22.03.2022.
//

import Foundation
import Combine
import RealmSwift

class AlbumsViewModel: ObservableObject{
   
    private let albumRepository: AlbumsRepository
    
    @Published var albums: [Album] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(albumRepository: AlbumsRepository, userId: Int) {
        print("AlbumsViewModel init() userId = \(userId)")
        self.albumRepository = albumRepository
        albumRepository.getAlbumsByUserId(userId: userId).assign(to:\.albums, on: self).store(in: &self.cancellableSet)
    }
    
    
    func deleteAlbum(album: Album){
        albumRepository.deleteAlbum(album: album)
    }
}
