//
//  RecorderSessionHandler.swift
//  RecordProject
//
//

import AVFoundation

class RecorderSessionHandler {
    let session = AVAudioSession.sharedInstance()
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        session.requestRecordPermission { granted in
            completion(granted)
        }
    }
    
    func setActive() {
        try! session.setCategory(.playAndRecord)
        try! session.setActive(true, options: [])
    }
}
