//
//  UIScrollView+EmptyDataSet.swift
//  CodeGather
//
//  Created by zsw on 2018/6/1.
//  Copyright © 2018年 jack_z. All rights reserved.
//

import UIKit

class WeakObjectContainer {
    weak var weakObject: AnyObject?
    
    init(_ weakObject: AnyObject?) {
        self.weakObject = weakObject
    }
}

class EmptyDataSetView: UIView {
    
    var fadeInOnDisplay: Bool = false
    
    private(set) lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "empty set background image"
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = UIColor.clear
        
        titleLabel.font = UIFont.systemFont(ofSize: 27.0)
        titleLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.accessibilityIdentifier = "empty set title"
        self.contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.backgroundColor = UIColor.clear
        
        detailLabel.font = UIFont.systemFont(ofSize: 17.0)
        detailLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        detailLabel.textAlignment = .center
        detailLabel.lineBreakMode = .byWordWrapping
        detailLabel.numberOfLines = 0
        detailLabel.accessibilityIdentifier = "empty set detail label"
        self.contentView.addSubview(detailLabel)
        return detailLabel
    }()
    
    internal lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.accessibilityIdentifier = "empty set button"
        
        self.contentView.addSubview(button)
        return button
    }()
    
    var customView: UIView? {
        willSet {
            if let customView = customView {
                customView.removeFromSuperview()
            }
        }
        didSet {
            if let customView = customView {
                customView.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(customView)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeAllConstraints() {
        removeConstraints(constraints)
        contentView.removeConstraints(contentView.constraints)
    }
    
    func prepareForReuse() {
//        self.contentView.subviews.forEach({ $0.removeFromSuperview() })
        customView = nil
        removeAllConstraints()
    }
    
    func setupConstraints() {
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        if let customView = customView {
            customView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            customView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView is UIControl {
            return hitView
        }
        
        if hitView == contentView || hitView == customView {
            return hitView
        }
        
        return nil
    }
    
    override func didMoveToSuperview() {
         let bounds = superview?.bounds
        frame = bounds ?? .zero
        
        func fadeInClosure() {
            contentView.alpha = 1
        }
        
        if fadeInOnDisplay {
            UIView.animate(withDuration: 0.25, animations: fadeInClosure)
        } else {
            fadeInClosure()
        }
    }
}

private var emptyDataSetViewKey: Void?
private var emptyDataSetItemKey: Void?
private var kConfigureEmptyDataSetView =    "configureEmptyDataSetView"

extension UIScrollView: UIGestureRecognizerDelegate {
    
    private var emptyDataSetView: EmptyDataSetView! {
        get {
            if let view = objc_getAssociatedObject(self, &emptyDataSetViewKey) as? EmptyDataSetView {
                return view
            } else {
                let view = EmptyDataSetView(frame: frame)
                view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                view.isHidden = true
                
//                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapContentView(_:)))
//                tapGesture.delegate = self
//                view.addGestureRecognizer(tapGesture)
                
                objc_setAssociatedObject(self, &emptyDataSetViewKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return view
            }
        }
        
        set {
            objc_setAssociatedObject(self, &emptyDataSetViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func reloadEmptyDataSet() {
        // canDisplay
        // (shouldDisplay && itemsCount == 0) || shouldBeForcedToDisplay
        // dzn_willAppear
        let view = emptyDataSetView
//        view?.fadeInOnDisplay = shouldFadeIn
        if view?.superview == nil {
            // UITableView UICollectionView subviews.count > 1
//            insertSubview
//            addSubview
        }
        
        view?.prepareForReuse()
        // customView
        // view.customView = customView
        
        view?.isHidden = false
        view?.clipsToBounds = true
//        view?.isUserInteractionEnabled = isTouchAllowed
        
        view?.setupConstraints()
        
        UIView.performWithoutAnimation {
            view?.layoutIfNeeded()
        }
        
        // self.scrollEnabled = [self dzn_isScrollAllowed];
        
        // dzn_didAppear
    }
    
}



final class EmptyDataSet<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol EmptyDataSetCompatible {
    associatedtype CompatibleType
    var eds: CompatibleType { get }
}

extension EmptyDataSetCompatible {
    public var eds: EmptyDataSet<Self> {
        return EmptyDataSet(self)
    }
}

extension UIView: EmptyDataSetCompatible { }

protocol EmptyDataSetItem {
    func customView(with contentView: UIView) -> UIView
}

enum PageState: EmptyDataSetItem {
    case loading    // 加载中
    case notFount   // 页面不存在
    case emptyData  // 空数据
    case netError // 网络错误
    
    
    func customView(with contentView: UIView) -> UIView {
        let view = UILabel()
        view.textAlignment = .center
        
        switch self {
        case .loading:
            view.text = "加载中"
        case .notFount:
            view.text = "页面不存在"
        case .emptyData:
            view.text = "空数据"
        case .netError:
            view.text = "网络错误"
        }
        
        return view
    }
}

extension EmptyDataSet where Base: UIView {
    private var emptyDataSetView: EmptyDataSetView {
        get {
            if let view = objc_getAssociatedObject(base, &emptyDataSetViewKey) as? EmptyDataSetView {
                return view
            } else {
                let view = EmptyDataSetView(frame: base.frame)
                view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                view.isHidden = true
                
                objc_setAssociatedObject(base, &emptyDataSetViewKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

                return view
            }
        }
        
        set {
            objc_setAssociatedObject(base, &emptyDataSetViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var item: EmptyDataSetItem? {
        get {
            let item = objc_getAssociatedObject(base, &kConfigureEmptyDataSetView) as? EmptyDataSetItem
            return item
        }
        
        set {
            objc_setAssociatedObject(base, &kConfigureEmptyDataSetView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            reload()
        }
    }
    
    func reload() {
        // canDisplay
        let view = emptyDataSetView
        
        guard let item = item else {
            view.isHidden = true
            return
        }
        // (shouldDisplay && itemsCount == 0) || shouldBeForcedToDisplay
        // dzn_willAppear
        //        view?.fadeInOnDisplay = shouldFadeIn
        if view.superview == nil {
            // UITableView UICollectionView subviews.count > 1
            //            insertSubview
            //            addSubview
//            view.backgroundColor = .red
            base.addSubview(view)
        }
        
        view.prepareForReuse()
        // customView
        view.customView = item.customView(with: view.contentView)
        // view.customView = customView
        
        view.isHidden = false
        view.clipsToBounds = true
        //        view?.isUserInteractionEnabled = isTouchAllowed
        
        view.setupConstraints()
        
        UIView.performWithoutAnimation {
            view.layoutIfNeeded()
        }
        
        // self.scrollEnabled = [self dzn_isScrollAllowed];
    }
}
