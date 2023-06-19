//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Irakli Nozadze on 16.06.23.
//

import UIKit

class SearchResultCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var artworkImageView: UIImageView!

  var downloadTask: URLSessionDownloadTask?

  override func awakeFromNib() {
    super.awakeFromNib()
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
    selectedBackgroundView = selectedView
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    downloadTask?.cancel()
    downloadTask = nil
  }

  // MARK: - Helper Methods
  func configure(for result: SearchResult) {
    nameLabel.text = result.name
    if result.artist.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = String(format: "%@ (%@)", result.artist, result.type)
    }
    artworkImageView.image = UIImage(systemName: "square")
    if let smallURL = URL(string: result.imageSmall) {
      // loadImages closure assigns the image to weak self
      downloadTask = artworkImageView.loadImage(url: smallURL)
    }
  }
}
