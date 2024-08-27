//
//  MovieDetailScreen.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//
import SwiftUI
import Kingfisher

struct MovieDetailScreen: View {
    private var input: MovieDetailViewModel.Input
    @ObservedObject private var output: MovieDetailViewModel.Output

    private let cancelBag = CancelBag()
    private let loadTrigger = NeverFailingPassthroughSubject<Bool>()

    @ViewBuilder
    func backdrop(movie: Movie) -> some View {
        ZStack(alignment: .bottom) {
            if let url = URL(string: movie.backdropUrl) {
                VStack(alignment: .leading) {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 210)
                        .frame(maxWidth: .infinity)

                    Spacer()
                        .frame(height: 40)
                }
            }
        }
    }

    @ViewBuilder
    func info(movie: Movie) -> some View {
        VStack {
            HStack(spacing: 8) {
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.red)
                        Text("\(Int(movie.voteAverage))/10")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor.labelSecondary))
                    }
                    HStack {
                        Image(systemName: "star.fill")
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.yellow)
                        Text("\(Int(movie.popularity))")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor.labelSecondary))
                    }
                    Text("Status: \(movie.status ?? "")")
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(UIColor.labelSecondary))
                    
                    Text("Release date: \(movie.releaseDate)")
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(UIColor.labelSecondary))
                }
                HStack(alignment: .bottom) {
                    RemoteImageView(imageUrl: movie.posterUrl, imageSize: CGSize(width: 90, height: 120))
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            Spacer()
            
            Text("Genres: \(movie.fullGenresString())")
                .fontWeight(.light)
                .font(.system(size: 16))
                .foregroundStyle(Color(UIColor.labelSecondary))
            
            Text("Languages: \(movie.fullLanguagesString())")
                .fontWeight(.light)
                .font(.system(size: 14))
                .foregroundStyle(Color(UIColor.labelSecondary))
            
            Text("\(movie.overview)")
                .padding(.top, 8)
                .padding(.horizontal, 16)
                .font(.body)
                .foregroundStyle(Color(UIColor.labelPrimary))
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var body: some View {
        BaseContentView(isLoading: $output.isLoading, title: output.movie?.title) {
            ScrollView {
                Group {
                    if let movie = output.movie {
                        VStack(spacing: 8) {
                            backdrop(movie: movie)
                            info(movie: movie)
                        }
                    } else {
                        VStack {}
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .refreshable {
                loadTrigger.send(true)
            }
        }
        .onAppear {
            loadTrigger.send(false)
        }
    }

    init(viewModel: MovieDetailViewModel) {
        let input = MovieDetailViewModel.Input(loadTrigger: loadTrigger.asNeverFailing())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
    }
}

