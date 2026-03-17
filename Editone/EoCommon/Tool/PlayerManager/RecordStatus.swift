//
//  RecordStatus.swift
//
//

enum RecordStatus {
    case ready
    case countdown
    case recording
    case pause
    case stop
    
    var title: String {
        switch self {
        case .ready: return "Ready?"
        case .recording: return "Recording"
        case .pause: return "Pause"
        case .stop: return "Stop"
        case .countdown: return ""
        }
    }
}
