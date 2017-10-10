//
//  TypedComponent.swift
//  components-swift
//
//  Created by Oliver Rickard on 10/9/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import Foundation

protocol TypedComponent: InternalTypedComponent {
  associatedtype PropType;
  associatedtype StateType = Void?;
  
  func props() -> PropType;
  func state() -> StateType?;
  
  func initialState() -> StateType?;
  
  func updateState(state: StateType?);
  
  init(_ props: PropType, key: AnyHashable?);
}

var kPropsKey: Void?;

extension TypedComponent {
  public init(_ props: PropType, key: AnyHashable? = nil) {
    self.init();
    setAssociatedObject(object: self,
                        value: props,
                        associativeKey: &kPropsKey);
  }
  
  func props() -> PropType {
    return objc_getAssociatedObject(self, &kPropsKey) as! PropType;
  }
  
  func state() -> StateType? {
    if let handle = getScopeHandle(component: self) {
      return handle.state as! StateType?;
    }
    assert(false, "Updating state before handle set on component. This state update will no-op");
    return nil;
  }

  func initialState() -> StateType? {
    return nil;
  }
  
  internal func initialUntypedState() -> Any? {
    return initialState();
  }
  
  func updateState(state: StateType?) {
    if let handle = getScopeHandle(component: self) {
      handle.stateUpdater(handle.identifier, state);
    } else {
      assert(false, "Updating state before handle set on component. This state update will no-op");
    }
  }
}

/* Used by infrastructure to allow polymorphism on prop/state types. */
protocol InternalTypedComponent: Component {}

extension InternalTypedComponent {
  internal func initialUntypedState() -> Any? {
    return nil;
  }
}
