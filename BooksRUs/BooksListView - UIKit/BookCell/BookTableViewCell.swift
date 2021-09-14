//
//  BookTableViewCell.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 10/09/2021.
//

import UIKit

class BookTableViewCell: UITableViewCell, SelfConfiguringCell {
	static var reuseIdentifier = "bookCell"

	@IBOutlet weak var bookImageView: UIImageView!
	@IBOutlet weak var bookName: UILabel!
	@IBOutlet weak var bookAuthor: UILabel!
	@IBOutlet weak var bookCostPrice: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

}
extension BookTableViewCell {
	func configure(for book: Book) {
		bookName.text = book.title
		bookAuthor.text = book.author
		bookImageView.image = book.getImage()
		bookCostPrice.text = book.getDisplayPrice()
	}
}
