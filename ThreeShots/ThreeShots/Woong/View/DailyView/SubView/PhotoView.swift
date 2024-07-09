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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let secondImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "mock2")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let thirdImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "mock3")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        applyRoundedCorners(to: firstImageView, corners: [.bottomLeft, .topLeft], radius: 10)
        applyRoundedCorners(to: secondImageView, corners: [.topRight], radius: 10)
        applyRoundedCorners(to: thirdImageView, corners: [.bottomRight], radius: 10)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if firstImageView.frame.contains(location) {
            firstImageViewTapped()
        }
        
        if secondImageView.frame.contains(location) {
            secondImageViewTapped()
        }
        
        if thirdImageView.frame.contains(location) {
            thirdImageViewTapped()
        }
    }
    
    private func firstImageViewTapped() {
        print("firstImageView Tapped in PhotoView")
    }
    
    private func secondImageViewTapped() {
        print("secondImageViewTapped Tapped in PhotoView")
    }
    
    private func thirdImageViewTapped() {
        print("thirdImageViewTapped Tapped in PhotoView")
    }
    
    func applyRoundedCorners(to view: UIView, corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            applyRoundedCorners(to: firstImageView, corners: [.topLeft, .bottomLeft], radius: 10)
            applyRoundedCorners(to: secondImageView, corners: [.topRight], radius: 10)
            applyRoundedCorners(to: thirdImageView, corners: [.bottomRight], radius: 10)
        }
}

#Preview {
    PhotoView()
}
