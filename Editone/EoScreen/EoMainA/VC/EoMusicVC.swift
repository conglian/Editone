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
    
    var musicBlock: ((Bool, String) -> Void)?
    var music_urls : [URL] = LibraryFileManager.shared.allFileURLs()
    var current_name = ""
    
    // MARK: - UI Elements
    fileprivate lazy var topimageV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "eo_top_bg")
        return v
    }()
    
    fileprivate lazy var musicimageV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.image = UIImage(named: "eo_music_bg_nomal")
        v.layer.cornerRadius = 24
        v.layer.masksToBounds = true
        return v
    }()
    
    fileprivate lazy var music_Label: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.textAlignment = .center
        v.font = UIFont.systemFont(ofSize: 18)
        v.text = ""
        return v
    }()
    
    fileprivate lazy var left_btn: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "eo_left_s"), for: .selected)
        v.setBackgroundImage(UIImage(named: "eo_left_n"), for: .normal)
        v.addTarget(self, action: #selector(handleLeftSender), for: .touchUpInside)
        return v
    }()
    
    fileprivate lazy var right_btn: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "eo_right_s"), for: .selected)
        v.setBackgroundImage(UIImage(named: "eo_right_n"), for: .normal)
        v.addTarget(self, action: #selector(handleRightSender), for: .touchUpInside)
        return v
    }()
    
    fileprivate lazy var play_btn: UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "eo_pause_btn"), for: .normal)
        v.setBackgroundImage(UIImage(named: "eo_play_btn"), for: .selected)
        v.addTarget(self, action: #selector(handlePlaySender), for: .touchUpInside)
        v.isSelected = true
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
        s.minimumTrackTintColor = UIColor(hexString: "#7395FF")
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: EO_NOTIFICATION_MUSIC_FINISHED, object: nil)
        if audioPlayer?.url?.deletingPathExtension().lastPathComponent != current_name {
            playMusicAsync()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: EO_NOTIFICATION_dismiss_FINISHED, object: nil)
    }
    
    func updateStatusUI() {
        music_urls = LibraryFileManager.shared.allFileURLs()
        left_btn.isSelected = music_urls.count >= 2
        right_btn.isSelected = music_urls.count >= 2
        
        if current_name.isEmpty {
            musicimageV.image = UIImage(named: "eo_music_bg_nomal")
        } else {
            musicimageV.image = LocalImageManager.shared.getImage(name: current_name)
        }
    }
    
    // MARK: - 异步播放音乐
    func playMusicAsync() {
        music_urls = LibraryFileManager.shared.allFileURLs()
        guard !music_urls.isEmpty else {
            music_Label.text = "Bass Synth"
            return
        }

        let url = LibraryFileManager.shared.fileURL(name: current_name)
        print("url=\(url.path) 后缀: \(url.pathExtension)")

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.delegate = self
                player.numberOfLoops = -1
                player.prepareToPlay()

                DispatchQueue.main.async {
                    self?.audioPlayer = player
                    self?.play_btn.isSelected = false
                    self?.music_Label.text = url.deletingPathExtension().lastPathComponent
                    player.play()
                    self?.updateStatusUI()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self?.musicBlock?((self?.audioPlayer?.isPlaying ?? false),
                                          self?.audioPlayer?.url?.deletingPathExtension().lastPathComponent ?? "")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("播放器初始化失败: \(error)")
                    self?.music_Label.text = "Bass Synth"
                }
            }
        }
    }
    
    // MARK: - 左右按钮切换音乐
    @objc func handleLeftSender() {
        // 每次点击先刷新文件列表
        music_urls = LibraryFileManager.shared.allFileURLs()

        if let currentIndex = music_urls.firstIndex(where: { $0.deletingPathExtension().lastPathComponent == current_name }) {
            let prevIndex = (currentIndex - 1 + music_urls.count) % music_urls.count
            current_name = music_urls[prevIndex].deletingPathExtension().lastPathComponent
            playMusicAsync()
        }
    }

    @objc func handleRightSender() {
        music_urls = LibraryFileManager.shared.allFileURLs()

        if let currentIndex = music_urls.firstIndex(where: { $0.deletingPathExtension().lastPathComponent == current_name }) {
            let nextIndex = (currentIndex + 1) % music_urls.count
            current_name = music_urls[nextIndex].deletingPathExtension().lastPathComponent
            playMusicAsync()
        }
    }
    
    @objc func handlePlaySender() {
        GADInterstitialAdManager.share.adDidCloseHandler = { [weak self] in
            guard let player = self?.audioPlayer else { return }
            self?.music_Label.text = player.url?.deletingPathExtension().lastPathComponent ?? ""
                if player.isPlaying {
                    player.pause()
                    self?.play_btn.isSelected = true
                } else {
                    player.play()
                    self?.play_btn.isSelected = false
                }
            self?.musicBlock?(player.isPlaying, player.url?.deletingPathExtension().lastPathComponent ?? "")
        }
        GADInterstitialAdManager.share.showAdIfAvailable(from: self)
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
        player.currentTime = 0
        player.play()
    }
    
    deinit {
        displayLink?.invalidate()
    }
}
