//
//  DetailView.swift
//  ThreePicDiary
//
//  Created by woong on 8/15/24.
//

import UIKit
import CoreData

final class DetailView: UIViewController {
    
    let coredata = DataManager.shared
    
    var dateString = ""
    
    var threePicsView = ThreePictureView()
    
    var contentLabel = UILabel()
    
    var diary: Diary?
    
    init(_ diary: Diary?, date: String) {
        super.init(nibName: nil, bundle: nil)
        self.diary = diary
        self.dateString = date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = dateString
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        threePicsView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = .systemBackground
        
        setViews()
        addViews()
        addConstraints()
    }
    
    private func setViews() {
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(closeButtonTapped))
        
        navigationItem.leftBarButtonItem = backButton
        
        let menuHandler: UIActionHandler = { action in
            if action.title == "edit" {
                self.editButtonTapped()
            } else {
                self.deleteButtonTapped()
            }
        }
        var barButtonMenu = UIMenu()
        if diary != nil {
            barButtonMenu = UIMenu(title: "menu", children: [
                UIAction(title: "edit", image: UIImage(systemName: "pencil"), handler: menuHandler),
                UIAction(title: "delete", image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal), handler: menuHandler)
            ])
        } else {
            barButtonMenu = UIMenu(title: "menu", children: [
                UIAction(title: "edit", image: UIImage(systemName: "pencil"), handler: menuHandler)
            ])
        }
        
        
        let menuButton = UIBarButtonItem(title: "menu", image: UIImage(systemName: "ellipsis"),target: self, action: nil)
        
        navigationItem.rightBarButtonItem = menuButton
        navigationItem.rightBarButtonItem?.menu = barButtonMenu
        
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
    
    @objc func closeButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func editButtonTapped() {
        let editView = EditDiaryView(diary, date: dateString)
        editView.dateString = dateString
        navigationController?.pushViewController(editView, animated: true)
    }
    
    func deleteButtonTapped() {
        if let diary = diary {
            let deleteAlert = UIAlertController(title: "이런", message: "정말로 일기를 지우실건가요?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel)
            let deleteAction = UIAlertAction(title: "지우기", style: .destructive) { _ in
                self.coredata.deleteData(diary: diary)
                self.navigationController?.popToRootViewController(animated: true)
            }
            deleteAlert.addAction(cancelAction)
            deleteAlert.addAction(deleteAction)
            present(deleteAlert, animated: true)
            
        }
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
