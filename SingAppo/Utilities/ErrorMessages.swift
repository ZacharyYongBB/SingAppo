//
//  ErrorMessages.swift
//  SingAppo
//
//  Created by Zachary on 28/5/24.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidURL = "The URL is Invalid"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from server. Please try again"
    case invalidData = "The data received from the server was invalid. Please try again"
    case missingApiKey = "Missing API Key."
    case noEmailFound = "User email cant be retrieved"
    case invalidUser = "The user is not Authenticated"
}
