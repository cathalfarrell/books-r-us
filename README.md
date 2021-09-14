# BooksRUs
A little simple UIKit & SwiftUI Books List example app that demonstrates network requests, 
unit testing, clean swift architecture, Lottie animation and Core Data. The network requests
are extremely slow so I thought it would be best to use Core Data to get them and store them.

##Installation
Download the code and open the .xcodeproj file in Xcode
Check that the dependencies Alamofire and Lottie are installed via Swift Package Manager, or update it if not.
Install Swiftlint if you want to check for Swiftlint warnings.

### How to use
* On first launch it should get the books fresh from the api end-point and load them into Core Data
* On each subsequent launch it should display any stored books if previously loaded
* You can simply pull to refresh to request the books fresh from the network

### Architecture
Though probably over-kill for a small test app, I have demonstrated Clean Swift architecture.

### Unit Tests
I have included a few unit tests for demonstration purposes, though there are probably many more
that I could have included, so it is not exhaustive.

### Services
You shall find the network calls to get the books and the call to get the book detail (including description)
in BookService the services folder.
You shall also find the PersistencyService that manages the Core Data functionality to store the books
the services folder.

### Final Notes
* I used UKit for the list screen and then SwiftUI for the detail screen just to demonstrate both
* I added in error handling too and re-used the swiftUI error view inside the UIKit View Controller also.
