//
//  ViewController.swift
//  ThreePicDiary
//
//  Created by woong on 8/5/24.
//

import UIKit

class MainView: UIViewController {

    private let segmentControl = UISegmentedControl()
    
    private let underLineView = UIView()
    
    private let settingButton = UIButton()
    
    let monthView = MonthView()
    
    let dailyView = DailyView()
    
    private var backgroundLayer: CALayer!
    
    var xPosition: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundLayer()
        changeBackground()
        
        setSegmentControl()
        setSettingButton()
        addViews()
        addConstraints()
        dailyView.view.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let halfWidth = segmentControl.frame.width / 2
        xPosition = segmentControl.frame.origin.x + (halfWidth * CGFloat(segmentControl.selectedSegmentIndex))
        
        underLineView.frame.origin.x = xPosition
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
    
    private func setSettingButton() {
        settingButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingButton.addTarget(self, action: #selector(tapSetting), for: .touchUpInside)
        settingButton.tintColor = .label
        settingButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setSegmentControl() {
        segmentControl.insertSegment(withTitle: "Month", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "Day", at: 1, animated: true)
        segmentControl.selectedSegmentIndex = 0
        
        let selectedSize = UIFont.preferredFont(forTextStyle: .title3)
        let selectedFontSize = selectedSize.pointSize
        
        let unSelectedSize = UIFont.preferredFont(forTextStyle: .callout)
        let unSelectedFontSize = unSelectedSize.pointSize
        
        // 평상시
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemGray2,
            NSAttributedString.Key.font: UIFont(name: "Hakgyoansim Geurimilgi TTF R", size: unSelectedFontSize) as Any]
                                              ,for: .normal)
            
        // 선택시
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont(name: "Hakgyoansim Geurimilgi TTF R", size: selectedFontSize) as Any], for: .selected)
        segmentControl.selectedSegmentTintColor = .clear
        segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segmentControl.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        underLineView.backgroundColor = .label
        underLineView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addViews() {
        view.addSubview(settingButton)
        view.addSubview(segmentControl)
        view.addSubview(underLineView)
        
        addChild(monthView)
        view.addSubview(monthView.view)
        monthView.didMove(toParent: self)
        
        addChild(dailyView)
        view.addSubview(dailyView.view)
        dailyView.didMove(toParent: self)
    }
    
    private func addConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        monthView.view.translatesAutoresizingMaskIntoConstraints = false
        dailyView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            settingButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            
            segmentControl.topAnchor.constraint(equalTo: safeArea.topAnchor),
            segmentControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            segmentControl.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4),
            segmentControl.heightAnchor.constraint(equalToConstant: 20),
            
            underLineView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10),
            underLineView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor),
            underLineView.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 0.5),
            underLineView.heightAnchor.constraint(equalToConstant: 2),
            
            monthView.view.topAnchor.constraint(equalTo: underLineView.bottomAnchor),
            monthView.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            monthView.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            monthView.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            dailyView.view.topAnchor.constraint(equalTo: underLineView.bottomAnchor),
            dailyView.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            dailyView.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            dailyView.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    // MARK: segment functions
    
    @objc private func changeUnderLinePosition(_ segment: UISegmentedControl) {
        let halfWidth = segmentControl.frame.width / 2
        xPosition = segmentControl.frame.origin.x + (halfWidth * CGFloat(segmentControl.selectedSegmentIndex))
        
        UIView.animate(withDuration: 0.2) {
            self.underLineView.frame.origin.x = self.xPosition
        }
        
        switch segment.selectedSegmentIndex {
        case 0:
            monthView.view.isHidden = false
            dailyView.view.isHidden = true
        case 1:
            monthView.view.isHidden = true
            dailyView.view.isHidden = false
        default:
            break
        }
    }
    
    @objc private func tapSetting() {
        navigationController?.pushViewController(SettingView(), animated: true)
    }

}

