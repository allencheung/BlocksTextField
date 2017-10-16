//
//  String+Index.swift
//  BlocksTextField
//
//  Created by AllenCheung on 16/10/2017.
//  Copyright © 2017 com.temp. All rights reserved.
//

import Foundation

extension String {
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}
