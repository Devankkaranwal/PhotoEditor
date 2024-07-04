//
//  FilterCell.swift
//  PhotoEditor
//
//  Created by Devank on 02/07/24.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    let filterLabel: UILabel = {
           let label = UILabel()
           label.textAlignment = .center
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       let filterImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.contentMode = .scaleAspectFit
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
       }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupUI()
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       func setupUI() {
           contentView.addSubview(filterLabel)
           contentView.addSubview(filterImageView)
           
           NSLayoutConstraint.activate([
               filterLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
               filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               filterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               
               filterImageView.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 5),
               filterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
               filterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
               filterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
           ])
       }
       
       func configureCell(name: String, image: UIImage?) {
           filterLabel.text = name
           filterImageView.image = image
       }
    
}


