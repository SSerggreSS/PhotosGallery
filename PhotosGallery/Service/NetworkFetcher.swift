//
//  NetworkFetcher.swift
//  PhotosGallery
//
//  Created by Сергей  Бей on 28.11.2020.
//

import Foundation

class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    func fetchImages(searchTerm: String, completion: @escaping (Page?) -> Void) {
        networkService.request(searchTerm: searchTerm) { (data, error) -> (Void) in
            if let error = error {
                completion(nil)
                fatalError("Error: \(error.localizedDescription) in \(#function)")
            }
            
            let decode = self.decodeJSON(type: Page.self, from: data)
            completion(decode)
        }
        
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        
        guard let data = from else { return nil }
        let decoder = JSONDecoder()
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print("Failed to decode JSON \(error.localizedDescription)")
            
            return nil
        }
    
    }
    
}
