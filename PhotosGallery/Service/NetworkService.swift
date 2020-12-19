//
//  NetworkService.swift
//  PhotosGallery
//
//  Created by Сергей  Бей on 27.11.2020.
//

import Foundation

class NetworkService {
    
    func request(searchTerm: String, completionHandler: @escaping (Data?, Error?) -> (Void)) {
        let parameters = prepareParameters(searchTerm: searchTerm)
        let url = createURL(parameters: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTaskWith(request: request, completionHandler: completionHandler)
        task.resume()
    }
                
    private func prepareParameters(searchTerm: String) -> [String: String] {
        var params = [String: String]()
        params["query"] = searchTerm
        params["page"] = String(1)
        params["per_page"] = String(30)
        
        return params
    }
    
    private func prepareHeader() -> [String: String] {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID yGH4JnsAR4k3isP3sqfbdFypOg6lLUF9Lq93porQDmU"
        
        return headers
    }
    
    private func createURL(parameters: [String: String]) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/search/photos"
        urlComponents.queryItems = parameters.map({ (key: String, value: String) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        })
        
        return urlComponents.url!
        }

    private func createDataTaskWith(request: URLRequest,
                                    completionHandler: @escaping (Data?, Error?) -> (Void)) -> URLSessionDataTask {

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completionHandler(data, error)
            }
        }
        
        return dataTask
    }
    
}

