//
//  Client.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 07/05/2025.
//

import Foundation

class Client {
    static let port = 8080
    static let baseURL = "http://localhost:\(port)/"
    
    
    func info(completion: @escaping (Pizzeria?) -> Void) {
        let path = "\(Client.baseURL)pizza"
        
        guard let url = URL(string: path) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            do {
                let pizza = try JSONDecoder().decode(Pizzeria.self, from: data)
                completion(pizza)
            } catch {
                print("Error decoding data:\(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // return list of categories that includes items
    func menu(completion: @escaping (MenuResponse?) -> Void) {
        let path = "\(Client.baseURL)menu"
        
        guard let url = URL(string: path) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            do {
                let menu = try JSONDecoder().decode(MenuResponse.self, from: data)
                completion(menu)
            } catch {
                print("Error decoding data:\(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func checkout(cart: [MenuItem], completion: @escaping (Bool) -> Void) {
        let path = "\(Client.baseURL)order"
        
        guard let url = URL(string: path) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        do {
            request.httpBody = try JSONEncoder().encode(cart)
        } catch {
            print("Error encoding data:\(error.localizedDescription)")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let _ = data else {
                completion(false)
                return
            }
            
            if let error = error {
                print("Error posting data: \(error)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    completion(true)
                }
            }
        }
        
        task.resume()
    }
    
}
