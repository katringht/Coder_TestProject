//
//  Result.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 07.11.2021.
//

import Foundation

enum Result<T>{
    case Success(T)
    case Error(String)
}
