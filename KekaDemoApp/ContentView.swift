//
//  ContentView.swift
//  KekaDemoApp
//
//  Created by Monalisa.Swain on 14/08/24.
//

import SwiftUI
import CoreData


//Create an iOS project that need to be display a tableview with the data from url: https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM
// 
//Details To display  (image mandatory rest any 1 / 2)
//
//title
//Description
//Date
//Image
// 
//Keys in response for above details
//
//Description - abstract
//Title - headline -> main
//Date - pub_date
//image - multimedia - 0 - url
// 
// 
//Things to follow
// 
//Should use generics.
//Code should be protocol oriented
//Should follow standards
//Use higher order functions
//Use solid principles
// 
//Create a core data model and  an entity for the response and save the data in it. If network is disabled should load data from core data.
// 
//Show the date in format of March 2024 and sort them as newest date should be on top.
// 
//Usage of coreData would be a plus.

struct ContentView: View {
    @StateObject var viewModel = ArticleListViewModel()
    
    var body: some View {
        List(viewModel.articleDataList, id: \.title.main) { article in
            VStack(alignment: .leading) {
                if let imageUrl = article.image?.first?.url {
                    AsyncImage(url: URL(string: "https://www.nytimes.com/\(imageUrl)")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                    } placeholder: {
                        Image(systemName: "photo.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                        
                    }
                }
                Text(article.title.main)
                    .font(.headline)
                
                Text(article.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(article.formattedDate)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .onAppear {
            if !Reachability.isConnectedToNetwork() {
                viewModel.loadFromCoreData()
            }
        }
    }
}
