import Foundation
import Alamofire
import UIKit
import ObjectMapper


class Api: ApiBase {
    
    static func detect(image:UIImage, success:((PisSchema) -> ())?, failure:((Error?) -> ())?, completion: ((Bool) -> ())?){
        let url = String(format: "%@/v1/detection/", Cons.Api.url)
        print(url)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(UIImageJPEGRepresentation(image, 1.0)!, withName: "image", fileName: "test.jpeg", mimeType: "image/jpeg")
        },
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if response.error == nil {
                            print("Sucess \(url)")
                            // success
                            if success != nil {
                                let schema:PisSchema = Mapper<PisSchema>().map(JSONObject: response.result.value)!
                                success!(schema)
                            }
                            if completion != nil {
                                completion!(true)
                            }
                        } else {
                            // error
                            if failure != nil {
                                failure!(response.error!)
                            }
                            if completion != nil {
                                completion!(false)
                            }
                        }
                    }
                case .failure(let encodingError):
                    // 失敗
                    print("Failure \(url)")
                    print(encodingError)
                    // error
                    if failure != nil {
                        failure!(encodingError)
                    }
                    if completion != nil {
                        completion!(false)
                    }
                }
            })
    }
    
    static func detect_test(image:UIImage, success:((PisSchema) -> ())?, failure:((Error?) -> ())?, completion: ((Bool) -> ())?){
        let url = String(format: "%@/v1/detection/", Cons.Api.url)
        print(url)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(UIImageJPEGRepresentation(image, 1.0)!, withName: "image", fileName: "test.jpeg", mimeType: "image/jpeg")
        },
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString(completionHandler: {
                        response in
                        print("-------TEST-----------")
                        print(response)
                    })
                case .failure(let encodingError):
                    // 失敗
                    print("Failure \(url)")
                    print(encodingError)
                    // error
                    if failure != nil {
                        failure!(encodingError)
                    }
                    if completion != nil {
                        completion!(false)
                    }
                }
        })
    }

}

@objc class ApiBase:NSObject {
    
    static let tokenHeaderName = "ChatitToken"
    
    static func GET(_ url: String, parameters: [String:String], success:((Any) -> ())?, failure:((Error) -> ())?, completion: ((Bool) -> ())?) {
        request(url, parameters: parameters, method: .get, success: success, failure: failure, completion: completion)
    }
    
    static func POST(_ url: String, parameters: [String:String], success:((Any) -> ())?, failure:((Error) -> ())?, completion: ((Bool) -> ())?) {
        request(url, parameters: parameters, method: .post, success: success, failure: failure, completion: completion)
    }
    
    static func PUT(_ url: String, parameters: [String:String], success:((Any) -> ())?, failure:((Error) -> ())?, completion: ((Bool) -> ())?) {
        request(url, parameters: parameters, method: .put, success: success, failure: failure, completion: completion)
    }
    
    static func DELETE(_ url: String, parameters: [String:String], success:((Any) -> ())?, failure:((Error) -> ())?, completion: ((Bool) -> ())?) {
        request(url, parameters: parameters, method: .delete, success: success, failure: failure, completion: completion)
    }
    
    static func request(_ url: String, parameters: [String:String], method: Alamofire.HTTPMethod, success:((Any) -> ())?, failure:((Error) -> ())?, completion: ((Bool) -> ())? ) {
        
        // set header
        let headers: [String:String]? = [:]

        // request
        Alamofire.request(url, method: method, parameters: parameters, headers:headers).validate(statusCode: 200...300)
            .responseJSON { response in
                if response.error == nil {
                    // success
                    if success != nil {
                        success!(response.result.value as Any)
                    }
                    if completion != nil {
                        completion!(true)
                    }
                } else {
                    // error
                    if failure != nil {
                        failure!(response.error!)
                    }
                    if completion != nil {
                        completion!(false)
                    }
                }
            }
        }
    }
