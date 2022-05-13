//
//  ErrorModel.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 13.05.2022.
//

import Foundation

struct ErrorModel: Codable, Error {
  let status: Int?
  let message: String?
}
