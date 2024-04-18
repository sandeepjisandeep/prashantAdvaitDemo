//
//  PhotoModel.swift
//  PrashantAdvaitDemoUnSplash
//
//  Created by Sandeep Srivastava on 18/04/24.
//

import Foundation

struct Photo: Identifiable, Equatable {
    let id = UUID()
    let imageUrl: String
}
