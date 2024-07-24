//
//  EditDiaryView.swift
//  ThreeShots
//
//  Created by woong on 7/24/24.
//

import UIKit

final class EditDiaryView: UIViewController {
//    TODO: 다이어리 추가 및 수정시에 현재 뷰 하나로 활용할 수 있도록 제작.
    
//    TODO: 현재 이미지 없으면 이미지대신 +버튼, 있으면 photoview를 이용. 터치하면 이미지 고르는 화면으로 넘기기

    
//    TODO: 현재 내용 없으면 빈 에디터, 있으면 그 내용으로 채워진 에디터
//    let toolbar = UIToolbar()
    let dummyLabel = UILabel()
    
    private var threePicsView = PhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        addDummy()
        
//        translatesAuth()
    }
    
    func addDummy() {
        dummyLabel.translatesAutoresizingMaskIntoConstraints = false
        dummyLabel.text = "hello, world!"
        dummyLabel.textColor = .black
        dummyLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(dummyLabel)
        NSLayoutConstraint.activate([
            dummyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dummyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    private func modifyView() {
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelButton
//        toolbar.items = [flexSpace]
    }
    
    func translatesAuth() {
//        toolbar.translatesAutoresizingMaskIntoConstraints = false
//        threePicsView.translatesAutoresizingMaskIntoConstraints = false
    }
}
