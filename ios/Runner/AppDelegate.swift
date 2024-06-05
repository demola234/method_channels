import UIKit
import Flutter
import CoreTelephony
import Darwin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "samples.flutter.dev/device",
                                                  binaryMessenger: controller.binaryMessenger)

        methodChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "getBatteryLevel":
                self?.receiveBatteryLevel(result: result)
            case "getSignalStrength":
                let signalStrength = self?.getSignalStrength() ?? -1
                result(signalStrength)
            default:
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Battery level not available.",
                                details: nil))
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }

    private func getSignalStrength() -> Int {
        let libHandle = dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_NOW)
        let CTGetSignalStrength2 = dlsym(libHandle, "CTGetSignalStrength")

        typealias CFunction = @convention(c) () -> Int

        if (CTGetSignalStrength2 != nil) {
            let fun = unsafeBitCast(CTGetSignalStrength2!, to: CFunction.self)
            let result = fun()
            return result
        }
        return -1
    }
}
