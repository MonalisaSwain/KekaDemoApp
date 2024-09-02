//
//  CoreDataManager.swift
//  KekaDemoApp
//
//  Created by Monalisa.Swain on 14/08/24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KekaDemoApp")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchArticles() -> [ArticleItem] {
        let request: NSFetchRequest<ArticleItem> = ArticleItem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "articleDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Failed to fetch articles: \(error)")
            return []
        }
    }
    
    func saveArticle(title: String, abstract: String, pubDate: Date, imageURL: String) {
        let context = persistentContainer.viewContext
        let article = ArticleItem(context: context)
        article.title = title
        article.articleDescription = abstract
        article.articleDate = pubDate
        article.image = imageURL
        
        saveContext()
    }
    
    func deleteArticle(title: String, abstract: String, pubDate: Date, imageURL: String) {
        let context = persistentContainer.viewContext
        let article = ArticleItem(context: context)
        article.title = title
        article.articleDescription = abstract
        article.articleDate = pubDate
        article.image = imageURL
        context.delete(article)
        saveContext()
    }
    
}
