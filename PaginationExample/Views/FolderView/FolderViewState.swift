//
//  FolderViewState.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 2.07.2025.
//

import SwiftUI

class FolderViewState: BaseViewState {

    @Published var searchText: String = ""
    @Published var folderList = [FolderResponse]() {
        didSet {
            let itemDataList: [CardViewData] = folderList.map { item in
                return .init(
                    id: item.id,
                    title: item.title,
                    description: item.description
                )
            }
            cardViewDataList = itemDataList
        }
    }
    @Published var cardViewDataList = [CardViewData]()
    var folderPagination: PaginationState

    override init() {
        self.folderPagination = PaginationState()
    }
}
