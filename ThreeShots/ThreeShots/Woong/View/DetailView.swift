//
//  DailyView.swift
//  ThreeShots
//
//  Created by woong on 6/24/24.
//

import UIKit

final class DetailView: UIViewController {
    //TODO: 테이블뷰로 db에서 불러오기, 페이징
    //TODO: 일기 서브뷰 만들기(사진세개, 사진누르면 오버레이(페이징컨트롤러), 하단에 글
    
    private lazy var threePicsView: PhotoView = {
        let view = PhotoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let diaryLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16)
        view.text = "난 이제"
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let numberOfImages = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        addConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPicture(_:)))
        threePicsView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func tapPicture(_ gesture: UITapGestureRecognizer) {
        let firstImageView = threePicsView.firstImageView
        let secondImageView = threePicsView.secondImageView
        let thirdImageView = threePicsView.thirdImageView

        let pageViewController = ImageOverlayView([firstImageView, secondImageView, thirdImageView])
        present(pageViewController, animated: true)
    }
    
    private func addSubViews() {
        view.addSubview(threePicsView)
        view.addSubview(diaryLabel)
    }
    
    private func addConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        //TODO: 이미지 갯수에 따라서 뷰 수정되야함
        NSLayoutConstraint.activate([
            threePicsView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            threePicsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32),
            threePicsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32),
            threePicsView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.3),
            
            
            diaryLabel.topAnchor.constraint(equalTo: threePicsView.bottomAnchor, constant: 20),
            diaryLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32),
            diaryLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32),
        ])
    }
}

#Preview {
    DetailView()
}
