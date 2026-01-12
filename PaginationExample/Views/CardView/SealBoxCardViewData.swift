//
//  SealBoxCardViewData.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 12.01.2026.
//

import Foundation

struct CardViewData: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String?
}
