//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 09.07.2023.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    
    static let shared = AnalyticsService()
    
    func sendOpenAppEvent(screen: String) {
        let params : [AnyHashable : Any] = ["screen": "\(screen)"]
        YMMYandexMetrica.reportEvent("open", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func sendCloseAppEvent(screen: String) {
        let params : [AnyHashable : Any] = ["screen": "\(screen)"]
        YMMYandexMetrica.reportEvent("close", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func sendTapByAddTracker(screen: String, item: String) {
        let params : [AnyHashable : Any] = ["screen": "\(screen)", "item": "\(item)"]
        YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func sendTapByTrack(screen: String, item: String) {
        let params : [AnyHashable : Any] = ["screen": "\(screen)", "item": "\(item)"]
        YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func sendTapByFilter(screen: String, item: String) {
        let params : [AnyHashable : Any] = ["screen": "\(screen)", "item": "\(item)"]
        YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func sendTapByEditTracker(screen: String, item: String) {
        let params : [AnyHashable : Any] = ["screen": "\(screen)", "item": "\(item)"]
        YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func sendTapByDeleteTracker(screen: String, item: String) {
        let params : [AnyHashable : Any] = ["screen": "\(screen)", "item": "\(item)"]
        YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
