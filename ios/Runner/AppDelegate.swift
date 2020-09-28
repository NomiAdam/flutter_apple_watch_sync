import UIKit
import Flutter
import WatchConnectivity

@available(iOS 9.3, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, WCSessionDelegate {

    var flutterChannel : FlutterMethodChannel!

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {}

    func sendString(text: String){
        print(text)
        let session = WCSession.default;
        if(session.isPaired && session.isReachable){
         DispatchQueue.main.async {
                print("Sending counter...")
                session.sendMessage(["counter": text], replyHandler: nil)
            }
        }else{
            print("Watch not reachable...")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("DID RECEIVE")
        self.sendMessageToFlutter()
    }

    private func sendMessageToFlutter(){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.flutterChannel.invokeMethod("pushDataFromWatch", arguments: nil)
            }
        }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    if(WCSession.isSupported()) {
                  let session = WCSession.default;
                  session.delegate = self;
                  session.activate();
    }

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    flutterChannel = FlutterMethodChannel.init(name: "ios_channel", binaryMessenger: controller.binaryMessenger)

    flutterChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
       if(call.method == "pushDataToWatch") {
          self.sendString(text: call.arguments as! String)
          }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
