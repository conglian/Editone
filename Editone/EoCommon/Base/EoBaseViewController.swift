//
//  BaseViewController.swift
//

import UIKit
import RxCocoa
import RxSwift
import LYEmptyView
import Toast_Swift

class BaseViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var tableview : UITableView?
    
    var collectionView : UICollectionView?
    
    let disposeBag = DisposeBag()
    
    lazy var navBar = WRCustomNavigationBar.CustomNavigationBar()
    
    lazy var layout : UICollectionViewFlowLayout = {
        var layous = UICollectionViewFlowLayout.init()
        layous.itemSize = CGSize(width: 0, height: 0)
        layous.scrollDirection = .horizontal
        layous.minimumLineSpacing = 0
        layous.minimumInteritemSpacing = 0
        layous.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return layous
    }()
    
    lazy var arr1 : NSMutableArray = {
        var arr = NSMutableArray()
        return arr
    }()
    
    lazy var arr2 : NSMutableArray = {
        var arr = NSMutableArray()
        return arr
    }()
    
    lazy var dict1 : NSMutableDictionary = {
        var arr = NSMutableDictionary()
        return arr
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /// 是否允许侧滑返回
    ///
    var allowGestureBack = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        addNotification()
        setupNavBar()
    }
    
    fileprivate func setupNavBar()
    {
        
        view.addSubview(navBar)
        
        // 设置自定义导航栏背景图片
//        navBar.barBackgroundImage = UIImage(named: "")

        // 设置自定义导航栏背景颜色
        // navBar.backgroundColor = MainNavBarColor
        
        navBar.textAlignment = .center
        
        // 设置自定义导航栏标题颜色
        navBar.titleLabelColor = .white

        // 设置自定义导航栏左右按钮字体颜色
//        navBar.wr_setTintColor(color: UIColor.black)
        
        navBar.wr_setBottomLineHidden(hidden: true)
        
        if self.navigationController?.children.count != 1 {
            navBar.wr_setLeftButton(image: UIImage(named: "eo_back_icon")!)
        }
        
        navBar.onClickLeftButton = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func back()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func addNotification() {
        
        /// 刷新个人资料
//        _ = NotificationCenter.default.rx.notification(BF_NOTIFICATION_UPDATE_USERINFO).take(until: self.rx.deallocated).subscribe(onNext: { [weak self] _ in
//            self?.reloadUserInfo()
//        }).disposed(by: disposeBag)
        
    }
    
    private func configUI() {
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.view.backgroundColor = UIColor.bgroundColors
        self.navigationController?.setNavigationBarHidden(true, animated: false)
                
    }
    
    func popViewController() {
        UIApplication.topViewController?.navigationController?.popViewController(animated: true)
        UIApplication.topViewController?.dismiss(animated: true)
    }
    
    /// 个人资料修改
    func reloadUserInfo() {
        
    }
    
    func getTableView() {
        tableview = .init(frame: CGRectMake(0, 0, WSCREEN, HSCREEN), style: .plain)
        tableview?.delegate = self
        tableview?.dataSource = self
        tableview?.separatorStyle = .none
        tableview?.backgroundColor = UIColor.clear
        tableview?.tableFooterView = UIView()
        tableview?.tableHeaderView = UIView()
        if #available(iOS 11.0, *) {
            tableview?.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableview?.ly_emptyView = BPEmptyView.empty(withImageStr: "", titleStr: "", detailStr: "")
        tableview?.ly_emptyView.tapEmptyViewBlock = {
            
        }
        self.view.addSubview(tableview!)
    }
    
    func getcollectionView() {
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.ly_emptyView = BPEmptyView.empty(withImageStr: "", titleStr: "", detailStr: "")
        collectionView?.ly_emptyView.tapEmptyViewBlock = {
            
        }
        self.view.addSubview(collectionView!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.allowGestureBack, self.navigationController?.viewControllers.count ?? 0 > 1 {
            return true
        }
        return false
    }
}

class BPEmptyView: LYEmptyView {
    
    override func prepare() {
        super.prepare()
        self.titleLabFont = UIFont.systemFont(ofSize: 16)
        self.titleLabTextColor = UIColor.white

        self.detailStr = ""
        
        self.detailLabTextColor = UIColor.gray

        self.actionBtnBackGroundColor = UIColor.clear
        self.actionBtnTitleColor = .white
        self.actionBtnFont = UIFont.systemFont(ofSize: 14)
        self.actionBtnWidth = 80
        self.actionBtnHeight = 30
        self.actionBtnCornerRadius = 15
//        self.btnTitleStr =
    }

    
}
extension UIView {
    
    /// view 设置圆角，范围，瞄点
    func setCorner(view : UIView, rect: UIRectCorner, size : CGSize) {
        let cornerPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: rect, cornerRadii: size)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = cornerPath.cgPath
        view.layer.mask = maskLayer
    }
    
    // view 默认 阴影
    func setshadowView() {
        self.layer.shadowColor = UIColor.init(hexString: "#791F3A", alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.08
    }
    
}

extension UIViewController {
    
    /// Toast
    func showToast(text: String, onScreen: Bool = true) {
        if onScreen {
            UIApplication.shared.currentKeyWindow?.makeToast(text, duration: 2.0, position: .center)
        } else {
            self.view.makeToast(text, duration: 2.0, position: .center)
        }
    }
}
extension UIView {
    
    /// Toast
    func showToast(text: String, onScreen: Bool = true) {
        UIApplication.shared.currentKeyWindow?.makeToast(text, duration: 2.0, position: .center)
    }
}
