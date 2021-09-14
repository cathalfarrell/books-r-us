//
//  Extensions.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 11/09/2021.
//

import Foundation

extension Locale {
	static func locale(from currencyIdentifier: String) -> Locale? {
		let allLocales = Locale.availableIdentifiers.map({ Locale.init(identifier: $0) })
		return allLocales.filter({ $0.currencyCode == currencyIdentifier }).first
	}
}
