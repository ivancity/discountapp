//
//  FileManager+Extension.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation

extension FileManager {
    
    static func saveToFile(to writePath: String, data: Data) {
        if let dir = self.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(writePath)
            
            do {
                try data.write(to: path)
            }
            catch {
                NSLog(error.localizedDescription)
            }
        }
    }
    
    static func readFromFile(from readPath: String) -> Data? {
        if let dir = self.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(readPath)
            
            do {
                let data = try Data(contentsOf: path)
                return data
            }
            catch {
                NSLog(error.localizedDescription)
            }
        }
        return nil
    }
}
