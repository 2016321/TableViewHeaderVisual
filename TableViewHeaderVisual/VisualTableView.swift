
//
//  VisualTableView.swift
//  TableViewHeaderVisual
//
//  Created by 王昱斌 on 17/6/2.
//  Copyright © 2017年 Qtin. All rights reserved.
//

import UIKit
import Kingfisher

protocol VisualTableViewDelegate : NSObjectProtocol {
    func rootTableViewDidScroll(_ tableView: UITableView) -> Void
    func rootTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void
}
protocol VisualTableViewDataSource : NSObjectProtocol{
    func rootTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

class VisualTableView: UIView {
    
    /// 头视图资源地址
    var imageResource : String?{
        didSet{
            if (imageResource?.hasPrefix("http"))! {
                let placeholder = placeholderResource ?? ""
                visualImage.kf.setImage(with: URL(string:imageResource!), placeholder: UIImage(named : placeholder), options: [.transition(ImageTransition.fade(0.25))], progressBlock: nil, completionHandler: nil)
            }else{
                visualImage.image = UIImage(named: imageResource!)
            }
        }
    }
    
    /// 头视图默认图
    var placeholderResource : String?
    
    /// 数据源
    fileprivate var data : Array<String>!{
        didSet{
            if data.count == 0 {
                rootTableView.reloadData()
            }
        }
    }
    
    /// 代理
    weak var delegate : VisualTableViewDelegate?
    
    /// 数据源
    weak var dataSource : VisualTableViewDataSource?
    
    /// 头图高度
    fileprivate var headerHeight : CGFloat = 0
    
    /// 主列表
    fileprivate var rootTableView : UITableView!{
        didSet{
            // FIXME : - 根据自定义修改
            rootTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            rootTableView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            rootTableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
            rootTableView.delegate = self
            rootTableView.dataSource = self
        }
    }
    
    /// 头图
    fileprivate var visualImage : UIImageView!{
        didSet{
            visualImage.contentMode = .scaleAspectFill
        }
    }
    
    fileprivate var visualView : UIVisualEffectView!
    
    init(frame: CGRect , headerHeight : CGFloat) {
        super.init(frame: frame)
        self.headerHeight = headerHeight - 64
        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension VisualTableView {
    func setUI() -> Void {
        let blur = UIBlurEffect(style: .dark)
        visualView = UIVisualEffectView(effect: blur)
        visualView.alpha = 0
        rootTableView = UITableView(frame: .zero, style: .plain)
        visualImage = UIImageView(frame: .zero)
        visualView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: headerHeight + 64)
        rootTableView.frame = CGRect(x: 0, y: 64, width: bounds.size.width, height: bounds.size.height - 64)
        visualImage.frame = CGRect(x: 0, y: -(headerHeight + 64) / 2, width: bounds.width, height: headerHeight + 64)
        visualImage.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        addSubview(visualImage)
        addSubview(visualView)
        addSubview(rootTableView)
        data = Array()
    }
}
//MARK: - 交互
extension VisualTableView{
    func makeEffect() -> Void {
        let point = rootTableView.contentOffset
        if point.y < -headerHeight {
            let scaleFactor = fabs(point.y) / (headerHeight)
            visualImage.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            visualView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }else{
            visualImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            visualView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        if point.y <= 0 {
            
            if point.y >= -headerHeight {
                let alpha = 1 - fabs(point.y/(headerHeight)) / 0.8
                visualImage.transform = visualImage.transform.translatedBy(x: 0, y: (fabs(point.y)-headerHeight)/2.0)
                if alpha > 0.8 {
                    visualView.alpha = 0.8
                }else if alpha < 0{
                    visualView.alpha = 0
                }else{
                    visualView.alpha = alpha
                }
                
            }else{
                visualView.alpha = 0//1 - fabs(point.y/(headerHeight))
            }
        }else{
            visualImage.transform = visualImage.transform.translatedBy(x: 0, y: -headerHeight / 2.0)
            visualView.alpha = 0.8
        }
    }
}
//MARK: - 数据源操作
extension VisualTableView{
    /// 清除数据源,慎用
    func clearData() -> Void {
        data.removeAll()
    }
    /// 添加数据
    ///
    /// - Parameter arr: arr description
    func addData(arr : Array<String>) -> Void {
        _ = arr.map{data.append($0)}
        rootTableView.reloadData()
    }
}
//MARK: - UIScrollViewDelegate
extension VisualTableView : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        makeEffect()
        if let delegate = delegate {
            delegate.rootTableViewDidScroll(rootTableView)
        }
    }
}
//MARK: - UITableViewDelegate
extension VisualTableView : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.rootTableView(tableView, didSelectRowAt: indexPath)
        }
    }
}
//MARK: - UITableViewDataSource
extension VisualTableView : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = dataSource else {
            return UITableViewCell()
        }
        let cell = dataSource.rootTableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = data[indexPath.row] + "----------"
        return cell
    }
}
