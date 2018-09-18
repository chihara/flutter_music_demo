import UIKit
import MediaPlayer
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    MediaPlugin.register(with: self.registrar(forPlugin: "MediaPlugin"))
//    FLTMediaPlugin.register(with: self.registrar(forPlugin: "MediaPlugin"))
    
//    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
//    let channel = FlutterMethodChannel.init(name: "com.example.player/media", binaryMessenger: controller)
//    channel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) -> Void in
//        print("handle:%s", call.method)
//        switch call.method {
//        case "getSongs":
//            let list = NSMutableArray.init()
//            let items = MPMediaQuery.songs().items
//            for item in items! {
//                let dic = NSMutableDictionary()
//                dic["title"] = item.title
//                dic["artist"] = item.artist
//                dic["album"] = item.albumTitle
//                dic["albumArt"] = item.artwork
//                dic["track"] = item.albumTrackNumber
//                dic["duration"] = item.playbackDuration
//                list.add(dic)
//            }
//            result(list)
//        case "getAlbums":
//            let list = NSMutableArray.init()
//            let items = MPMediaQuery.albums().items
//            for item in items! {
//                let dic = NSMutableDictionary()
//                dic["title"] = item.title
//                dic["artist"] = item.artist
//                dic["albumArt"] = item.artwork
//                dic["numOfTracks"] = item.albumTrackCount
//                list.add(dic)
//            }
//            result(list)
//        default:
//            result(FlutterMethodNotImplemented)
//        }
//    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
