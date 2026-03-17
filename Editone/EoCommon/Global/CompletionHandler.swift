//
//  CompletionHandler.swift
//

import Foundation

/// Purchase result
public enum CompletionHandlerResult {
    case success
    case error(error: String?, code: Int?)
}
