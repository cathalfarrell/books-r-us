//
//  APIResponseBooks.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 10/09/2021.
//
// 	swiftlint:disable identifier_name line_length

import UIKit

typealias APIResponseBooks = [Book]
typealias APIResponseBook = Book

struct Book: Codable {
	var id: Int
	var title: String
	var isbn: String
	var description: String?
	var price: Double
	var currencyCode: String
	var author: String
}
extension Book {
	public func getImage() -> UIImage {
		if let image = UIImage(named: "\(id)") {
			return image
		} else if let placeholder = UIImage(named: "placeholder") {
			return placeholder
		} else {
			return UIImage()
		}
	}

	public func getDisplayPrice() -> String {
		let formatter = NumberFormatter()
		formatter.locale = Locale.locale(from: currencyCode)
		formatter.numberStyle = .currency
		let costPrice = NSNumber(value: ("\(price/100)" as NSString).doubleValue)
		let amountWithSymbol = formatter.string(from: costPrice)
		return amountWithSymbol ?? ""
	}
}
extension Book {
	static var testBook: Book {
		return Book(id: 100,
					title: "Code Complete: A Practical Handbook of Software Construction",
					isbn: "978-0735619678",
					description: "Widely considered one of the best practical guides to programming, Steve McConnell’s original CODE COMPLETE has been helping developers write better software for more than a decade. Now this classic book has been fully updated and revised with leading-edge practices—and hundreds of new code samples—illustrating the art and science of software construction. Capturing the body of knowledge available from research, academia, and everyday commercial practice, McConnell synthesizes the most effective techniques and must-know principles into clear, pragmatic guidance. No matter what your experience level, development environment, or project size, this book will inform and stimulate your thinking—and help you build the highest quality code.",
					price: 2954,
					currencyCode: "EUR",
					author: "Mike Riley")
	}
}
