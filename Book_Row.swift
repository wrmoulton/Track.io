//
//  Book_Row.swift
//  Track.io
//
//  Created by William on 12/19/23.
//

import SwiftUI

struct Book_Row: View {
    var book : VolumeInfo
    var body: some View {
        NavigationLink(destination: BookDetailView(book: book)) {
            HStack(spacing: 20){
                // If the book has a thumbnail image, display it. Otherwise, display a placeholder.
                if let thumbnailURL = book.imageLinks?.thumbnail {
                    AsyncImage(url: thumbnailURL) {
                        image in image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 44, height: 66) // Adjust the size as needed
                    .cornerRadius(5)
                } else {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 44, height: 66)
                }
                VStack(alignment: .leading, spacing: 6) {
                    //MARK: BOOK TITLE
                    Text(book.title)
                        .font(.subheadline)
                        .bold()
                        .lineLimit(1)
                }
                .padding([.top,.bottom],8)
            }
            
        }
    }
}

struct StarRatingView: View {
    @Binding var rating: Int // The current rating

    var maximumRating = 5 // Maximum number of stars
    var offImage: Image? // Image for an unselected star
    var onImage = Image(systemName: "star.fill") // Image for a selected star
    var offColor = Color.gray // Color for an unselected star
    var onColor = Color.yellow // Color for a selected star

    var body: some View {
        HStack {
            ForEach(1...maximumRating, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct BookDetailView: View {
    var book: VolumeInfo
    @State private var rating = 0 // Default rating
    
    var body: some View {
        ScrollView{
            VStack(alignment: .center, spacing: 10) {
                Text(book.title)
                    .font(.largeTitle)
                    .bold()
                if let thumbnailURL = book.imageLinks?.thumbnail {
                    AsyncImage(url: thumbnailURL) {
                        image in image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 176, height: 272) // Adjust the size as needed
                    .cornerRadius(5)
                } else {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 176, height: 272)
                }
                Text(book.authors.joined(separator: ","))
                    .font(.title)
                
            }
                
                // Star Rating View
                StarRatingView(rating: $rating)
                    .padding(.vertical)
                
                Text(book.description)
            }
            .padding()
            .toolbar {
                ToolbarItem {
                    Image(systemName: "book.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icons, .primary)
        }
            }
        }
    }
