//
//  NetworkManager.swift
//  KekaDemoApp
//
//  Created by Monalisa.Swain on 14/08/24.
//

import Foundation


class NetworkManager : ObservableObject {
    
//    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error Occurred while fetching data: \(error.localizedDescription)")
//                completion(.failure(error))
//                return
//            } else if let data = data {
//                do {
//                    let decodedData = try JSONDecoder().decode(T.self, from: data)
//                    completion(.success(decodedData))
//                } catch {
//                    print("Error occurred while parsing the data: \(error.localizedDescription)")
//                    completion(.failure(error))
//                }
//            }
//        }.resume()
//    }
    
    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("Error occurred while parsing the data: \(error.localizedDescription)")
            throw error
        }
    }
    
}
