//
//  MockDelay.swift
//  PaginationExample
//
//  Created by Batuhan Ulutürk on 12.01.2026.
//


enum MockDelay {
    static func simulate(
        min: UInt64 = 300,
        max: UInt64 = 800
    ) async {
        let delay = UInt64.random(in: min...max)
        try? await Task.sleep(nanoseconds: delay * 1_000_000)
    }
}