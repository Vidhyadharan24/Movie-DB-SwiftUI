//
//  MovieDetailsViewModel.swift
//  Movie-DB
//
//  Created by Vidhyadharan on 23/12/20.
//

import Foundation
import Combine

class MovieDetailsViewModel: ObservableObject {

    private let movieId: String
    
    @Published var isLoading: Bool = false
    @Published var movieDetails: MovieDetails? = nil
    @Published var dataType: DataType = .noData
    
    @Published var isOffline = false
    @Published var showNoData = false
    @Published var showDetails = false

    private lazy var showOfflineView: AnyPublisher<Bool, Never> = {
        Publishers
            .CombineLatest3(self.$dataType, self.$isLoading, self.$movieDetails)
            .map { element in
                if element.0 == .cached, !element.1, element.2 != nil {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }()
    
    private lazy var showNoDataLabel: AnyPublisher<Bool, Never> = {
        Publishers
            .CombineLatest(self.$movieDetails, self.$isLoading)
            .map { element in
                if element.0 == nil, !element.1 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }()
    
    private lazy var showDetailsView: AnyPublisher<Bool, Never> = {
        Publishers
            .CombineLatest(self.$movieDetails, self.$isLoading)
            .map { element in
                if element.0 != nil, !element.1 {
                    return false
                } else {
                    return true
                }
            }
            .eraseToAnyPublisher()
    }()

    @Published var error: Error? = nil
    
    let movieDetailsStore: MovieDetailsStoreProtocol
    
    init(movieId: String, movieDetailsStore: MovieDetailsStoreProtocol = MovieDetailsStore()) {
        self.movieId = movieId
        self.movieDetailsStore = movieDetailsStore
        
        showOfflineView.assign(to: &self.$isOffline)
        showNoDataLabel.assign(to: &self.$showNoData)
        showDetailsView.assign(to: &self.$showDetails)
        
//        self.movieDetailsStore
//            .networkStatus
//            .withLatestFrom(self.dataType, resultSelector: { ($0, $1) })
//            .subscribe(onNext: { [weak self] element in
//                guard element.0, element.1 != .live else { return }
//                self?.getMovieDetails()
//            })
//            .disposed(by: disposeBag)
        
        getMovieDetails()
    }

    func getMovieDetails() {
        self.isLoading = true
        
        movieDetailsStore.getMovieDetails(id: self.movieId) { [weak self] storeState in
            self?.isLoading = false
            self?.dataType = storeState.dataType
            self?.movieDetails = storeState.movieDetails
            
            guard let error = storeState.error else { return }
            self?.error = error
        }
    }
}
