//
//  Search.swift
//  StoreSearch
//
//  Created by Irakli Nozadze on 28.06.23.
//

import Foundation



class Search {
  var searchResults: [SearchResult] = []
  var hasSearched = false
  var isLoading = false
  private var dataTask: URLSessionDataTask?
  
  func performSearch(for text: String, category: Int) {
    if !text.isEmpty {
      dataTask?.cancel()
      isLoading = true
      hasSearched = true
      searchResults = []
      let url = iTunesURL(searchText: text, category: category)
      let session = URLSession.shared
      dataTask = session.dataTask(with: url) {
        data, response, error in
        // Was the search cancelled?
        if let error = error as NSError?, error.code == -999 {
          return
        }
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200, let data = data {
          self.searchResults = self.parse(data: data)
          self.searchResults.sort(by: <)
          print("Success!")
          self.isLoading = false
          return
        }
        print("Failure! \(response!)")
        self.hasSearched = false
        self.isLoading = false
      }
      dataTask?.resume()
    }
  }
  
  private func iTunesURL(searchText: String, category: Int) -> URL {
    let kind: String
    switch category {
    case 1: kind = "musicTrack"
    case 2: kind = "software"
    case 3: kind = "ebook"
    default: kind = ""
    }
    // used to encode url string(basically change all unsoported charachters to ones that are supported like ' ' becomes '%20')
    let encodedText = searchText.addingPercentEncoding(
      withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let urlString = "https://itunes.apple.com/search?" +
    "term=\(encodedText)&limit=200&entity=\(kind)"
    let url = URL(string: urlString)
    return url!
  }
  
  private func parse(data: Data) -> [SearchResult] {
    do {
      let decoder = JSONDecoder()
      let result = try decoder.decode(
        ResultArray.self, from: data)
      return result.results
    } catch {
      print("JSON Error: \(error)")
      return []
    }
  }
}
