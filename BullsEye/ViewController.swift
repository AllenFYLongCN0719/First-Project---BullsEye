//
//  ViewController.swift
//  BullsEye
//
//  Created by 龙富宇 on 2017/11/11.
//  Copyright © 2017年 AllenLong. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation

class ViewController: UIViewController {
    //定义一个变量，给予其他功能引用
    @IBOutlet weak var slider: UISlider! //outlet类型变量的形式 @IBoutlet weak var, 将slider与UISlider关联在一起。这里变量的对象是UISlider(滑动条对象)
    //完成这行代码后需要在storyboard里面将outlet与他的对象slider关联在一起。
    @IBOutlet weak var targetLabel: UILabel! //将targetlabal与UILabel关联在一起。
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    //var currentValue: Int = 0 // Bug: 用户打开应用进入程序时将会默认得到0的值，而实际滑动条在50
    var currentValue = 0 // Bug Fixed: 正确的输出，当用户不移动滚动条并直接点击按钮。
    var targetValue = 0 // 随机数使用的变量
    var score = 0 //保存得分
    var round = 0 //保存轮数
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() { //当视图控制器从storyboard文件中加载用户界面时，UIKit会立即发送viewDidLoad()消息。 所以这个是程序的开始处。
        super.viewDidLoad()
//        currentValue = lroundf(slider.value)
//        targetValue = 1 + Int(arc4random_uniform(100)) //数值范围在1到100之间。由于上限是100，因此实际上随机数是0-99，为了得到1-100，所以需要在结果里加上1.
        //startNewRound()
        startNewGame()
        //设置滑动条外观
        let thumbImageNormal = UIImage(named:"SliderThumb-Normal")!
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")!
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        let trackLeftImage = UIImage(named:"SliderTrackLeft")!
        let trackLeftResizable =
            trackLeftImage.resizableImage(withCapInsets: insets)
        
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        
        let trackRightImage = UIImage(named:"SliderTrackRight")!
        let trackRightResizeable =
            trackRightImage.resizableImage(withCapInsets: insets)
        
        slider.setMaximumTrackImage(trackRightResizeable, for: .normal)
        // Do any additional setup after loading the view, typically from a nib.
        
        playBgMusic()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showAlter(){
         //第一种算法
//        var difference: Int
//        if (currentValue > targetValue){
//            difference = currentValue - targetValue
//        } else if(targetValue > currentValue){
//            difference = targetValue - currentValue
//        } else{
//            difference = 0
//        }
        
//        //第二种算法
//       var difference = currentValue - targetValue
//       if (difference < 0){
//       difference = difference * -1 // difference *= -1 或 difference = -difference
//        }
        
        //第三种算法 let定义的量为常量
        let difference = abs(targetValue - currentValue)
        var points = 100 - difference
        //score += points // score = score + points
        
        //添加以下代码对玩家的表现作出评价
        let title: String //常量初始化  或 var title = ""
        if difference == 0 {
            title = "运气逆天，你爽翻了, 多让你爽100次"
            points += 100
        }else if (difference == 1){
            title = "快爽死了，再让你爽50次"
            points += 50
        }else if difference < 5{
            title = "快爽死了"
        } else if difference < 20{
            title = "小爽怡情"
        } else {
            title = "没爽到！"
        }
        score += points
        
        //一定要使用系统默认的弹出格式，而不是手动输入
        let mesage = "爽哥当前的爽度是：\(currentValue)" + "\n想要的爽度是：\(targetValue)" + "\n两者的差值是：\(difference)" + "\n爽哥爽了 \(points) 次"//输出当前的数值并打印在消息框内。\n是换行符，+是拼接符号在这里。
        
        let alert = UIAlertController(title: title, message: mesage, preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "爽死了", style: .default, handler: {action in self.startNewRound()}) // nil意思是什么都不发生，而这里handler直接调用startNewRound,之后程序才会继续运转。 这个也被称之为 “闭包”
        
        alert.addAction(action)
        //对action添加dimiss按钮
        
        present(alert, animated: true, completion: nil)
        //present(alert1, animated: true, completion: nil)
        //startNewRound()
    }
    
    @IBAction func sliderMoved(slider: UISlider){
        print("滑动条的当前数值是： \(slider.value)") //打印内容在debug调试区
        print("随机的数值是：\(targetValue)")
        // \(slider.value) 提取当前数值
        currentValue = lroundf(slider.value) // lroundf() 是一个将float类型的常量强制转换为int类的函数
    }
    
    //本功能实现重新运作所有功能，开启新一轮。
    func startNewRound(){
        round += 1 //变量默认为0，应用开始运行时，round=0，但是当开始调用startNewRound()的时候，回合数会加1
        targetValue = 1 + Int (arc4random_uniform(100))
        currentValue = 1 + Int (arc4random_uniform(80))
        slider.value = Float (currentValue) //将int类型的currentvalue转换为float类型以此与slider.value保持一致
        updatelabels() //更新标签
    }
    
    
    //更新标签内容
    func updatelabels(){
        targetLabel.text = String (targetValue) //均为字符类型 targetlabel.text = "\(targetValue)" 也是可行的
        scoreLabel.text = String (score)
        roundLabel.text = String (round)
        
    }
    
    func startNewGame(){
        score = 0
        round = 0
        startNewRound()
        
        //add crossfade effects
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        view.layer.add(transition, forKey: nil)
        
    }
    
    // add audio player
    func playBgMusic(){
        let musicPath = Bundle.main.path(forResource: "高橋諒,MARU - The Other Side of the Wall", ofType: "mp3")
        let url = URL.init(fileURLWithPath: musicPath!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        }catch _ {
            audioPlayer = nil
        }
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    
    
    
    @IBAction func startover(){
        let messageNG = "清除成功"
        let alertNG = UIAlertController(title: "清除", message: messageNG, preferredStyle: .alert)
        let actionNG = UIAlertAction(title: "好的", style: .default, handler: {actionNG in self.startNewGame()})
        alertNG.addAction(actionNG)
        present(alertNG, animated: true, completion: nil)
    }
    
    
    
    

}

