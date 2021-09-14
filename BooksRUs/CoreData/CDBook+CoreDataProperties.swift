//
//  CDBook+CoreDataProperties.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 13/09/2021.
//
//

import Foundation
import CoreData

// swiftlint:disable identifier_name

extension CDBook {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<CDBook> {
		return NSFetchRequest<CDBook>(entityName: "CDBook")
	}

	@NSManaged public var id: Int64
	@NSManaged public var title: String?
	@NSManaged public var isbn: String?
	@NSManaged public var desc: String?
	@NSManaged public var price: Double
	@NSManaged public var currencyCode: String?
	@NSManaged public var author: String?

	// MARK: - Safe unwrappers for optional Strings

	func unwrappedTitle() -> String {
		return title ?? ""
	}

	func unwrappedISBN() -> String {
		return isbn ?? ""
	}

	func unwrappedDescription() -> String {
		return desc ?? ""
	}

	func unwrappedCurrencyCode() -> String {
		return currencyCode ?? ""
	}

	func unwrappedAuthor() -> String {
		return author ?? ""
	}

}

extension CDBook: Identifiable {

}
