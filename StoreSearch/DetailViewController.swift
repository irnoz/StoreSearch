//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Irakli Nozadze on 19.06.23.
//

import UIKit

class DetailViewController: UIViewController {

  var searchResult: SearchResult!
  var downloadTask: URLSessionDownloadTask?

  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var kindLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var priceButton: UIButton!

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    popupView.layer.cornerRadius = 10

    let gestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(close))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
    
    if searchResult != nil {
      updateUI()
    }
    
    // Show price
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = searchResult.currency
    let priceText: String
    if searchResult.price == 0 {
      priceText = "Free"
    } else if let text = formatter.string(
      from: searchResult.price as NSNumber) {
      priceText = text
    } else {
      priceText = ""
    }
    priceButton.setTitle(priceText, for: .normal)
    
    // Gradient view
    view.backgroundColor = UIColor.clear
    let dimmingView = GradientView(frame: CGRect.zero)
    dimmingView.frame = view.bounds
    view.insertSubview(dimmingView, at: 0)
  }

  deinit {
    print("deinit \(self)")
    downloadTask?.cancel()
  }

  // MARK: - Actions
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func openInStore() {
    if let url = URL(string: searchResult.storeURL) {
      UIApplication.shared.open(
        url, options: [:], completionHandler: nil)
    }
  }

  // MARK: - Helper Methods
  func updateUI() {
    nameLabel.text = searchResult.name
    if searchResult.artist.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = searchResult.artist
    }
    kindLabel.text = searchResult.type
    genreLabel.text = searchResult.genre
    
    // Get image
    if let largeURL = URL(string: searchResult.imageLarge) {
      downloadTask = artworkImageView.loadImage(url: largeURL)
    }
  }
}

// MARK: - Gesture
// a delegate method to check if the tapped item is the view behind popup
extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldReceive touch: UITouch
  ) -> Bool {
    return (touch.view === self.view)
  }
}
