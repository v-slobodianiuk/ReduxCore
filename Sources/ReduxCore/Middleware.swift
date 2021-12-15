//
//  Middleware.swift
//  
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation
import Combine

public typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>
