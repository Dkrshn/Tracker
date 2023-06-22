//
//  OnboardingPageView.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 11.06.2023.
//

import UIKit

final class OnboardingPageView: UIPageViewController {
    
    lazy var pages: [UIViewController] = {
        let firstScreen = FirstOnboardingScreen()
        let secondScreen = SecondOnboardingScreen()
        
        return [firstScreen, secondScreen]
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .YPBlackDay
        button.setTitle("Вот это технологии!", for: .normal)
        button.layer.cornerRadius = 16
        button.setTitleColor(.YPWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(openTrackers), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .YPBlackDay
        pageControl.pageIndicatorTintColor = .YPWhiteDay
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        configUI()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
    
    func configUI() {
        view.addSubview(pageControl)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -71),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.widthAnchor.constraint(equalToConstant: 335),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    func openTrackers() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
            let tabBarViewController = TabBarViewController()
            window.rootViewController = tabBarViewController
        }
    }
}

extension OnboardingPageView: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages[pages.count - 1]
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages[0]
        }
        return pages[nextIndex]
    }
}

extension OnboardingPageView: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
