//
//  CustomTabBarController.swift
//

import UIKit

// MARK: - 自定义 TabBar 按钮
class TabBarButton: UIButton {

    var imageSize: CGSize = CGSize(width: 40, height: 40)
    var spacing: CGFloat = 6 // 图片和文字间距

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView = imageView, let titleLabel = titleLabel else { return }

        // 设置图片大小
        imageView.frame.size = imageSize

        // 居中图片
        imageView.center.x = bounds.width / 2
        imageView.frame.origin.y = (bounds.height - imageView.frame.height - spacing - titleLabel.frame.height) / 2

        // 居中文字
        titleLabel.sizeToFit()
        titleLabel.center.x = bounds.width / 2
        titleLabel.frame.origin.y = imageView.frame.maxY + spacing
    }
}

// MARK: - 自定义 TabBarController
class EoCustomTabBarController: UIViewController {

    private let customTabBar = UIView()
    private var buttons: [TabBarButton] = []

    private let titles = ["Create", "Library", "Setting"]
    private let normalImages = ["eo_home_n","eo_Library_n","eo_set_n"]
    private let selectedImages = ["eo_home_s","eo_Library_s","eo_set_s"]

    var viewControllersList: [UINavigationController] = []
    var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupCustomTabBar()
        displayViewController(at: 0)
    }

    // MARK: - 初始化 ViewControllers
    private func setupViewControllers() {
        let homeVC = EoBaseNavigationController(rootViewController: EoHomeViewController())
        homeVC.delegate = self
        let libraryVC = EoBaseNavigationController(rootViewController: EoLibraryViewController())
        libraryVC.delegate = self
        let settingVC = EoBaseNavigationController(rootViewController: EoSettingViewController())
        settingVC.delegate = self
        viewControllersList = [homeVC, libraryVC, settingVC]
    }

    // MARK: - 显示某个 ViewController
    private func displayViewController(at index: Int) {
        // 移除旧的
        for child in children {
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        let vc = viewControllersList[index]
        addChild(vc)
        vc.view.frame = view.bounds
        view.insertSubview(vc.view, belowSubview: customTabBar)
        vc.didMove(toParent: self)
        selectedIndex = index
    }

    // MARK: - 设置自定义 TabBar
    private func setupCustomTabBar() {
        customTabBar.backgroundColor = UIColor(hexString: "#181B20")
        view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 88)
        ])

        let itemWidth = UIScreen.main.bounds.width / CGFloat(titles.count)

        for i in 0..<titles.count {
            let button = TabBarButton(type: .custom)
            button.tag = i
            button.frame = CGRect(x: CGFloat(i) * itemWidth, y: 0, width: itemWidth, height: 88)

            button.setTitle(titles[i], for: .normal)
            button.setTitleColor(UIColor(white: 1.0, alpha: 0.4), for: .normal)
            button.setTitleColor(UIColor(red: 115/255, green: 149/255, blue: 255/255, alpha: 1.0), for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)

            button.setImage(UIImage(named: normalImages[i]), for: .normal)
            button.setImage(UIImage(named: selectedImages[i]), for: .selected)

            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

            // 设置图片大小和间距
            button.imageSize = CGSize(width: 40, height: 40)
            button.spacing = 6

            customTabBar.addSubview(button)
            buttons.append(button)
        }

        updateSelectedButton(index: 0)
    }

    // MARK: - 点击按钮
    @objc private func tabButtonTapped(_ sender: TabBarButton) {
        let index = sender.tag
        displayViewController(at: index)
        updateSelectedButton(index: index)
    }

    // MARK: - 更新选中状态 + 自然 Q 弹动画
    private func updateSelectedButton(index: Int) {
        for (i, button) in buttons.enumerated() {
            let isSelected = i == index
            button.isSelected = isSelected

            guard let imageView = button.imageView else { continue }

            if isSelected {
                imageView.transform = CGAffineTransform.identity

                // Q弹动画
                UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [.calculationModeCubic], animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {
                        imageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.2) {
                        imageView.transform = CGAffineTransform(scaleX: 1.45, y: 1.45)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2) {
                        imageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        imageView.transform = CGAffineTransform.identity
                    }
                }, completion: nil)
            } else {
                imageView.transform = CGAffineTransform.identity
            }
        }
    }

    // MARK: - 外部切换 Tab
    func switchToTab(index: Int) {
        guard index >= 0, index < buttons.count else { return }
        displayViewController(at: index)
        updateSelectedButton(index: index)
    }
}

// MARK: - UINavigationControllerDelegate 自动隐藏 TabBar
extension EoCustomTabBarController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 根 VC 显示 TabBar，其余隐藏
        if navigationController.viewControllers.first == viewController {
            customTabBar.isHidden = false
        } else {
            customTabBar.isHidden = true
        }
    }
}

