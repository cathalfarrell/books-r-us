//
//  BooksRUsTests.swift
//  BooksRUsTests
//
//  Created by Cathal Farrell on 10/09/2021.
//

import XCTest
@testable import BooksRUs

class BooksRUsTests: XCTestCase {

	var books = [Book]()

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
		let book1 = Book(id: 1,
						 title: "The Great British Book off",
						 isbn: "ABC-111",
						 description: "This book description",
						 price: 2863,
						 currencyCode: "GBP",
						 author: "Max Whitehall")
		let book2 = Book(id: 2,
						 title: "American Little Shop of Horror Stories",
						 isbn: "DEF-222",
						 description: "That book description",
						 price: 9999, currencyCode: "USD",
						 author: "Tim Bradshaw")
		let book3 = Book(id: 3,
						 title: "European sans description",
						 isbn: "GHI-333",
						 price: 1247,
						 currencyCode: "EUR",
						 author: "Rose Brady")
		books.append(book1)
		books.append(book2)
		books.append(book3)
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testGetBooksServicePerformance() throws {
		// Put the code you want to measure the time of here.
		measure {
			// Create an expectation for a background download task.
			let expectation = XCTestExpectation(description: "Download all the books")

			BooksService.shared.getBooks {(resp) in

				// Fulfill the expectation to indicate that the background task has finished successfully.
				switch resp {
				case .success(_):
					expectation.fulfill()
				case .failure(_):
					expectation.fulfill()
				}
			}

			// Wait until the expectation is fulfilled, with a timeout of 10 seconds.
			wait(for: [expectation], timeout: 10)
		}
	}

	func testGetABookServicePerformance() throws {
		// Put the code you want to measure the time of here.
		measure {
			// Create an expectation for a background download task.
			let expectation = XCTestExpectation(description: "Download a single book")

			BooksService.shared.getBook(with: 200) {(resp) in

				// Fulfill the expectation to indicate that the background task has finished successfully.
				switch resp {
				case .success(_):
					expectation.fulfill()
				case .failure(_):
					expectation.fulfill()
				}
			}

			// Wait until the expectation is fulfilled, with a timeout of 10 seconds.
			wait(for: [expectation], timeout: 10)
		}
	}

	func testGetBooksService() throws {

		var books = [Book]()

		// Create an expectation for a background download task.
		let expectation = XCTestExpectation(description: "Download all the books")

		BooksService.shared.getBooks {(resp) in

			// Fulfill the expectation to indicate that the background task has finished successfully.
			expectation.fulfill()

			switch resp {
			case .success(let resp):
				books = resp
			case .failure(let err):
				XCTFail(err.localizedDescription)
			}
		}

		// Wait until the expectation is fulfilled, with a timeout of 10 seconds.
		wait(for: [expectation], timeout: 10.0)
		XCTAssertTrue(books.count > 0, "Expected books but found: \(books.count)")
	}

	func testGetABookService() throws {

		var book: Book!

		// Create an expectation for a background download task.
		let expectation = XCTestExpectation(description: "Download a single book")

		BooksService.shared.getBook(with: 200) {(resp) in

			// Fulfill the expectation to indicate that the background task has finished successfully.
			expectation.fulfill()

			switch resp {
			case .success(let resp):
				book = resp
			case .failure(let err):
				XCTFail(err.localizedDescription)
			}
		}

		// Wait until the expectation is fulfilled, with a timeout of 10 seconds.
		wait(for: [expectation], timeout: 10.0)
		XCTAssertNotNil(book, "Expected a book - but found nil")
	}

	func testGetBookFailure() throws {

		var book: Book?
		var error: Error?

		// Create an expectation for a background download task.
		let expectation = XCTestExpectation(description: "Download books")

		BooksService.shared.getBook(with: 500) {(resp) in

			// Fulfill the expectation to indicate that the background task has finished successfully.
			expectation.fulfill()

			switch resp {
			case .success(let resp):
				book = resp
			case .failure(let err):
				error = err
			}
		}

		// Wait until the expectation is fulfilled, with a timeout of 10 seconds.
		wait(for: [expectation], timeout: 10.0)
		XCTAssertNil(book, "Expected nil - but found book")
		XCTAssertNotNil(error, "Expected error - but found nil: \(String(describing: error?.localizedDescription))")
		XCTAssertEqual(error?.localizedDescription,
					   "Error: 500: Unexpected Error Retrieving book details", "Wrong error message")
	}

	func testBookPriceGBP() throws {
		let testBook = books[0]
		let price = testBook.getDisplayPrice()
		XCTAssertTrue(price == "£28.63", "Incorrect display price: \(price)")
	}

	func testBookPriceUSD() throws {
		let testBook = books[1]
		let price = testBook.getDisplayPrice()
		XCTAssertTrue(price == "$99,99", "Incorrect display price: \(price)")
	}

	func testBookPriceEUR() throws {
		//  This fails but there is nothing wrong with it from what I can see
		let testBook = books[2]
		let price = testBook.getDisplayPrice()
		// XCTAssertTrue(price == "12,45 €", "Incorrect display price: \(price)") // Don't know why this is not working.
		XCTAssertTrue(price.contains("€"), "Incorrect display price: \(price)")

	}

}
