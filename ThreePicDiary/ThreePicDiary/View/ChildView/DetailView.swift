//
//  DetailView.swift
//  ThreePicDiary
//
//  Created by woong on 8/15/24.
//

import UIKit

final class DetailView: UIViewController {
    
    var dateString = ""
    
    var threePicsView = ThreePictureView()
    
    var contentLabel = UILabel()
    
    var diary: Diary?
    
    init(_ diary: Diary?, date: String) {
        super.init(nibName: nil, bundle: nil)
        self.diary = diary
        self.dateString = date
//        print("DetailView init")
//        
        print(diary)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        threePicsView.delegate = self
        
        self.navigationController?.title = dateString
        self.view.backgroundColor = .systemBackground
        
        setViews()
        addViews()
        addConstraints()
    }
    
    private func setViews() {
        threePicsView.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        threePicsView.firstImageView.image = diary?.firstImage
        threePicsView.secondImageView.image = diary?.secondImage
        threePicsView.thirdImageView.image = diary?.thirdImage
        
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.numberOfLines = 0
        contentLabel.sizeToFit()
        contentLabel.text = self.diary?.content
    }
    
    private func addViews() {
        self.view.addSubview(threePicsView)
        self.view.addSubview(contentLabel)
    }
    
    private func addConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            threePicsView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            threePicsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            threePicsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            threePicsView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.3),
            
            contentLabel.topAnchor.constraint(equalTo: threePicsView.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: threePicsView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: threePicsView.trailingAnchor),
        ])
    }
    
}

//    MARK: 델리게이트 설정
extension DetailView: ThreePictureViewDelegate {
    func setPictures() {
        threePicsView.firstImageView.image = diary?.firstImage
        threePicsView.secondImageView.image = diary?.secondImage
        threePicsView.thirdImageView.image = diary?.thirdImage
    }
}
