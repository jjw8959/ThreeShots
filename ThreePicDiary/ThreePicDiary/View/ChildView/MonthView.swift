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
    
    var specificDiary: Diary?
    
    let calendarView = UICalendarView()
    
    let summaryView = UIView()
    
    let calendar = Calendar.current
    
    lazy var selectedDate: DateComponents? = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
    
    let textContents: String? = nil
    
    let dateLabel = UILabel()
    
    let editDiaryButton = UIButton()
    
    let showDiaryButton = UIButton()
    
    let contentsLabel = UILabel()
    
    lazy var selectedDateString = calendar.date(from: selectedDate!)?.toString()
    
    var dateSelection: UICalendarSelectionSingleDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
//        coredata.resetCoreData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateLabel.text = selectedDateString
        
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
        dateSelection = UICalendarSelectionSingleDate(delegate: self)
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
        
        modifySummaryView()
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
            calendarView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 7/9),
            
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
    
    func modifySummaryView() {
        specificDiary = monthDiary?.first{ $0.date == selectedDateString }
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
        selectedDateString = calendar.date(from: selectedDate!)?.toString()
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
        
        let dateString = calendar.date(from: dateComponents)?.toString()
        if monthDiary?.contains(where: { $0.date == dateString }) == true {
            return .customView {
                self.specificDiary = self.monthDiary?.first{ $0.date == dateString }
                let decoView = UIImageView()
                decoView.translatesAutoresizingMaskIntoConstraints = false
                decoView.contentMode = .scaleAspectFill
                decoView.clipsToBounds = true
                NSLayoutConstraint.activate([
                    decoView.widthAnchor.constraint(equalToConstant: 20),
                    decoView.heightAnchor.constraint(equalToConstant: 20),
                    
                    
                ])
                
                if let superview = decoView.superview {
                    print("실행되나?")
                    NSLayoutConstraint.activate([
                        decoView.centerXAnchor.constraint(equalTo: decoView.superview!.centerXAnchor),
                        decoView.centerYAnchor.constraint(equalTo: decoView.superview!.centerYAnchor),
                    ])
                }
                
                decoView.image = self.specificDiary?.firstImage
                return decoView
            }
        }
        
        return nil
    }
    
    func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
        
        let changedDateMonth = "\(calendarView.visibleDateComponents.year!).\(calendarView.visibleDateComponents.month!).01".toDate()
        guard let date = changedDateMonth else {
            print("date = changedDateMonth 옵셔널 해제 안됨")
            return
        }
        
        var selectedDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        selectedDateComponents.hour = 0
        selectedDateComponents.minute = 0
        selectedDateComponents.second = 0
        
        selectedDate = selectedDateComponents
        guard let selectedDate = selectedDate else { return }
        selectedDateString = calendar.date(from: selectedDate)?.toString()
        dateLabel.text = selectedDateString
        
        monthDiary = coredata.loadMonthData(year: calendar.date(from: selectedDate)!.toString(dateFormat: "yy"),
                               month: calendar.date(from: selectedDate)!.toString(dateFormat: "MM"))//selectedDate로 바꾸기
        
        dateSelection(dateSelection, didSelectDate: selectedDate)
        
        modifySummaryView()
    }
}
