//
//  Book_Row.swift
//  Track.io
//
//  Created by William on 12/19/23.
//
import SwiftUI



struct AllBooksView: View {
    private var loggedBooks: [RatedBook] {
        BookDiary.shared.loggedBooks
    }

    var body: some View {
        List(loggedBooks, id: \.volumeInfo.title) { ratedBook in
            Book_Diary_View(book: ratedBook.volumeInfo, rating: ratedBook.rating)
        }
        .navigationBarTitle("Logged Books")
    }
}


struct Book_Diary_View: View {
    var book : VolumeInfo
    @State private var rating: Int
    init(book: VolumeInfo, rating: Int) {
            self.book = book
            self._rating = State(initialValue: rating)
        }
    var body: some View {
        NavigationLink(destination: BookDetail(book: book, rating: $rating)) {
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

struct StarRating: View {
    @Binding var rating: Int // The current rating

    let maximumRating = 5 // Maximum number of stars
    let offImage = Image(systemName: "star") // Image for an unselected star
    let onImage = Image(systemName: "star.fill") // Image for a selected star
    let offColor = Color.gray // Color for an unselected star
    let onColor = Color.yellow // Color for a selected star

    var body: some View {
        HStack {
            ForEach(1...maximumRating, id: \.self) { number in
                self.image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }

    func image(for number: Int) -> Image {
        number > rating ? offImage : onImage
    }
}


struct BookDetail: View {
    var book: VolumeInfo
    @Binding var rating: Int
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
        }
    }
