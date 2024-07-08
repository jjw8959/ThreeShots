//
//  ImageOverlayView.swift
//  ThreeShots
//
//  Created by woong on 6/26/24.
//

import UIKit

final class ImageOverlayView: UIViewController {
    
    private var imageViews: [UIImageView?]
    
    init(_ images: [UIImageView]) {
        imageViews = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var vc1: UIViewController = {
        let vc = UIViewController()
        
        let containerView = UIView(frame: vc.view.bounds)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        ])
        
        guard let originalImageView = imageViews[0] else { return vc }
        let imageView = UIImageView(frame: containerView.bounds)
        imageView.image = originalImageView.image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return vc
    }()
    
    private lazy var vc2: UIViewController = {
        let vc = UIViewController()
        
        let containerView = UIView(frame: vc.view.bounds)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        ])
        
        guard let originalImageView = imageViews[1] else { return vc }
        let imageView = UIImageView(frame: containerView.bounds)
        imageView.image = originalImageView.image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return vc
    }()
    
    private lazy var vc3: UIViewController = {
        let vc = UIViewController()
        
        let containerView = UIView(frame: vc.view.bounds)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        ])
        
        guard let originalImageView = imageViews[2] else { return vc }
        let imageView = UIImageView(frame: containerView.bounds)
        imageView.image = originalImageView.image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return vc
    }()
    
    lazy var dataViewControllers: [UIViewController] = {
        return [vc1, vc2, vc3]
    }()
    
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        vc.setViewControllers([vc1], direction: .forward, animated: true)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        configure()
        setDelegate()
        
    }
    
    private func configure() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        pageViewController.didMove(toParent: self)
    }
    
    private func setDelegate() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
}

extension ImageOverlayView: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        return dataViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewController = pageViewController.viewControllers?.first,
              let currentIndex = dataViewControllers.firstIndex(of: viewController) else { return 0 }
        
        return currentIndex
    }
}
