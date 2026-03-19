//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 16.03.26.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl, handler: { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if !mostPopularMovies.errorMessage.isEmpty {
                        let error = NSError(
                            domain: "IMDBAPI",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: mostPopularMovies.errorMessage])
                        handler(.failure(error))
                    } else {
                        handler(.success(mostPopularMovies))
                    }
                } catch {
                    handler(.failure(error))
                }
                
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }
}
