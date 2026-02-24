import Cocoa
import FlutterMacOS
import window_manager
import ServiceManagement
import desktop_multi_window
class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // launch_at_startup integration using modern native SMAppService (Requires macOS 13+)
    FlutterMethodChannel(
      name: "launch_at_startup", binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    .setMethodCallHandler { (_ call: FlutterMethodCall, result: @escaping FlutterResult) in
      if #available(macOS 13.0, *) {
          let service = SMAppService.mainApp
          switch call.method {
          case "launchAtStartupIsEnabled":
              result(service.status == .enabled)
          case "launchAtStartupSetEnabled":
              if let arguments = call.arguments as? [String: Any],
                 let setEnabledValue = arguments["setEnabledValue"] as? Bool {
                  do {
                      if setEnabledValue {
                          if service.status != .enabled {
                              try service.register()
                          }
                      } else {
                          if service.status == .enabled {
                              try service.unregister()
                          }
                      }
                      result(nil)
                  } catch {
                      print("SMAppService error: \(error)")
                      result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                  }
              } else {
                  result(nil)
              }
          default:
              result(FlutterMethodNotImplemented)
          }
      } else {
          print("launch_at_startup requires macOS 13.0 or newer.")
          result(false) // Fallback for older macOS
      }
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    FlutterMultiWindowPlugin.setOnWindowCreatedCallback { controller in
        RegisterGeneratedPlugins(registry: controller)
        
        if let window = controller.view.window {
            window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
            window.level = .normal
            window.titleVisibility = .visible
            window.titlebarAppearsTransparent = false
            window.isOpaque = true
            window.hasShadow = true
            window.backgroundColor = NSColor.windowBackgroundColor
            window.isMovableByWindowBackground = false
            
            // Force buttons to render explicitly
            window.standardWindowButton(.closeButton)?.isHidden = false
            window.standardWindowButton(.miniaturizeButton)?.isHidden = false
            window.standardWindowButton(.zoomButton)?.isHidden = false
        }
    }

    self.isOpaque = false
    self.backgroundColor = NSColor.clear
    flutterViewController.backgroundColor = .clear

    super.awakeFromNib()
  }

  override public func order(_ place: NSWindow.OrderingMode, relativeTo otherWin: Int) {
    super.order(place, relativeTo: otherWin)
    hiddenWindowAtLaunch()
  }
}
