//
//  PhotoScreenViewModel.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 22.03.2022.
//

import Foundation
import Combine

class PhotoViewModel: ObservableObject{
   
    private let photoRepository: PhotoRepository
    
    @Published var photos = [Photo]()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(photoRepository: PhotoRepository, albumId: Int) {
        print("PhotoViewModel init() userId = \(albumId)")
        self.photoRepository = photoRepository
        photoRepository.getPhotosByAlbumId(albumId: albumId).assign(to:\.photos, on: self).store(in: &self.cancellableSet)
    }
}
