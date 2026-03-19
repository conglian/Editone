//
//  EoMusicVC.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 19/03/2026.
//

import UIKit
import SnapKit
import AVFoundation


class EoMusicVC: BaseViewController, AVAudioPlayerDelegate {
    
    // MARK: - 单例
    static let shared = EoMusicVC()
    
    // 定义一个可选闭包属性
    var musicBlock: ((Bool, String) -> Void)?
    
    // MARK: - UI Elements
    fileprivate lazy var topimageV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "eo_top_bg")
        return v
    }()
    
    fileprivate lazy var musicimageV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "eo_music_bg_nomal")
        return v
    }()
    
    fileprivate lazy var music_Label: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.textAlignment = .center
        v.font = UIFont.systemFont(ofSize: 18)
        v.text = "Bass Name"
        return v
    }()
    
    fileprivate lazy var left_btn: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "eo_left_s"), for: .normal)
        v.addTarget(self, action: #selector(handleLeftSender), for: .touchUpInside)
        return v
    }()
    
    fileprivate lazy var right_btn: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "eo_right_s"), for: .normal)
        v.addTarget(self, action: #selector(handleRightSender), for: .touchUpInside)
        return v
    }()
    
    fileprivate lazy var play_btn: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "eo_pause_btn"), for: .normal)
        v.setBackgroundImage(UIImage(named: "eo_play_btn"), for: .selected)
        v.addTarget(self, action: #selector(handlePlaySender), for: .touchUpInside)
        v.isSelected = true // 默认显示播放按钮
        return v
    }()
    
    // MARK: - 底部进度 UI
    fileprivate lazy var currentTimeLabel: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.font = UIFont.systemFont(ofSize: 12)
        v.text = "00:00"
        return v
    }()
    
    fileprivate lazy var durationLabel: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.font = UIFont.systemFont(ofSize: 12)
        v.text = "00:00"
        return v
    }()
    
    fileprivate lazy var progressSlider: UISlider = {
        let s = UISlider()
        s.minimumTrackTintColor = UIColor.init(hexString: "#7395FF")
        s.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        s.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        s.addTarget(self, action: #selector(sliderTouchDown(_:)), for: .touchDown)
        s.addTarget(self, action: #selector(sliderTouchUp(_:)), for: [.touchUpInside, .touchUpOutside])
        return s
    }()
    
    // MARK: - 播放管理
    var audioPlayer: AVAudioPlayer?
    var displayLink: CADisplayLink?
    var isSliding = false
    
    // MARK: - Actions
    @objc func handleLeftSender() {
        guard let player = audioPlayer else {
            print("播放器未初始化")
            return
        }
        // 上一首逻辑
        music_Label.text = player.url?.deletingPathExtension().lastPathComponent ?? ""

    }
    
    @objc func handleRightSender() {
        guard let player = audioPlayer else {
            print("播放器未初始化")
            return
        }
        // 下一首逻辑
        music_Label.text = player.url?.deletingPathExtension().lastPathComponent ?? ""
    }
    
    @objc func handlePlaySender() {
        guard let player = audioPlayer else {
            print("播放器未初始化")
            return
        }
        music_Label.text = player.url?.deletingPathExtension().lastPathComponent ?? ""
        if player.isPlaying {
            player.pause()
            play_btn.isSelected = true
            print("暂停")
        } else {
            player.play()
            play_btn.isSelected = false
            print("继续播放")
        }
        if musicBlock != nil {
            musicBlock!(player.isPlaying, player.url?.deletingPathExtension().lastPathComponent ?? "")
        }
    }
    
    // MARK: - Slider Actions
    @objc private func sliderValueChanged(_ slider: UISlider) {
        guard let player = audioPlayer else { return }
        let time = TimeInterval(slider.value) * player.duration
        updateTimeLabels(current: time, duration: player.duration)
    }
    
    @objc private func sliderTouchDown(_ slider: UISlider) {
        isSliding = true
    }
    
    @objc private func sliderTouchUp(_ slider: UISlider) {
        guard let player = audioPlayer else { return }
        let time = TimeInterval(slider.value) * player.duration
        player.currentTime = time
        isSliding = false
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupPlayer()
        setupDisplayLink()
    }
    
    // MARK: - UI Setup
    private func configUI() {
        
        navBar.barBackgroundColor = .bgroundColors
        
        view.addSubview(topimageV)
        topimageV.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(0)
            make.height.equalTo(421)
        }
        
        view.addSubview(musicimageV)
        musicimageV.snp.makeConstraints { make in
            make.leading.equalTo((WSCREEN - 281) * 0.5)
            make.width.height.equalTo(281)
            make.top.equalTo(NAVIGATION_H + 20)
        }
        
        view.addSubview(music_Label)
        music_Label.snp.makeConstraints { make in
            make.leading.equalTo((WSCREEN - 281) * 0.5)
            make.width.equalTo(281)
            make.top.equalTo(musicimageV.snp.bottom).offset(30)
        }
        
        // 底部播放按钮
        view.addSubview(play_btn)
        play_btn.snp.makeConstraints { make in
            make.bottom.equalTo(-97)
            make.width.height.equalTo(86)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(left_btn)
        left_btn.snp.makeConstraints { make in
            make.bottom.equalTo(-121)
            make.width.height.equalTo(50)
            make.leading.equalTo(50)
        }
        
        view.addSubview(right_btn)
        right_btn.snp.makeConstraints { make in
            make.bottom.equalTo(-121)
            make.width.height.equalTo(50)
            make.trailing.equalTo(-50)
        }
        
        // 底部进度条 + 时间
        view.addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.bottom.equalTo(play_btn.snp.top).offset(-88)
        }
        
        view.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-24)
            make.centerY.equalTo(currentTimeLabel)
        }
        
        view.addSubview(progressSlider)
        progressSlider.snp.makeConstraints { make in
            make.leading.equalTo(currentTimeLabel.snp.trailing).offset(10)
            make.trailing.equalTo(durationLabel.snp.leading).offset(-10)
            make.centerY.equalTo(currentTimeLabel)
        }
    }
    
    // MARK: - 播放器初始化
    private func setupPlayer() {
        // 如果已经有播放器，直接返回
        if audioPlayer != nil { return }

        guard let url = Bundle.main.url(forResource: "Bass Synth", withExtension: "mp3") else {
            print("音频文件不存在")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.numberOfLoops = -1 // 单曲循环
            audioPlayer?.prepareToPlay()
        } catch {
            print("播放器初始化失败: \(error)")
        }
    }
    
    // MARK: - 实时刷新进度
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateProgress() {
        guard let player = audioPlayer, !isSliding else { return }
        let progress = Float(player.currentTime / player.duration)
        progressSlider.value = progress
        updateTimeLabels(current: player.currentTime, duration: player.duration)
    }
    
    private func updateTimeLabels(current: TimeInterval, duration: TimeInterval) {
        let curMin = Int(current) / 60
        let curSec = Int(current) % 60
        let durMin = Int(duration) / 60
        let durSec = Int(duration) % 60
        
        currentTimeLabel.text = String(format: "%d:%02d", curMin, curSec)
        durationLabel.text = String(format: "%d:%02d", durMin, durSec)
    }
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // 如果 numberOfLoops = -1 已经循环播放，不会进入这里
        // 如果你希望单曲循环，也可以这里手动处理：
        player.currentTime = 0
        player.play()
    }
    
    deinit {
        displayLink?.invalidate()
    }
}
