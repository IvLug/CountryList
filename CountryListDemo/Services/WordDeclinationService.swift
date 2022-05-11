//
//  WordDeclinationService.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 09.05.2022.
//

import Foundation

func formatte(digit: Int, forms: [String]) -> String {
    let lastNumber = digit % 100
    if lastNumber >= 11 && lastNumber <= 19 {
        return forms[2]
    }
    let lastDigit = digit % 10
    if [0, 5, 6, 7, 8, 9].contains(lastDigit) {
        return forms[2]
    } else if [1].contains(lastDigit) {
        return forms[0]
    } else {
        return forms[1]
    }
}

func continentsCount(count: Int) -> String {
    formatte(digit: count, forms: ["Language:", "Languages:", "Languages:"])
}
