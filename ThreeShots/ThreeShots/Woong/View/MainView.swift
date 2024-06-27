//
//  MainView.swift
//  ThreeShots
//
//  Created by woong on 6/23/24.
//

import UIKit

final class MainView: UIViewController {
    
    private let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "Month", at: 0, animated: true)
        segment.insertSegment(withTitle: "Day", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .selected)
        segment.selectedSegmentTintColor = .clear
        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segment.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)
        segment.addTarget(self, action: #selector(didMoveUnderLine), for: .valueChanged)
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let monthVC = MonthView()
    
    let dayVC = DailyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        dayVC.view.isHidden = true
        addSubViews()
        addConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(segmentControl)
        view.addSubview(underLineView)
        
        addChild(monthVC)
        view.addSubview(monthVC.view)
        monthVC.didMove(toParent: self)
        
        addChild(dayVC)
        view.addSubview(dayVC.view)
        dayVC.didMove(toParent: self)
    }
    
    private func addConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        monthVC.view.translatesAutoresizingMaskIntoConstraints = false
        dayVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: safeArea.topAnchor),
            segmentControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4),
            segmentControl.heightAnchor.constraint(equalToConstant: 20),
            
            underLineView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10),
            underLineView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor),
            underLineView.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 0.5),
            underLineView.heightAnchor.constraint(equalToConstant: 2),
            
            monthVC.view.topAnchor.constraint(equalTo: underLineView.bottomAnchor),
            monthVC.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            monthVC.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            monthVC.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            dayVC.view.topAnchor.constraint(equalTo: underLineView.bottomAnchor),
            dayVC.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            dayVC.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            dayVC.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    @objc
    private func changeUnderLinePosition(_ segment: UISegmentedControl) {
        let halfWidth = segmentControl.frame.width / 2
        let xPosition = segmentControl.frame.origin.x + (halfWidth * CGFloat(segmentControl.selectedSegmentIndex))
        
        UIView.animate(withDuration: 0.2) {
            self.underLineView.frame.origin.x = xPosition
        }
    }
    
    @objc
    private func didMoveUnderLine(_ segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            monthVC.view.isHidden = false
            dayVC.view.isHidden = true
        case 1:
            monthVC.view.isHidden = true
            dayVC.view.isHidden = false
        default:
            break
        }
    }
    
}


