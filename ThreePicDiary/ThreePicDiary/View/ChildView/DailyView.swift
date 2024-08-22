//
//  DailyView.swift
//  ThreePicDiary
//
//  Created by woong on 8/5/24.
//

import UIKit
import CoreData

final class DailyView: UIViewController {
    
    let coredata = DataManager.shared
    
    let tableView = UITableView()
    
    var diarys: [Diary]?
    
    let cellName = "DailyViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DailyViewCell.self, forCellReuseIdentifier: cellName)
        
        diarys = coredata.loadDailyData()
        
        setView()
    }
    
    private func setView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension DailyView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if diarys == nil {
            return 0
        } else {
            return diarys!.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? DailyViewCell else { return UITableViewCell() }
        cell.dateString = diarys?[indexPath.row].date
        cell.firstImage = diarys?[indexPath.row].firstImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
