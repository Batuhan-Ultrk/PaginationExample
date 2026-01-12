//
//  PaginationView.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 12.01.2026.
//

import SwiftUI

struct PaginationView<Item: Identifiable, Content: View>: View {
    typealias SafeActionBuilder = (@escaping (Item) -> Void) -> () -> Void
    typealias ItemViewBuilder = (Binding<Item>, SafeActionBuilder) -> Content

    @Binding var items: [Item]
    let loadMore: (() async -> Void)?
    let itemView: ItemViewBuilder

    init(
        items: Binding<[Item]>,
        loadMore: (() async -> Void)? = nil,
        @ViewBuilder itemView: @escaping ItemViewBuilder
    ) {
        self._items = items
        self.loadMore = loadMore
        self.itemView = itemView
    }

    var body: some View {
        LazyVStack(spacing: 16) {
            ForEach($items, id: \.id) { $item in
                let currentItem = item
                
                let createSafeAction = { (action: @escaping (Item) -> Void) in
                    self.createSafeAction(
                        for: currentItem,
                        in: { items },
                        perform: action
                    )
                }
                
                itemView($item, createSafeAction)
            }

            if !items.isEmpty {
                Color.clear
                    .frame(width: 1, height: 1)
                    .onAppear {
                        guard let loadMore = loadMore else { return }
                        Task {
                            await loadMore()
                        }
                    }
            }
        }
    }

    private func createSafeAction<Element: Identifiable>(
        for item: Element,
        in listProvider: @escaping () -> [Element],
        perform action: @escaping (Element) -> Void
    ) -> () -> Void {
        {
            guard let validItem = listProvider().first(
                where: {
                    $0.id == item.id
                }) else {
                return
            }
            action(
                validItem
            )
        }
    }
}
