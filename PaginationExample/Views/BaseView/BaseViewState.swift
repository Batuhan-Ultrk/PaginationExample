//
//  BaseViewState.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 5.05.2025.
//

import Foundation

class BaseViewState: ObservableObject, Hashable, Identifiable {
    @Published var loadingType: LoadingType = .none

    let id = UUID()

    static func == (lhs: BaseViewState, rhs: BaseViewState) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct PaginationState {
    var page: Int = Constant.Paginate.page
    var per: Int = Constant.Paginate.per
    var total: Int = Constant.Paginate.total
    var pageCount: Int = Constant.Paginate.pageCount
    var isLoading = false

    private mutating func reset() {
        self.page = Constant.Paginate.page
        self.per = Constant.Paginate.per
        self.total = Constant.Paginate.total
        self.pageCount = Constant.Paginate.pageCount
        self.isLoading = false
    }

    mutating func resetItems<T>(_ items: inout [T]) {
        self.reset()
        items.removeAll()
    }
}

enum LoadingType {
    case global
    case local
    case none
}
