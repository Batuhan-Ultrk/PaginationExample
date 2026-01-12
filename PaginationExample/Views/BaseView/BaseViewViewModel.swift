//
//  BaseSceneViewModel.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 5.05.2025.
//

import Foundation

@MainActor
class BaseViewViewModel<D: BaseViewState>: ObservableObject {

    @Published var viewState: D

    init(viewState: D) {
        self.viewState = viewState
    }

    func sendRequest<T: Sendable>(
        _ request: @escaping () async throws -> T,
        loading type: LoadingType,
        onSuccess: ((T) async -> Void)? = nil,
        onFail: ((Error?, ErrorResponse?) async -> Void)? = nil
    ) async {
        viewState.loadingType = type

        defer {
            viewState.loadingType = .none
        }

        do {
            let result = try await request()
            await onSuccess?(result)
        } catch HttpError.customErrorResponse(let errorResponse) {
            await onFail?(nil ,errorResponse)
        } catch {
            print("An error occurred: \(error)")
            await onFail?(error, nil)
        }
    }

    func loadPagedItems<Item: ResponseComposition>(
        itemsKeyPath: ReferenceWritableKeyPath<D, [Item]>,
        paginationKeyPath: ReferenceWritableKeyPath<D, PaginationState>,
        loading type: LoadingType,
        fetch: @escaping (_ page: Int, _ per: Int) async throws -> PageResponse<Item>
    ) async {
        var pagination = viewState[keyPath: paginationKeyPath]
        guard pagination.page <= pagination.pageCount else {
            return
        }
        guard !pagination.isLoading else {
            return
        }
        pagination.isLoading = true
        viewState[keyPath: paginationKeyPath] = pagination
        
        await sendRequest(
            {
                try await fetch(pagination.page, pagination.per)
            },
            loading: type,
            onSuccess: { [weak self] response in
                guard let self else { return }
                
                /// Items append or replace logic
                if pagination.page == 1 {
                    self.viewState[keyPath: itemsKeyPath] = response.items
                } else {
                    self.viewState[keyPath: itemsKeyPath].append(
                        contentsOf: response.items
                    )
                }
                
                /// Pagination metadata update
                pagination.pageCount = response.metadata.pageCount
                pagination.total = response.metadata.total
                pagination.page += 1
                pagination.isLoading = false
                self.viewState[keyPath: paginationKeyPath] = pagination
            }
        )
    }
}
