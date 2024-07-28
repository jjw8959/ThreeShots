//
//  MainView.swift
//  ThreeShots
//
//  Created by woong on 6/21/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MonthView: UIViewController {
    
    let calendarView = CalendarView()
    let smallDiaryView = SmallDiaryView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(calendarView)
        view.addSubview(calendarView.view)
        calendarView.didMove(toParent: self)
        addChild(smallDiaryView)
        view.addSubview(smallDiaryView.view)
        smallDiaryView.didMove(toParent: self)
        addConstraints()
        
        let currentDateString = Date().toString()
        smallDiaryView.selectedDateInput.onNext(currentDateString)
        
        calendarView.selectedDateString
            .bind(to: smallDiaryView.selectedDateInput)
            .disposed(by: disposeBag)
    }
    
    private func addConstraints() {
        calendarView.view.translatesAutoresizingMaskIntoConstraints = false
        smallDiaryView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            calendarView.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            calendarView.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            calendarView.view.heightAnchor.constraint(equalToConstant: self.view.frame.height / 7 * 4),
            
            smallDiaryView.view.topAnchor.constraint(equalTo: calendarView.view.bottomAnchor, constant: 16),
            smallDiaryView.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            smallDiaryView.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            smallDiaryView.view.heightAnchor.constraint(equalToConstant: self.view.frame.height / 7 * 3)
        ])
        
    }
}
