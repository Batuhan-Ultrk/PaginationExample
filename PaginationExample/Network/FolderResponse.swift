//
//  FolderResponse.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 12.01.2026.
//

import Foundation

struct FolderResponse: ResponseComposition {
    let id: UUID
    let title: String
    let description: String?
}
