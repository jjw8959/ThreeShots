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
    
    let refreshControl = UIRefreshControl()
    
    var isBottomRefresh = false
    
    let cellName = "DailyViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DailyViewCell.self, forCellReuseIdentifier: cellName)
        
        diarys = coredata.loadDailyData()
        
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.view.isHidden {
            coredata.offset = 0
            diarys = coredata.loadDailyData()
        }
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
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        footerView.backgroundColor = .clear
        tableView.tableFooterView = footerView
        
    }
    
    @objc
    func handleRefresh() {
        guard isBottomRefresh else {
            refreshControl.endRefreshing()
            return
        }
        
        if let temp = coredata.loadDailyData() {
            diarys?.append(contentsOf: temp)
        }
        tableView.reloadData()
        
        print("Refreshing...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isBottomRefresh = false
        }
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
        let date = diarys?[indexPath.row].date
        let detailView = DetailView(diarys?[indexPath.row], date: date!)
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        guard !isBottomRefresh else { return }
        
        if offsetY > contentHeight - scrollViewHeight {
            if offsetY - (contentHeight - scrollViewHeight) > 50 {
                    isBottomRefresh = true
                    handleRefresh()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isBottomRefresh = false
    }
    
}
