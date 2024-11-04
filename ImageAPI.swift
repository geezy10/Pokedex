//
//  ImageAPI.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 04.11.24.
//

import Foundation

class ImageAPI {
    func getData(url:String, completion: @escaping(Data?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
