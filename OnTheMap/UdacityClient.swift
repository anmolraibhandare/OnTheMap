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
        case logout
        case getStudentLocation
        case addlocation
        case updateLocation
        case facebookAuth
        
        
        // String values of Endpoints including base and apiKeyParam
        var stringValue: String {
            switch self {
                
            case .login:
                return Endpoints.base + "/session"
        
            case .signUp:
                return "https://auth.udacity.com/sign-up"
                
            case .getData:
                return Endpoints.base + "/users/" + Auth.key
                
            case .logout:
                return Endpoints.base + "/session"
                
            case .getStudentLocation:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
                
            case .addlocation:
                return Endpoints.base + "/StudentLocation"
                
            case .updateLocation:
                return Endpoints.base + "/StudentLocation/" + Auth.ObjectId
                
            case .facebookAuth:
                return ""

            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
//    // MARK: Get Student Location (GET)
//
//    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
//    let session = URLSession.shared
//    let task = session.dataTask(with: request) { data, response, error in
//      if error != nil { // Handle error...
//          return
//      }
//      print(String(data: data!, encoding: .utf8)!)
//    }
//    task.resume()
//
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
    
    class func login(email: String, password: String, completion: @escaping (Bool,Error) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
        
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
    
    // MARK: Get User data (GET)
    
    class func getData(email: String, password: String, completion: @escaping (Bool,Error) -> Void) {
        let request = URLRequest(url: Endpoints.login.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    // MARK: Logout (DELETE)
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
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
    
//    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try! JSONEncoder().encode(body)
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let data = data else{
//                // DispatchQueue.main.async called to push the code in main thread
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//                return
//            }
//            let decoder = JSONDecoder()
//            do{
//                let responseObject = try decoder.decode(ResponseType.self, from: data)
//                DispatchQueue.main.async {
//                    print(data)
//                    print(responseObject)
//                    completion(responseObject, nil)
//                }
//            } catch{
//                // Error Handling
//                do{
//                    let errorResponse = try decoder.decode(LoginResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(nil, errorResponse)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(nil, error)
//                    }
//                }
//            }
//        }
//        task.resume()
//
//        return task
//    }
//
//    class func taskForGETRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
//
//
//
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                // DispatchQueue.main.async called to push the code in main thread
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//                return
//            }
//            let decoder = JSONDecoder()
//            do {
//                let responseObject = try decoder.decode(ResponseType.self, from: data)
//                DispatchQueue.main.async {
//                    completion(responseObject, nil)
//                }
//            } catch {
//                // Error Handling
//                do{
//                    let errorResponse = try decoder.decode(ResponseType.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(nil, errorResponse)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(nil, error)
//                    }
//                }
//            }
//        }
//        task.resume()
//
//        return task
//    }
}
