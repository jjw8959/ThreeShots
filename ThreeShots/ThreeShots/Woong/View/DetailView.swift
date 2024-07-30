//
//  DailyView.swift
//  ThreeShots
//
//  Created by woong on 6/24/24.
//

import UIKit

import CoreData

final class DetailView: UIViewController {
    //TODO: 테이블뷰로 db에서 불러오기, 페이징
    //TODO: 일기 서브뷰 만들기(사진세개, 사진누르면 오버레이(페이징컨트롤러), 하단에 글
    let coredata = CoredataManager.shared
    
    var dateString = "2024.07.29"
    
    private lazy var threePicsView: PhotoView = {
        let view = PhotoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentLabel: UILabel = {
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
        
        view.backgroundColor = .systemBackground
        
        let result = coredata.loadData(date: dateString)

        if result.date != "" {
            // TODO: 이미지 불러와서 미리 채우기
            
            contentLabel.text = result.contents
            threePicsView.firstImageView.image = result.firstImage
            threePicsView.secondImageView.image = result.secondImage
            threePicsView.thirdImageView.image = result.thirdImage
            
            print("데이터 있음")
        } else {
            
            contentLabel.text = "아직 작성된 일기가 없어요..."
            threePicsView.firstImageView.image = UIImage(named: "gray")
            threePicsView.secondImageView.image = UIImage(named: "gray")
            threePicsView.thirdImageView.image = UIImage(named: "gray")
            print("데이터 없음")
        }
        
        modifyNavibar()
        
        addSubViews()
        addConstraints()
        
        if threePicsView.firstImageView.image != UIImage(named: "gray")
            && threePicsView.secondImageView != UIImage(named: "gray")
            && threePicsView.thirdImageView != UIImage(named: "gray") {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPicture(_:)))
            threePicsView.addGestureRecognizer(tapGesture)
        }
        
    }
    
    private func modifyNavibar() {
        
        self.title = dateString
        let backButton = UIBarButtonItem(title: "back", image: UIImage(systemName: "xmark"), target: self, action: #selector(dismissView))
        
        let menuHandler: UIActionHandler = { action in
            if action.title == "edit" {
                self.editButtonTapped()
            } else {
                self.deleteButtonTapped()
            }
        }
        
        let barButtonMenu = UIMenu(title: "menu", children: [
            UIAction(title: "edit", image: UIImage(systemName: "pencil"), handler: menuHandler),
            UIAction(title: "delete", image: UIImage(systemName: "trash"), handler: menuHandler)
        ])
        
        let menuButton = UIBarButtonItem(title: "menu", image: UIImage(systemName: "ellipsis"),target: self, action: nil)
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = menuButton
        navigationItem.rightBarButtonItem?.menu = barButtonMenu
        
    }
    
    private func addSubViews() {
        view.addSubview(threePicsView)
        view.addSubview(contentLabel)
    }
    
    private func addConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        //TODO: 이미지 갯수에 따라서 뷰 수정되야함
        NSLayoutConstraint.activate([
            
            threePicsView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            threePicsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            threePicsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            threePicsView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.3),
            
            contentLabel.topAnchor.constraint(equalTo: threePicsView.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
        ])
    }
    
    @objc
    private func tapPicture(_ gesture: UITapGestureRecognizer) {
        let firstImageView = threePicsView.firstImageView
        let secondImageView = threePicsView.secondImageView
        let thirdImageView = threePicsView.thirdImageView

        let pageViewController = ImageOverlayView([firstImageView, secondImageView, thirdImageView])
        present(pageViewController, animated: true)
    }
    
    @objc
    private func dismissView() {
        dismiss(animated: true)
    }
    
    func editButtonTapped() {
        let editView = EditDiaryView()
        editView.dateString = dateString
        navigationController?.pushViewController(editView, animated: true)
        print("실행됨")
    }
    
    func deleteButtonTapped() {
        coredata.deleteData(date: dateString)
        print("삭제 메서드 실행됨")
        dismiss(animated: true)
    }
}

#Preview {
    DetailView()
}
