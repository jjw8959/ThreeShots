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
    
    let editDiaryButton = UIButton()
    
    let showDiaryButton = UIButton()
    
    let contentsLabel = UILabel()
    
    lazy var selectedDateString = Calendar.current.date(from: selectedDate!)?.toString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
//        coredata.resetCoreData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateLabel.text = Date().toString()
        
        monthDiary = coredata.loadMonthData(year: Date().toString(dateFormat: "yy"),
                               month: Date().toString(dateFormat: "MM"))
        
        setCalendarView()
        setSummaryView()
        addViews()
        addConstraints()
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
        
        editDiaryButton.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        editDiaryButton.tintColor = .black
        editDiaryButton.addTarget(self, action: #selector(editDiaryButtonTapped), for: .touchUpInside)
        editDiaryButton.translatesAutoresizingMaskIntoConstraints = false
        
        showDiaryButton.setImage(UIImage(systemName: "book"), for: .normal)
        showDiaryButton.tintColor = .black
        showDiaryButton.addTarget(self, action: #selector(showDiaryButtonTapped), for: .touchUpInside)
        showDiaryButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentsLabel.textColor = .black
        contentsLabel.numberOfLines = 3
        contentsLabel.sizeToFit()
        contentsLabel.font = UIFont.systemFont(ofSize: 16)
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let specificDiary = monthDiary?.first{ $0.date == selectedDateString }
        if specificDiary != nil {
            contentsLabel.text = specificDiary?.content
            editDiaryButton.isHidden = true
            showDiaryButton.isHidden = false
            contentsLabel.setNeedsDisplay()
            editDiaryButton.setNeedsDisplay()
            showDiaryButton.setNeedsDisplay()
        } else {
            contentsLabel.text = specificDiary?.content
            editDiaryButton.isHidden = false
            showDiaryButton.isHidden = true
            contentsLabel.setNeedsDisplay()
            editDiaryButton.setNeedsDisplay()
            showDiaryButton.setNeedsDisplay()
        }
    }
    
    private func addViews() {
        self.view.addSubview(dateLabel)
        self.view.addSubview(contentsLabel)
        self.view.addSubview(showDiaryButton)
        self.view.addSubview(editDiaryButton)
    }
    
    private func addConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 7 * 4),
            
            dateLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            
            showDiaryButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            showDiaryButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            
            editDiaryButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            editDiaryButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            
            contentsLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            contentsLabel.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            contentsLabel.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
//            contentsLabel.heightAnchor.constraint(equalToConstant: self.view.frame.height / 7 * 3),
        ])
    }
    
    @objc
    func editDiaryButtonTapped() {
        let specificDiary = monthDiary?.first{ $0.date == selectedDateString }
        let editVC = EditDiaryView(specificDiary, date: selectedDateString!)
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc
    func showDiaryButtonTapped() {
        let specificDiary = monthDiary?.first{ $0.date == selectedDateString }
        let detailVC = DetailView(specificDiary, date: selectedDateString!)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension MonthView: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        selectedDate?.timeZone = TimeZone.autoupdatingCurrent
        selectedDateString = (selectedDate?.date?.toString())!
        dateLabel.text = selectedDateString
        
        //    TODO: 날짜 선택했을때 월이나 년도가 바뀌면 monthDiary 다시 불러오는거 구현하기
        let specificDiary = monthDiary?.first{ $0.date == selectedDateString }
        if specificDiary != nil { // 데이터 있으면
            contentsLabel.text = specificDiary?.content
            editDiaryButton.isHidden = true
            showDiaryButton.isHidden = false
            contentsLabel.setNeedsDisplay()
            editDiaryButton.setNeedsDisplay()
            showDiaryButton.setNeedsDisplay()
        } else { // 데이터 없으면
            contentsLabel.text = specificDiary?.content
            editDiaryButton.isHidden = false
            showDiaryButton.isHidden = true
            contentsLabel.setNeedsDisplay()
            editDiaryButton.setNeedsDisplay()
            showDiaryButton.setNeedsDisplay()
        }
        
        
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
