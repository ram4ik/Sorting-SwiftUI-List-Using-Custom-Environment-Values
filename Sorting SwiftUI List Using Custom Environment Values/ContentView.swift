//
//  ContentView.swift
//  Sorting SwiftUI List Using Custom Environment Values
//
//  Created by admin on 10/28/24.
//

import SwiftUI

enum SortOrder {
    case asc, desc
}

struct Sort {
    var sortOrder: SortOrder = .asc
    
    func callAsFunction<U, T: Comparable>(_ array: [U], by keyPath: KeyPath<U, T>?, _ order: SortOrder = .asc) -> [U] {
        
        switch order {
        case .asc:
            return keyPath == nil ? array : array.sorted { $0[keyPath: keyPath!] < $1[keyPath: keyPath!] }
        case .desc:
            return keyPath == nil ? array : array.sorted { $0[keyPath: keyPath!] > $1[keyPath: keyPath!] }
        }
    }
}

extension EnvironmentValues {
    var sort: Sort {
        get { self[SortKey.self] }
        set { self[SortKey.self] = newValue }
    }
}

private struct SortKey: EnvironmentKey {
    static let defaultValue = Sort()
}

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let rating: Double
}

struct ContentView: View {
    
    @Environment(\.sort) var sort
    
    @State private var sortOrder: SortOrder = .asc
    @State private var sortedByTitle = true
    
    let movies = [
        Movie(title: "Batman", rating: 9.2),
        Movie(title: "Joker", rating: 8.7),
        Movie(title: "Dark Knight", rating: 9.4),
        Movie(title: "ARK", rating: 7.2)
    ]
    
    var body: some View {
        List {
            HStack {
                Button(sortOrder == .asc ? "ASC" : "DESC") {
                    sortOrder = sortOrder == .asc ? .desc : .asc
                }
                
                Toggle("", isOn: $sortedByTitle)
            }
            
            ForEach(sortedByTitle ? sort(movies, by: \.title, sortOrder) : sort(movies, by: \.rating, sortOrder)) { movie in
                HStack {
                    Text(movie.title)
                    Spacer()
                    Text(String(format: "%.1f", movie.rating))
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.sort, Sort())
}

