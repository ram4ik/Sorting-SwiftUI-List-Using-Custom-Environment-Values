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
    
    func callAsFunction<T: Comparable, U>(_ array: [U], by keyPath: KeyPath<U, T>, _ order: SortOrder = .asc) -> [U] {
        
        switch order {
        case .asc:
            return array.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
        case .desc:
            return array.sorted { $0[keyPath: keyPath] > $1[keyPath: keyPath] }
        }
    }
}

extension EnvironmentValues {
    @Entry var sort = Sort()
}

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let rating: Double
}

struct ContentView: View {
    
    @Environment(\.sort) var sort
    
    @State private var sortOrder: SortOrder = .asc
    
    let movies = [
        Movie(title: "Batman", rating: 9.2),
        Movie(title: "Joker", rating: 8.7),
        Movie(title: "Dark Knight", rating: 9.4),
        Movie(title: "ARK", rating: 7.2)
    ]
    
    var body: some View {
        List {
            Button(sortOrder == .asc ? "ASC" : "DESC") {
                sortOrder = sortOrder == .asc ? .desc : .asc
            }
            
            ForEach(sort(movies, by: \.title, sortOrder)) { movie in
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
