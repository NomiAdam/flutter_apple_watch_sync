//
//  HostingController.swift
//  WatchApp Extension
//
//  Created by Adam Kvasnička on 27/09/2020.
//

import WatchKit
import Foundation
import SwiftUI
import WatchConnectivity

class AppState: ObservableObject {
    static let shared = AppState()

    @Published var counter: String = "0"
}

class HostingController: WKHostingController<AnyView>, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
            
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if (WCSession.isSupported()) {
         let session = WCSession.default;
            session.delegate = self;
            session.activate();
        }
    }

    func sendString() {
        if (WCSession.isSupported()) {
        let session = WCSession.default;
        if (session.isReachable) {
         DispatchQueue.main.async {
                print("Sending counter from watches...")
                session.sendMessage(["counter": "text"], replyHandler: nil)
            let incrementValue = Int(AppState.shared.counter) ?? 0
            AppState.shared.counter = String(incrementValue + 1)
            }
        } else {
            print("iPhone not reachable...")
        }
      }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            AppState.shared.counter = message["counter"] as! String
        }
    }

    override var body: AnyView {
        let contentView = ContentView(onIncrement: sendString)
                   .environmentObject(AppState.shared)
        return AnyView(contentView)
    }
}
