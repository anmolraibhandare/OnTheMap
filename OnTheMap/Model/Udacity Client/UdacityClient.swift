//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Anmol Raibhandare on 7/20/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
        static var firstName = ""
        static var lastName = ""
        static var key = ""
        static var ObjectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case signUp
        case getData
        case getStudentLocation
        case addStudentLocation
        case updateStudentLocation
        
        // String values of Endpoints including base and apiKeyParam
        var stringValue: String {
            switch self {
                
            case .login:
                return Endpoints.base + "/session"
        
            case .signUp:
                return "https://auth.udacity.com/sign-up"
                
            case .getData:
                return Endpoints.base + "/users/" + Auth.key
                
            case .getStudentLocation:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
                
            case .addStudentLocation:
                return Endpoints.base + "/StudentLocation"
                
            case .updateStudentLocation:
                return Endpoints.base + "/StudentLocation/" + Auth.ObjectId

            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Get Student Location (GET)
    
    class func getStudentLocation(completion: @escaping ([StudentLocation]?, Error?) -> Void){
        taskForGETRequest(url: Endpoints.getStudentLocation.url, apiType: "Parse", responseType: studentLocationResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
//
//    // MARK: Post Student Location (POST)
//
//    class func addStudentLocation(location: StudentLocation, completion: @escaping (Bool, Error?) -> Void){
//        let body = "{\"uniqueKey\": \(location.uniqueKey ?? "")\", \"firstName\": \"\(location.lastName)\", \"lastName\": \"\(location.firstName)\",\"mapString\": \"\(location.mapString ?? "")\", \"mediaURL\": \"\(location.mediaURL ?? "")\",\"latitude\": \(location.latitude ?? 0.0), \"longitude\": \(location.longitude ?? 0.0)}"
//        taskForPOSTRequest(url: Endpoints.addStudentLocation.url, apiType: "Parse", responseType: PostLocationResponse.self, body: body, httpMethod: "POST") { (response, error) in
//            if let response = response, response.createdAt != nil {
//                Auth.ObjectId = response.objectId ?? ""
//                completion(true, nil)
//            } else {
//                completion(false, error)
//            }
//        }
//    }
//
//    // MARK: Putting a Student Location (PUT)
//
//    class func updateStudentLocation(location: StudentLocation, completion: @escaping (Bool, Error?) -> Void){
//        let body = "{\"uniqueKey\": \(location.uniqueKey ?? "")\", \"firstName\": \"\(location.lastName)\", \"lastName\": \"\(location.firstName)\",\"mapString\": \"\(location.mapString ?? "")\", \"mediaURL\": \"\(location.mediaURL ?? "")\",\"latitude\": \(location.latitude ?? 0.0), \"longitude\": \(location.longitude ?? 0.0)}"
//        taskForPOSTRequest(url: Endpoints.updateStudentLocation.url, apiType: "Parse", responseType: UpdateLocationResponse.self, body: body,httpMethod: "PUT") { (response, error) in
//            if let response = response, response.updatedAt != nil {
//                completion(true, nil)
//            } else {
//                completion(false, error)
//            }
//        }
//    }
    
    // MARK: Login (POST)
    
    class func login(email: String, password: String, completion: @escaping (Bool,Error?) -> Void) {
        let body = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        taskForPOSTRequest(url: Endpoints.login.url, apiType: "Udacity", responseType: LoginResponse.self, body: body, httpMethod: "POST") { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.key = response.account.key
                getData { (success, error) in
                    if success{
                        print("Information obtained!")
                    }
                }
                completion(true, nil)
            } else {
                completion (false, nil)
            }
        }
    }
    
    // MARK: Get User data (GET)
    
    class func getData(completion: @escaping (Bool,Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getData.url, apiType: "Udacity", responseType: userDataResponse.self) { (response, error) in
            if let response = response{
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                print("First name: \(response.firstName) Last name: \(response.lastName) Nick name: \(response.nickName)")
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // MARK: Logout (DELETE)
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
    
   // MARK: Refactor GET and POST (Helper Functions)
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if apiType == "Udacity" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("application/json", forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil { // Handle error…
                        completion(nil, error)
                    }
                    guard let data = data else{
                        // DispatchQueue.main.async called to push the code in main thread
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                        return
                    }
                    do{
                        if apiType == "Udacity" {
                            let range = 5..<data.count
                            let newData = data.subdata(in: range)
                            let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                            DispatchQueue.main.async {
                                completion(responseObject, nil)
                            }
                        } else {
                            let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                            DispatchQueue.main.async {
                                completion(responseObject, nil)
                            }
                        }
                    } catch{
                        DispatchQueue.main.async {
                        completion(nil, error)
                        }
                    }
                }
            task.resume()
        }
    
    
    
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, body: String, httpMethod: String, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        if httpMethod == "POST" {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "PUT"
        }
        if apiType == "Udacity" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.httpBody = body.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil { // Handle error…
                completion(nil, error)
            }
            guard let data = data else{
                // DispatchQueue.main.async called to push the code in main thread
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do{
                if apiType == "Udacity" {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } else {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch{
                DispatchQueue.main.async {
                completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    
    
}


