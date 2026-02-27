//
//  Collectible.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import Foundation

struct Collectible {
    enum CollectibleType {
        case bubble
        case star
    }

    var type: CollectibleType
    var position: CGPoint
    var value: Int
}
