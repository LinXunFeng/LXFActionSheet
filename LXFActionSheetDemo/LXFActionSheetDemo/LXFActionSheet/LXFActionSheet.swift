//
//  LXFActionSheet.swift
//  LXFWeChat
//
//  Created by 林洵锋 on 2017/1/31.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

fileprivate let LXFActionSheetCancelTag = 9999
fileprivate let LXFActionSheetCancelBaseTag = 1000
fileprivate let LXFActionSheetHeight: CGFloat = 44.0
fileprivate let LXFActionSheetAnimationDuration: TimeInterval = 0.25

protocol LXFActionSheetDelegate: NSObjectProtocol {
    func lxfActionSheet(actionSheet: LXFActionSheet, didClickedAt index: Int)
}

class LXFActionSheet: UIView {
    // MARK:- 代理
    weak var delegate: LXFActionSheetDelegate?
    // MARK:- 懒加载
    lazy var btnArr: [UIButton] = {
        return [UIButton]()
    }()
    lazy var dividerArr: [UIView] = {
        return [UIView]()
    }()
    lazy var coverView: UIView = { [unowned self] in
        let coverView = UIButton(type: .custom)
        coverView.backgroundColor = UIColor.clear
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coverViewDidClick)))
        return coverView
    }()
    lazy var actionSheet: UIView = {
        let actionSheet = UIView()
        actionSheet.backgroundColor = UIColor.gray
        return actionSheet
    }()
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.tag = LXFActionSheetCancelTag
        cancelBtn.backgroundColor = UIColor.init(white: 1, alpha: 1)
        cancelBtn.titleLabel?.textAlignment = .center
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cancelBtn.setTitleColor(UIColor.black, for: .normal)
        cancelBtn.addTarget(self, action: #selector(actionSheetClicked(_:)), for: .touchUpInside)
        return cancelBtn
    }()
    lazy var lxfActionSheet: LXFActionSheet = {
        let lxfActionSheet = LXFActionSheet()
        lxfActionSheet.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        return lxfActionSheet
    }()
    
    
    class func showActionSheet(with delegate: LXFActionSheetDelegate?,  cancelTitle: String, otherTitles: [String]) -> LXFActionSheet {
        return LXFActionSheet(delegate: delegate, cancelTitle: cancelTitle, otherTitles: otherTitles)
    }
    
    // MARK:- init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(delegate: LXFActionSheetDelegate?, cancelTitle: String, otherTitles: [String]) {
        super.init(frame: CGRect.zero)
        
        // 清空
        btnArr.removeAll()
        dividerArr.removeAll()
        
        self.backgroundColor = UIColor.clear
        self.delegate = delegate
        
        // 添加视图
        // lxfActionSheet
        self.addSubview(lxfActionSheet)
        // 添加遮盖
        self.lxfActionSheet.addSubview(coverView)
        // 遮盖 上 添加 底部弹窗
        self.coverView.addSubview(actionSheet)
        // 操作action
        for i in 0..<otherTitles.count {
            self.createBtn(with: otherTitles[i], bgColor: UIColor.init(white: 1, alpha: 1), titleColor: UIColor.black, tagIndex: i + LXFActionSheetCancelBaseTag)
        }
        // 取消按钮
        cancelBtn.setTitle(cancelTitle, for: .normal)
        self.actionSheet.addSubview(cancelBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 创建按钮
extension LXFActionSheet {
    fileprivate func createBtn(with title: String?, bgColor: UIColor?, titleColor: UIColor?, tagIndex: Int) {
        let actionBtn = UIButton(type: .custom)
        actionBtn.tag = tagIndex
        actionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        actionBtn.backgroundColor = bgColor
        actionBtn.titleLabel?.textAlignment = .center
        actionBtn.setTitle(title, for: .normal)
        actionBtn.setTitleColor(titleColor, for: .normal)
        actionBtn.addTarget(self, action: #selector(actionSheetClicked(_:)), for: .touchUpInside)
        self.actionSheet.addSubview(actionBtn)
        self.btnArr.append(actionBtn)
        
        let divider = UIView()
        divider.backgroundColor = UIColor.hexInt(0xebebeb)
        actionBtn.addSubview(divider)
        dividerArr.append(divider)
    }
}

// MARK:- 事件处理
extension LXFActionSheet {
    @objc fileprivate func coverViewDidClick() {
        self.dismiss()
    }
    
    @objc fileprivate func actionSheetClicked(_ btn: UIButton) {
        if btn.tag != LXFActionSheetCancelTag {
            self.delegate?.lxfActionSheet(actionSheet: self, didClickedAt: btn.tag - LXFActionSheetCancelBaseTag)
            self.dismiss()
        } else {
            self.dismiss()
        }
    }
    
    func show() {
        if self.superview != nil { return }
        
        let keyWindow = UIApplication.shared.keyWindow
        self.frame = (keyWindow?.bounds)!
        keyWindow?.addSubview(self)
        
        lxfActionSheet.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        coverView.frame = lxfActionSheet.bounds
        
        let actionH = CGFloat(self.btnArr.count + 1) * LXFActionSheetHeight + 5.0
        actionSheet.frame = CGRect(x: 0, y: self.lxf_height, width: kScreenW, height: actionH)
        
        cancelBtn.frame = CGRect(x: 0, y: actionH - LXFActionSheetHeight, width: self.lxf_width, height: LXFActionSheetHeight)
        
        let btnW: CGFloat = self.lxf_width
        let btnH: CGFloat = LXFActionSheetHeight
        let btnX: CGFloat = 0
        var btnY: CGFloat = 0
        for i in 0..<btnArr.count {
            let btn = btnArr[i]
            let divider = dividerArr[i]
            btnY = LXFActionSheetHeight * CGFloat(i)
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            divider.frame = CGRect(x: btnX, y: btnH - 1, width: btnW, height: 1)
        }
        
        UIView.animate(withDuration: LXFActionSheetAnimationDuration) {
            self.actionSheet.lxf_y = self.lxf_height - self.actionSheet.lxf_height
        }
    }
    
    fileprivate func dismiss() {
        UIView.animate(withDuration: LXFActionSheetAnimationDuration, animations: {
            self.actionSheet.lxf_y = self.lxf_height
        }) { (_) in
            if self.superview != nil {
                self.removeFromSuperview()
            }
        }
    }
}


fileprivate let kScreenH = UIScreen.main.bounds.height
fileprivate let kScreenW = UIScreen.main.bounds.width

extension UIView {
    public var lxf_x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var lxf_y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    public var lxf_width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    public var lxf_height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
}

extension UIColor {
    class func hexInt(_ hexValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0,
                       
                       green: ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0,
                       
                       blue: ((CGFloat)(hexValue & 0xFF)) / 255.0,
                       
                       alpha: 1.0)
    }
}
