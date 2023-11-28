//
//  API.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import Foundation

struct Card: Codable, Identifiable {
    var COMENTARIOS: String
    var DIRECCION: String
    var ESTATUS_PAGO: Int
    var FECHA_PAGO: String
    var ID_DONANTE: Int
    var ID_RECIBO: String
    var IMPORTE: Float
    var NOMBRE_DONANTE: String
    var REFERENCIA_DOMICILIO: String
    var TEL_CASA: String
    var TEL_MOVIL: String
    var USUARIO_RECOLECTOR: String
    var id: Int
   
}

func loginManager(username: String, password: String, completion: @escaping (Int) -> Void) {
    
    let apiUrl = URL(string: "https://equipo17.tc2007b.tec.mx:8443/loginManager")!
    
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
                            if let token = json["token"] as? String {
                                UserDefaults.standard.setValue(token, forKey: "token")
                            }
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

func callApi() -> [Card] {
    var cards: [Card] = []
    
    print("Entering API")
    
    guard let url = URL(string: "https://equipo17.tc2007b.tec.mx:8443/recibosManager") else {
        return cards
    }
    
    let group = DispatchGroup()
    group.enter()
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let token = UserDefaults.standard.string(forKey: "token")
    request.setValue(token, forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        let jsonDecoder = JSONDecoder()
        if let data = data {
            do {
                let cardList = try jsonDecoder.decode([Card].self, from: data)
                
                print("List: \(cardList)")
                
                for cardItem in cardList {
                    print("Id: \(cardItem.id) - Address: \(cardItem.DIRECCION)")
                }
                cards = cardList
            } catch {
                print(error)
            }
            
            if let datosAPI = String(data: data, encoding: .utf8) {
                print(datosAPI)
            }
        } else {
            print("No data")
        }
        group.leave()
    }
    
    task.resume()
    group.wait()
    
    print("******************************************")
    print("List2: \(cards)")
    
    return cards
}

var listaCards = callApi()
