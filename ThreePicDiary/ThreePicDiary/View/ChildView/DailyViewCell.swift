//
//  DailyViewCell.swift
//  ThreePicDiary
//
//  Created by woong on 8/21/24.
//

import UIKit

class DailyViewCell: UITableViewCell {
    
    var dateString: String? {
        didSet {
            monthLabel.text = dateString?.toDate()?.toString(dateFormat: "MMM")
            dayLabel.text = dateString?.toDate()?.toString(dateFormat: "d")
            dowLabel.text = dateString?.toDate()?.toString(dateFormat: "EEEE")
        }
    }
    
    var firstImage: UIImage? {
        didSet {
            firstImageView.image = firstImage
        }
    }
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private let monthLabel = UILabel()
    
    private let dayLabel = UILabel()
    
    private let dowLabel = UILabel() // 요일(day of the week
    
    private let firstImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setViews()
        addViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dowLabel.translatesAutoresizingMaskIntoConstraints = false
        firstImageView.translatesAutoresizingMaskIntoConstraints = false

        monthLabel.textAlignment = .center
        dayLabel.textAlignment = .center
        dowLabel.textAlignment = .center
        
        monthLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dayLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle).withWeight(.semibold)
        dowLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 3
        
        stackView.addArrangedSubview(monthLabel)
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(dowLabel)
        
        firstImageView.contentMode = .scaleAspectFill
        firstImageView.layer.cornerRadius = 10
        firstImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        firstImageView.clipsToBounds = true
        
        
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        containerView.layer.shadowRadius = 5
        containerView.layer.masksToBounds = false
        
        containerView.backgroundColor = .systemBackground
        
        containerView.addSubview(stackView)
        containerView.addSubview(firstImageView)
    }
    
    private func addViews() {
        contentView.addSubview(containerView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
            
            firstImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            firstImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            firstImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            firstImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            firstImageView.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.trailingAnchor.constraint(equalTo: firstImageView.leadingAnchor),
        ])
    }
}
