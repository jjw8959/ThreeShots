//
//  TestView.swift
//  ThreeShots
//
//  Created by woong on 6/19/24.
//

import UIKit

class TestView: UIViewController {
    
    var selectedDate: Date?
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown
        
        let df = DateFormatter()
        df.dateFormat = "dd"
        let dateString = df.string(from: selectedDate!)
        
        self.textView.text = dateString
        
        view.addSubview(textView)
        let textViewConstraints = [
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //            dateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ]
        NSLayoutConstraint.activate(textViewConstraints)
        
        textView.isScrollEnabled = false
        textView.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        textView.sizeToFit()
    }
}
