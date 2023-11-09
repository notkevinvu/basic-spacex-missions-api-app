//
//  LaunchListViewModel.swift
//  GlobalPaymentsCodingChallenge
//
//  Created by Kevin Vu on 11/9/23.
//

import SwiftUI

@MainActor
final class LaunchListViewModel: ObservableObject {
    
    private let networkService: NetworkService
    @Published private(set) var launchItems: [LaunchItem] = []
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var hasError: Bool = false
    
    // constructor injection of our network service for easier mocking
    // if/when we need a test network service environment
    init(networkService: NetworkService = RestNetworkServiceAdapter.instance) {
        self.networkService = networkService
    }
    
    func getLaunches() async {
        do {
            let response = try await networkService.request(type: [LaunchItem].self, router: .getLaunchesList)
            // requirements ask for launches to be ordered newest to oldest
            // the API sends us oldest to newest, so we simply need to reverse
            // the array
            launchItems = response.reversed().compactMap { $0 }
        } catch {
            errorMessage = (error as! GPError).customDescription
            hasError = true
        }
    }
}
