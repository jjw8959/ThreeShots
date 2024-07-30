//
//  PhotoView.swift
//  ThreeShots
//
//  Created by woong on 6/24/24.
//

import UIKit

final class PhotoView: UIView {
    
    let firstImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "mock1")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
//        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let secondImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "mock2")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
//        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let thirdImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "mock3")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
//        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
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

#Preview {
    PhotoView()
}
