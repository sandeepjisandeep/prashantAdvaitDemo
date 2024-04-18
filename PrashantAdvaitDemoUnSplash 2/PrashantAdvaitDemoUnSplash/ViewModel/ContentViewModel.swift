//
//  ContentViewModel.swift
//  PrashantAdvaitDemoUnSplash
//
//  Created by Sandeep Srivastava on 18/04/24.
//

import Foundation
import UIKit

class PhotoViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var isLoading: Bool = false
    
    private var imageCache: [String: UIImage] = [:]
    private let itemsPerPage = 10
    private let unsplashAPIKey = "pQXEsWiBshvcAR1lOyaqOwidFHorNSaWJd9Yha1MWR8"
    
    func loadPhotos() {
        guard !isLoading else { return }
        isLoading = true
        
        let urlString = "https://api.unsplash.com/photos/random?count=\(itemsPerPage)&client_id=\(unsplashAPIKey)"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    self.isLoading = false
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let jsonArray = json as? [[String: Any]] else {
                        print("Invalid JSON format")
                        self.isLoading = false
                        return
                    }
                    let urls = jsonArray.compactMap { $0["urls"] as? [String: String] }
                    let regularUrls = urls.compactMap { $0["regular"] }
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: regularUrls.map { Photo(imageUrl: $0) })
                        self.isLoading = false
                    }
                } catch {
                    print("Decoding error: \(error)")
                    self.isLoading = false
                }
            }.resume()
        } else {
            print("Invalid URL")
            self.isLoading = false
        }
    }
    
    func getImage(for urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache[urlString] {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                self.imageCache[urlString] = image
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
