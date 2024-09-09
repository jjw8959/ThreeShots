//
//  SecondViewController.swift
//  ThreeShots
//
//  Created by YUJIN JEON on 7/8/24.
//

import UIKit

class AddPhotoView: UIViewController {
    
    var dataSendClosure: (([UIImage]) -> Void)?
    
    let toolbar = UIToolbar()
    let addPhotoBoxVC = AddPhotoBoxViewController()
    
    var dateString = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = dateString
        
        let backButton = UIBarButtonItem(title: "back", image: UIImage(systemName: "chevron.left"), target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = doneButton
        
        addChild(addPhotoBoxVC)
        view.addSubview(addPhotoBoxVC.view)
        addPhotoBoxVC.didMove(toParent: self)
        addPhotoBoxVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            addPhotoBoxVC.view.topAnchor.constraint(equalTo: safeArea.topAnchor),
            addPhotoBoxVC.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            addPhotoBoxVC.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            addPhotoBoxVC.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonTapped() {
        // 완료 버튼 함수, 사진 고른거 넘기기
        if self.addPhotoBoxVC.imageViews[0].image != nil {
            guard let editDiaryView = navigationController?.viewControllers.first(where: { $0 is EditDiaryView }) as? EditDiaryView else { return }
            
            editDiaryView.threePicsView.firstImageView.image = self.addPhotoBoxVC.imageViews[0].image
            editDiaryView.threePicsView.secondImageView.image = self.addPhotoBoxVC.imageViews[1].image
            editDiaryView.threePicsView.thirdImageView.image = self.addPhotoBoxVC.imageViews[2].image
            
            editDiaryView.threePicsView.firstImageView.setNeedsDisplay()
            editDiaryView.threePicsView.secondImageView.setNeedsDisplay()
            editDiaryView.threePicsView.thirdImageView.setNeedsDisplay()
            
            editDiaryView.addPicsButton.backgroundColor = .none
            editDiaryView.addPicsButton.tintColor = .none
            editDiaryView.addPicsButton.setImage(.none, for: .normal)
            
            self.navigationController?.popViewController(animated: true)
        } else {
            let cantDoneAlert = UIAlertController(title: "이런!", message: "고른 사진이 없어요.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel)
            cantDoneAlert.addAction(cancelAction)
            present(cantDoneAlert, animated: true)
        }
        
        
    }
}

extension Date {
    
}

#Preview{
    AddPhotoView()
}
