//
//  Loggoer.swift
//
//

import Foundation
import CocoaLumberjack


@inline (__always) func Eo_Log(_ log: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    
//    #if DEBUG
        NSLog("%@", log())
        DDLogInfo(log(), file: file, line: line)
//    #else
        
//    #endif
}

@inline (__always) func Eo_Log(_ format: String, file: StaticString = #file, line: UInt = #line, _ args: CVarArg...) {

    let message = String(format: format, args)
    Eo_Log(message, file: file, line: line)
}
