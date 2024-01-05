//
//  Book_Diary.swift
//  Track.io
//
//  Created by William on 12/26/23.
//
class BookDiary {
    static let shared = BookDiary()
    private(set) var loggedBooks: [RatedBook] = []

    func logBook(_ book: VolumeInfo, withRating rating: Int) {
        let ratedBook = RatedBook(volumeInfo: book, rating: rating)

        if let index = loggedBooks.firstIndex(where: { $0.volumeInfo.title == book.title }) {
            loggedBooks[index] = ratedBook // Update existing book
        } else {
            loggedBooks.append(ratedBook) // Add new book
        }

        sortBooksByRating()
    }

    private func sortBooksByRating() {
        loggedBooks.sort { $0.rating > $1.rating }
    }
}





