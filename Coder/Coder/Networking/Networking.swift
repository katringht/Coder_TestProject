//
//  Networking.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 07.11.2021.
//

import Foundation

class NetworkingService {
    
    static let shared = NetworkingService()
    private init() {}
    
    let headers = ["Content-Type": "application/json", "Prefer": "code=200, example=success"]
    lazy var endPoint: String = {
        return "https://stoplight.io/mocks/kode-education/trainee-test/25143926/users"
    } ()
    
    func getDataWith(completion: @escaping (Result<[User]>) -> Void){
        
        let request = NSMutableURLRequest(url: URL(string: endPoint)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else {
                return completion(.Error(error!.localizedDescription))
            }
            guard let data = data else {
                return completion(.Error("There are no new Items to show"))
            }
            
                let decoder = JSONDecoder()
                if let jsonUser = try? decoder.decode(Users.self, from: data) {
                    DispatchQueue.global().async {
                        completion(.Success(jsonUser.items))
                    }
                }
        }.resume()
    }
}
