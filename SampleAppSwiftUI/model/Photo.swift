//
//  Photo.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 08.03.2022.
//

import Foundation
import RealmSwift

class Photo: Object, Codable, ObjectKeyIdentifiable {
    @Persisted var albumId: Int
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var url: String
    @Persisted var thumbnailUrl: String
}
