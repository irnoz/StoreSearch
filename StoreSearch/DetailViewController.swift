//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Irakli Nozadze on 19.06.23.
//

import UIKit

class DetailViewController: UIViewController {

  var searchResult: SearchResult!

  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var kindLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var priceButton: UIButton!

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
  }

  // MARK: - Actions
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
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
