//
//  NetworkService.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 08.03.2022.
//

import Foundation
import Combine

protocol NetworkService {
    func fetchUsers() -> AnyPublisher<[User], Never>
    func fetchAlbums(userId: Int) -> AnyPublisher<[Album], Never>
    func fetchPhotos(albumId: Int) -> AnyPublisher<[Photo], Never>
}


class NetworkServiceImpl: NetworkService{
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func fetchUsers() -> AnyPublisher<[User], Never> {
        guard let url = RequestUrlBuilder.users.path() else {
                           return Just([User]()).eraseToAnyPublisher()
               }
                  return
                   URLSession.shared.dataTaskPublisher(for:url)
                   .map{$0.data}
                   .decode(type: [User].self,
                           decoder: JSONDecoder())
                   .replaceError(with: [])
                   .receive(on: RunLoop.main)
                   .eraseToAnyPublisher()
       }
    
    func fetchAlbums(userId: Int) -> AnyPublisher<[Album], Never> {
        guard let url = RequestUrlBuilder.albums.path() else {
            return Just([Album]()).eraseToAnyPublisher()
        }
        return
            URLSession.shared.dataTaskPublisher(for:url)
            .map{$0.data}
            .decode(type: [Album].self,
                    decoder: JSONDecoder())
            .replaceError(with: [])
            .map{list in list.filter{ $0.userId == userId }}
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchPhotos(albumId: Int) -> AnyPublisher<[Photo], Never> {
        guard let url = RequestUrlBuilder.photos.path() else {
            return Just([Photo]()).eraseToAnyPublisher()
        }
        return
            URLSession.shared.dataTaskPublisher(for:url)
            .map{$0.data}
            .decode(type: [Photo].self,
                    decoder: JSONDecoder())
            .map{list in list.filter{ $0.albumId == albumId }}
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    enum RequestUrlBuilder {
        
        case users
        case albums
        case photos
       
        func path() -> URL? {
            let baseURL: String = "https://jsonplaceholder.typicode.com/"
            switch self {
            case .users:
                return {URL(string: baseURL + "users")!}()
            case .albums:
                return {URL(string: baseURL + "albums")!}()
            case .photos:
                return {URL(string: baseURL + "photos")!}()
            }
        }
    }
}



