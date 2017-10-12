//
//  ViewAttribute.swift
//  Theodolite
//
//  Created by Oliver Rickard on 10/11/17.
//  Copyright © 2017 Oliver Rickard. All rights reserved.
//

import UIKit

class Attr<ViewType: UIView, ValueType: Hashable>: Attribute {
  convenience init(value: ValueType,
                   applicator: @escaping (ViewType) -> (ValueType) -> ()) {
    self.init();
    self.identifier = "\(applicator)";
    self.value = value;
    self.applicator = { (view: UIView) in
      return {(obj: Any?) in
        applicator(view as! ViewType)(obj as! ValueType);
      }
    }
  }
  
  convenience init(value: ValueType,
                   applicator: @escaping (ViewType, ValueType) -> ()) {
    self.init();
    self.identifier = "\(applicator)";
    self.value = value;
    self.applicator = { (view: UIView) in
      return {(obj: Any?) in
        applicator(view as! ViewType, obj as! ValueType);
      }
    }
  }
}

class Attribute: Equatable, Hashable {
  internal var identifier: String;
  internal var value: AnyHashable?;
  internal var applicator: ((UIView) -> (Any) -> ())?;
  
  public var hashValue: Int {
    return self.identifier.hashValue;
  }
  
  init() {
    self.identifier = "";
    self.value = nil;
    self.applicator = nil;
  }
  
  func apply(view: UIView) {
    if let applicator = self.applicator,
      let value = self.value {
      applicator(view)(value);
    }
  }
}

func ==(lhs: Attribute, rhs: Attribute) -> Bool {
  return lhs.identifier == rhs.identifier
    && lhs.value == rhs.value;
}
