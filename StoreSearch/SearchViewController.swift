//
//  ViewController.swift
//  StoreSearch
//
//  Created by Irakli Nozadze on 13.06.23.
//

import UIKit

class SearchViewController: UIViewController {

  struct TableView {
    struct CellIdentifiers {
      static let searchResultCell = "SearchResultCell"
      static let nothingFoundCell = "NothingFoundCell"
      static let loadingCell = "LoadingCell"
    }
  }

  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!

  private let search = Search()
  var landscapeVC: LandscapeViewController?

  override func viewDidLoad() {
    super.viewDidLoad()

    searchBar.becomeFirstResponder()

    tableView.contentInset = UIEdgeInsets(top: 91, left: 0, bottom: 0, right: 0)

    var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)

    cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
    
    cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
  }
  
//  // set presentation style via code
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "ShowDetail" {
//      segue.destination.modalPresentationStyle = .overFullScreen
//    }
//  }
  override func willTransition(
    to newCollection: UITraitCollection,
    with coordinator: UIViewControllerTransitionCoordinator
  ){
    super.willTransition(to: newCollection, with: coordinator)
    switch newCollection.verticalSizeClass {
    case .compact:
      showLandscape(with: coordinator)
    case .regular, .unspecified:
      hideLandscape(with: coordinator)
    @unknown default:
      break
    } }
  
  // MARK: - Helper Methods

  func showNetworkError() {
    let alert = UIAlertController(
      title: "Whoops...",
      message: "There was an error accessing the iTunes Store." +
      " Please try again.",
      preferredStyle: .alert)
    let action = UIAlertAction(
      title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

  func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    guard landscapeVC == nil else { return }
    landscapeVC = storyboard!.instantiateViewController(
      withIdentifier: "LandscapeViewController") as? LandscapeViewController
    if let controller = landscapeVC {
      controller.search = search
      controller.view.frame = view.bounds
      controller.view.alpha = 0

      view.addSubview(controller.view)
      addChild(controller)
      coordinator.animate(
        alongsideTransition: { _ in
          controller.view.alpha = 1
          self.searchBar.resignFirstResponder()
          if self.presentedViewController != nil {
            self.dismiss(animated: true, completion: nil)
          }
        }, completion: { _ in
          controller.didMove(toParent: self)
        })
    }
  }
  
  func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    if let controller = landscapeVC {
      controller.willMove(toParent: nil)
      coordinator.animate(
        alongsideTransition: { _ in
          controller.view.alpha = 0
        }, completion: { _ in
          controller.view.removeFromSuperview()
          controller.removeFromParent()
          self.landscapeVC = nil
        })
    }
  }

  // MARK: - Actions
  @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    performSearch()
  }

  // MARK: - Navigation
  override func prepare(
    for segue: UIStoryboardSegue,
    sender: Any?) {
    if segue.identifier == "ShowDetail" {
      let detailViewController = segue.destination as! DetailViewController
      let indexPath = sender as! IndexPath
      let searchResult = search.searchResults[indexPath.row]
      detailViewController.searchResult = searchResult
    }
  }
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearch()
  }

  func performSearch() {
    search.performSearch(
      for: searchBar.text!,
      category: segmentedControl.selectedSegmentIndex)
    tableView.reloadData()
    searchBar.resignFirstResponder()
  }
//  func performSearch() {
//    if !searchBar.text!.isEmpty {
//      searchBar.resignFirstResponder()
//      dataTask?.cancel()
//
//      isLoading = true
//      tableView.reloadData()
//
//      hasSearched = true
//      searchResults = []
//
//      let url = iTunesURL(
//        searchText: searchBar.text!,
//        category: segmentedControl.selectedSegmentIndex)
//      let session = URLSession.shared
//      dataTask = session.dataTask(with: url) { data, response, error in
//        if let error = error as NSError?, error.code == -999 {
//          return  // Search was cancelled (code -999)
//        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//          if let data = data {
//            self.searchResults = self.parse(data: data)
//            self.searchResults.sort(by: <)
////            // check if current thread is main
////            print("On main thread? " + (Thread.current.isMainThread ?
////                                        "Yes" : "No"))
//            DispatchQueue.main.async {
//              self.isLoading = false
//              self.tableView.reloadData()
//            }
//            return
//          }
//        } else {
//          print("Failure! \(response!)")
//        }
//        DispatchQueue.main.async {
//          self.hasSearched = false
//          self.isLoading = false
//          self.tableView.reloadData()
//          self.showNetworkError()
//        }
//      }
//      dataTask?.resume()
//    }
//  }

  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    if search.isLoading {
      return 1  // Loading...
    } else if !search.hasSearched {
      return 0  // Not searched yet
    } else if search.searchResults.count == 0 {
      return 1  // Nothing Found
    } else {
      return search.searchResults.count
    }
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    if search.isLoading {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.loadingCell,
        for: indexPath)
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    } else if search.searchResults.count == 0 {
      return tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.nothingFoundCell,
        for: indexPath)
    } else {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.searchResultCell,
        for: indexPath) as! SearchResultCell

      let searchResult = search.searchResults[indexPath.row]
      cell.configure(for: searchResult)
      return cell
    }
  }

  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "ShowDetail", sender: indexPath)
  }

  func tableView(
    _ tableView: UITableView,
    willSelectRowAt indexPath: IndexPath
  ) -> IndexPath? {
    if search.searchResults.count == 0 || search.isLoading {
      return nil
    } else {
      return indexPath
    }
  }
}
