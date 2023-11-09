//
//  LaunchListView.swift
//  GlobalPaymentsCodingChallenge
//
//  Created by Kevin Vu on 11/9/23.
//

import SwiftUI

struct LaunchListView: View {
    
    @StateObject var viewModel = LaunchListViewModel()
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    var body: some View {
        
        NavigationSplitView(columnVisibility: $columnVisibility) {
            launchList
                .navigationTitle("SpaceX Launches")
                .navigationBarTitleDisplayMode(.inline)
        } detail: {
            // no need for detail if we have nav link?
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            columnVisibility = .all
        }
        .task {
            await viewModel.getLaunches()
        }
    }
    
    @ViewBuilder
    var launchList: some View {
        List {
            ForEach(viewModel.launchItems) { launch in
                NavigationLink {
                    launchDetailItemView(for: launch)
                } label: {
                    Text(launch.missionName)
                }
                
            }
        }
    }
    
    @ViewBuilder
    func launchDetailItemView(for launch: LaunchItem) -> some View {
        VStack {
            AsyncImage(url: URL(string: launch.launchLinks.missionPatchImageUrlString ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "photo.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .padding([.leading, .trailing, .top], 40)
            .padding(.bottom, 20)
            
            List {
                Section("Mission name") {
                    Text(launch.missionName)
                }
                Section("Launch date") {
                    Text(viewModel.getFormattedDateStringFor(launch: launch))
                }
                Section("Rocket name") {
                    Text(launch.rocket.rocketName)
                }
                Section("Launch site name") {
                    Text(launch.launchSite.siteNameLong)
                }
            }
            
            Spacer()
        }
        .navigationTitle(launch.missionName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    LaunchListView()
}
