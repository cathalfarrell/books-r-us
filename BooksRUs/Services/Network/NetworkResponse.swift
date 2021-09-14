//
//  NetworkResponse.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 12/09/2021.
//

import Foundation
import Alamofire

struct NetworkResponse {

	// Properly checks and handles the status code of the response

	static func handleNetworkResponse(for resp: AFDataResponse<Any>?) -> Result<String> {

		guard let resp = resp, let res = resp.response else { return Result.failure(BooksRUsError.unwrappingError)}

		switch res.statusCode {
		case 200...299: return Result.success("Successful Network Response: \(res.statusCode)")
		case 401: return Result.failure(BooksRUsError.authenticationError)
		case 403: return Result.failure(BooksRUsError.forbiddenError)
		case 404: return Result.failure(BooksRUsError.resourceNotFound)
		case 400...499: return Result.failure(BooksRUsError.badRequest)
		case 500...599: return Result.failure(BooksRUsError.serverSideError)
		default: return Result.failure(BooksRUsError.failed)
		}
	}
}
