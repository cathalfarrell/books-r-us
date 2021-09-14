//
//  BooksService.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 10/09/2021.
//  Copyright © 2021 BooksRUs. All rights reserved.
//

import Foundation
import Alamofire

struct BooksService {

	static let shared = BooksService()

	func getBooks(_ completion: @escaping (Result<APIResponseBooks>) -> Void) {

		let url = "https://tpbookserver.herokuapp.com/books"

		do {
			Log.v("😀 Making this request: \(url)")

			let request = AF.request(url)

			request.responseJSON { response in

				let result = NetworkResponse.handleNetworkResponse(for: response)

				switch result {
				case .success:

					if let unwrappedData = response.data {

						do {
							let jsonResult = try JSONDecoder().decode(APIResponseBooks.self, from: unwrappedData)
								Log.v("Successfully parsed APIResponseBook type response")
								completion(Result.success(jsonResult))

						} catch let parseError {
							Log.e("Unable to parse JSON response: \(parseError.localizedDescription)")
							completion(Result.failure(BooksRUsError.couldNotParse))
						}
					}

				case .failure(let err):

					if let unwrappedData = response.data, let apiResponse = response.response {

						// The API respondes with an API error messge that we should display to user

						do {
							let jsonResult = try JSONDecoder().decode(APIResponseError.self, from: unwrappedData)
							Log.v("Successfully parsed APIResponseError type response")
							let apiError = BooksRUsError.responseStatusError(status: apiResponse.statusCode, message: jsonResult.message)
							completion(Result.failure(apiError))

						} catch {
							completion(Result.failure(err))
						}
					}
				}
			}
		}
	}

	func getBook(with identifier: Int, completion: @escaping (Result<APIResponseBook>) -> Void) {

		let url = "https://tpbookserver.herokuapp.com/book/\(identifier)"

		do {
			Log.v("😀 Making this request: \(url)")

			let request = AF.request(url)

			request.responseJSON { response in

				let result = NetworkResponse.handleNetworkResponse(for: response)

				switch result {
				case .success:

					if let unwrappedData = response.data {

						do {
							let jsonResult = try JSONDecoder().decode(APIResponseBook.self, from: unwrappedData)
								Log.v("Successfully parsed APIResponseBook type response")
								completion(Result.success(jsonResult))

						} catch let parseError {
							Log.e("Unable to parse JSON response: \(parseError.localizedDescription)")
							completion(Result.failure(BooksRUsError.couldNotParse))
						}
					}

				case .failure(let err):

					if let unwrappedData = response.data, let apiResponse = response.response {

						// The API respondes with an API error messge that we should display to user

						do {
							let jsonResult = try JSONDecoder().decode(APIResponseError.self, from: unwrappedData)
							Log.v("Successfully parsed APIResponseError type response")
							let apiError = BooksRUsError.responseStatusError(status: apiResponse.statusCode, message: jsonResult.message)
							completion(Result.failure(apiError))

						} catch {
							completion(Result.failure(err))
						}
					}
				}
			}
		}
	}
}
