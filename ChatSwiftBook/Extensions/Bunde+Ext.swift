//
//  Bunde+Ext.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 03.07.21.
//

import UIKit

extension Bundle {
    
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else { fatalError("file not found") }
        
        guard let data = try? Data(contentsOf: url) else { fatalError("data incorrect") }
        
        let decoder = JSONDecoder()
        
        guard let result = try? decoder.decode(type, from: data) else { fatalError("decoding is incorrect") }
        
        return result
    }
    
}
