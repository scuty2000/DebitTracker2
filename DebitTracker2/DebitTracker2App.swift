//
//  DebitTracker2App.swift
//  DebitTracker2
//
//  Created by Luca Scutigliani on 27/11/20.
//

import SwiftUI

@main
struct DebitTracker2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func writeNewData(name: String, surname: String, debit: Int) {
        
        var dictionary = ["":0]
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let surname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("data").appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            dictionary = try JSONSerialization.jsonObject(with: data) as! [String : Int]
        } catch {
            print("File not found")
            dictionary = ["\(name) \(surname)":debit]
            do {
                let fileURL = try FileManager.default
                    .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("data").appendingPathExtension("json")
            
                try JSONSerialization.data(withJSONObject: dictionary)
                    .write(to: fileURL)
            } catch {
                // should I add something here?
            }
            return
        }
        
        print("Got this:\n\(dictionary)\n")
        
        if(dictionary["\(name) \(surname)"] != nil){
            dictionary["\(name) \(surname)"] = dictionary["\(name) \(surname)"]! + debit
        } else {
            dictionary["\(name) \(surname)"] = debit
        }
        
        // dictionary = [:] // use this to reset all data
        
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("data").appendingPathExtension("json")
        
            try JSONSerialization.data(withJSONObject: dictionary)
                .write(to: fileURL)
        } catch {
            // should I add something here?
        }
        
        print(dictionary)
        return
        
    }
    
    func readData() -> [Debitor] {
        
        var dictionary = ["":0]
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("data").appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            dictionary = try JSONSerialization.jsonObject(with: data) as! [String : Int]
        } catch {
            print("no data here")
            // return [Debitor(name: "Luca", surname: "Scutigliani", debit: 10)] // use only for simulator (json don't work on simulators and I don't know why)
            return[]
        }
        
        var data: [Debitor] = []
        
        for (key, value) in dictionary {
            let spliced = key.components(separatedBy: " ")
            data.append(Debitor(name: spliced[0], surname: spliced[1], debit: value))
        }
        
        return data
    }
    
    func removeData(name: String, surname: String) {
        var dictionary = ["":0]
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("data").appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            dictionary = try JSONSerialization.jsonObject(with: data) as! [String : Int]
        } catch {
            print("no data here")
        }
        dictionary.removeValue(forKey: "\(name) \(surname)")
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("data").appendingPathExtension("json")
        
            try JSONSerialization.data(withJSONObject: dictionary)
                .write(to: fileURL)
        } catch {
            // should I add something here?
        }
    }
    
}
