//
//  ContentView.swift
//  PrashantAdvaitDemoUnSplash
//
//  Created by Sandeep Srivastava on 18/04/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PhotoViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(viewModel.photos) { photo in
                    GridCell(photo: photo, viewModel: viewModel)
                        .onAppear {
                            if photo == viewModel.photos.last {
                                viewModel.loadPhotos()
                            }
                        }
                }
            }
            .padding()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    viewModel.loadPhotos()
                }) {
                    Text("Load More")
                        .padding()
                }
            }
        }
        .onAppear {
            viewModel.loadPhotos()
        }
    }
}

struct GridCell: View {
    let photo: Photo
    @ObservedObject var viewModel: PhotoViewModel
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(12)
                    .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: 2)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .onAppear {
                        viewModel.getImage(for: photo.imageUrl) { image in
                            self.image = image
                        }
                    }
            }
        }
    }
}
