//
//  EoEditRecordVC.swift
//  Editone
//

import UIKit
import SnapKit
import FDWaveformView
import AVFoundation

class EoEditRecordVC: BaseViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var bg_name  = ""
    
    var music_path : URL?
    
    var is_save = false

    // MARK: - Waveform & Range
    let waveformView = FDWaveformView()
    let startTimeLabel = UILabel()
    let endTimeLabel = UILabel()

    var audioURL: URL!
    var audioPlayer: AVAudioPlayer?

    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var displayLink: CADisplayLink?
    
    var proViewLeadingConstraint: Constraint?
    
    var coverimage : UIImage?

    // MARK: - UI Elements
    fileprivate lazy var topimageV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "eo_top_bg")
        return v
    }()

    fileprivate lazy var add_bg_btn: UIButton = {
        let v = UIButton()
        v.backgroundColor = UIColor(hexString: "#99ADCB", alpha: 0.12)
        v.layer.cornerRadius = 21
        v.layer.masksToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor(hexString: "#FFFFFF", alpha: 0.05).cgColor
        v.setBackgroundImage(UIImage(named: bg_name), for: .normal)
        v.addTarget(self, action: #selector(handleAddSender), for: .touchUpInside)
        v.imageView?.contentMode = .scaleToFill
        return v
    }()

    fileprivate lazy var addimageV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.image = UIImage(named: "eo_add_big")
        return v
    }()

    fileprivate lazy var tuoimageV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.isUserInteractionEnabled = true
        v.image = UIImage(named: "eo_edit_tuo_bg")
        return v
    }()
    
    fileprivate lazy var eidtbgimageV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.isUserInteractionEnabled = true
        v.image = UIImage(named: "eo_edit_bgs")
        return v
    }()

    fileprivate lazy var add_Label: UILabel = {
        let v = UILabel()
        v.textColor = UIColor.white.withAlphaComponent(0.6)
        v.textAlignment = .center
        v.font = UIFont.systemFont(ofSize: 16)
        v.text = "Add Cover"
        return v
    }()

    fileprivate lazy var music_name_Label: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.textAlignment = .left
        v.font = UIFont.systemFont(ofSize: 16)
        v.text = "Music Name"
        return v
    }()

    fileprivate lazy var edit_btn: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(handleEditSender), for: .touchUpInside)
        v.setImage(UIImage(named: "eo_edit_icon_s"), for: .normal)
        return v
    }()

    fileprivate lazy var play_btn: UIButton = {
        let v = UIButton()
        v.setTitle("Play", for: .normal)
        v.setTitle("Pause", for: .selected)
        v.backgroundColor = .white
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 16
        v.setTitleColor(.bgroundColors, for: .normal)
        v.setTitleColor(.white, for: .selected)
        v.addTarget(self, action: #selector(handlePlaySender), for: .touchUpInside)
        return v
    }()
    
    fileprivate lazy var save_btn: UIButton = {
        let v = UIButton()
        v.setTitle("Save", for: .normal)
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 16
        v.setTitleColor(.bgroundColors, for: .normal)
        v.setBackgroundImage(UIImage(named: "eo_btn_bg"), for: .normal)
        v.addTarget(self, action: #selector(handleSaveSender), for: .touchUpInside)
        return v
    }()
    
    fileprivate lazy var pro_View: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.init(hexString: "#ECA2FF")
        return v
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupWaveform()
        setupTuoImageDrag()
        loadAudio()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.stop()
        audioPlayer = nil
        displayLink?.invalidate()
        displayLink = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if EoMusicVC.shared.audioPlayer?.isPlaying == true {
            EoMusicVC.shared.handlePlaySender()
            NotificationCenter.default.post(name: EO_NOTIFICATION_MUSIC_FINISHED, object: nil)
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    // MARK: - Waveform Setup
    private func setupWaveform() {
        waveformView.frame = CGRect(x: 12, y: 7, width: view.bounds.width - 60, height: 46)
        waveformView.wavesColor = UIColor(hexString: "#D9D9D9")
        waveformView.progressColor = .blue
        waveformView.backgroundColor = .clear
        waveformView.doesAllowScrubbing = false
        waveformView.delegate = self
        eidtbgimageV.addSubview(waveformView)
        
        setupLabels()
    }

    // MARK: - tuoimageV 拖拽设置
    private func setupTuoImageDrag() {
        let waveformWidth = Int(WSCREEN - 36)
        let waveformHeight = 60

        tuoimageV.frame = CGRect(x: 0, y: 0, width: waveformWidth, height: waveformHeight)
        eidtbgimageV.addSubview(tuoimageV)

        // 左右拖拽手势区域
        let leftPanArea = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: waveformHeight))
        leftPanArea.backgroundColor = .clear
        tuoimageV.addSubview(leftPanArea)
        let leftPan = UIPanGestureRecognizer(target: self, action: #selector(handleLeftPan(_:)))
        leftPanArea.addGestureRecognizer(leftPan)

        let rightPanArea = UIView(frame: CGRect(x: waveformWidth - 40, y: 0, width: 40, height: waveformHeight))
        rightPanArea.backgroundColor = .clear
        rightPanArea.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth]
        tuoimageV.addSubview(rightPanArea)
        let rightPan = UIPanGestureRecognizer(target: self, action: #selector(handleRightPan(_:)))
        rightPanArea.addGestureRecognizer(rightPan)
    }
    
    @objc func handleAddSender(){
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
        
    }

    // MARK: - 左右拖拽处理
    @objc private func handleLeftPan(_ gesture: UIPanGestureRecognizer) {
        playToTouchStopMusic()
        stopPlaybackForDrag()
        let translation = gesture.translation(in: eidtbgimageV)
        gesture.setTranslation(.zero, in: eidtbgimageV)

        var newX = tuoimageV.frame.origin.x + translation.x
        var newWidth = tuoimageV.frame.width - translation.x

        let minX: CGFloat = 0
        let maxWidth = tuoimageV.frame.maxX
        let minWidth: CGFloat = 40

        if newX < minX {
            newWidth -= (minX - newX)
            newX = minX
        }

        if newWidth < minWidth {
            newX = tuoimageV.frame.maxX - minWidth
            newWidth = minWidth
        }

        tuoimageV.frame = CGRect(x: newX, y: tuoimageV.frame.origin.y, width: newWidth, height: tuoimageV.frame.height)

        updateTimeLabels()
        updateProViewPosition()
    }

    @objc private func handleRightPan(_ gesture: UIPanGestureRecognizer) {
        playToTouchStopMusic()
        stopPlaybackForDrag()
        let translation = gesture.translation(in: eidtbgimageV)
        gesture.setTranslation(.zero, in: eidtbgimageV)

        var newWidth = tuoimageV.frame.width + translation.x
        let maxWidth = eidtbgimageV.frame.width - tuoimageV.frame.origin.x
        let minWidth: CGFloat = 40

        if newWidth > maxWidth {
            newWidth = maxWidth
        }

        if newWidth < minWidth {
            newWidth = minWidth
        }

        tuoimageV.frame = CGRect(x: tuoimageV.frame.origin.x, y: tuoimageV.frame.origin.y, width: newWidth, height: tuoimageV.frame.height)

        updateTimeLabels()
        updateProViewPosition()
    }

    private func stopPlaybackForDrag() {
        audioPlayer?.pause()
        play_btn.isSelected = false
        updateProViewPosition()
    }

    // MARK: - 更新时间
    private func updateTimeLabels() {
        guard let duration = audioPlayer?.duration else { return }
        let waveformWidth = waveformView.frame.width
        let startRatio = tuoimageV.frame.minX / waveformWidth
        let endRatio = tuoimageV.frame.maxX / waveformWidth

        startTime = duration * Double(startRatio)
        endTime = duration * Double(endRatio)

        startTimeLabel.text = formatTime(startTime)
        endTimeLabel.text = formatTime(endTime)
    }

    // MARK: - Labels Setup
    private func setupLabels() {
        startTimeLabel.textColor = UIColor.init(hexString: "#FFFFFF",alpha: 0.6)
        startTimeLabel.text = "0:00"
        startTimeLabel.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(startTimeLabel)
        startTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(music_name_Label.snp.bottom).offset(12)
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.leading.equalTo(18)
        }

        endTimeLabel.textColor = UIColor.init(hexString: "#FFFFFF",alpha: 0.6)
        endTimeLabel.text = "0:00"
        endTimeLabel.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(endTimeLabel)
        endTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(music_name_Label.snp.bottom).offset(12)
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.trailing.equalTo(-8)
        }

        view.addSubview(play_btn)
        play_btn.snp.makeConstraints { make in
            make.bottom.equalTo(-100)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.height.equalTo(50)
        }
        view.addSubview(save_btn)
        save_btn.snp.makeConstraints { make in
            make.bottom.equalTo(-30)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.height.equalTo(50)
        }
        
        view.addSubview(pro_View)
        pro_View.snp.makeConstraints { make in
            make.top.equalTo(endTimeLabel.snp.bottom).offset(-3)
            proViewLeadingConstraint = make.leading.equalTo(31).constraint
            make.height.equalTo(72)
            make.width.equalTo(3)
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Load Audio
    private func loadAudio() {
        DispatchQueue.global().async {
            guard let url = self.music_path else { return }
            self.audioURL = url

            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer?.prepareToPlay()

                // 确保主线程更新 UI
                DispatchQueue.main.async {
                    self.waveformView.audioURL = url
                    self.waveformView.doesAllowScrubbing = false

                    // 设置初始选区为整个音频
                    if let duration = self.audioPlayer?.duration {
                        self.startTime = 0
                        self.endTime = duration
                        self.startTimeLabel.text = self.formatTime(self.startTime)
                        self.endTimeLabel.text = self.formatTime(self.endTime)
                        self.updateProViewPosition()
                    }
                }
            } catch {
                print("播放器初始化失败: \(error)")
            }
        }
    }
    
    // 播放过程中暂停恢复
    private func playToTouchStopMusic() {
        guard let player = audioPlayer else { return }

        if player.isPlaying {
            player.pause()
            play_btn.isSelected = false
            displayLink?.invalidate()
            play_btn.backgroundColor = .white
        }
    }

    // MARK: - Play Action
    @objc func handlePlaySender() {
        guard let player = audioPlayer else { return }

        if !player.isPlaying {
            player.currentTime = startTime
            player.play()
            play_btn.isSelected = true
            play_btn.backgroundColor = .view_background
            // CADisplayLink更新pro_View
            displayLink?.invalidate()
            displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
            displayLink?.add(to: .main, forMode: .default)
        } else {
            player.pause()
            play_btn.isSelected = false
            displayLink?.invalidate()
            play_btn.backgroundColor = .white
        }
    }

    @objc private func updateProgress() {
        guard let player = audioPlayer else { return }
        if startTime == nil || endTime == nil  { return }
        let progressRatio = CGFloat((player.currentTime - startTime) / (endTime - startTime))
        let newX = tuoimageV.frame.minX + (progressRatio * tuoimageV.frame.width)
        
            proViewLeadingConstraint?.update(offset: newX + 26)
        
            view.layoutIfNeeded()

        if player.currentTime >= endTime {
            player.stop()
            play_btn.isSelected = false
            play_btn.backgroundColor = .white
            displayLink?.invalidate()
            displayLink = nil
            updateProViewPosition()
        }
    }
    private func updateProViewPosition() {
        proViewLeadingConstraint?.update(offset: tuoimageV.frame.minX + 26)
        view.layoutIfNeeded()
    }

    // MARK: - Edit Button
    @objc func handleEditSender() {
        let view = EoEditNameView().loadViewFromNib()
        view.saveBlock = { [weak self] name in
            self?.music_name_Label.text = name
        }
        EoPopupManager.shared.showPopupView(view, direction: .center)
    }
    
    // MARK: - Save Button
    @objc func handleSaveSender() {
        
        if music_name_Label.text == "Music Name" || music_name_Label.text == "" {
            self.showToast(text: "Please set the music name.")
            return
        }
        guard let audioURL = audioURL else { return }
        
        let asset = AVAsset(url: audioURL)
        
        // 创建输出文件路径
        let myFilesURL = LibraryFileManager.shared.subdirectoryURL()
        let outputURL = myFilesURL.appendingPathComponent("\(music_name_Label.text ?? "").\(music_path?.pathExtension ?? "")")
        // 如果目录不存在，创建
            if !FileManager.default.fileExists(atPath: myFilesURL.path) {
                try? FileManager.default.createDirectory(at: myFilesURL,
                                                         withIntermediateDirectories: true,
                                                         attributes: nil)
            }
        // 如果文件已存在，先删除
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try? FileManager.default.removeItem(at: outputURL)
        }
        
        // 创建导出会话
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            print("创建 AVAssetExportSession 失败")
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = fileType(for: music_path!)
        
        // 保存图片
        let backgroundImage = add_bg_btn.backgroundImage(for: .normal)
        if coverimage != nil {
            LocalImageManager.shared.saveImage(coverimage!, name: music_name_Label.text ?? "")
        } else {
            LocalImageManager.shared.saveImage(backgroundImage!, name: music_name_Label.text ?? "")
        }

        
        // 设置截取时间范围
        let start = CMTime(seconds: startTime, preferredTimescale: 1000)
        let duration = CMTime(seconds: endTime - startTime, preferredTimescale: 1000)
        exportSession.timeRange = CMTimeRange(start: start, duration: duration)
        
        // 导出
        exportSession.exportAsynchronously {
            DispatchQueue.main.async {
                switch exportSession.status {
                case .completed:
                    print("导出成功: \(outputURL.path)")
                    self.is_save = true
                    self.showToast(text: "Your work has been saved in 'library-mywork'")
                case .failed:
                    print("导出失败: \(exportSession.error?.localizedDescription ?? "")")
                case .cancelled:
                    print("导出取消")
                default:
                    break
                }
            }
        }
    }
    
    func fileType(for url: URL) -> AVFileType? {
        let asset = AVURLAsset(url: url)
        
        // 获取文件扩展名
        let fileExtension = url.pathExtension.lowercased()
        
        switch fileExtension {
        case "mov": return .mov
        case "mp4": return .mp4
        case "m4a": return .m4a
        case "wav": return .wav
        case "mp3": return .mp3
        case "caf": return .caf
        default: return nil
        }
    }

    // MARK: - UI Setup
    private func configUI() {
        navBar.barBackgroundColor = .bgroundColors
        navBar.title = "Record"
        navBar.onClickLeftButton = { [weak self] in
            if self?.is_save == false {
                let view = EoConfirmExitView().loadViewFromNib()
                view.exitBlcok = { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
                EoPopupManager.shared.showPopupView(view, direction: .center)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }

        view.addSubview(topimageV)
        topimageV.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(0)
            make.height.equalTo(421)
        }

        view.addSubview(add_bg_btn)
        add_bg_btn.snp.makeConstraints { make in
            make.top.equalTo(NAVIGATION_H + 40)
            make.leading.equalTo((WSCREEN - 242) * 0.5)
            make.height.width.equalTo(242)
        }

        add_bg_btn.addSubview(addimageV)
        addimageV.snp.makeConstraints { make in
            make.top.equalTo(54)
            make.leading.equalTo(76)
            make.height.width.equalTo(90)
        }

        add_bg_btn.addSubview(add_Label)
        add_Label.snp.makeConstraints { make in
            make.top.equalTo(164)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(24)
        }

        view.addSubview(music_name_Label)
        music_name_Label.snp.makeConstraints { make in
            make.bottom.equalTo(-280)
            make.centerX.equalTo(view.snp.centerX).offset(-10)
            make.height.equalTo(24)
        }

        view.addSubview(edit_btn)
        edit_btn.snp.makeConstraints { make in
            make.bottom.equalTo(-273)
            make.leading.equalTo(music_name_Label.snp.trailing).offset(12)
            make.height.width.equalTo(38)
        }
        
        view.addSubview(eidtbgimageV)
        eidtbgimageV.snp.makeConstraints { make in
            make.top.equalTo(edit_btn.snp.bottom).offset(27)
            make.leading.equalTo(18)
            make.trailing.equalTo(-18)
            make.height.equalTo(60)
        }
    }
    
    
    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            // 在这里使用选中的图片
            print("选择了一张图片: \(image)")
            coverimage = image
            add_bg_btn.setImage(image, for: .normal)
            addimageV.isHidden = true
            add_Label.isHidden = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - FDWaveformViewDelegate
extension EoEditRecordVC: FDWaveformViewDelegate {
    func waveformViewWillLoad(_ waveformView: FDWaveformView) {
        print("Waveform will load")
    }

    func waveformViewDidLoad(_ waveformView: FDWaveformView) {
        print("Waveform did load")
    }
}

