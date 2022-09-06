//
//  FIleManager-DocumentsDirectory.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 9/2/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
