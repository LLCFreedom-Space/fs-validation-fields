//
//  Validator+Extensions.swift
//  
//
//  Created by Mykola Buhaiov on 15.09.2023.
//  Copyright © 2023 Freedom Space LLC
//  All rights reserved: http://opensource.org/licenses/MIT
//

import Vapor

extension Validator where T == String {
    /// RegEx for phone numbers
    /// https://en.wikipedia.org/wiki/Telephone_numbering_plan
    static let phoneNumberRegex: String = "^(\\s*)?(\\+)?([-()+]?\\d[- _():=+]?){5,15}(\\s*)?$"
    static let serviceNameRegex: String = "^[a-z-]{1,100}$"
    static let phoneNumberCodeRegex: String = "^\\d{6}$"
    static let nameRegex: String = "^(([a-zA-Z'` -]{1,100})|([а-яА-ЯЁёІіЇїҐґЄє'` -]{1,100}))$"
    static let postalCodeRegex: String = "(^\\d{5}(-\\d{4})?$)|(^[ABCEGHJKLMNPRSTVXY]\\d[A-Z][- ]*\\d[A-Z]\\d$)"
    static let isoCountryCodeRegex = "^[A-Z]{2}$"
    static let passwordRegex: String = "^.{8,}$"
    static let companyNameRegex: String = "^.{6,255}$"
    static let tinRegex: String = "^\\d{10}$"

    public static var ukraineCompanyEdrpou: Validator<T> {
        .init { ukraineEdrpou in
            guard ukraineEdrpou.count == 8 else {
                return ValidatorResults.UkraineCompanyEdrpou(isValidUkraineCompanyEdrpou: false)
            }
            guard let edrpou = Int(ukraineEdrpou) else {
                return ValidatorResults.UkraineCompanyEdrpou(isValidUkraineCompanyEdrpou: false)
            }
            let registerNumberArray = ukraineEdrpou.compactMap { Int(String($0)) }
            let result = registerNumberArray[7]
            var resultMatch: Int
            if edrpou < 30000000 || edrpou > 60000000 {
                resultMatch = (
                    registerNumberArray[0] * 1 +
                    registerNumberArray[1] * 2 +
                    registerNumberArray[2] * 3 +
                    registerNumberArray[3] * 4 +
                    registerNumberArray[4] * 5 +
                    registerNumberArray[5] * 6 +
                    registerNumberArray[6] * 7) % 11

                if resultMatch == 10 {
                    resultMatch = (
                        registerNumberArray[0] * 3 +
                        registerNumberArray[1] * 4 +
                        registerNumberArray[2] * 5 +
                        registerNumberArray[3] * 6 +
                        registerNumberArray[4] * 7 +
                        registerNumberArray[5] * 8 +
                        registerNumberArray[6] * 9) % 11
                }
            } else {
                resultMatch = (
                    registerNumberArray[0] * 7 +
                    registerNumberArray[1] * 1 +
                    registerNumberArray[2] * 2 +
                    registerNumberArray[3] * 3 +
                    registerNumberArray[4] * 4 +
                    registerNumberArray[5] * 5 +
                    registerNumberArray[6] * 6) % 11
                if resultMatch == 10 {
                    resultMatch = (
                        registerNumberArray[0] * 9 +
                        registerNumberArray[1] * 3 +
                        registerNumberArray[2] * 4 +
                        registerNumberArray[3] * 5 +
                        registerNumberArray[4] * 6 +
                        registerNumberArray[5] * 7 +
                        registerNumberArray[6] * 8) % 11
                }
            }
            let isValid = resultMatch == result
            return ValidatorResults.UkraineCompanyEdrpou(isValidUkraineCompanyEdrpou: isValid)
        }
    }

    /// Check if date is before current date
    public static var birthday: Validator<T> {
        .init { birthday in
            let fullString = birthday + "T00:00:00.000"
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            guard let date = formatter.date(from: fullString) else {
                return ValidatorResults.Date(isValidDate: false)
            }
            let birthdayDate = date.timeIntervalSince1970
            let dateNow = Date().timeIntervalSince1970

            return ValidatorResults.Birthday(isValidBirthday: dateNow > birthdayDate)
        }
    }

    ///
    public static var serviceName: Validator<T> {
        .init {
            guard
                let range = $0.range(of: serviceNameRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                return ValidatorResults.ServiceName(isValidServiceName: false)
            }
            return ValidatorResults.ServiceName(isValidServiceName: true)
        }
    }

    ///
    public static var phoneNumber: Validator<T> {
        .init {
            guard
                let range = $0.range(of: phoneNumberRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                return ValidatorResults.PhoneNumber(isValidPhoneNumber: false)
            }
            return ValidatorResults.PhoneNumber(isValidPhoneNumber: true)
        }
    }

    ///
    public static var phoneNumberCode: Validator<T> {
        .init {
            guard
                let range = $0.range(of: phoneNumberCodeRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                return ValidatorResults.PhoneNumberCode(isValidPhoneNumberCode: false)
            }
            return ValidatorResults.PhoneNumberCode(isValidPhoneNumberCode: true)
        }
    }

    ///
    public static var name: Validator<T> {
        .init {
            guard
                let range = $0.range(of: nameRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                return ValidatorResults.Name(isValidName: false)
            }
            return ValidatorResults.Name(isValidName: true)
        }
    }

    ///
    public static var postalCode: Validator<T> {
        .init {
            guard
                let range = $0.range(of: postalCodeRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                return ValidatorResults.PostalCode(isValidPostalCode: false)
            }
            return ValidatorResults.PostalCode(isValidPostalCode: true)
        }
    }

    ///
    public static var isoCountryCode: Validator<T> {
        .init {
            guard let range = $0.range(of: isoCountryCodeRegex, options: [.regularExpression]),
                  range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                return ValidatorResults.IsoCountryCode(isValidIsoCountryCode: false)
            }
            return ValidatorResults.IsoCountryCode(isValidIsoCountryCode: true)
        }
    }

    ///
    public static var password: Validator<T> {
        .init {
            guard
                let range = $0.range(of: passwordRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                return ValidatorResults.Password(isValidPassword: false)
            }
            return ValidatorResults.Password(isValidPassword: true)
        }
    }

    public static var companyName: Validator<T> {
        .init {
            guard
                let range = $0.range(of: companyNameRegex, options: [.regularExpression]),
                range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
            else {
                return ValidatorResults.CompanyName(isValidCompanyName: false)
            }
            return ValidatorResults.CompanyName(isValidCompanyName: true)
        }
    }

    public static var ukraineTin: Validator<T> {
        .init { ukraineTin in
            guard ukraineTin.count == 10 else {
                return ValidatorResults.UkraineTin(isValidUkraineTin: false)
            }
            guard Int(ukraineTin) != nil else {
                return ValidatorResults.UkraineTin(isValidUkraineTin: false)
            }
            let tinArray = ukraineTin.compactMap { Int(String($0)) }

            let isValid = tinArray[9] == ((
                -1 * tinArray[0] +
                 5 * tinArray[1] +
                 7 * tinArray[2] +
                 9 * tinArray[3] +
                 4 * tinArray[4] +
                 6 * tinArray[5] +
                 10 * tinArray[6] +
                 5 * tinArray[7] +
                 7 * tinArray[8]) % 11
            )
            return ValidatorResults.UkraineCompanyEdrpou(isValidUkraineCompanyEdrpou: isValid)
        }
    }
}

extension Validator where T == [String] {
    ///
    public static var arrayUrls: Validator<T> {
        .init {
            guard !$0.isEmpty else {
                return ValidatorResults.ArrayUrls(isValid: false)
            }
            for item in $0 {
                guard URL(string: item) != nil else {
                    return ValidatorResults.ArrayUrls(isValid: false)
                }
            }
            return ValidatorResults.ArrayUrls(isValid: true)
        }
    }
}

extension ValidatorResults {
    ///
    public struct PhoneNumber {
        ///
        public let isValidPhoneNumber: Bool
    }

    ///
    public struct PhoneNumberCode {
        ///
        public let isValidPhoneNumberCode: Bool
    }

    ///
    public struct Name {
        ///
        public let isValidName: Bool
    }

    ///
    public struct PostalCode {
        ///
        public let isValidPostalCode: Bool
    }

    ///
    public struct Birthday {
        ///
        public let isValidBirthday: Bool
    }

    ///
    public struct Date {
        ///
        public let isValidDate: Bool
    }

    ///
    public struct IsoCountryCode {
        ///
        public let isValidIsoCountryCode: Bool
    }

    ///
    public struct Password {
        ///
        public let isValidPassword: Bool
    }

    public struct CompanyName {
        public let isValidCompanyName: Bool
    }

    public struct UkraineTin {
        public let isValidUkraineTin: Bool
    }

    public struct UkraineCompanyEdrpou {
        public let isValidUkraineCompanyEdrpou: Bool
    }
    ///
    public struct ServiceName {
        ///
        public let isValidServiceName: Bool
    }

    ///
    public struct Url {
        ///
        public let isValidUrl: Bool
    }
    ///
    public struct ArrayUrls {
        ///
        public let isValid: Bool
    }
}

extension ValidatorResults.PhoneNumber: ValidatorResult {
    public var isFailure: Bool {
        !isValidPhoneNumber
    }

    public var successDescription: String? {
        "is a valid phone number"
    }

    public var failureDescription: String? {
        "is not a valid phone number"
    }
}

extension ValidatorResults.PhoneNumberCode: ValidatorResult {
    public var isFailure: Bool {
        !isValidPhoneNumberCode
    }

    public var successDescription: String? {
        "is a valid phone code"
    }

    public var failureDescription: String? {
        "is not a valid phone code"
    }
}

extension ValidatorResults.Name: ValidatorResult {
    public var isFailure: Bool {
        !isValidName
    }

    public var successDescription: String? {
        "is a valid name"
    }

    public var failureDescription: String? {
        "is not a valid name"
    }
}

extension ValidatorResults.PostalCode: ValidatorResult {
    public var isFailure: Bool {
        !isValidPostalCode
    }

    public var successDescription: String? {
        "is a valid postal code"
    }

    public var failureDescription: String? {
        "is not a valid postal code"
    }
}

extension ValidatorResults.Birthday: ValidatorResult {
    public var isFailure: Bool {
        !isValidBirthday
    }

    public var successDescription: String? {
        "Birthday is valid"
    }

    public var failureDescription: String? {
        "Birthday is invalid"
    }
}

extension ValidatorResults.Date: ValidatorResult {
    public var isFailure: Bool {
        !isValidDate
    }

    public var successDescription: String? {
        "Date conversion success"
    }

    public var failureDescription: String? {
        "Date conversion error"
    }
}

extension ValidatorResults.IsoCountryCode: ValidatorResult {
    public var isFailure: Bool {
        !isValidIsoCountryCode
    }

    public var successDescription: String? {
        "ISO country code is valid"
    }

    public var failureDescription: String? {
        "ISO country code is invalid"
    }
}

extension ValidatorResults.Password: ValidatorResult {
    public var isFailure: Bool {
        !isValidPassword
    }

    public var successDescription: String? {
        "is a valid password"
    }

    public var failureDescription: String? {
        "is not a valid password"
    }
}

extension ValidatorResults.CompanyName: ValidatorResult {
    public var isFailure: Bool {
        !self.isValidCompanyName
    }

    public var successDescription: String? {
        "is a valid company name"
    }

    public var failureDescription: String? {
        "is not a valid company name"
    }
}

extension ValidatorResults.UkraineTin: ValidatorResult {
    public var isFailure: Bool {
        !self.isValidUkraineTin
    }

    public var successDescription: String? {
        "is a valid UkraineTin Tin"
    }

    public var failureDescription: String? {
        "is not a valid UkraineTin Tin"
    }
}

extension ValidatorResults.UkraineCompanyEdrpou: ValidatorResult {
    public var isFailure: Bool {
        !self.isValidUkraineCompanyEdrpou
    }

    public var successDescription: String? {
        "is a valid Ukraine Company Edrpou"
    }

    public var failureDescription: String? {
        "is not a valid Ukraine Company Edrpou"
    }
}

extension ValidatorResults.ServiceName: ValidatorResult {
    public var isFailure: Bool {
        !isValidServiceName
    }

    public var successDescription: String? {
        "is a valid service name"
    }

    public var failureDescription: String? {
        "is not a valid service name"
    }
}

extension ValidatorResults.Url: ValidatorResult {
    public var isFailure: Bool {
        !isValidUrl
    }

    public var successDescription: String? {
        "is a valid url"
    }

    public var failureDescription: String? {
        "is not a valid url"
    }
}

extension ValidatorResults.ArrayUrls: ValidatorResult {
    public var isFailure: Bool {
        !isValid
    }

    public var successDescription: String? {
        "has valid an URL"
    }

    public var failureDescription: String? {
        "has not valid an URL"
    }
}
