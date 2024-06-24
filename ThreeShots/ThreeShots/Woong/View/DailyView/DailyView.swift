//
//  DailyView.swift
//  ThreeShots
//
//  Created by woong on 6/24/24.
//

import UIKit

final class DailyView: UIViewController {
    //TODO: 테이블뷰로 db에서 불러오기, 페이징
    //TODO: 일기 서브뷰 만들기(사진세개, 사진누르면 오버레이(페이징컨트롤러), 하단에 글
    
    private let threePicsView: PhotoView = {
        let view = PhotoView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
