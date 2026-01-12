//
//  ErrorResponse.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 12.01.2026.
//

struct ErrorResponse: ResponseComposition {
    var error: Bool
    var message: String
    var code: String
}
