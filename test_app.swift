import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let menu = NSApp.mainMenu {
            print("Main menu items:")
            for item in menu.items {
                print("\(item.title) - isEnabled: \(item.isEnabled)")
                if let submenu = item.submenu {
                    for subitem in submenu.items {
                        print("  \(subitem.title) - isEnabled: \(subitem.isEnabled)")
                    }
                }
            }
        } else {
            print("No main menu")
        }
        NSApp.terminate(nil)
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.regular)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
