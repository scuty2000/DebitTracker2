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
    
    func writeNewData(debitor: Debitor) {
        
        var storedData: [Debitor] = []
        
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("newStorage").appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            storedData = try JSONDecoder.init().decode([Debitor].self, from: data)
        } catch {
            print("File not found, creating one")
            do {
                let fileURL = try FileManager.default
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("newStorage").appendingPathExtension("json")
                try JSONEncoder.init().encode(storedData).write(to: fileURL)
            } catch {
                // should I add something here?
            }
        }
        
        storedData.append(debitor)
        
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("newStorage").appendingPathExtension("json")
            try JSONEncoder.init().encode(storedData).write(to: fileURL)
        } catch {
            // should I add something here?
        }
        
        print(storedData)
        return
        
    }
    
    func readData() -> [Debitor] {
        
        var readData: [Debitor] = []
        
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("newStorage").appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            readData = try JSONDecoder.init().decode([Debitor].self, from: data)
        } catch {
            print("[FileManager] File not found. Are you running in a simulator? Providing fake data.")
            return[]
        }
        
        return readData
    }
    
    func removeData(debitor: Debitor) {
        
        var storedData: [Debitor] = []
        
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("newStorage").appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            storedData = try JSONDecoder.init().decode([Debitor].self, from: data)
        } catch {
            print("no data here")
        }
        
        storedData = storedData.filter(){ $0.id != debitor.id }
        
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("newStorage").appendingPathExtension("json")
            try JSONEncoder.init().encode(storedData).write(to: fileURL)
        } catch {
            // should I add something here?
        }
    }
    
}
