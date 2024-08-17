//
//  MonthView.swift
//  ThreePicDiary
//
//  Created by woong on 8/5/24.
//

import UIKit
import CoreData

final class MonthView: UIViewController {
    
    let coredata = DataManager.shared
    
    var monthDiary: [Diary]?
    
    let calendarView = UICalendarView()
    
    let summaryView = UIView()
    
    var selectedDate: DateComponents? = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
    
    let textContents: String? = nil
    
    let dateLabel = UILabel()
    
    let addButton = UIButton()
    
    let contentsLabel = UILabel()
    
    lazy var selectedDateString = selectedDate?.date?.toString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        dateLabel.text = Date().toString()
        
        monthDiary = coredata.loadMonthData(year: Date().toString(dateFormat: "yy"),
                               month: Date().toString(dateFormat: "MM"))
        
        setCalendarView()
        setSummaryView()
        
        applyConstraints()
        
    }
    
    func setCalendarView() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.wantsDateDecorations = true
        
        calendarView.delegate = self
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        dateSelection.setSelected(selectedDate, animated: true)
        
        view.addSubview(calendarView)
    }
    
    func setSummaryView() {
        
        dateLabel.textColor = .black
        dateLabel.font = UIFont.systemFont(ofSize: 17)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17)
        let image = UIImage(systemName: "pencil.line", withConfiguration: imageConfig)
        addButton.setImage(image, for: .normal)
        addButton.tintColor = .black
        addButton.addTarget(self, action: #selector(editDiaryButtonTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentsLabel.textColor = .black
        contentsLabel.numberOfLines = 3
        contentsLabel.font = UIFont.systemFont(ofSize: 20)
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if textContents != nil {
            self.view.addSubview(dateLabel)
            self.view.addSubview(contentsLabel)
            contentsLabel.text = textContents
            
        } else {
            self.view.addSubview(dateLabel)
            self.view.addSubview(addButton)
        }
        
    }
    
    private func applyConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 7 * 4)
        ])
        
        if textContents != nil {
            NSLayoutConstraint.activate([
                dateLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
                dateLabel.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
                
                contentsLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
                contentsLabel.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
                contentsLabel.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                dateLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
                dateLabel.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
                
                addButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
                addButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
                addButton.widthAnchor.constraint(equalToConstant: 50),
            ])
        }
    }
    
    @objc
    func editDiaryButtonTapped() {
        //        let rootVC = EditDiaryView(calendarView: calendarView) // 사진뷰가 아니라 내용수정뷰로 바꿔야함
        //        let nc = UINavigationController(rootViewController: rootVC)
        //        nc.modalPresentationStyle = .fullScreen
        //        rootVC.dateString = dateLabel.text!
        //        present(nc, animated: true)
        //        editVC.diary = Diary(date: Date().toString(), year: "a", month: "a", content: "aaa", firstImage: UIImage(named: "gray"), secondImage: UIImage(named: "gray"), thirdImage: UIImage(named: "gray"))
        let specificDiary = monthDiary?.first { $0.date == selectedDate?.date?.toString() }
        
        let editVC = EditDiaryView(specificDiary)
        editVC.dateString = Calendar.current.date(from: selectedDate!)?.toString()

        navigationController?.pushViewController(editVC, animated: true)
    }
    
}

extension MonthView: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        selectedDate?.timeZone = TimeZone.autoupdatingCurrent
        selectedDateString = selectedDate?.date?.toString()
        dateLabel.text = selectedDateString
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
//        guard let monthResult = monthResult else { return nil }
//        
//        let calendar = Calendar.current
//        // 현재 일자를 문자열로 변환
//        let dateString = calendar.date(from: dateComponents)?.toString(dateFormat: "yyyy-MM-dd")
//        
//        // monthResult에서 일치하는 날짜 찾기
//        if let dateString = dateString, monthResult.contains(where: { $0.dateString == dateString }) {
//            // 해당 일자에 맞는 데이터가 있을 경우 😀 이모지를 표시하는 레이블을 만듭니다.
//            return .customView {
//                let decorationLabel = UILabel()
//                decorationLabel.text = "😀"
//                decorationLabel.font = UIFont.systemFont(ofSize: 20) // 원하는 크기로 설정
//                decorationLabel.textAlignment = .center
//                return decorationLabel
//            }
//        }
//        
//        return nil
        return nil
    }
    
}
