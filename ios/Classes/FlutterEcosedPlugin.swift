import Flutter

public class FlutterEcosedPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_ecosed", binaryMessenger: registrar.messenger())
        let instance = FlutterEcosedPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlugins":
            result(nil)
        case "openDialog":
            result(true)
        case "closeDialog":
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
