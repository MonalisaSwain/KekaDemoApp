//
//  ArticleListViewModel.swift
//  KekaDemoApp
//
//  Created by Monalisa.Swain on 14/08/24.
//

import Foundation

class ArticleListViewModel : ObservableObject {
    let articleDataURL = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM"
    private let netwokManager: NetworkManager
    private let coreDataManager = CoreDataManager.shared
    @Published var articleDataList = [Article]()
    
    
    init(netwokManager: NetworkManager = NetworkManager())  {
        self.netwokManager = netwokManager
        Task {
            await fetchArticlesListData()
        }
    }
    
    func fetchArticlesListData() async {
        guard let url = URL(string: articleDataURL) else { return }
        do {
            let articleResponse: ArticleResponse = try await netwokManager.fetchData(from: url)
            print("Fetched Articles: \(articleResponse)")
            
            await MainActor.run {
                // Sort the articles by date
                self.articleDataList = articleResponse.response.docs.sorted(by: {
                    let formatter = ISO8601DateFormatter()
                    let date1 = formatter.date(from: $0.date) ?? Date()
                    let date2 = formatter.date(from: $1.date) ?? Date()
                    return date1 > date2
                })
                
                // Save data to Core Data
                articleResponse.response.docs.forEach { articleData in
                    let dateFormatter = ISO8601DateFormatter()
                    if let date = dateFormatter.date(from: articleData.date) {
                        self.coreDataManager.saveArticle(
                            title: articleData.title.main,
                            abstract: articleData.description,
                            pubDate: date,
                            imageURL: articleData.image?.first?.url ?? ""
                        )
                    }
                }
            }
        } catch {
            print("Error in fetch articles: \(error)")
        }
    }
    
    func loadFromCoreData() {
        let savedArticles = coreDataManager.fetchArticles()
        self.articleDataList = savedArticles.map {
            Article(
                title: Headline(main: $0.title ?? ""),
                description: $0.articleDescription ?? "",
                date: ISO8601DateFormatter().string(from: $0.articleDate!),
                image: [Multimedia(url: $0.image ?? "")]
            )
        }
    }
}
