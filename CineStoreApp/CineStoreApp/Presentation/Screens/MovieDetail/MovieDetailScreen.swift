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
    func backdrop(content: ContentDetail) -> some View {
        ZStack(alignment: .bottom) {
            if let url = URL(string: content.imageBackdropUrl) {
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
    func info(content: ContentDetail) -> some View {
        VStack {
            HStack(spacing: 8) {
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.red)
                        Text("\(Int(content.voteAverage))/10")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor.labelSecondary))
                    }
                    HStack {
                        Image(systemName: "star.fill")
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.yellow)
                        Text("\(Int(content.popularity))")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor.labelSecondary))
                    }
                    Text("Status: \(content.status)")
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(UIColor.labelSecondary))
                    
                    Text("Release date: \(content.releaseDate)")
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(UIColor.labelSecondary))
                }
                HStack(alignment: .bottom) {
                    RemoteImageView(imageUrl: content.imagePosterUrl, imageSize: CGSize(width: 90, height: 120))
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            Spacer()
            
            Text("Genres: \(content.genres)")
                .fontWeight(.light)
                .font(.system(size: 16))
                .foregroundStyle(Color(UIColor.labelSecondary))
            
            Text("Languages: \(content.languages)")
                .fontWeight(.light)
                .font(.system(size: 14))
                .foregroundStyle(Color(UIColor.labelSecondary))
            
            Text("\(content.body)")
                .padding(.top, 8)
                .padding(.horizontal, 16)
                .font(.body)
                .foregroundStyle(Color(UIColor.labelPrimary))
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var body: some View {
        BaseContentView(isLoading: $output.isLoading, title: output.contentDetail?.title) {
            ScrollView {
                Group {
                    if let content = output.contentDetail {
                        VStack(spacing: 8) {
                            backdrop(content: content)
                            info(content: content)
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

