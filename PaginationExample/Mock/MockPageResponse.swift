//
//  MockPageResponse.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 12.01.2026.
//

import Foundation

struct MockPageResponse<Item: ResponseComposition> {

    static func make(
        items: [Item],
        page: Int,
        per: Int,
        total: Int
    ) -> PageResponse<Item> {

        let pageCount = Int(ceil(Double(total) / Double(per)))

        return PageResponse(
            items: items,
            metadata: PageMetadata(
                page: page,
                per: per,
                total: total,
                pageCount: pageCount
            )
        )
    }
}
