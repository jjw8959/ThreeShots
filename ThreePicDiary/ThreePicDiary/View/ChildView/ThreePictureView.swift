//
//  ThreePictureView.swift
//  ThreePicDiary
//
//  Created by woong on 8/15/24.
//

import UIKit

protocol ThreePictureViewDelegate: AnyObject {
    func setPictures()
}

final class ThreePictureView: UIView {
    
    weak var delegate: ThreePictureViewDelegate?
    
    let firstImageView = UIImageView()
    let secondImageView = UIImageView()
    let thirdImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        delegate?.setPictures()
        
        addViews()
        addConstraints()
    }
    
    private func setViews() {
        let imageViews = [firstImageView, secondImageView, thirdImageView]
        
        for imageView in imageViews {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "gray")
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    private func addViews() {
        if secondImageView.image == nil && thirdImageView.image == nil {
            self.addSubview(firstImageView)
        } else if thirdImageView.image == nil {
            self.addSubview(firstImageView)
            self.addSubview(secondImageView)
        } else {
            self.addSubview(firstImageView)
            self.addSubview(secondImageView)
            self.addSubview(thirdImageView)
        }
        
    }
    
    private func addConstraints() {
        if secondImageView.image == nil && thirdImageView.image == nil {
            NSLayoutConstraint.activate([
                firstImageView.topAnchor.constraint(equalTo: self.topAnchor),
                firstImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                firstImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                firstImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        } else if thirdImageView.image == nil {
            NSLayoutConstraint.activate([
                firstImageView.topAnchor.constraint(equalTo: self.topAnchor),
                firstImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                firstImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                firstImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
                
                secondImageView.topAnchor.constraint(equalTo: self.topAnchor),
                secondImageView.leadingAnchor.constraint(equalTo: firstImageView.trailingAnchor),
                secondImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                secondImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
            
        } else {
            NSLayoutConstraint.activate([
                firstImageView.topAnchor.constraint(equalTo: self.topAnchor),
                firstImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                firstImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                firstImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
                
                secondImageView.topAnchor.constraint(equalTo: self.topAnchor),
                secondImageView.leadingAnchor.constraint(equalTo: firstImageView.trailingAnchor),
                secondImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                secondImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
                secondImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
                
                thirdImageView.topAnchor.constraint(equalTo: secondImageView.bottomAnchor),
                thirdImageView.leadingAnchor.constraint(equalTo: secondImageView.leadingAnchor),
                thirdImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                thirdImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
                thirdImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            ])
        }
       
    }
    
}

