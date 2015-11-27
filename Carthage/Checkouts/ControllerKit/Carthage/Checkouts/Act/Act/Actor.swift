//
//  Actor.swift
//  Act
//
//  Created by Robin Goos on 24/10/15.
//  Copyright © 2015 Robin Goos. All rights reserved.
//

import Foundation

public protocol Message {
    var type: String { get }
}

public class Actor<T> {
    public typealias Transformer = (Actor<T>, Message, (Message) -> ()) -> ()
    public typealias Reducer = (T, Message) -> T
    
    public var state: T {
        return _state
    }
    
    private var _state: T
    
    public let transformers: [Transformer]
    public let reducer: Reducer
    
    private let processingQueue: Queueable
    private let mainQueue: Queueable

    public init(initialState: T, transformers: [Transformer], reducer: Reducer, mainQueue: Queueable? = nil, processingQueue: Queueable? = nil) {
        self._state = initialState
        self.transformers = transformers
        self.reducer = reducer
        self.mainQueue = mainQueue ?? dispatch_get_main_queue().queueable()
        self.processingQueue = processingQueue ?? dispatch_queue_create("com.act.actor", DISPATCH_QUEUE_SERIAL).queueable()
    }
    
    public func send(message: Message, completion: ((T) -> ())? = nil) {
        processingQueue.enqueue {
            if self.transformers.count > 0 {
                var gen = self.transformers.generate()
                
                func passOn(message: Message) {
                    if let next = gen.next() {
                        self.processingQueue.enqueue {
                            next(self, message, passOn)
                        }
                    } else {
                        self.processingQueue.enqueue {
                            self._state = self.reducer(self.state, message)
                            if let comp = completion {
                                let state = self.state
                                self.mainQueue.enqueue { comp(state) }
                            }
                        }
                    }
                }
                
                passOn(message)
            } else {
                self._state = self.reducer(self.state, message)
                if let comp = completion {
                    let state = self.state
                    self.mainQueue.enqueue { comp(state) }
                }
            }
        }
    }
}

public class ObservableActor<T: Equatable> : Actor<T> {
    private var observers: [Observer<T>] = []
    
    override private var _state: T {
        didSet {
            if (oldValue != state) {
                notifyChange()
            }
        }
    }
    
    private func notifyChange() {
        let state = self.state
        mainQueue.enqueue {
            for observer in self.observers {
                observer.closure(state)
            }
        }
    }
    
    public func observe(observer: (T) -> ()) -> (() -> ())! {
        let boxed = Observer(closure: observer)
        observers.append(boxed)
        return {
            if let index = self.observers.indexOf(boxed) {
                self.observers.removeAtIndex(index)
            }
        }
    }
    
    public override init(initialState: T, transformers: [Transformer], reducer: Reducer, mainQueue: Queueable? = nil, processingQueue: Queueable? = nil) {
        super.init(initialState: initialState, transformers: transformers, reducer: reducer, mainQueue: mainQueue, processingQueue: processingQueue)
    }
}

private final class Observer<T: Equatable> : Equatable {
    let closure: (T) -> ()
    init(closure: (T) -> ()) {
        self.closure = closure
    }
}

private func ==<T>(lhs: Observer<T>, rhs: Observer<T>) -> Bool {
    return lhs === rhs
}