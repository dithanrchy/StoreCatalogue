//
//  APIHelper.swift
//  StoreData
//
//  Created by Ditha Nurcahya Avianty on 05/01/23.
//

import Alamofire
import Foundation

class APIHelper {
    static let shared = APIHelper()

    func login(username: String, password: String, completionHandler: @escaping (Result<[StoreDatum], AFError>) -> Void) {
        guard let url = URL(string: "https://dev.pitjarus.co/api/sariroti_md/index.php/login/loginTest") else { return }
        let body: [String: String] = [
            "username": username,
            "password": password,
        ]

        AF.request(url, method: .post, parameters: body).validate().responseDecodable(of: StoresResponse.self) { response in
            switch response.result {
            case let .success(value):
                completionHandler(.success(value.stores))
            case let .failure(error):
                print(error)
                completionHandler(.failure(error.asAFError(orFailWith: "Failed to Login")))
            }
        }
    }
}
