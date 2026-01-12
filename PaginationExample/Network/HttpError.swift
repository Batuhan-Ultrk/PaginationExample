//
//  HttpError.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 12.01.2026.
//

enum HttpError: Error {
    case invalidURL
    case badResponse(statusCode: Int)
    case decodingError
    case encodingError
    case unknown(Error)
    case unauthorized
    case recoverFailed
    case customErrorResponse(ErrorResponse)
}
