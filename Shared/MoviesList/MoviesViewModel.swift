//
//  MoviesViewModel.swift
//  Movie-DB
//
//  Created by Vidhyadharan on 23/12/20.
//

import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var isRefreshing = false

    @Published var dataType: DataType = .noData
    @Published var error: Error? = nil
    
    @Published var isOffline = false
    @Published var showNoData = false
    
    private var showOfflineView: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest3(self.$dataType, self.$isLoading, self.$isRefreshing)
            .map { element in
                if element.0 == .cached, !element.1, !element.2 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var showNoDataLabel: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest(self.$dataType, self.$isLoading)
            .map { element in
                if element.0 == .noData, !element.1 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }

    var category: Endpoints.Movies.Category = .popular
    
    private let moviesStore: MoviesStoreProtocol
    
    private var cancellableSet: Set<AnyCancellable> = []

    init(moviesStore: MoviesStoreProtocol = MoviesStore()) {
        self.moviesStore = moviesStore
        
        showOfflineView.assign(to: &self.$isOffline)
        showNoDataLabel.assign(to: &self.$showNoData)

//        let initialDataType: DataType = moviesStore.getPersistedMoviesCount() > 0 ? .cached : .noData
//        self._dataType = BehaviorRelay<DataType>(value: initialDataType)
        
//        moviesStore
//            .networkStatus
//            .withLatestFrom(self._dataType, resultSelector: { ($0, $1) })
//            .subscribe(onNext: { [weak self] element in
//                guard element.0, element.1 == .noData else { return }
//                self?.getMovies()
//            })
//            .disposed(by: disposeBag)
        
        getMovies()
    }
    
    func loadMoviesIfNeeded() {
        guard self.dataType == .cached else { return }
        self.getMovies()
    }
        
    func getMovies() {
        self.isRefreshing = self.dataType != .noData
        self.isLoading = self.dataType == .noData
        
        moviesStore.getMovies(category: category) { [weak self] storeState in
            self?.isLoading = false
            self?.isRefreshing = false
            self?.dataType = storeState.dataType
            
            guard let error = storeState.error else { return }
            self?.error = error
        }
    }
    
}
