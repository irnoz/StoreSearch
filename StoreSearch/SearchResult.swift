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
    return "\nResult - Name: \(name), Artist Name: \(artistName ?? "None")"
  }

  var artistName: String? = ""
  var trackName: String? = ""
  var name: String {
    return trackName ?? ""
  }
}
