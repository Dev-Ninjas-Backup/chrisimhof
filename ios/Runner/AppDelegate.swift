import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    print("AppDelegate openURL: \(url.absoluteString)")

    if url.scheme?.hasPrefix("msauth") == true {
      // Dismiss SFSafariViewController if presented
      if let presented = window?.rootViewController?.presentedViewController {
        presented.dismiss(animated: true, completion: nil)
      } else {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
      }

      let handled = super.application(app, open: url, options: options)
      if handled {
        return true
      }

      // AppAuth matching fallback: handle trailing slash discrepancy on path
      let urlStr = url.absoluteString
      if urlStr.contains("://auth/?") {
        if let altUrl = URL(string: urlStr.replacingOccurrences(of: "://auth/?", with: "://auth?")) {
          print("AppDelegate trying alternate redirect without trailing slash: \(altUrl.absoluteString)")
          return super.application(app, open: altUrl, options: options)
        }
      } else if urlStr.contains("://auth?") {
        if let altUrl = URL(string: urlStr.replacingOccurrences(of: "://auth?", with: "://auth/?")) {
          print("AppDelegate trying alternate redirect with trailing slash: \(altUrl.absoluteString)")
          return super.application(app, open: altUrl, options: options)
        }
      }
      return false
    }

    return super.application(app, open: url, options: options)
  }
}