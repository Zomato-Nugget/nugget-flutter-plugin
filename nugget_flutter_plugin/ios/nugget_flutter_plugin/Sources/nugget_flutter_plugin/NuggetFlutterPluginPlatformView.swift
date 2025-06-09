//
//  NuggetFlutterPluginPlatformView.swift
//  nugget_flutter_plugin
//
//  Created by Rajesh Budhiraja on 21/05/25.
//

import Foundation
import Flutter

final class NuggetFlutterPluginPlatformView: NSObject, FlutterPlatformView {
    private let _view: UIView
    private var chatViewController: UIViewController?
    
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, pluginInstance: NuggetFlutterPlugin?) {
        _view = UIView(frame: frame)
        _view.backgroundColor = .lightGray
        super.init()
        
        guard let factory = pluginInstance?.nuggetFactory else {
            return
        }
        
        let creationArgs = args as? [String: Any]
        let deeplink = creationArgs?["deeplink"] as? String ?? ""
        
        guard let chatVC = factory.contentViewController(deeplink: deeplink) else {
            return
        }
        
        self.chatViewController = chatVC
        
        if let chatView = chatVC.view {
            chatView.frame = _view.bounds
            chatView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            _view.addSubview(chatView)
        }
    }
    
    func view() -> UIView {
        return _view
    }
}
