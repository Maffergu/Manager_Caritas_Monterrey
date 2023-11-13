//
//  API.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import Foundation

struct Recolector {
    let message: String
}

func loginManager(username: String, password: String, completion: @escaping (Int) -> Void) {
    
    let apiUrl = URL(string: "http://10.14.255.85:8085/loginManager")!
    
    let parameters: [String: Any] = [
        "USUARIO": username,
        "PASS": password
    ]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                let userID = 2
                completion(2)
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = (json["message"] as? String) ?? ""
                        if (message == "Authentication successful") {
                            let userID = 1
                            completion(1)
                        } else {
                            let userID = 0
                            completion(0)
                        }
                    } else {
                        print("Error: Unable to parse API response as JSON.")
                        completion(0) // or handle the error in a way that makes sense for your application
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                    completion(0)
                }
            }
        }
        task.resume()
    } catch {
        print("Error encoding JSON: \(error)")
        completion(0)
    }
}
