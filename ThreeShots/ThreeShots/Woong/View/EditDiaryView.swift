//
//  EditDiaryView.swift
//  ThreeShots
//
//  Created by woong on 7/24/24.
//

import UIKit
import CoreData

import RxSwift
import RxCocoa

final class EditDiaryView: UIViewController {
    var checker = 0 // 0이면 데이터 빈거 1이면 데이터 있는거
    var calendarViewController: CalendarView?
    
    var result: [NSFetchRequestResult]?
    
    let coredata = CoredataManager.shared
    
    var dateString = ""
    
    var threePicsView = PhotoView()
    
    var addPicsButton = UIButton()
    
    private var contentsField = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // 블랙으로 바꾸기
        
        title = dateString
        
        contentsField.delegate = self
        
        let result = coredata.loadData(date: dateString)
        
        // 데이터있으면
        if result.date != "" {
            // TODO: 이미지 불러와서 미리 채우기
            contentsField.text = result.contents
            threePicsView.firstImageView.image = result.firstImage
            threePicsView.secondImageView.image = result.secondImage
            threePicsView.thirdImageView.image = result.thirdImage
            print("데이터 있음")
            print(result.date)
            checker = 1
            
        } else { // 데이터 없으면
            contentsField.text = "아직 작성된 일기가 없어요..."
            contentsField.textColor = .placeholderText
            threePicsView.firstImageView.image = UIImage(named: "gray")
            threePicsView.secondImageView.image = UIImage(named: "gray")
            threePicsView.thirdImageView.image = UIImage(named: "gray")
            
            checker = 0
            print("데이터 없음")
        }
        
        modifyViews()
        translatesAuth()
        addSubviews()
        addConstraints()
        
        if checker == 1 { // 데이터 있으면 사진뷰 누르면 이걸로 사진 수정뷰 가져온다.
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPicture(_:)))
            threePicsView.addGestureRecognizer(tapGesture)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear called")
        print("First Image: \(String(describing: threePicsView.firstImageView.image))")
        print("Second Image: \(String(describing: threePicsView.secondImageView.image))")
        print("Third Image: \(String(describing: threePicsView.thirdImageView.image))")
        
    }
    
    private func modifyViews() {
        
        let closeButton = UIBarButtonItem(title: "close", image: UIImage(systemName: "xmark"), target: self, action: #selector(closeButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let configuredImage = UIImage(systemName: "plus", withConfiguration: imageConfig)
        addPicsButton.setImage(configuredImage, for: .normal)
        addPicsButton.backgroundColor = .systemGray
        addPicsButton.layer.cornerRadius = CGFloat(10)
        addPicsButton.tintColor = .white
        addPicsButton.addTarget(self, action: #selector(tappedImageEditButton), for: .touchUpInside)
        
        contentsField.layer.borderWidth = CGFloat(2)
        contentsField.layer.borderColor = UIColor.gray.cgColor
        contentsField.layer.cornerRadius = CGFloat(10)
        contentsField.font = .systemFont(ofSize: 20)
    }
    
    private func translatesAuth() {
        threePicsView.translatesAutoresizingMaskIntoConstraints = false
        addPicsButton.translatesAutoresizingMaskIntoConstraints = false
        contentsField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        if checker == 0 {
            view.addSubview(threePicsView)
            view.addSubview(addPicsButton)
        } else {
            view.addSubview(threePicsView)
        }
        view.addSubview(contentsField)
    }
    
    private func addConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        if threePicsView.firstImageView.image == UIImage(named: "gray") && threePicsView.secondImageView.image == UIImage(named: "gray") && threePicsView.thirdImageView.image == UIImage(named: "gray") {
            NSLayoutConstraint.activate([
                threePicsView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                threePicsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
                threePicsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
                threePicsView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.3),
                
                // TODO: 사진 세개 다 gray면 addPicsButton을 threePicsView위로 배치
                addPicsButton.topAnchor.constraint(equalTo: threePicsView.topAnchor),
                addPicsButton.leadingAnchor.constraint(equalTo: threePicsView.leadingAnchor),
                addPicsButton.trailingAnchor.constraint(equalTo: threePicsView.trailingAnchor),
                addPicsButton.heightAnchor.constraint(equalTo: threePicsView.heightAnchor, multiplier: 1.0),
                
                contentsField.topAnchor.constraint(equalTo: addPicsButton.bottomAnchor, constant: 16),
                contentsField.leadingAnchor.constraint(equalTo: threePicsView.leadingAnchor),
                contentsField.trailingAnchor.constraint(equalTo: threePicsView.trailingAnchor),
                contentsField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 16)
            ])
        } else { // 데이터 있을때
            NSLayoutConstraint.activate([
                threePicsView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                threePicsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
                threePicsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
                threePicsView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.3),
                
                contentsField.topAnchor.constraint(equalTo: threePicsView.bottomAnchor, constant: 16),
                contentsField.leadingAnchor.constraint(equalTo: threePicsView.leadingAnchor),
                contentsField.trailingAnchor.constraint(equalTo: threePicsView.trailingAnchor),
                contentsField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 16)
                
            ])
        }
        
    }
    
    @objc
    func tappedImageEditButton() {
        let editView = AddPhotoView()
        navigationController?.pushViewController(editView, animated: true)
        print("실행됨")
    }
    
    @objc
    func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func doneButtonTapped() {
        
        if threePicsView.firstImageView == UIImage(named: "gray") &&
            threePicsView.secondImageView == UIImage(named: "gray") &&
            threePicsView.thirdImageView == UIImage(named: "gray") ||
            contentsField.text == "아직 작성된 일기가 없어요..." {
            let cantSaveAlert = UIAlertController(title: "이런", message: "아무런 내용이 없어요", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel)
            cantSaveAlert.addAction(cancelAction)
            present(cantSaveAlert, animated: true)
        } else {
            coredata.saveData(date: dateString, content: contentsField.text ?? "",
                              firstImage: ((threePicsView.firstImageView.image) ?? UIImage(named: "gray"))!,
                              secondImage: ((threePicsView.secondImageView.image) ?? UIImage(named: "gray"))!,
                              thirdImage: ((threePicsView.thirdImageView.image) ?? UIImage(named: "gray"))!)
            
            if let calendarVC = calendarViewController {
                if let date = dateString.toDate() {
                    calendarVC.reloadDateView(date: date)
                }
            }
            
            dismiss(animated: true)
        }
    }
    
    @objc
    private func tapPicture(_ gesture: UITapGestureRecognizer) {
        navigationController?.pushViewController(AddPhotoView(), animated: true)
    }
    
}

// MARK: UITextViewDelegate

extension EditDiaryView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .placeholderText else { return }
        textView.textColor = .label
        textView.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "아직 작성된 일기가 없어요..."
            textView.textColor = .placeholderText
        }
    }
}
