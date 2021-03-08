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
       static var user: String = ""
        static var students = [Student]()
        static var objectId: String = ""
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
            case .getstudentLocation: return Endpoints.base + "StudentLocation?limit=10&order=-updatedAt"
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
                Auth.students.append(contentsOf: responseObject.results)
                completion(true,nil)
            }
            }catch {
                print(error)
                completion(false,nil)
            }
        }
        task.resume()
    }
    class func postStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double,completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.putStudentLocation(Auth.objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false , error)
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(PostLocationResponse.self, from: data)
                Auth.student.createdAt = responseObject.createdAt
                Auth.student.objectID = responseObject.objectID
                completion(true,nil)

            } catch {
                print(error)
                completion(false ,error)
            }
        }
        task.resume()
        } catch {
            print(error)
            completion(false ,error)
        }
    }
    class func putStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double,completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.putStudentLocation(Auth.objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false , error)
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(PutLocationResponse.self, from: data)
                Auth.student.updatedAt = responseObject.updatedAt
                completion(true,nil)

            } catch {
                print(error)
                completion(false ,error)
            }
            
            completion(true,nil)
        }
        task.resume()
        } catch {
            print(error)
            completion(false ,error)
        }
    }
   
    class func loginRequest(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.session.url, responseType: SessionResponse.self, body: Credentails(udacity: Udacity(username: username, password: password))) { (response, error) in
            guard let response = response else {
                completion(false,error)
                return
            }
            Auth.user = response.account.key
            completion(true,nil)
        }
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
        request.httpMethod = "POST"
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
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
                    completion(nil, error)
                }
            }
            postTask.resume()
            
        } catch {
            print(error)
        }
    }
}

/*
 class func loginRequest(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
     var request = URLRequest(url: Endpoints.session.url)
     request.httpMethod = "POST"
     request.addValue("application/json", forHTTPHeaderField: "Accept")
     request.addValue("application/json", forHTTPHeaderField:"Content-Type")
     let body = Credentails(udacity: Udacity(username: username, password: password))
     // encoding a JSON body from a string, can also use a Codable struct
     do {
         request.httpBody = try JSONEncoder().encode(body)
     let session = URLSession.shared
     let task = session.dataTask(with: request) { data, response, error in
         guard let data = data else {
             completion(false,error)
             return
         }
         do {
             let range = 5..<data.count
          let newData = data.subdata(in: range)
             let stu = try JSONDecoder().decode(SessionResponse.self, from: newData)
             Auth.user = stu.account.key
             //print(stu)
             completion(true,nil)
         }
         catch {
                 print(error)
             completion(false,error)
             }
        
     }
     task.resume()
     } catch {
         print(error)
         completion(false,error)
     }
 }
 
 */
