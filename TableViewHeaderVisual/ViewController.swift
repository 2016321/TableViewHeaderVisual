//
//  ViewController.swift
//  TableViewHeaderVisual
//
//  Created by 王昱斌 on 17/6/2.
//  Copyright © 2017年 Qtin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//    let arr = VisualTableView
    
    let cellId = "cell"
    
    
    var mainView : VisualTableView?
    var arr : Array<String> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        for i in 0...19 {
            arr.append("\(i)")
        }
        mainView = VisualTableView(frame: view.bounds, headerHeight: 300)
        mainView?.imageResource = "https://tse4-mm.cn.bing.net/th?id=OIP.0LS9Sj1Nr8PIVDGmP7JSVQEsDI&w=273&h=182&c=7&qlt=90&o=4&dpr=2&pid=1.7"
        mainView?.delegate = self
        mainView?.dataSource = self
        view.addSubview(mainView!)
        mainView?.addData(arr: arr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
extension ViewController : VisualTableViewDelegate{
    func rootTableViewDidScroll(_ tableView: UITableView) -> Void{
        
    }
    func rootTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void{
        print("Select")
    }
}
extension ViewController : VisualTableViewDataSource{
    func rootTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.selectionStyle = .none
        return cell
    }
}

