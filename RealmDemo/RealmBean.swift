//
//  RealmBean.swift
//  RealmDemo
//
//  Created by angcyo on 16/08/20.
//  Copyright © 2016年 angcyo. All rights reserved.
//

import Foundation
import RealmSwift

class RealmBean: Object {

// Specify properties to ignore (Realm won't persist these)

//  override static func ignoredProperties() -> [String] {
//    return []
//  }

	dynamic var string: String? = nil // 注意dynamic关键字
	var int = RealmOptional<Int>()
	var bool = RealmOptional<Bool>()
	var double = RealmOptional<Double>()

	func testFunc() -> Bool {
		return NSThread.isMainThread()
	}

	override var description: String {
		return "\(string, int.value!, bool.value!, double.value!)"
	}
}
