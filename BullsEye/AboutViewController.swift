//
//  AboutViewController.swift
//  BullsEye
//
//  Created by 龙富宇 on 2017/11/14.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //固定网页
//        if let url = Bundle.main.url(forResource: "BullsEye", withExtension: "html"){ //在应用束里找到BullsEye.html。1. 创建一个字符串对象保存html在文件系统
//            if let htmlData = try? Data(contentsOf: url){ //加载到一个Data对象中                                     2. 创建一个数据对象，保存html中的具体内容
//                let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath) //                                     3. 创建一个URL网址对象，让它保存系统的主路径。
//                //webView显示Data对象中的内容                                                                        4. 让网页视图以特定的形式来加载具体的网页内容
//                webView.load(htmlData, //数据对象。
//                             mimeType: "text/html", //设定某种扩展名的文件使用何种浏览器打开
//                             textEncodingName: "UTF-8", //字符编码方式
//                             baseURL: baseURL)
//            }
//        }
        
        //非固定网页
        let myURL = URL.init(string: "http://www.apple.com")
        let request: URLRequest = URLRequest(url: myURL!)
        webView.loadRequest(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //关闭按钮的实现
    @IBAction func close(){
        dismiss(animated: true, completion: nil)
    }
}
