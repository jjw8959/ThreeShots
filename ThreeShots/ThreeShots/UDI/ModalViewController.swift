//
//  SecondViewController.swift
//  ThreeShots
//
//  Created by YUJIN JEON on 7/8/24.
//

import UIKit

class ModalViewController: UIViewController {
    
    let addPhotoBox: UIButton = {
        let view = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        
        view.tintColor = .white
        view.backgroundColor = .systemGray2
        
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //툴바 생성
        let toolbar = UIToolbar()
        toolbar.barTintColor = .white
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        //툴바 아이템 생성
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let today = Date().toString()
        let todayToString = UIBarButtonItem(title: today)
        todayToString.tintColor = .black
        todayToString.isEnabled = false
        
        
        toolbar.items = [cancelButton, flexSpace, todayToString, flexSpace, doneButton]
        
        view.addSubview(toolbar)
        view.addSubview(addPhotoBox)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            addPhotoBox.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 10),
            addPhotoBox.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 25),
            addPhotoBox.widthAnchor.constraint(equalTo: safeArea.widthAnchor,constant: -50),
            addPhotoBox.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.30),
        ])
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        //완료 버튼 함수
    }
    
    @objc func addPhotoButtonTapped() {
        //포토피커 구현
    }
}

#Preview{
    ModalViewController()
}
