//
//  User.swift
//  SampleAppSwiftUI
//
//  Created by Sergey Zakharov on 08.03.2022.
//

import Foundation
import RealmSwift

class User : Object, Codable, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id : Int
    @Persisted var name : String
    @Persisted var username : String
    @Persisted var email : String
    @Persisted var address : Address?
    @Persisted var phone : String
    @Persisted var website : String
    @Persisted var company : Company?
}

class Address : Object, Codable {
    @Persisted var street : String
    @Persisted var suite : String
    @Persisted var city : String
    @Persisted var zipcode : String
    @Persisted var geo : Geo?
}


class Geo : Object, Codable {
    @Persisted var lat : String
    @Persisted var lng : String
}


class Company : Object, Codable {
    @Persisted var name : String
    @Persisted var catchPhrase : String
    @Persisted var bs : String
}
