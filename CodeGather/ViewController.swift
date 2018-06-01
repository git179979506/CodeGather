//
//  ViewController.swift
//  CodeGather
//
//  Created by zsw on 2018/5/30.
//  Copyright © 2018年 jack_z. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.eds.reload()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let nav = Storyboard.Notifications.instantiateInitialViewController()!
//        present(nav, animated: true, completion: nil)
        switch count {
        case 0:
            view.eds.item = PageState.loading
        case 1:
            view.eds.item = PageState.notFount
        case 2:
            view.eds.item = PageState.emptyData
        case 3:
            view.eds.item = PageState.netError
        default:
//            view.eds.item = nil
            print("\(count)")
        }
        
        count += 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

