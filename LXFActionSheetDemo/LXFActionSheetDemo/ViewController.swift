//
//  LXFActionSheet.swift
//  LXFActionSheetDemo
//
//  Created by 林洵锋 on 2017/1/31.
//  Copyright © 2017年 林洵锋. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenW: CGFloat = UIScreen.main.bounds.width
        let btnW: CGFloat = 100
        let btnH: CGFloat = 40
        let btnX: CGFloat = (screenW - btnW) * 0.5
        let btnY: CGFloat = 200
        
        let btn = UIButton()
        btn.setTitle("菜单", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
        view.addSubview(btn)
    }
}

extension ViewController {
    @objc fileprivate func btnClick() {
        let sheet = LXFActionSheet(delegate: self, cancelTitle: "取消", otherTitles: ["拍照", "从手机相册选择", "保存图片"])
        sheet.show()
    }
}

// MARK:- LXFActionSheetDelegate
extension ViewController: LXFActionSheetDelegate {
    func lxfActionSheet(actionSheet: LXFActionSheet, didClickedAt index: Int) {
        print("print 点击了 \(index)")
        NSLog("nslog 点击了 \(index)")
    }
}


