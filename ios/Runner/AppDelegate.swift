import UIKit
import Flutter
import Photos

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

    let channel = FlutterMethodChannel(
      name: "solarmax/save_image",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "saveImage" {

        guard let args = call.arguments as? FlutterStandardTypedData else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Không có dữ liệu ảnh", details: nil))
          return
        }

        self?.saveImageToGallery(args.data, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func saveImageToGallery(_ imageData: Data, result: @escaping FlutterResult) {

    // iOS 14 trở xuống dùng API cũ
    func save() {
      PHPhotoLibrary.shared().performChanges({
        let request = PHAssetCreationRequest.forAsset()
        request.addResource(with: .photo, data: imageData, options: nil)
      }, completionHandler: { success, error in
        if success {
          result(true)
        } else {
          result(FlutterError(code: "SAVE_FAILED",
                              message: "Không lưu được ảnh",
                              details: error?.localizedDescription))
        }
      })
    }

    // Xin quyền trước
    PHPhotoLibrary.requestAuthorization { status in
      switch status {
      case .authorized:
        save()
      default:
        result(FlutterError(code: "NO_PERMISSION",
                            message: "Không có quyền lưu ảnh",
                            details: nil))
      }
    }
  }
}
