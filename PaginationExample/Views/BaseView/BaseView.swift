//
//  BaseView.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 1.05.2025.
//

import SwiftUI

struct BaseView<Content: View>: View {
    @ObservedObject var viewState: BaseViewState

    let content: () -> Content

    var body: some View {
        ZStack {
            content()

            if viewState.loadingType == .global {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(
                        CircularProgressViewStyle(tint: .white)
                    )
            }
        }
    }
}
