//
//  HomeTabView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-21.
//  Purpose:
//      The Home page: a daily set of curated card-suggestion rows pulled from Scryfall. Each row
//      loads independently (showing a skeleton while it fetches) and the whole set is cached once
//      per day. A dev option in Settings forces a refetch.
//  External Types:
//      SetInfo, HomeSection, HomeSuggestions, HomeSuggestionsStore, SuggestionWidget, SFAPI, SetJSON
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct HomeTabView: View {

    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Query var setList: [SetInfo]
    /// Per-section results + which sections are still loading, so rows appear as they finish.
    @State private var cards: [HomeSection: [CardJSON]] = [:]
    @State private var loading: Set<HomeSection> = []
    /// The composed feed (collection preview + shuffled suggestion/news rows), rolled daily.
    @State private var feed: [HomeFeedItem] = []
    @State private var newsItems: [NewsItem] = []
    @State private var newsLoading = false
    /// Bumped by the Settings dev "Reload Home" option to force a refetch without relaunching.
    @AppStorage("homeReloadToken") private var reloadToken = 0

    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                header
                    .padding(.vertical, 20)

                VStack(spacing: 30) {
                    ForEach(feed) { item in
                        row(for: item)
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        // Runs on appear and whenever the dev reload token changes.
        .task(id: reloadToken) {
            // Register already-stored sets immediately so icons resolve before any network fetch.
            for set in setList { SetIconRegistry.shared.register(code: set.code, iconURI: set.iconURI) }
            feed = HomeFeed.build(seed: HomeFeed.dailySeed(token: reloadToken))
            async let suggestions: () = loadSuggestions()
            async let news: () = loadNews()
            async let sets: () = loadSetsIfNeeded()
            async let symbols: () = SymbolStore.load()
            _ = await (suggestions, news, sets, symbols)
        }
    }

    // MARK: Subviews

    /// Render one feed item.
    @ViewBuilder
    private func row(for item: HomeFeedItem) -> some View {
        switch item {
        case .collectionPreview:
            CollectionPreviewWidget()

        case .newsFeed:
            NewsFeedWidget(items: newsItems, isLoading: newsLoading)

        case .suggestion(let section):
            SuggestionWidget(
                systemImage: section.systemImage,
                title: section.title,
                description: section.blurb,
                collection: cards[section] ?? [],
                isLoading: loading.contains(section),
                shuffle: { cards[section] = (cards[section] ?? []).shuffled() }
            )
        }
    }

    private var header: some View {
        VStack(spacing: 4) {
            HStack(alignment: .center) {
                Image("MtgBinder")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)

                Text("Cardhold")
                    .font(.title)
                    .bold()
            }
            .foregroundColor(.primary)

            Text("Your daily card discovery")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: Loading

    /// Suggestions are a once-per-day discovery: reuse today's cached set if present, otherwise
    /// load each row independently (skeletons show until each finishes) and persist the lot.
    private func loadSuggestions() async {
        if HomeSuggestionsStore.isFreshForToday(),
           let cached = await Task.detached(priority: .userInitiated, operation: {
               HomeSuggestionsStore.load()
           }).value {
            for section in HomeSection.allCases { cards[section] = cached[section] }
            return
        }

        // Fresh day: fetch every row concurrently, updating each as its own request returns so the
        // page fills in progressively instead of waiting on the slowest one.
        loading = Set(HomeSection.allCases)
        await withTaskGroup(of: (HomeSection, [CardJSON]).self) { group in
            for section in HomeSection.allCases {
                group.addTask { (section, await SFAPI.fetchCardQuery(query: section.query)) }
            }
            for await (section, result) in group {
                cards[section] = result
                loading.remove(section)
            }
        }

        // Persist the day's set off the main thread.
        var blob = HomeSuggestions()
        for section in HomeSection.allCases { blob[section] = cards[section] ?? [] }
        let toSave = blob
        Task.detached(priority: .utility) { HomeSuggestionsStore.save(toSave) }
    }

    /// News refreshes every 2 hours. Serve from cache when fresh; otherwise fetch all three feeds
    /// concurrently and persist the result.
    private func loadNews() async {
        if NewsFeedStore.isFresh(), let cached = NewsFeedStore.load() {
            newsItems = cached
            return
        }
        newsLoading = true
        let fetched = await NewsFeedStore.fetch()
        newsItems = fetched
        newsLoading = false
        Task.detached(priority: .utility) { NewsFeedStore.save(fetched) }
    }

    /// Set list is reference data that rarely changes — only fetch when we have none, and de-dupe
    /// against a Set (O(n)) instead of a per-row linear scan (O(n²)).
    private func loadSetsIfNeeded() async {
        guard setList.isEmpty else { return }
        let existing = Set(setList.map(\.code))
        for set in await SFAPI.fetchSetData() {
            let model = SFAPI.setToModel(json: set)
            SetIconRegistry.shared.register(code: model.code, iconURI: model.iconURI)
            if !existing.contains(model.code) {
                modelContext.insert(model)
            }
        }
    }
}
