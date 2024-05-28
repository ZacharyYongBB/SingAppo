//
//  ErrorMessages.swift
//  SingAppo
//
//  Created by Zachary on 28/5/24.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from server. Please try again"
    case invalidData = "The data received from the server was invalid. Please try again"
    case unableToFavourite = "There was an error while favouriting this user. Try again."
    case alreadyInFavourites = "You've already added this user to favourites."
}
