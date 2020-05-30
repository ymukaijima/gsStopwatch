//
//  ViewController.swift
//  Stopwatch
//
//  Created by yumi on 2020/05/23.
//  Copyright © 2020 Yumi Takahashi. All rights reserved.
//

import UIKit
import AVFoundation
 
class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    // imageViewの変数設定
    var image1: UIImage!
    
    // Timerの分・秒・小数点以下のLabelを定義する
    @IBOutlet var timerMinute: UILabel!
    @IBOutlet var timerSecond: UILabel!
    @IBOutlet var timerMSec: UILabel!
    
    // Timerの設定
    weak var timer: Timer!
    
    // 音の設定
    var player: AVAudioPlayer!
    
    // 各種変数の設定
    var startTime = Date()
    var pauseTime: Double = 0
    var currentTime: Double = 0
    var newCurrentTime: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // はじめにtimerの時間表記を0にする
        resetTime()
        image1 = UIImage(named: "nabeatsuImage")
    }
    
    // スタートボタンを押したとき
    @IBAction func startTimer(_ sender : Any) {
        if timer != nil{
            // timerが起動中なら一旦破棄する
            timer.invalidate()
        }
        // Timerを作成
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(self.timerCounter),
            userInfo: nil,
            repeats: true)
        
        // 現在の時刻をstartTimeに代入
        startTime = Date()
    }
    
    // ストップボタンを押したとき
    @IBAction func stopTimer(_ sender : Any) {
        if timer != nil{
            // timerが起動中なら一旦破棄する
            timer.invalidate()
        }
        // newCurrentTimeに0以外の値が入っている場合
        if newCurrentTime != 0{
            pauseTime = newCurrentTime
        // newCurrentTime=0の場合
        } else {
            pauseTime = currentTime
        }
    }
    
    // リセットボタンを押したとき
    @IBAction func resetTimer(_ sender: Any) {
        if timer != nil{
            // timerが起動中なら一旦破棄する
            timer.invalidate()
        }
        // timerの時間表記を0にする
        resetTime()
        pauseTime = 0
    }
    
    @objc func timerCounter(){
        // タイマー開始からのインターバル時間
        currentTime = Date().timeIntervalSince(startTime)
        // タイマーを一時停止から再開する場合は、pauseTimeに値が入っているので足す必要がある
        //　pauseTimeに値がない場合はcurrentTimeとnewCurrentTimeは同じ値
        newCurrentTime = currentTime + Double(pauseTime)
        // fmod() 余りを計算
        let minute = (Int)(fmod((newCurrentTime/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(newCurrentTime, 60))
        // floor 切り捨て、小数点以下を取り出して *100
        let msec = (Int)((newCurrentTime - floor(newCurrentTime))*100)
        
        // %02d： ２桁表示、0で埋める
        let sMinute = String(format:"%02d", minute)
        let sSecond = String(format:"%02d", second)
        let sMsec = String(format:"%02d", msec)
        
        timerMinute.text = sMinute
        timerSecond.text = sSecond
        timerMSec.text = sMsec
        
        // 秒数が3の倍数になったときに音を流す
        if Int(sSecond)! > 0 && Int(sSecond)! % 3 == 0 {
            playSound()
            imageView.image = image1
        } else {
            imageView.image = nil

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
    }
    
    // timerの時間表記を0にする関数
    func resetTime() {
        timerMinute.text = "00"
        timerSecond.text = "00"
        timerMSec.text = "00"
    }
    
    // 音を流す関数
    func playSound() {
        let url = Bundle.main.url(forResource: "nabeatsu3", withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
}

