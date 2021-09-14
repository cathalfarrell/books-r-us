//
//  AppDelegate.swift
//  BooksRUs
//
//  Created by Cathal Farrell on 10/09/2021.
//
// swiftlint:disable vertical_parameter_alignment
//
// App Icon Image is free to use under the Creative Commons Attribution-Share Alike 4.0 International license.:
// AlekseyP8, CC BY-SA 4.0 <https://creativecommons.org/licenses/by-sa/4.0>, via Wikimedia Commons
// https://commons.wikimedia.org/wiki/File:Book-icon-bible.png

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication,
					 configurationForConnecting connectingSceneSession: UISceneSession,
					 options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
	}

	// MARK: - Core Data for persistence

	lazy var persistentContainer: NSPersistentContainer = {
			/*
			 The persistent container for the application. This implementation
			 creates and returns a container, having loaded the store for the
			 application to it. This property is optional since there are legitimate
			 error conditions that could cause the creation of the store to fail.
			 */
			let container = NSPersistentContainer(name: "BookCoreDataModel")
			container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy // Merges duplicates
			container.loadPersistentStores(completionHandler: { (_, error) in
				if let error = error as NSError? {
					fatalError("Unresolved error \(error), \(error.userInfo)")
				}
			})
			return container
		}()

		// MARK: - Core Data Saving support

		func saveContext () {
			let context = persistentContainer.viewContext
			if context.hasChanges {
				do {
					try context.save()
				} catch {
					let nserror = error as NSError
					fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
				}
			}
		}

}
