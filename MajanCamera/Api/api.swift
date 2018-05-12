import Foundation
import Alamofire
import UIKit
import ObjectMapper


class Api: NSObject {
    
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
