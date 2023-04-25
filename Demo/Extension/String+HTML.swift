//
//  String+HTML.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/25/23.
//

import Foundation

extension String {
    
    func htmlString() -> NSAttributedString? {
        
        guard let data = self.data(using: .utf8) else {
            return nil
        }

        return try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }
}
