//
//  SelfConfiguringCell.swift
//  RecipesInMotion
//
//  Created by Cathal Farrell on 03/09/2021.
//

import Foundation

//// Useful to define the reuseidentifier in just one place, and reference it from the cell

protocol SelfConfiguringCell {
	static var reuseIdentifier: String { get }
}
