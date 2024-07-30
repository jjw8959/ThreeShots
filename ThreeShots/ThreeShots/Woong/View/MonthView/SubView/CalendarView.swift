//
//  CalendarView.swift
//  ThreeShots
//
//  Created by woong on 6/18/24.
//

import UIKit
import CoreData

import RxSwift
import RxCocoa

class CalendarView: UIViewController {
    
    let coredata = CoredataManager.shared
    
    var monthResult: [(dateString: String, texts: String, firstImage: UIImage?, secondImage: UIImage?, thirdImage: UIImage?)]?
    
    var currentMonth = ""
    
    var currentYear = ""
    
    var currentDate = ""
    
    lazy var dateView: UICalendarView = {
        var view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsDateDecorations = true
        return view
    }()
    
    var selectedDate: DateComponents? = nil
    
    var selectedDateString = PublishRelay<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
//        coredata.resetCoreData()
        
        applyConstraints()
        setCalendar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAndReloadDate(year: currentYear, month: currentMonth, date: "")
        print("currentDate",currentDate)
        
        if let currentDate = currentDate.toDate() {
            reloadDateView(date: currentDate)
        }
    }
    
    func setAndReloadDate(year: String, month: String, date: String) {
        currentYear = year
        currentMonth = month
        currentDate = date
        print(currentDate)
        monthResult = coredata.loadMonthData(year: currentYear, month: currentMonth) // 한달치 가져오기
//        if let monthResult = monthResult, !monthResult.isEmpty { // 언랩후 데이터 있으면 리로드
//        reloadDateView(date: Date())
//        }
//        let updateDate = "\(currentYear).\(currentMonth)."
        reloadDateView(date: currentDate.toDate())
        
    }
    
    private func setCalendar() {
        dateView.delegate = self
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = dateSelection
        
    }
    
    private func applyConstraints() {
        view.addSubview(dateView)
        
        let dateViewConstraints = [
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(dateViewConstraints)
    }
    
    func reloadDateView(date: Date?) {
        if date == nil { return }
        let calendar = Calendar.current
        dateView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
    }
}

extension CalendarView: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
           guard let monthResult = monthResult else { return nil }
           
           let calendar = Calendar.current
           // 현재 일자를 문자열로 변환
           let dateString = calendar.date(from: dateComponents)?.toString(dateFormat: "yyyy.MM.dd")
           
           // monthResult에서 일치하는 날짜 찾기
           if let dateString = dateString, monthResult.contains(where: { $0.dateString == dateString }) {
               // 해당 일자에 맞는 데이터가 있을 경우 😀 이모지를 표시하는 레이블을 만듭니다.
               return .customView {
                   let decorationLabel = UILabel()
                   decorationLabel.text = "😀"
                   decorationLabel.font = UIFont.systemFont(ofSize: 20) // 원하는 크기로 설정
                   decorationLabel.textAlignment = .center
                   return decorationLabel
               }
               
           }
           
           return nil
       }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        selectedDateString.accept(selectedDate?.date?.toString() ?? "fail")
    }
    
}

