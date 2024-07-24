//
//  SecondViewController.swift
//  ThreeShots
//
//  Created by YUJIN JEON on 7/8/24.
//

import UIKit

class ModalViewController: UIViewController {
    let toolbar = UIToolbar()
    let addPhotoBoxViewController = AddPhotoBoxViewController()
    
    var dateString = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // 툴바 생성
        toolbar.barTintColor = .white
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        // 툴바 아이템 생성
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        let todayToString = UIBarButtonItem(title: dateString)
        todayToString.tintColor = .black
//        todayToString.isEnabled = false
        
        toolbar.items = [cancelButton, flexSpace, todayToString, flexSpace, doneButton]
        
        view.addSubview(toolbar)
        
        // AddPhotoBoxViewController를 추가
        addChild(addPhotoBoxViewController)
        view.addSubview(addPhotoBoxViewController.view)
        addPhotoBoxViewController.didMove(toParent: self)
        addPhotoBoxViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            
            addPhotoBoxViewController.view.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            addPhotoBoxViewController.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            addPhotoBoxViewController.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            addPhotoBoxViewController.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        // 완료 버튼 함수
    }
}

extension Date {
    func toString(dateFormat format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

#Preview{
    ModalViewController()
}
