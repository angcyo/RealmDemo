//
//  ViewController.swift
//  RealmDemo
//
//  Created by angcyo on 16/08/20.
//  Copyright © 2016年 angcyo. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

	// MARK: 声明一个Realm对象
	let realm = try! Realm()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func onCreate() {
		initTime()
		create()
		showTime()
		// 用时:0.257408142089844
	}
	@IBAction func onModify() {
		initTime()
		modify()
		showTime()

		// 用时:0.360152959823608
	}
	@IBAction func onQuery() {
		initTime()
		query()
		showTime()
		// 用时:0.000139951705932617
	}
	@IBAction func onDelete() {
		initTime()
		delete()
		showTime()
		// 用时:0.00264286994934082
	}

}

extension ViewController {

	static var startTime: Double!

	func create() {
		// 1:
//		realm.beginWrite()
//		for i in 0..<1000 {
//			let bean = RealmBean()
//			bean.bool.value = i.boolValue
//			bean.double.value = Double(i)
//			bean.int.value = i
//			bean.string = String(i)
//
//			realm.add(bean)
//
//			print("添加:\(i+1) -> \(bean) isMain:\(bean.testFunc())")
//		}
//		try! realm.commitWrite()

		// 2:
		try! realm.write {
			for i in 0..<1000 {
				let bean = RealmBean()
				bean.bool.value = i.boolValue
				bean.double.value = Double(i)
				bean.int.value = i
				bean.string = String(i)

				realm.add(bean)

				print("添加:\(i+1) -> \(bean) isMain:\(bean.testFunc())")
			}
		}
	}

	func modify() {
		try! realm.write {
			for (index, bean) in realm.objects(RealmBean).enumerate() {
				bean.bool.value = !(bean.bool.value!)
				bean.double.value = bean.double.value! + Double(1)
				bean.int.value = bean.int.value! + 1
				if let string = bean.string {
					bean.string = string + "new ---- " + String(index)
				}

				print("修改:\(index+1) -> \(bean) isMain:\(bean.testFunc())")
			}
		}
	}

	func query() {
		let restuls = realm.objects(RealmBean)
		print("查询到:\(restuls.count)条")
	}

	func delete() {
		// 1:
//		try! realm.write {
//			realm.deleteAll()
//		}

		// 2:
		try! realm.write {
			realm.delete(realm.objects(RealmBean))
		}
	}

	func initTime() {
		ViewController.startTime = NSDate().timeIntervalSince1970
	}

	func showTime() {
		print("用时:\(NSDate().timeIntervalSince1970-ViewController.startTime) isMain:\(NSThread.isMainThread())")
	}

	class func cleanRealm() {
		let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
		let realmURLs = [
			realmURL,
			realmURL.URLByAppendingPathExtension("lock"),
			realmURL.URLByAppendingPathExtension("log_a"),
			realmURL.URLByAppendingPathExtension("log_b"),
			realmURL.URLByAppendingPathExtension("note")
		]
		let manager = NSFileManager.defaultManager()
		for URL in realmURLs {
			do {
				try manager.removeItemAtURL(URL)
			} catch {
				// 处理错误
				print("删除出错...")
			}
		}
	}
}

extension Int: BooleanType {
	public var boolValue: Bool {
		return self % 2 == 0
	}
}
