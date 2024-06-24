//
//  PhotoView.swift
//  ThreeShots
//
//  Created by woong on 6/24/24.
//

import UIKit

final class PhotoView: UIView {
    
    private let firstImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "sun.max")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let secondImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "sun.max")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let thirdImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "sun.max")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var firstImage: UIImage? {
        didSet {
            firstImageView.image = firstImage
        }
    }
    
    public var secondImage: UIImage? {
        didSet {
            secondImageView.image = secondImage
        }
    }
    
    public var thirdImage: UIImage? {
        didSet {
            thirdImageView.image = thirdImage
        }
    }
       
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubview(firstImageView)
        self.addSubview(secondImageView)
        self.addSubview(thirdImageView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            firstImageView.topAnchor.constraint(equalTo: self.topAnchor),
            firstImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            firstImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            firstImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            
            secondImageView.topAnchor.constraint(equalTo: self.topAnchor),
            secondImageView.leadingAnchor.constraint(equalTo: firstImageView.trailingAnchor),
            secondImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            secondImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            
            thirdImageView.topAnchor.constraint(equalTo: secondImageView.bottomAnchor),
            thirdImageView.leadingAnchor.constraint(equalTo: firstImageView.trailingAnchor),
            thirdImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            thirdImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
        ])
    }
}
