//
//  DiscoverView.swift
//  MessengerClone
//
//  Created by rentamac on 2/6/26.
//

import SwiftUI

struct DiscoverView: View {

    @State private var selectedTab: DiscoverTab = .forYou

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            searchBar
            segmentedControl

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    recentSection
                    moreSection
                }
                .padding(.top, 10)
            }
        }
        .background(Color(.backgroundPrimary))
    }
}

private extension DiscoverView {

    var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            Text("Search")
                .foregroundColor(.gray)

            Spacer()
        }
        .padding(.horizontal, 12)
        .frame(height: 36)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemGray5))
        )
        .padding(.horizontal)
        .padding(.top, 8)
    }

    var segmentedControl: some View {
        HStack(spacing: 8) {
            segmentButton(title: "FOR YOU", tab: .forYou)
            segmentButton(title: "BUSINESSES", tab: .businesses)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }

    func segmentButton(title: String, tab: DiscoverTab) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(selectedTab == tab ? .black : .gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(selectedTab == tab ? Color(.systemGray4) : Color.clear)
            )
            .onTapGesture {
                selectedTab = tab
            }
    }

    var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent")
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    recentItem(name: "Apple", systemImage: "apple.logo")
                    recentItem(name: "Samsung", systemImage: "display")
                    recentItem(name: "Airbnb", systemImage: "house.fill")
                }
                .padding(.horizontal)
            }
        }
    }

    func recentItem(name: String, systemImage: String) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
                    .shadow(radius: 3)

                Image(systemName: systemImage)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.black)
            }

            Text(name)
                .font(.system(size: 13))
        }
    }

    var moreSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("More")
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal)

            VStack(spacing: 16) {
                businessRow(
                    name: "Microsoft",
                    category: "Science, Technology & Engineering",
                    description: "Our mission is to empower every person...",
                    systemImage: "windows.logo",
                    color: .blue
                )

                businessRow(
                    name: "Instagram",
                    category: "Business",
                    description: "Bringing you closer to the people...",
                    systemImage: "camera.fill",
                    color: .pink
                )

                businessRow(
                    name: "Disney",
                    category: "Brand",
                    description: "Disney magic right at your fingertips",
                    systemImage: "sparkles",
                    color: .purple
                )

                businessRow(
                    name: "Facebook",
                    category: "Website",
                    description: "Welcome to the Facebook chat bot...",
                    systemImage: "f.cursive",
                    color: .blue
                )

                businessRow(
                    name: "McDonald's",
                    category: "Fast Food Restaurant",
                    description: "I'm lovin' it",
                    systemImage: "fork.knife",
                    color: .orange
                )
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
    }

    func businessRow(
        name: String,
        category: String,
        description: String,
        systemImage: String,
        color: Color
    ) -> some View {

        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)

                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16, weight: .semibold))

                Text(category)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)

                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer()
        }
    }
}

enum DiscoverTab {
    case forYou
    case businesses
}
