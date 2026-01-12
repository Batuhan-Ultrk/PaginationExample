//
//  FolderView.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 2.07.2025.
//

import SwiftUI

struct FolderView: View {
    @StateObject var viewModel: FolderViewViewModel

    init() {
        _viewModel = .init(
            wrappedValue: .init(
                viewState: FolderViewState()
            )
        )
    }

    var body: some View {
        BaseView(viewState: viewModel.viewState) {
            ScrollView {
                bodyView
                    .onAppear {
                        viewModel.start()
                    }
            }
        }
        .navigationBarBackButtonHidden()
    }

    var bodyView: some View {
        VStack(spacing: 8) {
            cardViews
        }
    }

    private var cardViews: some View {
        PaginationView(
            items: $viewModel.viewState.cardViewDataList,
            loadMore: {
                await viewModel.loadFolders()
            },
            itemView: { $item, makeSafeAction in
                CardView(
                    cardViewData: $item
                ) { item in
                    print(item)
                }
            }
        )
    }
}
