//
//  BookDetailView.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 11/09/2021.
//

import SwiftUI

struct BookDetailView: View {

	@State var book: Book
	@State var errorString: String = ""
	@State var bookDescription: String = ""
	@State var makingApiCall: Bool = false

	var body: some View {
		VStack {
			Form {

				// MARK: - Image Header

				HStack(spacing: 0) {
					Spacer()
					Image(uiImage: book.getImage())
						.resizable()
						.frame(width: 100, height: 150)
						.cornerRadius(10)
						.shadow(radius: 5)
						.padding()
					Spacer()
				}

				// MARK: - Error View

				if !errorString.isEmpty {
					ErrorView(errorString: self.$errorString) {
						self.getBookDescription(for: self.book)
					}
				}

				// MARK: - Details Section

				Section {
					HStack(alignment: .top) {
						Text("\(book.title)")
							.font(.headline)
					}
					HStack {
						Text("ISBN:")
						Spacer()
						Text("\(book.isbn)")
							.font(.subheadline)
					}
					HStack {
						Text("Price:")
						Spacer()
						Text("\(book.getDisplayPrice())")
							.font(.subheadline)
					}
				}

				// MARK: - Description Section

				Section {
					HStack {
						Text("Description:")
						Spacer()
					}
					VStack {
						if makingApiCall && book.description == nil {
							ProgressView()
						} else {
							Text("\(book.description ?? "")")
								.font(.subheadline)
						}
					}
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.onAppear(perform: {
			getBookDescription(for: self.book)
		})
		.navigationTitle("Book Detail")
	}

	fileprivate func getBookDescription(for book: Book) {

		if let descriptionPersisted = PersistencyService.shared.fetchBookDescription(for: self.book.id) {
			self.book.description = descriptionPersisted
		}

		self.makingApiCall = true

		BooksService.shared.getBook(with: book.id) { response in
			switch response {
			case .success(let book):
				self.book = book
				PersistencyService.shared.updateBook(book: book)
			case .failure(let error):
				self.errorString = error.localizedDescription
			}

			self.makingApiCall = false
		}
	}
}

struct BookDetailView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			BookDetailView(book: Book.testBook)
			BookDetailView(book: Book.testBook, errorString: "Oops, well this is awkward.")
		}
	}
}
