//
//  PageResponse.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 12.01.2026.
//

import Foundation

struct PageResponse<T: ResponseComposition>: ResponseComposition {
    let items: [T]
    let metadata: PageMetadata
}

struct PageMetadata: ResponseComposition {
    let page: Int
    let per: Int
    let total: Int
    let pageCount: Int
}
