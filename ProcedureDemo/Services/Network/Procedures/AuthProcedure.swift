//
//  AuthProcedure.swift
//  ProcedureDemo
//
//  Created by Daniel Dorozhkin on 02/01/2022.
//

import Foundation
import ProcedureKit
import Alamofire

class AuthProcedure: Procedure, OutputProcedure {
    var output : Pending<ProcedureResult<String>> = .pending
    
    override func execute() {
        getToken { token in
            if let token = token {
                self.output = .ready(.success(token))
            } else {
                self.cancel()
            }
            
            self.finish()
        }
    }
    
    private func getToken(_ compilation: @escaping (String?) -> Void) {
        let url = "https://www.universal-tutorial.com/api/getaccesstoken"
        let headers = getAuthHeaders()
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).response { data in
            guard let data = data.data else {
                compilation(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let auth = try decoder.decode(AuthResponse.self, from: data)
                
                let token = "Rk6_2E0MRdzZwq3BiOPGhnX_wHmDO1mXMm971uGQEDmpwhuFqW7z0zJ-zi0efAVsUZU \(auth.key)"
                
                compilation(token)
            } catch {
                compilation(nil)
            }
        }
    }
    
    private func getAuthHeaders() -> HTTPHeaders {
        let token = "Rk6_2E0MRdzZwq3BiOPGhnX_wHmDO1mXMm971uGQEDmpwhuFqW7z0zJ-zi0efAVsUZU"
        let mail = "danield@gini-apps.com"
        
        let headers : HTTPHeaders = [
            "Accept": "application/json",
            "api-token": token,
            "user-email": mail
        ]
        
        return headers
    }
}

struct AuthResponse : Decodable {
    let key : String
    
    enum CodingKeys: String, CodingKey {
        case key = "auth_token"
    }
}
