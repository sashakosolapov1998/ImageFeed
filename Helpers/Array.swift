//
//  Array.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 6/5/25.
//

extension Array {
    func withReplaced(itemAt index: Int, newValue: Element) -> [Element] {
        var newArray = self
        newArray[index] = newValue
        return newArray
    }
}
