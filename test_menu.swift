import Cocoa

class Target: NSObject {
    @objc func doThing(_ sender: Any?) { print("Thing done") }
}

let target = Target()
let menu = NSMenu()
let item = NSMenuItem(title: "Test", action: #selector(Target.doThing(_:)), keyEquivalent: "")
item.target = target
menu.addItem(item)

print(item.isEnabled)
