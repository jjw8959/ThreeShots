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
    
    let noDataLabel = UILabel()
    
    private var backgroundLayer: CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DailyViewCell.self, forCellReuseIdentifier: cellName)
        
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coredata.offset = 0
        diarys = coredata.loadDailyData()
        tableView.reloadData()
        
        if diarys?.isEmpty ?? true {
            noDataLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noDataLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func setView() {
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.text = "아직 작성된 일기가 없어요..."
        noDataLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = .label
        view.addSubview(noDataLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        if diarys?.isEmpty ?? true {
            NSLayoutConstraint.activate([
                
                tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                noDataLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
                noDataLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                
            ])
        }
        
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
        cell.backgroundColor = .clear
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
