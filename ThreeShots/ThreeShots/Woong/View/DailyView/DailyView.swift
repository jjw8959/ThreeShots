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
//  TODO: 아직 하나도 없으면 테이블뷰 말고 아직 작성된 일기가 없다는 내용의 화면 보여주기
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Daily View"
        
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
        
        cell.dateLabel.text = Date().toStringDate()
        cell.bestImageView.image = UIImage(named: "mock1")
        cell.expressionImageView.image = UIImage(systemName: "sun.max")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rootVC = DetailView()
        let nc = UINavigationController(rootViewController: rootVC)
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

#Preview {
    DailyView()
}
