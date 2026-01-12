//
//  FolderViewViewModel.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 2.07.2025.
//

import Foundation

final class FolderViewViewModel: BaseViewViewModel<FolderViewState> {

    override init(
        viewState: FolderViewState
    ) {
        super.init(viewState: viewState)
    }

    private lazy var _start: Void = {
        Task { [weak self] in
            await self?.performOnceOnlyTask()
        }
    }()

    private func performOnceOnlyTask() async {
        await loadFolders()
    }

    func start() {
        _ = _start
    }


    @MainActor
    func loadFolders(
        resetLoadFolders: Bool = false
    ) async {
        if resetLoadFolders {
            viewState.folderPagination.resetItems(&viewState.folderList)
        }

        await loadPagedItems(
            itemsKeyPath: \FolderViewState.folderList,
            paginationKeyPath: \FolderViewState.folderPagination,
            loading: .local,
            fetch: { page, per in
                return try await MockFolderService.fetchFolders(
                    page: page,
                    per: per
                )
            }
        )
    }
}
