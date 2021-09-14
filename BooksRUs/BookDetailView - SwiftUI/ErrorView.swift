//
//  ErrorView.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 11/09/2021.
//

import SwiftUI

struct ErrorView: View {

	@Binding var errorString: String

	var onButtonTap = {} // callback for tap of button

	var body: some View {
		VStack(alignment: .center) {
			Text(errorString)
				.padding(16)
				.frame(maxWidth: .infinity)
				.background(Color.red)
				.foregroundColor(.white)
				.font(.body)
				.multilineTextAlignment(.center)
				.cornerRadius(5)

			Button("Try Again") {
				onButtonTap()
			}
			.foregroundColor(.accentColor)
			.padding()
		}
		.padding(.vertical, 16)
		.buttonStyle(PlainButtonStyle())
	}
}

struct ErrorView_Previews: PreviewProvider {
	static var previews: some View {
		ErrorView(errorString: .constant("Whoops, scarlet"))
			.frame(width: 375, height: 200)
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
