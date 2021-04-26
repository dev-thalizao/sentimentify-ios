//
//  SearchResultCell.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit
import Kingfisher

final class SearchResultCell: UITableViewCell {
    
    class var nib: UINib {
        return UINib(nibName: "SearchResultCell", bundle: bundle)
    }
    
    class var bundle: Bundle {
        return Bundle(for: SearchResultCell.self)
    }
    
    class var identifier: String {
        return String(describing: self)
    }

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearContent()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearContent()
    }
    
    private func clearContent() {
        userImageView.kf.cancelDownloadTask()
        userNameLabel.text = nil
        screenNameLabel.text = nil
        contentLabel.text = nil
        createdAtLabel.text = nil
    }
}
