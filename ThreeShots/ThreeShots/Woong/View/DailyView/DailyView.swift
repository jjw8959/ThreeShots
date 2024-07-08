//
//  DailyView.swift
//  ThreeShots
//
//  Created by woong on 6/27/24.
//

import UIKit

final class DailyView: UIViewController {
    
    let tableView = UITableView()
    
    let diarys = DiaryModel()
    
    let cellName = "DailyViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DailyViewCell.self, forCellReuseIdentifier: cellName)
        
        addSubviews()
        addConstraints()
        
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
}

extension DailyView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diarys.diarys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? DailyViewCell else { return UITableViewCell() }
        
//        cell.textLabel?.text = diarys.diarys[indexPath.row].title
        cell.dateLabel.text = Date().toStringDate()
//        cell.date = Date()
        cell.bestImageView.image = UIImage(named: "mock1")
        cell.expressionImageView.image = UIImage(systemName: "sun.max")
        
        
        return cell
    }
    
    
}

#Preview {
    DailyView()
}
