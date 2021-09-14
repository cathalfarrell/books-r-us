//
//  PersistencyService.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 13/09/2021.
//

import UIKit
import CoreData

class PersistencyService {

	static let shared = PersistencyService()

	weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

	// MARK: - Save books to Core Data

	func addBooks(books: [Book]) {

		guard let context = appDelegate?.persistentContainer.viewContext else {
			Log.e("Missing context")
			return
		}

		for book in books {
			let bookToStore = CDBook(context: context)
			bookToStore.id = Int64(book.id)
			bookToStore.title = book.title
			bookToStore.isbn = book.isbn
			bookToStore.desc = book.description
			bookToStore.author = book.author
			bookToStore.currencyCode = book.currencyCode
			bookToStore.price = book.price

			Log.v("Saving book with ID: \(book.id)")

			appDelegate?.saveContext()
		}
	}

	func updateBook(book: Book) {

		guard let context = appDelegate?.persistentContainer.viewContext else {
			Log.e("Missing context")
			return
		}

		let bookToStore = CDBook(context: context)
		bookToStore.id = Int64(book.id)
		bookToStore.title = book.title
		bookToStore.isbn = book.isbn
		bookToStore.desc = book.description
		bookToStore.author = book.author
		bookToStore.currencyCode = book.currencyCode
		bookToStore.price = book.price

		Log.v("Updating book with ID: \(book.id)")

		appDelegate?.saveContext()
	}

	func fetchAllBooks() -> [Book]? {
		var books = [Book]()

		let request = CDBook.fetchRequest() as NSFetchRequest<CDBook>

		guard let context = appDelegate?.persistentContainer.viewContext else {
			Log.e("Missing context")
			return nil
		}

		do {

			let result = try context.fetch(request)

			Log.v("CORE DATA fetchAllBooks: \(result.count) RESULTS")

			for item in result {
				let book = Book(id: Int(item.id),
								title: item.unwrappedTitle(),
								isbn: item.unwrappedISBN(),
								description: item.unwrappedDescription(),
								price: item.price,
								currencyCode: item.unwrappedCurrencyCode(),
								author: item.unwrappedAuthor()
				)
				books.append(book)
			}

			return books.count > 0 ? books : nil

		} catch let error as NSError {
			Log.e("Could not fetch. \(error), \(error.userInfo)")
		}

		return nil
	}

	func fetchBookDescription(for identifier: Int) -> String? {
		var bookDescription = ""

		let request = CDBook.fetchRequest() as NSFetchRequest<CDBook>
		// create an NSPredicate to get the instance you want to make change
		let predicate = NSPredicate(format: "id = %@", "\(identifier)")
		request.predicate = predicate

		guard let context = appDelegate?.persistentContainer.viewContext else {
			Log.e("Missing context")
			return nil
		}

		do {

			let result = try context.fetch(request)

			Log.v("CORE DATA fetchBookDescription: ID: \(identifier) - \(result.count) RESULTS")

			if result.count == 1, let book = result.first {
				bookDescription = book.unwrappedDescription()
			}

			return !bookDescription.isEmpty ? bookDescription : nil

		} catch let error as NSError {
			Log.e("Could not fetch. \(error), \(error.userInfo)")
		}

		return nil
	}

	func deleteAllPersistedBooks() {

		guard let context = appDelegate?.persistentContainer.viewContext else {
			Log.e("Missing context")
			return
		}

		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDBook")
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

		do {
			try context.executeAndMergeChanges(using: deleteRequest)
			Log.v("Deleted all persisted books")
		} catch let error as NSError {
			Log.e(error.localizedDescription)
		}
	}
}
extension NSManagedObjectContext {

	// MARK: - Batch Deletes Objects and immediately update the moc

	/// Executes the given `NSBatchDeleteRequest`
	/// and directly merges the changes to bring the given managed object context up to date.
	///
	/// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
	/// - Throws: An error if anything went wrong executing the batch deletion.

	public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
		batchDeleteRequest.resultType = .resultTypeObjectIDs
		let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
		let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
		NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
	}
}
