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
        case addlocation
        case updateLocation
        
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
                
            case .addlocation:
                return Endpoints.base + "/StudentLocation"
                
            case .updateLocation:
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

//    // MARK: Post Student Location (POST)
//
//    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
//    request.httpMethod = "POST"
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
//    let session = URLSession.shared
//    let task = session.dataTask(with: request) { data, response, error in
//      if error != nil { // Handle error…
//          return
//      }
//      print(String(data: data!, encoding: .utf8)!)
//    }
//    task.resume()
//
//    // MARK: Putting a Student Location (PUT)
//
//    let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/8ZExGR5uX8"
//    let url = URL(string: urlString)
//    var request = URLRequest(url: url!)
//    request.httpMethod = "PUT"
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
//    let session = URLSession.shared
//    let task = session.dataTask(with: request) { data, response, error in
//      if error != nil { // Handle error…
//          return
//      }
//      print(String(data: data!, encoding: .utf8)!)
//    }
//    task.resume()
    
    // MARK: Login (POST)
    
    class func login(email: String, password: String, completion: @escaping (Bool,Error?) -> Void) {
        let body = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        taskForPOSTRequest(url: Endpoints.login.url, apiType: "Udacity", responseType: LoginResponse.self, body: body) { (response, error) in
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
        }
        task.resume()
    }
    
    
   // MARK: Refactor GET and POST (Helper Functions)
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if apiType == "Udacity" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
                
            return task
        }
    

    
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, body: String, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
        
        return task
    }
}


