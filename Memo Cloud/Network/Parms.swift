//
//  Parms.swift
//  JJSystems
//
//  Created by Rizwan Shah on 22/10/2024.
//

import Foundation

struct LoginParms {
    static let username     = "username"
    static let password     = "password"
    static let isApp        = "is_app"
    static let deviceId        = "device_id"
}

struct VerificationParms {
    static let otp          = "otp"
    static let userId       = "user_id"
    static let username     = "username"
    static let isApp        = "is_app"
}

struct ForgotParms {
    static let username     = "username"
}
struct ForgotPasswordParms {
    static let username     = "username"
    static let password     = "password"
    static let otp          = "otp"
}

struct UpdatePasswordParms {
    static let old     = "old_password"
    static let new     = "new_password"
    static let confirm = "new_password_confirmation"
}

struct VehicleParms {
    static let countryId            = "country_id"
    static let yardId               = "yard_id"
    static let page                 = "page"
    static let perPage              = "per_page"
    static let makerId              = "maker_id"
    static let modelId              = "model_id"
    static let chassisCodeId        = "chassis_code_id"
    static let bodyTypeId           = "body_type_id"
    static let fromYear             = "from_year"
    static let toYear               = "to_year"
    static let engine               = "engine"
    static let year                 = "year"
    static let month                = "month"
    static let purchaseFromDate     = "purchase_from_date"
    static let purchaseToDate       = "purchase_to_date"
    static let steeringId           = "steering_id"
    static let chassisNo            = "chassis_no"
    static let transmissionId       = "transmission_id"
    static let fuelId               = "fuel_id"
    static let stockNo              = "stock_no"
    static let pdDays               = "pd_days"
    static let etaCrossed           = "eta_crossed"
    static let dutyPaid             = "duty_paid"
    static let noInspection         = "no_inspection"
    static let searchKeyword        = "search_keyword"
    static let isReserved           = "is_reserved"
    static let auctionCompanyId     = "auction_company_id"
    static let auctionDate          = "auction_date"
    static let lotNo                = "lot_no"
    static let loader               = "loader"
    static let chassisNumber        = "chassis_number"
    static let makerName            = "maker"
    static let purchaseDate         = "purchase_date"
    static let carIds               = "carIds"
    static let carId                = "car_id"
    static let type                 = "type"
    static let profitAndLoss        = "profit_loss"

    
}

struct TTReportParms {
    
    static let appUserId            = "app_user_id"
    static let ttDateTo             = "tt_date_to"
    static let ttDateFrom           = "tt_date_from"
    static let selId                = "sel_id"
    static let createDateFrom       = "created_at_date_from"
    static let createDateTo         = "created_at_date_to"
    
    
}

struct DefaultCountryParms {
    static let countryId     = "country_id"
}

struct Observer {
    
    static let results          = "results"
    static let fourceLogout     = "fourceLogout"
    static let downloadProgress     = "downloadProgress"
}
