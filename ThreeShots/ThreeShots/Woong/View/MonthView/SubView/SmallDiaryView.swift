//
//  SmallDiaryView.swift
//  ThreeShots
//
//  Created by woong on 6/20/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SmallDiaryView: UIViewController {
    
    var selectedDateInput = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    var dateString: String? = Date().toString() {
        didSet {
            dateLabel.text = dateString
        }
    }
   
    var textContents: String?
    
    // 날짜용 레이블
    var dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black // 수정필
        view.font = UIFont.systemFont(ofSize: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //  일기 추가용 버튼
    var addButton: UIButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //  일기내용 레이블
    // TODO: 내용 3줄, scroll 불가
    var contentsLabel: UILabel = {
        let view = UILabel()
        //        view.textColor = .black // 수정필
        view.numberOfLines = 3
        view.font = UIFont.systemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white // 수정필
        
        selectedDateInput
            .subscribe { [weak self] dateString in
                self?.dateLabel.text = dateString
            }
            .disposed(by: disposeBag)
        
        if textContents != nil {
            contentsLabel.text = textContents
        }
        addSubViews()
        addConstraints()
    }
    
    private func addSubViews() {
        addButton.addTarget(self, action: #selector(addDiaryButtonTapped), for: .touchUpInside)
        if textContents == nil {
            // TODO: 플러스 버튼이랑 날짜만 있는거
            self.view.addSubview(dateLabel)
            self.view.addSubview(addButton)
        } else {
            // TODO: 해당 컨텐츠 보여주기
            self.view.addSubview(dateLabel)
            self.view.addSubview(contentsLabel)
        }
    }
    
    private func addConstraints() {
        
        switch textContents {   // 내용유뮤
        case nil:   // 없으면
            let emptyConstraint = [
                dateLabel.topAnchor.constraint(equalTo: self.view.topAnchor),
                dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                
                addButton.topAnchor.constraint(equalTo: self.view.topAnchor),
                addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                addButton.widthAnchor.constraint(equalToConstant: 50),
            ]
            NSLayoutConstraint.activate(emptyConstraint)
            
        default:    // 있으면
            let filledConstraint = [
                dateLabel.topAnchor.constraint(equalTo: self.view.topAnchor),
                dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                
                contentsLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
                contentsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                contentsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            ]
            NSLayoutConstraint.activate(filledConstraint)
        }
    }
    
    @objc func addDiaryButtonTapped() {
        let rootVC = EditDiaryView() // 사진뷰가 아니라 내용수정뷰로 바꿔야함
        let nc = UINavigationController(rootViewController: rootVC)
        nc.modalPresentationStyle = .fullScreen
        rootVC.dateString = dateLabel.text!
        present(nc, animated: true)
    }
}
