//
//  Store.swift
//  
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation
import Combine

public final class Store<State, Action>: ObservableObject {
    @Published public private(set) var state: State
    private let reducer: Reducer<State, Action>
    
    private let middlewares: [Middleware<State, Action>]
    private var middlewareCancellables: Set<AnyCancellable> = []
    
    private let serialQueue = DispatchQueue(label: "redux.serial.queue", qos: .userInitiated)
    
    public init(
        initialState: State,
        reducer: @escaping Reducer<State, Action>,
        middlewares: [Middleware<State, Action>] = []
    ) {
        self.state = initialState
        self.reducer = reducer
        self.middlewares = middlewares
    }
    
    public func dispatch(action: Action) {
        serialQueue.sync {
            reducer(&state, action)
            
            middlewares.forEach {
                let middlewarePublisher = $0(state, action)
                
                middlewarePublisher
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: dispatch)
                    .store(in: &middlewareCancellables)
            }
        }
    }
}
