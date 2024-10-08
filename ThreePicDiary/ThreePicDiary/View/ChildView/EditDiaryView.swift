//
//  EditDiaryView.swift
//  ThreePicDiary
//
//  Created by woong on 8/15/24.
//

import UIKit
import CoreData

final class EditDiaryView: UIViewController, ThreePictureViewDelegate {
    
    let coredata = DataManager.shared
    
    var dateString: String = ""
    
    var diary: Diary?
    
    //    MARK: UI Components
    var addPicsButton = UIButton()
    
    var threePicsView = ThreePictureView()
    
    var contentField = UITextView()
    
    private var backgroundLayer: CALayer!
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
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
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        contentField.delegate = self
        threePicsView.delegate = self
        
        self.navigationItem.title = dateString
        let preferredSize = UIFont.preferredFont(forTextStyle: .title3)
        let fontSize = preferredSize.pointSize
        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: fontSize)!
        ]
        
        setupBackgroundLayer()
        changeBackground()
        setViews()
        addViews()
        addConstraints()
    }
    
    private func setupBackgroundLayer() {
        backgroundLayer = CALayer()
        backgroundLayer.contents = UIImage(named: "background")?.cgImage
        backgroundLayer.frame = view.bounds
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    private func changeBackground() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.backgroundLayer.contents = UIImage(named: "background")?.cgImage
        }
    }
    
    private func setViews() {
        //    MARK: 네비게이션바
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(closeButtonTapped))
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        saveButton.setTitleTextAttributes([.font: UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: UIFont.buttonFontSize)!], for: .normal)
        saveButton.setTitleTextAttributes([.font: UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: UIFont.buttonFontSize)!], for: .selected)
        
        backButton.tintColor = .label
        saveButton.tintColor = .label
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveButton
        
        let preferredSize = UIFont.preferredFont(forTextStyle: .title2)
        let fontSize = preferredSize.pointSize
        contentField.font = UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: fontSize)
        contentField.backgroundColor = .clear
        
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
            addPicsButton.addTarget(self, action: #selector(imageEditButtonTapped), for: .touchUpInside)
        } else {    // 데이터 없을때
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
            let configuredImage = UIImage(systemName: "plus", withConfiguration: imageConfig)
            addPicsButton.setImage(configuredImage, for: .normal)
            addPicsButton.backgroundColor = .systemGray2
            addPicsButton.layer.cornerRadius = CGFloat(10)
            addPicsButton.tintColor = .white
            addPicsButton.addTarget(self, action: #selector(imageEditButtonTapped), for: .touchUpInside)
            contentField.text = "아직 작성된 일기가 없어요..."
            contentField.textColor = .placeholderText
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
    func imageEditButtonTapped() {
        let imageEditView = AddPhotoView()
        
        imageEditView.dataSendClosure = { images in
            self.threePicsView.firstImageView.image = images[0]
            self.threePicsView.secondImageView.image = images[1]
            self.threePicsView.thirdImageView.image = images[2]
        }
        
        navigationController?.pushViewController(imageEditView, animated: true)
    }
    
    @objc
    func closeButtonTapped() {
        if threePicsView.firstImageView.image != UIImage(named: "gray") || contentField.text != "아직 작성된 일기가 없어요..." {
            let cancelAlert = UIAlertController(title: "이런", message: "지금 나가면 작성중인 일기가 사라져요.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel)
            let deleteAction = UIAlertAction(title: "나가기", style: .destructive) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            cancelAlert.addAction(cancelAction)
            cancelAlert.addAction(deleteAction)
            present(cancelAlert, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    @objc
    func saveButtonTapped() {
        if threePicsView.firstImageView.image == UIImage(named: "gray") || contentField.text == "아직 작성된 일기가 없어요..." {
            let cantSaveAlert = UIAlertController(title: "이런", message: "아무런 내용이 없어요", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel)
            cantSaveAlert.addAction(cancelAction)
            present(cantSaveAlert, animated: true)
        } else {
            
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
        if diary?.firstImage != nil {
            threePicsView.firstImageView.image = diary?.firstImage
        }
        
        if diary?.secondImage != nil {
            threePicsView.secondImageView.image = diary?.secondImage
        }
        
        if diary?.thirdImage != nil {
            threePicsView.thirdImageView.image = diary?.thirdImage
        }
        
    }
    
}

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

//#Preview {
//    EditDiaryView()
//}
