//
//  HUDHelper.swift
//  picpayment
//
//  Created by Caio Alcântara on 28/02/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import Foundation
import KRProgressHUD

class HUDHelper {
    class func showLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        KRProgressHUD.show()
    }
    
    class func hideLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        KRProgressHUD.dismiss()
    }
    
    class func hideLoadingWithSuccess() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        KRProgressHUD.showSuccess()
    }
    
    class func hideLoadingWithError() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        KRProgressHUD.showError()
    }
}
