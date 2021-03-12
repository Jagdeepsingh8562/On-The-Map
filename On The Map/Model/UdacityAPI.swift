//
//  UdacityAPI.swift
//  On The Map
//
//  Created by Jagdeep Singh on 04/03/21.
//

import Foundation
import UIKit

class UdacityAPI {
    struct Auth {
       static var key: String = ""
        static var students = [Student]()
        static var objectId: String = ""
        static var firstName = ""
        static var lastName = ""
        static var createdAt: String = ""
        static var updatedAt: String = ""
        static var student: Student!
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case session
        case getUser(String)
        case getstudentLocation
        case postStudentLocation
        case putStudentLocation(String)
        case webAuth
        
        var stringValue: String {
            switch self {
            case .session: return Endpoints.base + "session"
            case .getUser(let user): return Endpoints.base + "users/\(user)"
            case .getstudentLocation: return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"
            case .putStudentLocation(let objectId): return Endpoints.base + "StudentLocation/\(objectId)"
            case .webAuth: return "https://auth.udacity.com/sign-in?next=https://classroom.udacity.com/authenticated"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    class func getStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getstudentLocation.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{
                completion(false,nil)
                return
            }
            do {
            let responseObject =  try JSONDecoder().decode(StudentResponse.self, from: data)
                DispatchQueue.main.async {
                Auth.students = responseObject.results
                completion(true,nil)
            }
            }catch {
                print(error)
                completion(false,nil)
            }
        }
        task.resume()
    }
    class func postStudentLocationRe(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double,completion: @escaping (Bool, Error?) -> Void)
    {
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostLocationResponse.self, body: LocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)) { (responseObject, error) in
            
            guard let responseObject = responseObject else {
                    completion(false , error)
                return
            }
                Auth.objectId = responseObject.objectID
                Auth.createdAt = responseObject.createdAt
                completion(true,nil)
            }
        }
   
    
    
    class func putStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double,completion: @escaping (Bool, Error?) -> Void){
        taskForPOSTRequest(url: Endpoints.putStudentLocation(Auth.objectId).url, responseType: PutLocationResponse.self, body: LocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)) { (responseObject, error) in
            guard let responseObject = responseObject else {
                completion(false , error)
                return
            }
            Auth.updatedAt = responseObject.updatedAt
            completion(true,nil)
        }
    }
   
    class func loginRequest(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.session.url, responseType: SessionResponse.self, body: Credentails(udacity: Udacity(username: username, password: password))) { (response, error) in
            guard let response = response else {
                completion(false,error)
                return
            }
            Auth.key = response.account.key
            getLoggedInUser { (success, error) in
                if success {
                    print("User info fecthed successfully")
                }
            }
            completion(true,nil)
        }
    }
    class func getLoggedInUser(completion: @escaping (Bool, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getUser(Auth.key).url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            completion(false,error)
              return
          }
          let range = 5..<data.count
          let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(UserResponse.self, from: newData)
                Auth.firstName = responseObject.firstName
                Auth.lastName = responseObject.lastName
            } catch {
                print("error failed to fecthed User info")
            }
        }
        task.resume()
    }
    class func logoutRequest(completion: @escaping (Bool ,Error? ) -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
            DispatchQueue.main.async {
            completion(true, nil)
            }
        }
        task.resume()

    }
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        var request = URLRequest(url: url)
        if responseType.self == PutLocationResponse.self {
            request.httpMethod = "PUT"        }
        else {
            request.httpMethod = "POST" }
        request.addValue("application/json", forHTTPHeaderField: "Accept")//changess
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = body
        do {
            request.httpBody = try JSONEncoder ().encode(body)
            let postTask =  URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard var data = data else {
                    DispatchQueue.main.async {
                        completion(nil,error)
                    }
                    return
                }
                let decoder = JSONDecoder()
                do {
                    if responseType.self == SessionResponse.self{
                        let range = 5..<data.count
                        data = data.subdata(in: range)
                    }
                    let respon = try decoder.decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(respon,nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error) }
                }
            }
            postTask.resume()
            
        } catch {
            print(error)
        }
    }
}
