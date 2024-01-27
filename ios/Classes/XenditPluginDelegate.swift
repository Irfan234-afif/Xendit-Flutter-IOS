//
//  XenditPluginDelegate.swift
//  xendit_ios
//
//  Created by irfan on 05/01/24.
//

import UIKit
import Flutter

@UIApplicationMain
@objc class XenditAppDelegate: FlutterAppDelegate{
    override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        print("HALOHALOOOOOO")
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Contoh fungsi untuk navigasi ke halaman login
    private func navigateToLogin() {
      // Tambahkan logika navigasi ke halaman login di sini
    }
}
