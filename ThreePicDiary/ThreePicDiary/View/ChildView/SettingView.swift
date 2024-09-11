//
//  SettingVIew.swift
//  ThreePicDiary
//
//  Created by woong on 8/26/24.
//

import UIKit
import UserNotifications

final class SettingView : UIViewController {
    
    private let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    
    private var isDiaryAlertOn = true
    
    private var isPictureAlertOn = true
    
    let diaryAlertStatus = "diaryAlertStatus"
    
    let pictureAlertStatus = "pictureAlertStatus"
    
    var diaryTime = Date()
    
    var picTimes = [Date(), Date(), Date()]
    
    var themeSelection = 0
    
    private var backgroundLayer: CALayer!
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
        
        setupBackgroundLayer()
        changeBackground()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        isDiaryAlertOn = UserDefaults.standard.bool(forKey: diaryAlertStatus)
        isPictureAlertOn = UserDefaults.standard.bool(forKey: pictureAlertStatus)
        themeSelection = UserDefaults.standard.integer(forKey: "themeSelection")
        
        diaryTime = UserDefaults.standard.object(forKey: "diaryTime") as? Date ?? Date()
        picTimes[0] = UserDefaults.standard.object(forKey: "firstPicTime") as? Date ?? Date()
        picTimes[1] = UserDefaults.standard.object(forKey: "secondPicTime") as? Date ?? Date()
        picTimes[2] = UserDefaults.standard.object(forKey: "thirdPicTime") as? Date ?? Date()
        
        let viewTitle = "설정"
        self.title = viewTitle
        let preferredSize = UIFont.preferredFont(forTextStyle: .title3)
        let fontSize = preferredSize.pointSize
        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: fontSize)!
        ]
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(closeButtonTapped))
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        saveButton.setTitleTextAttributes([.font: UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: UIFont.buttonFontSize)!], for: .normal)
        saveButton.setTitleTextAttributes([.font: UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: UIFont.buttonFontSize)!], for: .selected)
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveButton
        
        if sceneDelegate?.window?.traitCollection.userInterfaceStyle == .dark {
            backButton.tintColor = .white
            saveButton.tintColor = .white
        } else {
            backButton.tintColor = .black
            saveButton.tintColor = .black
        }
        
        setTableView()
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
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
        
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    @objc
    private func requestDiaryNoti() {
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: diaryTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "일기 알림"
        content.body = "오늘의 일기를 기록해주세요!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "diaryNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            guard let error = error else { return }
            print(error.localizedDescription)
        }
    }
    
    @objc
    private func requestPictureNoti(times: [Date]) {
        let content = UNMutableNotificationContent()
        content.title = "사진 알림"
        content.body = "사진을 찍어주세요!"
        content.sound = .default
        
        for time in times {
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: "pictureNotification_\(dateComponents.hour ?? 0)_\(dateComponents.minute ?? 0)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc
    private func deletePictureNoti(times: [Date]) {
        let content = UNMutableNotificationContent()
        content.title = "사진 알림"
        content.body = "사진을 찍어주세요!"
        content.sound = .default
        
        for time in times {
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: "pictureNotification_\(dateComponents.hour ?? 0)_\(dateComponents.minute ?? 0)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current()
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
               if notification.identifier == "identifierCancel" {
                  identifiers.append(notification.identifier)
               }
           }
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    @objc
    private func closeButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    private func saveButtonTapped() {
        UserDefaults.standard.setValue(diaryTime, forKey: "diaryTime")
        UserDefaults.standard.setValue(picTimes[0], forKey: "firstPicTime")
        UserDefaults.standard.setValue(picTimes[1], forKey: "secondPicTime")
        UserDefaults.standard.setValue(picTimes[2], forKey: "thirdPicTime")
        
        requestDiaryNoti()
        requestPictureNoti(times: [picTimes[0], picTimes[1], picTimes[2]])
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension SettingView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if isDiaryAlertOn {
                return 2
            } else {
                return 1
            }
        case 2:
            if isPictureAlertOn {
                return 4
            } else {
                return 1
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            let themeTitleString = "화면 모드"
            content.text = themeTitleString
            let preferredSize = UIFont.preferredFont(forTextStyle: .headline)
            let fontSize = preferredSize.pointSize
            content.textProperties.font = UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: fontSize)!
            cell.contentConfiguration = content
            
            let toggleItems = ["시스템", "라이트", "다크"]
            let toggleSegment = UISegmentedControl(items: toggleItems)
            toggleSegment.selectedSegmentIndex = themeSelection
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: UIFont.systemFontSize) as Any
            ]
            
            toggleSegment.setTitleTextAttributes(attributes, for: .normal)
            toggleSegment.setTitleTextAttributes(attributes, for: .selected)
            
            toggleSegment.addTarget(self, action: #selector(toggleSelection), for: .valueChanged)
            cell.accessoryView = toggleSegment
            
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                var content = cell.defaultContentConfiguration()
                let diaryNotiTitleString = "일기 알림"
                content.text = diaryNotiTitleString
                let preferredSize = UIFont.preferredFont(forTextStyle: .headline)
                let fontSize = preferredSize.pointSize
                content.textProperties.font = UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: fontSize)!
                cell.contentConfiguration = content
                
                let toggleSwitch = UISwitch()
                toggleSwitch.setOn(isDiaryAlertOn, animated: true)
                toggleSwitch.tag = indexPath.row
                toggleSwitch.addTarget(self, action: #selector(toggleDiaryAlert), for: .valueChanged)
                cell.accessoryView = toggleSwitch
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
                var content = cell.defaultContentConfiguration()
                
                let diaryNotiTimeString = "알림 시간"
                content.text = diaryNotiTimeString
                let preferredSize = UIFont.preferredFont(forTextStyle: .headline)
                let fontSize = preferredSize.pointSize
                content.textProperties.font = UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: fontSize)!
                cell.contentConfiguration = content
                
                let timePickerView = UIDatePicker()
                timePickerView.preferredDatePickerStyle = .compact
                timePickerView.datePickerMode = .time
                timePickerView.date = diaryTime
                
                timePickerView.addTarget(self, action: #selector(setDiaryTime), for: .valueChanged)
                
                cell.accessoryView = timePickerView
                return cell
                
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                var content = cell.defaultContentConfiguration()
                let diaryNotiTitleString = "사진 알림"
                content.text = diaryNotiTitleString
                let preferredSize = UIFont.preferredFont(forTextStyle: .headline)
                let fontSize = preferredSize.pointSize
                content.textProperties.font = UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: fontSize)!
                cell.contentConfiguration = content
                
                let toggleSwitch = UISwitch()
                toggleSwitch.setOn(isPictureAlertOn, animated: true)
                toggleSwitch.tag = indexPath.row
                toggleSwitch.addTarget(self, action: #selector(togglePictureAlert), for: .valueChanged)
                cell.accessoryView = toggleSwitch
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                var content = cell.defaultContentConfiguration()
                
                switch indexPath.row - 1 {
                case 0:
                    content.text = "첫번째 알림"
                case 1:
                    content.text = "두번째 알림"
                case 2:
                    content.text = "세번째 알림"
                default:
                    content.text = "알림 시간"
                }
                let preferredSize = UIFont.preferredFont(forTextStyle: .headline)
                let fontSize = preferredSize.pointSize
                content.textProperties.font = UIFont(name: "HakgyoansimGeurimilgiTTF-R", size: fontSize)!
                cell.contentConfiguration = content
                
                let timePickerView = UIDatePicker()
                
                timePickerView.preferredDatePickerStyle = .compact
                timePickerView.datePickerMode = .time
                timePickerView.date = picTimes[indexPath.row - 1]
                
                timePickerView.addTarget(self, action: #selector(setPicTimes), for: .valueChanged)
                timePickerView.tag = indexPath.row - 1
                
                cell.accessoryView = timePickerView
                return cell
            }
            
        }
        return UITableViewCell()
    }

    // UI의 심미성부분에서 검토필요
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let alerTimeString = "일기 알림"
//        let alertPictureString = "사진 알림"
//        
//        switch section {
//        case 0:
//            return ""
//        case 1:
//            return alerTimeString
//        case 2:
//            return alertPictureString
//        default:
//            return ""
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        let diaryText = "일기를 쓰고싶은 시간을 정해 주세요."
//        let picText = "사진을 찍고싶은 시간을 정해 주세요."
//        
//        switch section {
//        case 0:
//            return ""
//        case 1:
//            return diaryText
//        case 2:
//            return picText
//        default:
//            return ""
//        }
//    }
    
    @objc
    func toggleSelection(segment: UISegmentedControl) {

        switch segment.selectedSegmentIndex {
        case 0:
            sceneDelegate?.window?.overrideUserInterfaceStyle = .unspecified
        case 1:
            sceneDelegate?.window?.overrideUserInterfaceStyle = .light
        case 2:
            sceneDelegate?.window?.overrideUserInterfaceStyle = .dark
        default:
            break
        }

        themeSelection = segment.selectedSegmentIndex
        UserDefaults.standard.setValue(themeSelection, forKey: "themeSelection")
    }

    
    @objc
    func toggleDiaryAlert() {
        isDiaryAlertOn.toggle()
        UserDefaults.standard.setValue(isDiaryAlertOn, forKey: diaryAlertStatus)
        
        tableView.beginUpdates()
        
        let indexPath = IndexPath(row: 1, section: 1)
        if isDiaryAlertOn {
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        tableView.endUpdates()
    }
    
    @objc
    func togglePictureAlert() {
        isPictureAlertOn.toggle()
        UserDefaults.standard.setValue(isPictureAlertOn, forKey: pictureAlertStatus)
        
        tableView.beginUpdates()
        
        let indexPaths = [IndexPath(row: 1, section: 2), IndexPath(row: 2, section: 2), IndexPath(row: 3, section: 2)]
        if isPictureAlertOn {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } else {
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
        
        tableView.endUpdates()
    }
    
    @objc
    func setDiaryTime(_ sender: UIDatePicker) {
        diaryTime = sender.date
    }
    
    @objc
    func setPicTimes(_ sender: UIDatePicker) {
        let selectedIndex = sender.tag
        picTimes[selectedIndex] = sender.date
    }
}
