//
//  MockUserService.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 12.01.2026.
//

import Foundation

enum MockFolderService {

    private static let allFolders: [FolderResponse] = {
        (1...137).map {
            FolderResponse(
                id: UUID(),
                title: "Title \($0)",
                description: "Description \($0)"
            )
        }
    }()

    static func fetchFolders(
        page: Int,
        per: Int
    ) async throws -> PageResponse<FolderResponse> {

        await MockDelay.simulate()

        let startIndex = (page - 1) * per
        let endIndex = min(startIndex + per, allFolders.count)

        guard startIndex < allFolders.count else {
            return MockPageResponse<FolderResponse>.make(
                items: [],
                page: page,
                per: per,
                total: allFolders.count
            )
        }

        let items = Array(allFolders[startIndex..<endIndex])

        return MockPageResponse<FolderResponse>.make(
            items: items,
            page: page,
            per: per,
            total: allFolders.count
        )
    }
}
