import Foundation

class Firebase {
    static var baseURL: URL!  { return URL(string: "https://bookshelf-67481.firebaseio.com/") }
    
    static func requestURL(_ method: String, for recordIdentifier: String = "unknownid") -> URL {
        switch method {
        case "POST":
            // You post to the main DB. It will return a new record identifier
            return baseURL.appendingPathExtension("json")
        case "DELETE", "PUT", "GET":
            // These all work on individual records, and you need to use the
            // record identifier in your URL with one exception, which is when
            // all the records at once, in which case, you do not need the record
            // identifier.
            return baseURL
                .appendingPathComponent(recordIdentifier)
                .appendingPathExtension("json")
        default:
            fatalError("Unknown request method: \(method)")
        }
    }
    
    // Handle a single request: meant for DELETE, PUT, POST.
    static func processRequest(
        method: String, //GET, PUT, POST or DELETE
        for bookshelves: Bookshelves, // Conforms to Codeable and to Firebase Item
        with completion: @escaping (_ success: Bool) -> Void = { _ in }
        ) {
        
        // Fetch appropriate request URL customized to method
        var request = URLRequest(url: requestURL(method, for: bookshelves.recordIdentifier))
        request.httpMethod = method
        
        // Encode this record
        do {
            request.httpBody = try JSONEncoder().encode(bookshelves)
        } catch {
            NSLog("Unable to encode \(bookshelves): \(error)")
            completion(false)
            return
        }
        
        // Create data task to perform request
        let dataTask = URLSession.shared.dataTask(with: request) { data, _ , error in
            
            // Fail on error
            if let error = error {
                NSLog("Server \(method) error: \(error)")
                completion(false)
                return
            }
            
            // Handle PUT, GET, DELETE and leave
            guard method == "POST" else {
                completion(true)
                return
            }
            
            // Process POST requests
            
            // Fetch identifier from POST
            guard let data = data else {
                NSLog("Invalid server response data")
                completion(false)
                return
            }
            
            do {
                
                // POST request returns `["name": recordIdentifier]`. Store the
                // record identifier
                let nameDict = try JSONDecoder().decode([String: String].self, from: data)
                guard let name = nameDict["name"] else {
                    completion(false)
                    return
                }
                
                // Update record and store that name. POST is now successful
                // and includes the recordIdentifier as part of the item record.
                var bookshelves = bookshelves
                bookshelves.recordIdentifier = name
                processRequest(method: "PUT", for: bookshelves)
                completion(true)
                
            } catch {
                
                NSLog("Error decoding JSON response: \(error)")
                completion(false)
                return
            }
        }
        
        dataTask.resume()
    }
    
    static func delete(bookshelves: Bookshelves, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        processRequest(method: "DELETE", for: bookshelves, with: completion)
    }
    
    static func save(bookshelves: Bookshelves, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        switch bookshelves.recordIdentifier.isEmpty {
        case true: // POST, new record
            print(bookshelves.recordIdentifier)
            processRequest(method: "POST", for: bookshelves, with: completion)
            
        case false: // PUT, existing record
            processRequest(method: "PUT", for: bookshelves, with: completion)
        }
    }
    
    // Fetch all records and pass them to sender via completion handler
    static func fetchRecords(completion: @escaping ([Bookshelves]?) -> Void) {
        let requestURL = baseURL.appendingPathExtension("json")
        let dataTask = URLSession.shared.dataTask(with: requestURL) { data, _, error in
            
            if let error = error {
                NSLog("Could not decode data: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                NSLog("Could not get data")
                completion(nil)
                return
            }
            
            do {
                let recordDict = try JSONDecoder().decode([String: Bookshelves].self, from:data)
                let records = recordDict.map({ $0.value })
                Model.shared.bookshelves = records[0]
                print (Model.shared.bookshelves)
                completion(nil)
            } catch {
                NSLog("Error decoding received data: \(error)")
                completion([])
            }
        }
        
        dataTask.resume()
    }
}
