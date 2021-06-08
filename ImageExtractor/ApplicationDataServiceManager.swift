//
//  ApplicationDataServiceManager.swift
//  ImageExtractor
//
//  Created by Vishnu on 07/06/21.
//

import Foundation

struct Appurl {
    public static let get_synonym = "https://wordsapiv1.p.rapidapi.com/words/%@/synonyms"
    public static let get_antonym = "https://wordsapiv1.p.rapidapi.com/words/%@/antonyms"
    public static let get_thesaurus = "https://wordsapiv1.p.rapidapi.com/words/%@/thesaurus"
}

public struct RequestHTTPMethod {
    public static var POST = "POST"
    public static var PUT = "PUT"
    public static var GET = "GET"
    public static var Delete = "DELETE"
}

public struct HTTPHeaderKey {
    public static var rapidKey = "x-rapidapi-key"
    public static var rapidHost = "x-rapidapi-host"

}

public struct ErrorResponse {
    public var errorCode: String? = nil
    public var errorData: Data? = nil
    public var errorDescription: String? = nil
}

class ApplicationDataServiceManager: NSObject {
    public static let shared = ApplicationDataServiceManager()

    //Method to get synonym and Antonym from Rapid API
    func getWordVal(urlString: String, dictKey: String, completionHandler: @escaping(_ synonModel: [String]?) -> ()){

        let headers = [
            HTTPHeaderKey.rapidKey: "eb8683b46emsh59b4a64a4df02cdp1f4f9djsnef06ce065737",
            HTTPHeaderKey.rapidHost: "wordsapiv1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = RequestHTTPMethod.GET
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
            }

            guard let data = data else { return }
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {

                    // Get value by key
                    if let userId = convertedJsonIntoDict[dictKey] {
                        completionHandler((userId as! [String]))
                    }

                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }

            
        })

        dataTask.resume()
    }
}

//Method to parse JSON to Codable struct
func parseJSON(data: Data) -> wordAPIModel? {

    var returnValue: wordAPIModel?
    do {
        returnValue = try JSONDecoder().decode(wordAPIModel.self, from: data)
    } catch {
        print("Error took place\(error.localizedDescription).")
    }

    return returnValue
}

