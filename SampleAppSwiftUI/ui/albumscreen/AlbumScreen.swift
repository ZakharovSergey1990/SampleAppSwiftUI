//
//  AlbumScreen.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 22.03.2022.
//

import Foundation
import SwiftUI
import RealmSwift

struct AlbumsScreen: View {
    
    @ObservedObject private var vm : AlbumsViewModel
    
    init(vm : AlbumsViewModel){
        self.vm = vm
    }
    
    var body: some View {
        // NavigationView{
        VStack(alignment: .leading){
            List(vm.albums){ album in
                HStack{
                    ZStack{
                        NavigationLink(destination: NavigationLazyView(screenFactory.makePhotosScreen(albumId: album.id))) {
                            Text(album.title)
                        }
                        //   .buttonStyle(PlainButtonStyle()).hidden()
                        
                    }
                }.onLongPressGesture {
                    vm.deleteAlbum(album: album)
                }
                //   }
            }
            .navigationBarTitle("Albums", displayMode: .inline)
        }
    }
}
