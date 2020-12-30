# Movie-DB-SwiftUI
The app is built using the MVVM + RxSwift architecture with offline support via coredata persistant storage. The app fetches movies and movie details from the TMDB database. As of now only part of the app has been build, the following features and pages will be added later on.

## TODO:

- [ ] Pull to refresh in LazyVStack.
- [x] Movie Details page.
- [ ] Unit testing of view models.
- [ ] Unit testing of store class.
- [ ] Rewrite network manager using combine.
- [ ] Monitoring network connection and refreshing UI.

## Installation

The app relies on three external libraries,
Kingfisher - For loading images
Reachability - For monitoring network availabilty change

Both Kingfisher and Reachablity are added using the Swift Package Manager, for these no additional steps are required to run the app

Funtionality
## MoviesList

The page by default loads the popular movies from the TMDB database and caches it to coredata for offline usage, when the app is offline an bar is show to indicate that the current movie data is cached data. Using network monitoring if there is nodata the app reload the movies list.

## MovieDetails 
The page loads the cached movie details when the live data api call fails for any reason, an offline bar is shown when the displyed data is cached data. The page auto reloads the movie details when the device is back online by monitoring the network status.


## Unit Testing
Unit testing for the MoviesDataStore and MovieDetailsDataStore (Model) is done via expections, testing MoviesViewModel and MovieDetailsViewModel is achevied via RxTest framework and TestableObserver class. 
