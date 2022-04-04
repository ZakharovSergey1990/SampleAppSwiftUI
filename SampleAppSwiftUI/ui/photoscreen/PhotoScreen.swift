//
//  PhotoScreen.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 22.03.2022.
//

import Foundation
import SwiftUI

struct PhotoScreen: View {
    
    @ObservedObject private var vm : PhotoViewModel
    
    init(vm : PhotoViewModel){
        self.vm = vm
    }
    
    var body: some View {
        VStack(alignment: .leading){
            List(vm.photos){ photo in
                VStack{
                    AsyncImage(url: URL(string: photo.url)!,
                               placeholder: {
                                 ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle(tint: .purple))})
                        .aspectRatio(contentMode: .fill)
                Text(photo.title)
               }
            }
        }.navigationBarTitle("Photos", displayMode: .inline)
    }
}

