//
//  EneGIVE - CollectionExtensions.swift
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

extension Collection where Indices.Iterator.Element == Index {
    
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
