//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Irakli Nozadze on 13.06.23.
//

import Foundation

class ResultArray: Codable {
  var resultCount = 0
  var results = [SearchResult]()
}

class SearchResult: Codable, CustomStringConvertible {
  var description: String {
    return "\nResult - Kind: \(kind ?? "None"), Name: \(name), Artist Name: \(artistName ?? "None")"
  }

  var kind: String? = ""
  var artistName: String? = ""
  var trackName: String? = ""
  var trackPrice: Double? = 0.0
  var currency = ""
  var imageSmall = ""
  var imageLarge = ""
  var trackViewUrl: String?
  var collectionName: String?
  var collectionViewUrl: String?
  var collectionPrice: Double?
  var itemPrice: Double?
  var itemGenre: String?
  var bookGenre: [String]?
  
  var name: String {
    return trackName ?? collectionName ?? ""
  }
  var storeURL: String {
    return trackViewUrl ?? collectionViewUrl ?? ""
  }
  var price: Double {
    return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
  }
  var genre: String {
    if let genre = itemGenre {
      return genre
    } else if let genres = bookGenre {
      return genres.joined(separator: ", ")
    }
    return ""
  }
  var artist: String {
    return artistName ?? ""
  }
  // can replace this with find and regular expressions ex:
  //  In the search box type: return “(.+)” and press return to search.
  //  In the replacement box type:
  //  return NSLocalizedString(”$1”, comment: “Localized kind: $1”)
  //  var type: String {
  //    let kind = self.kind ?? "audiobook"
  //    switch kind {
  //    case "album": return "Album"
  //    case "audiobook": return "Audio Book"
  //    case "book": return "Book"
  //    case "ebook": return "E-Book"
  //    case "feature-movie": return "Movie"
  //    case "music-video": return "Music Video"
  //    case "podcast": return "Podcast"
  //    case "software": return "App"
  //    case "song": return "Song"
  //    case "tv-episode": return "TV Episode"
  //    default: break
  //    }
  //    return "Unknown"
  //  }
  var type: String {
    let kind = self.kind ?? "audiobook"
    switch kind {
    case "album":
      return NSLocalizedString(
        "Album",
        comment: "Localized kind: Album")
    case "audiobook":
      return NSLocalizedString(
        "Audio Book",
        comment: "Localized kind: Audio Book")
    case "book":
      return NSLocalizedString(
        "Book",
        comment: "Localized kind: Book")
    case "ebook":
      return NSLocalizedString(
        "E-Book",
        comment: "Localized kind: E-Book")
    case "feature-movie":
      return NSLocalizedString(
        "Movie",
        comment: "Localized kind: Feature Movie")
    case "music-video":
      return NSLocalizedString(
        "Music Video",
        comment: "Localized kind: Music Video")
    case "podcast":
      return NSLocalizedString(
        "Podcast",
        comment: "Localized kind: Podcast")
    case "software":
      return NSLocalizedString(
        "App",
        comment: "Localized kind: Software")
    case "song":
      return NSLocalizedString(
        "Song",
        comment: "Localized kind: Song")
    case "tv-episode":
      return NSLocalizedString(
        "TV Episode",
        comment: "Localized kind: TV Episode")
    default:
      return kind }
  }
  
  enum CodingKeys: String, CodingKey {
    case imageSmall = "artworkUrl60"
    case imageLarge = "artworkUrl100"
    case itemGenre = "primaryGenreName"
    case bookGenre = "genres"
    case itemPrice = "price"
    case kind, artistName, currency
    case trackName, trackPrice, trackViewUrl
    case collectionName, collectionViewUrl, collectionPrice
  }
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
//  // sort by artist name
//  return lhs.artistName.localizedStandardCompare(rhs.artistName) == .orderedAscending
}

func > (lhs: SearchResult, rhs: SearchResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name) == .orderedDescending
}
// Usage of above functions:
func usage() {
//  self.searchResults.sort(by: <)
//  // or write this
//  searchResults.sort { $0 < $1 }
//  // if < is not overloaded than write following
//  searchResults.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
//  // or write this
//  searchResults.sort { result1, result2 in
//    return result1.name.localizedStandardCompare(result2.name) == .orderedAscending
//  }
}
