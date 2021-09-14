//
//  Result.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 10/09/2021.
//  Copyright © 2021 BooksRUs. All rights reserved.
//

import Foundation

enum Result<T> {

	case success(T)
	case failure(Error)
}
