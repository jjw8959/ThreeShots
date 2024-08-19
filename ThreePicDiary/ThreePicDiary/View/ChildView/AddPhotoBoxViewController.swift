//
//  addPhotoBoxViewController.swift
//  ThreeShots
//
//  Created by YUJIN JEON on 7/9/24.
//

import UIKit
import PhotosUI

class AddPhotoBoxViewController: UIViewController, PHPickerViewControllerDelegate {

    // UIImageView 배열을 사용하여 여러 이미지를 표시
    var imageViews: [UIImageView] = []

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
        
        let safeArea = self.view.safeAreaLayoutGuide

        addPhotoBox.addTarget(self, action: #selector(pickPhotos), for: .touchUpInside)
        view.addSubview(addPhotoBox)

        // 여러 개의 UIImageView를 설정
        for _ in 0..<3 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = .lightGray
            imageView.layer.cornerRadius = 10
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            imageViews.append(imageView)
        }

        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            addPhotoBox.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            addPhotoBox.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            addPhotoBox.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            addPhotoBox.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.3)
        ])
        
        let imageWidth = (view.frame.width - 80) / 3
        for (index, imageView) in imageViews.enumerated() {
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: addPhotoBox.bottomAnchor, constant: 40),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 + (imageWidth + 20) * CGFloat(index)),
                imageView.widthAnchor.constraint(equalToConstant: imageWidth),
                imageView.heightAnchor.constraint(equalToConstant: imageWidth)
            ])
        }
    }
    
    // 포토피커
    @objc func pickPhotos() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3 // 최대 3개의 사진 선택
        configuration.filter = .images // 이미지 필터

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // PHPickerViewControllerDelegate 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for (index, result) in results.enumerated() {
            if index < 3 {
                let provider = result.itemProvider
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        DispatchQueue.main.async {
                            if let image = image as? UIImage {
                                self?.imageViews[index].image = image
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddPhotoBoxViewController()
}
