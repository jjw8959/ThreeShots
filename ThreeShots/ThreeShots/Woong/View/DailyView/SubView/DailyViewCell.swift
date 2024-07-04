//
//  DailyViewCell.swift
//  ThreeShots
//
//  Created by woong on 6/27/24.
//

import UIKit

class DailyViewCell: UITableViewCell {
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 26, weight: .semibold)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let expressionImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        view.addSubview(expressionImageView)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            expressionImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
            expressionImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            expressionImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            expressionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        return view
    }()
    
    let bestImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        contentView.addSubview(containerView)
        contentView.addSubview(bestImageView)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            bestImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bestImageView.leadingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bestImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bestImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bestImageView.heightAnchor.constraint(equalToConstant: 150)
//            bestImageView.widthAnchor.constraint(equalToConstant: 100),
//            bestImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
