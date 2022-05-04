//
//  CountryListModel.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 04.05.2022.
//

import Foundation

struct CountryModel: Codable {
    let name, iso3166Alpha2, iso3166Alpha3: String?
    let iso3166Numeric, population, area: Int?
    let phoneCode: String?
}

struct Links: Codable {
    let first: String?
    let last, prev: String?
    let next: String?
}

struct Meta: Codable {
    let currentPage, from: Int?
    let path: String?
    let perPage, to: Int?
}
