//
//  CardView.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 12.01.2026.
//

import SwiftUI

struct CardView: View {
    @Binding var cardViewData: CardViewData
    var action: ((CardViewData) -> Void)? = nil

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Button {
                action?(cardViewData)
            } label: {
                itemView
            }
        }
    }

   private var itemView: some View {
       return HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(cardViewData.title)
                    .fixedSize(horizontal: false, vertical: true)
                if let description = cardViewData.description {
                    Text(description)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
