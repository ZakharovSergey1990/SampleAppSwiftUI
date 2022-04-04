//
//  Album.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 08.03.2022.
//

import Foundation
import RealmSwift

class Album: Object, Codable, ObjectKeyIdentifiable {
    @Persisted var userId: Int
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
}

