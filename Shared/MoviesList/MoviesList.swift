//
//  MoviesList.swift
//  Shared
//
//  Created by Vidhyadharan on 28/12/20.
//

import SwiftUI
import SwiftUIX
import CoreData

struct MoviesList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Movie.id, ascending: true)],
        animation: .default)
    private var movies: FetchedResults<Movie>

    @ObservedObject private var viewModel = MoviesViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.showNoData {
                    Text("Unable to load Movies list")
                } else if viewModel.isLoading {
                    ActivityIndicator()
                        .animated(true)
                        .style(.large)
                } else {
                    if viewModel.isOffline {
                        OfflineBarView()
                    }
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(movies) { movie in
                                MovieView(movie: movie, height: 200)
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(radius: 3)
                            }
                        }.padding()
                    }
                }
            }
            .navigationBarTitle("Movies", displayMode: .inline)
        }
        .background(Color(UIColor.systemGray6))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesList().environment(\.managedObjectContext, PersistenceController.preview.viewContext)
    }
}
