//
//  BooksRUsError.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 12/09/2021.
//

import Foundation

// MARK: - Possible errors to encounter during Network Request

public enum BooksRUsError: Error {

	case responseStatusError(status: Int, message: String)
	case parametersNil
	case headersNil
	case encodingFailed
	case decodingFailed
	case missingURL
	case couldNotParse
	case noData
	case fragmentResponse
	case unwrappingError
	case dataTaskFailed
	case authenticationError
	case badRequest
	case resourceNotFound
	case failed
	case serverSideError
	case forbiddenError
}

// MARK: - Custom user-friendly messages to display these errors to end-user

extension BooksRUsError: LocalizedError {

	public var errorDescription: String? {

		let errorString = "Error:"

		switch self {
		case let .responseStatusError(status, message):
			return "\(errorString) \(status): \(message)"
		case .parametersNil:
			return "\(errorString) Parameters are nil."
		case .headersNil:
			return "\(errorString) Headers are Nil"
		case .encodingFailed:
			return "\(errorString) Parameter Encoding failed."
		case .decodingFailed:
			return "\(errorString) Unable to Decode the data."
		case .missingURL:
			return "\(errorString) The URL is nil."
		case .couldNotParse:
			return "\(errorString) Unable to parse the JSON response."
		case .noData:
			return "\(errorString) The data from API is Nil."
		case .fragmentResponse:
			return "\(errorString) The API's response's body has fragments."
		case .unwrappingError:
			return "\(errorString) Unable to unwrap the data."
		case .dataTaskFailed:
			return "\(errorString) The Data Task object failed."
		case .authenticationError:
			return "\(errorString) You must be Authenticated"
		case .badRequest:
			return "\(errorString) Bad Request"
		case .resourceNotFound:
			return "\(errorString) Resource requested not found."
		case .failed:
			return "\(errorString) Network Request failed"
		case .serverSideError:
			return "\(errorString) Server error"
		case .forbiddenError:
			return "\(errorString) You don't have permission to access this server."
		}
	}
}
