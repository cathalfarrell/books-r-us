//
//  BooksListViewController.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 10/09/2021.
//  Copyright (c) 2021 BooksRUs. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SwiftUI
import Lottie

protocol BooksListDisplayLogic: AnyObject {
	func displayStoredBooks(viewModel: BooksList.FetchBooks.ViewModel)
	func displayStoredBooksError(viewModel: BooksList.FetchBooks.ViewModel)
	func displayBooks(viewModel: BooksList.FetchBooks.ViewModel)
	func displayError(viewModel: BooksList.FetchBooks.ViewModel)
}

class BooksListViewController: UIViewController, BooksListDisplayLogic {

	var books: [Book] = [Book]()

	var interactor: BooksListBusinessLogic?
	var router: (NSObjectProtocol & BooksListRoutingLogic & BooksListDataPassing)?

	private let refreshControl = UIRefreshControl()
	private var loadingAnimationView: AnimationView!

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var errorView: UIView!
	@IBOutlet weak var errorHeightConstraint: NSLayoutConstraint!

	// MARK: Object lifecycle

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	// MARK: Setup

	private func setup() {
		let viewController = self
		let interactor = BooksListInteractor()
		let presenter = BooksListPresenter()
		let router = BooksListRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}

	// MARK: Routing

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let scene = segue.identifier {
			let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
			if let router = router, router.responds(to: selector) {
				router.perform(selector, with: segue)
			}
		}
	}

	// MARK: View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Books R Us"

		fetchAllStoredBooks()
		setupTable()
		setupPullToRefresh()

	}

	fileprivate func setupTable() {
		let cellNib = UINib(nibName: "BookTableViewCell", bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: BookTableViewCell.reuseIdentifier)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = .black
	}

	fileprivate func setupPullToRefresh() {
		// Add Refresh Control to Table View
		refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
		refreshControl.tintColor = UIColor.white
		refreshControl.attributedTitle = NSAttributedString(string: "Fetching Books...", attributes: nil)
		tableView.refreshControl = refreshControl
	}

	// MARK: Fetch Books From Storage (if any)

	func fetchAllStoredBooks() {
		hideErrorView()
		let request = BooksList.FetchBooks.Request()
		interactor?.fetchAllStoredBooks(request: request)
	}

	// MARK: Fetch Books From Network

	func fetchAllBooksFreshFromNetwork() {
		startLoadingAnimation()
		hideErrorView()
		let request = BooksList.FetchBooks.Request()
		interactor?.fetchBooks(request: request)
	}

	// MARK: Pull To Refresh

	@objc private func refreshData(_ sender: Any) {
		// Clear out persisted books so that I can get the data fresh
		PersistencyService.shared.deleteAllPersistedBooks()
		fetchAllBooksFreshFromNetwork()
	}

	// MARK: Display Books From Storage

	func displayStoredBooks(viewModel: BooksList.FetchBooks.ViewModel) {

		self.books = viewModel.books

		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}

	// MARK: Display Books From Network

	func displayBooks(viewModel: BooksList.FetchBooks.ViewModel) {

		self.books = viewModel.books

		DispatchQueue.main.async {
			self.stopLoadingAnimation()
			self.refreshControl.endRefreshing()
			self.tableView.reloadData()
		}
	}

	// MARK: Display Error

	func displayError(viewModel: BooksList.FetchBooks.ViewModel) {
		if let errorMessage = viewModel.errorMessage {
			DispatchQueue.main.async {
				self.stopLoadingAnimation()
				self.refreshControl.endRefreshing()
				self.showErrorView(with: errorMessage)
			}
		}
	}

	// MARK: Display Stored Book Error

	func displayStoredBooksError(viewModel: BooksList.FetchBooks.ViewModel) {

		// If I get any error in trying to retrieve stored results, incuding no results
		// I'll just fetch the results fresh

		if let errorMessage = viewModel.errorMessage {
			Log.e(errorMessage)
			fetchAllBooksFreshFromNetwork()
		}
	}
}
extension BooksListViewController {

	// MARK: - Error Handling

	fileprivate func hideErrorView() {
		self.errorView.viewWithTag(999)?.removeFromSuperview()
		self.errorHeightConstraint.constant = 0 // hides view by decreasing to zero
	}

	fileprivate func showErrorView(with errorString: String) {

		// Here I am using a SwiftUI View inside UIKit, it allows me to reuse the same error view

		let errorViewController = UIHostingController(
			rootView: ErrorView(errorString: .constant(errorString), onButtonTap: {
				self.fetchAllBooksFreshFromNetwork()
			})
		)

		errorViewController.view.tag = 999 // use this tag to allow removal later
		errorViewController.view.frame = errorView.bounds
		errorViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		errorView.addSubview(errorViewController.view)

		self.errorHeightConstraint.constant = 220 // reveals view by increasing view height
	}

}
extension BooksListViewController {

	// MARK: - Loading Animation from Lottie

	func startLoadingAnimation() {

		let lottieFileName = "5-dots-lottie-animation"
		let midX = UIScreen.main.bounds.midX
		let midY = UIScreen.main.bounds.midY
		let size: CGFloat = 100
		let offset: CGFloat = size/2

		if loadingAnimationView == nil {

			loadingAnimationView = AnimationView(name: "LoadingAnimation")
			loadingAnimationView.frame = CGRect(x: midX-offset, y: midY, width: size, height: size)
			loadingAnimationView.loopMode = .loop

			if let animation = Animation.named(lottieFileName) {
				loadingAnimationView.animation = animation
			} else {
				fatalError("missing lottie animation: \(lottieFileName)")
			}
		}

		DispatchQueue.main.async {
			self.view.addSubview(self.loadingAnimationView)
			self.loadingAnimationView.play()
		}
	}

	func stopLoadingAnimation() {
		if let animation = loadingAnimationView {
			DispatchQueue.main.async {
				animation.stop()
				animation.removeFromSuperview()
			}
		}
	}
}
extension BooksListViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		// Open SwiftUI detail view
		let view = BookDetailView(book: self.books[indexPath.row])
		let hostVC = UIHostingController(rootView: view)
		navigationController?.pushViewController(hostVC, animated: true)
	}
}
extension BooksListViewController: UITableViewDataSource {

	// MARK: - Table view data source

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return books.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard
			let bookTableViewCell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reuseIdentifier,
																  for: indexPath) as? BookTableViewCell else {
			Log.e("Failed to find ingredientTableViewCell to dequeue")
			return UITableViewCell()
		}
		DispatchQueue.main.async {
			bookTableViewCell.configure(for: self.books[indexPath.row])
		}

		return bookTableViewCell
	}
}
