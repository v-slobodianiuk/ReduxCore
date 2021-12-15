//
//  Reducer.swift
//  
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

public typealias Reducer<State, Action> = (inout State, Action) -> Void
