//
//  EditDiaryView.swift
//  ThreePicDiary
//
//  Created by woong on 8/15/24.
//

import UIKit
import CoreData

final class EditDiaryView: UIViewController, UITextViewDelegate, ThreePictureViewDelegate {
    
    let coredata = DataManager.shared
    
    var dateString: String = ""
    
    var diary: Diary?
    
    //    MARK: UI Components
    var addPicsButton = UIButton()
    
    var threePicsView = ThreePictureView()
    
    var contentField = UITextView()
    
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
        view.backgroundColor = .systemBackground
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        contentField.delegate = self
        threePicsView.delegate = self
        
        self.navigationItem.title = dateString
        
        setViews()
        addViews()
        addConstraints()
    }
    
    private func setViews() {
        //    MARK: 네비게이션바
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        saveButton.image = UIImage(systemName: "square.and.arrow.down")
        saveButton.title = "Save"
        
        navigationItem.rightBarButtonItem = saveButton
        
        //    MARK: translates~ = false
        threePicsView.translatesAutoresizingMaskIntoConstraints = false
        addPicsButton.translatesAutoresizingMaskIntoConstraints = false
        contentField.translatesAutoresizingMaskIntoConstraints = false
        
        //    MARK: 뷰 세부조정
        if diary != nil {   // 데이터 있을때
            contentField.text = diary?.content
            threePicsView.firstImageView.image = diary?.firstImage
            threePicsView.secondImageView.image = diary?.secondImage
            threePicsView.thirdImageView.image = diary?.thirdImage
            addPicsButton.addTarget(self, action: #selector(tappedImageEditButton), for: .touchUpInside)
            contentField.font = UIFont.systemFont(ofSize: 16)
            
        } else {    // 데이터 없을때
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
            let configuredImage = UIImage(systemName: "plus", withConfiguration: imageConfig)
            addPicsButton.setImage(configuredImage, for: .normal)
            addPicsButton.backgroundColor = .systemGray
            addPicsButton.layer.cornerRadius = CGFloat(10)
            addPicsButton.tintColor = .white
            addPicsButton.addTarget(self, action: #selector(tappedImageEditButton), for: .touchUpInside)
            contentField.text = "아직 작성된 일기가 없어요..."
            contentField.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
    private func addViews() {
        view.addSubview(threePicsView)
        view.addSubview(addPicsButton)
        view.addSubview(contentField)
    }
    
    private func addConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            threePicsView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            threePicsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            threePicsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            threePicsView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.3),
            
            addPicsButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            addPicsButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            addPicsButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            addPicsButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.3),
            
            contentField.topAnchor.constraint(equalTo: addPicsButton.bottomAnchor, constant: 16),
            contentField.leadingAnchor.constraint(equalTo: addPicsButton.leadingAnchor),
            contentField.trailingAnchor.constraint(equalTo: addPicsButton.trailingAnchor),
            contentField.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
    }
    
    @objc
    func tappedImageEditButton() {
        let imageEditView = AddPhotoView()
        
        imageEditView.dataSendClosure = { images in
            self.threePicsView.firstImageView.image = images[0]
            self.threePicsView.secondImageView.image = images[1]
            self.threePicsView.thirdImageView.image = images[2]
        }
        
        navigationController?.pushViewController(imageEditView, animated: true)
    }
    
    @objc
    func saveButtonTapped() {
        
        if threePicsView.firstImageView == UIImage(named: "gray") || contentField.text == "아직 작성된 일기가 없어요..." {
            let cantSaveAlert = UIAlertController(title: "이런", message: "아무런 내용이 없어요", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel)
            cantSaveAlert.addAction(cancelAction)
            present(cantSaveAlert, animated: true)
        } else {
//            coredata.saveData(date: dateString, content: contentField.text ?? "",
//                              firstImage: (threePicsView.firstImageView.image),
//                              secondImage: (threePicsView.secondImageView.image),
//                              thirdImage: (threePicsView.thirdImageView.image)
//            
//            
//            if let date = dateString.toDate() {
//                print("date")
////                calendarViewController!.reloadDateView(date: date)
//                delegate?.sendData(date: dateString)
//            }
            
            if diary != nil {
                diary = Diary(date: dateString, year: dateString.substring(from: 2, to: 3), month: dateString.substring(from: 5, to: 6), content: contentField.text, firstImage: threePicsView.firstImageView.image, secondImage: threePicsView.secondImageView.image, thirdImage: threePicsView.thirdImageView.image)
                coredata.updateData(userDiary: diary!)
                print("update")
            } else {
                diary = Diary(date: dateString, year: dateString.substring(from: 2, to: 3), month: dateString.substring(from: 5, to: 6), content: contentField.text, firstImage: threePicsView.firstImageView.image, secondImage: threePicsView.secondImageView.image, thirdImage: threePicsView.thirdImageView.image)
                coredata.saveData(userDiary: diary!)
                print("save")
            }
            
            
            let detailView = DetailView(diary, date: dateString)
            navigationController?.pushViewController(detailView, animated: true)
            
        }
    }
    
    func setPictures() {
//        if diary != nil {
        if diary?.firstImage != nil {
            threePicsView.firstImageView.image = diary?.firstImage
        } else {
            threePicsView.firstImageView.image = UIImage(named: "gray")
        }
        
        if diary?.secondImage != nil {
            threePicsView.secondImageView.image = diary?.secondImage
        } else {
            threePicsView.secondImageView.image = UIImage(named: "gray")
        }
        
        if diary?.thirdImage != nil {
            threePicsView.thirdImageView.image = diary?.thirdImage
        } else {
            threePicsView.thirdImageView.image = UIImage(named: "gray")
        }
//        }
        
    }
    
}

//#Preview {
//    EditDiaryView()
//}
