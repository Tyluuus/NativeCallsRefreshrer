import Flutter
import UIKit
import Network

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      guard let pluginRegistrar = self.registrar(forPlugin: "AppIntegration") else {
              return super.application(application, didFinishLaunchingWithOptions: launchOptions)
          }
      let messenger = pluginRegistrar.messenger()

      let api = MyDeviceInfoApi()
      DeviceInfoApiSetup.setUp(binaryMessenger: messenger, api: api)

      let networkChannel = FlutterMethodChannel(name: "com.sandbox.app/airplane",
                                                binaryMessenger: messenger)

      networkChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "isAirplaneModeOn" {
        self.checkNetworkStatus(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
      })
      
      HapticsApiSetup.setUp(binaryMessenger: messenger, api: MyHapticsApi())
      
      let brightnessChannel = FlutterEventChannel(name: "com.sandbox.app/brightness", binaryMessenger: messenger)
      
      brightnessChannel.setStreamHandler(BrightnessStreamHandler())
      
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func checkNetworkStatus(result: @escaping FlutterResult) {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")

    monitor.pathUpdateHandler = { path in
        let isOffline = path.status != .satisfied

        DispatchQueue.main.async {
            result(isOffline)
        }

        monitor.cancel()
    }
    monitor.start(queue: queue)
  }
}

class MyDeviceInfoApi: DeviceInfoApi {
    func getDeviceInfo() throws -> DeviceInfo {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        let batteryLevel = Int(device.batteryLevel * 100)
        
        return DeviceInfo(modelName: device.model, batteryLevel: batteryLevel < 0 ? -1 : Int64(batteryLevel))
    }
}

class MyHapticsApi: HapticsApi {
    func triggerFeedback(type: HapticsFeedbackType) throws {
        let generator = UINotificationFeedbackGenerator()
        
        generator.prepare()
        
        switch type {
        case .error:
            generator.notificationOccurred(.error)
        case .success:
            generator.notificationOccurred(.success)
        case .warning:
            generator.notificationOccurred(.warning)
        }
    }
}

class BrightnessStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var timer: Timer?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let brightness = UIScreen.main.brightness
            events(brightness)
        }
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.timer?.invalidate()
        self.timer = nil
        self.eventSink = nil
        return nil
    }
    
}
