//
//  CountryDetailsModel.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 07.05.2022.
//

import Foundation

struct ProductModel: Codable {
    let nameNum: Int
    let id: Float
}

struct CountryModel: Codable {
    let name: Name?
    let tld: [String]?
    let cca2, ccn3, cca3, cioc: String?
    let independent: Bool?
    let status: String?
    let unMember: Bool?
    let currencies: [String: Pen]?
    let idd: Idd?
    let capital, altSpellings: [String]?
    let region, subregion: String?
    let landlocked: Bool?
    let borders: [String]?
    let area: Double?
    let demonyms: Demonyms?
    let flag: String?
    let maps: Maps?
    let population: Int?
    let gini: Gini?
    let fifa: String?
    let car: Car?
    let timezones, continents: [String]?
    let flags, coatOfArms: CoatOfArms?
    let startOfWeek: String?
    let capitalInfo: CapitalInfo?
    let postalCode: PostalCode?
    let languages: [String:String]?
    let translations: [String: Translation]?
}

// MARK: - Translation
struct Translation: Codable {
    let common, official: String
}

// MARK: - CapitalInfo
struct CapitalInfo: Codable {
    let latlng: [Double]?
}

// MARK: - Car
struct Car: Codable {
    let signs: [String]?
    let side: String?
}

// MARK: - CoatOfArms
struct CoatOfArms: Codable {
    let png: String?
    let svg: String?
}

// MARK: - Pen
struct Pen: Codable {
    let name, symbol: String?
}

// MARK: - Demonyms
struct Demonyms: Codable {
    let eng, fra: Eng?
}

// MARK: - Eng
struct Eng: Codable {
    let f, m: String?
}

// MARK: - Gini
struct Gini: Codable {
    let the2019: Double?

    enum CodingKeys: String, CodingKey {
        case the2019 = "2019"
    }
}

// MARK: - Idd
struct Idd: Codable {
    let root: String?
    let suffixes: [String]?
}

// MARK: - Maps
struct Maps: Codable {
    let googleMaps, openStreetMaps: String?
}

// MARK: - Name
struct Name: Codable {
    let common, official: String?
}

// MARK: - PostalCode
struct PostalCode: Codable {
    let format, regex: String?
}
