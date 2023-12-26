//
//  Book_Manager.swift
//  Track.io
//
//  Created by William on 12/20/23.
//

import Foundation

class BookManager: ObservableObject {
    @Published var books: Books? = nil

    func getBookInfo(title: String) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        guard var url = URL(string: "https://www.googleapis.com/books/v1/volumes") else {return}
        let urlParams = [
            "q": "intitle:\(title)", // Use "intitle:" to search for books with a title matching the search string
        ]
        url = url.appendingQueryParameters(urlParams)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Start a new Task
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Failure
                print("URL Session Task Failed: \(error.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                print("Invalid response")
                return
            }
            print("URL Session Task Succeeded: HTTP \(statusCode)")
            
            guard let jsonData = data else {
                print("No data received")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let bookData = try JSONDecoder().decode(Books.self, from: jsonData)
                    self.books = bookData
                } catch {
                    // Handle decoding error
                    print("JSON decoding error: \(error)")
                }
            }
        }
        task.resume()
    }
}

// Your URLQueryParameterStringConvertible and Dictionary extensions can remain as they are.


protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
    */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
    */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}


