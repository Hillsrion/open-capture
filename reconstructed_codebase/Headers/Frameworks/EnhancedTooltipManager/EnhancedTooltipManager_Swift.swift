 protocol EnhancedTooltipManager.EnhancedTooltipTimeProtocol // 1 requirements
 protocol EnhancedTooltipManager.EnhancedTooltipTimerDelayProviderProtocol // 3 requirements

 struct __C.CGRect {

	// Properties
	var origin : CGPoint
	var size : CGSize
 }

 struct __C.CGSize {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var width : Ý
WARNING: couldn't find address 0x0 (0x0) in binary!
	var height : Ý
 }

 struct __C.CGPoint {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var x : Ý
WARNING: couldn't find address 0x0 (0x0) in binary!
	var y : Ý
 }

 class EnhancedTooltipManager.EnhancedTooltipDataRepositoryCompat : NSObject /usr/lib/libobjc.A.dylib {
	// ObjC -> Swift bridged methods
WARNING: couldn't find address 0xb00000076d0 (0x300000076d0) in binary!
	0x98000000c  @objc EnhancedTooltipDataRepositoryCompat.(null) <stripped>
 }

 class EnhancedTooltipManager.EnhancedTooltipTriggerFactory : NSObject /usr/lib/libobjc.A.dylib {
	// ObjC -> Swift bridged methods
WARNING: couldn't find address 0xbb000007780 (0x3b000007780) in binary!
	0xc8000000c  @objc EnhancedTooltipTriggerFactory.(null) <stripped>
 }

 class EnhancedTooltipManager.EnhancedTooltipsManager : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var tooltips :  first-element-marker 
WARNING: couldn't find address 0x0 (0x0) in binary!
	let tooltipDataRepository : ‡
	let keyboardShortcutMapper : EnhancedTooltipKeyboardShortcutMapperProtocol
	let timerDelayProvider : EnhancedTooltipTimerDelayProviderProtocol
WARNING: couldn't find address 0x0 (0x0) in binary!
	let timingFactory : 
WARNING: couldn't find address 0x0 (0x0) in binary!
	let analyticsReporter : 
WARNING: couldn't find address 0x0 (0x0) in binary!
	let helpUrlBuilder : û

WARNING: couldn't find address 0x0 (0x0) in binary!
	let localization : ë


	// Swift methods
	0x2e0c  class func EnhancedTooltipsManager.__allocating_init(tooltipDataRepository:keyboardShortcutMapper:timerDelayProvider:timingFactory:helpUrlBuilder:localization:analyticsReporter:) // init 
	0x2f60  func EnhancedTooltipsManager.tooltipFlow(for:mouseLocation:showImmediately:) // method 
	0x3604  func <stripped> // method 
	0x3894  func EnhancedTooltipsManager.hideAllTooltips() // method 
	0x3a3c  func EnhancedTooltipsManager.enhancedTooltipRouter(willClose:wasVisible:) // method 
	0x3a84  func EnhancedTooltipsManager.enhancedTooltipRouter(didClose:wasVisible:) // method 
 }

 class EnhancedTooltipManager.EnhancedTooltipEventHandler : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var tooltipsManager : EnhancedTooltipsManager

	// Swift methods
	0x5028  class func EnhancedTooltipEventHandler.__allocating_init(tooltipsManager:) // init 
	0x50b4  func EnhancedTooltipEventHandler.handle(event:) // method 
	0x568c  func EnhancedTooltipEventHandler.resignKey() // method 
 }

 class EnhancedTooltipManager.EnhancedTooltipSegmentedControlTrigger : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let view : NSSegmentedControl
	var action : String?
	var tooltipId : String?
	var bounds : CGRect
	var preferVerticalPlacement : Bool

	// ObjC -> Swift bridged methods
WARNING: couldn't find offset 0x930 in binary!
WARNING: couldn't find offset 0x930 in binary!
WARNING: couldn't find address 0x93c00007738 (0x13c00007738) in binary!
	0x0  @objc EnhancedTooltipSegmentedControlTrigger.(null) <stripped>
WARNING: couldn't find offset 0x89a in binary!
WARNING: couldn't find offset 0x89a in binary!
WARNING: couldn't find address 0xad000007778 (0x2d000007778) in binary!
	0x0  @objc EnhancedTooltipSegmentedControlTrigger.(null) <stripped>
WARNING: couldn't find offset 0xce0 in binary!
WARNING: couldn't find offset 0xce0 in binary!
WARNING: couldn't find address 0x90c00007600 (0x10c00007600) in binary!
	0x0  @objc EnhancedTooltipSegmentedControlTrigger.(null) <stripped>
WARNING: couldn't find offset 0xcfa in binary!
WARNING: couldn't find offset 0xcfa in binary!
WARNING: couldn't find address 0xcfe000076d8 (0x4fe000076d8) in binary!
	0x0  @objc EnhancedTooltipSegmentedControlTrigger.(null) <stripped>
WARNING: couldn't find address 0xa8800007698 (0x28800007698) in binary!
	0x25029232840  @objc EnhancedTooltipSegmentedControlTrigger.(null) <stripped>
WARNING: couldn't find address 0x61686e453a4d4152 (0x6453a4d4152) in binary!
	0x6614d706974  @objc EnhancedTooltipSegmentedControlTrigger.(null) <stripped>
WARNING: couldn't find address 0x4a4f525020207265 (0x25020207265) in binary!
	0x7546465636e  @objc EnhancedTooltipSegmentedControlTrigger.(null) <stripped>
WARNING: couldn't find address 0xa312d73706974 (0x12d73706974) in binary!
	0x0  @objc EnhancedTooltipSegmentedControlTrigger.(null) <stripped>
WARNING: couldn't find address 0x1 (0x1) in binary!
	0x36e61686e45  @objc EnhancedTooltipSegmentedControlTrigger.(null) <stripped>

	// Swift methods
	0x5984  func <stripped> // getter 
 }

 class EnhancedTooltipManager.EnhancedTooltipCustomViewTrigger : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let view : NSView
	var tooltipId : String?
	var keyboardShortcutCommand : String?
	var bounds : CGRect
	var screenRect : CGRect
	var windowRect : CGRect
	var preferVerticalPlacement : Bool

	// ObjC -> Swift bridged methods
WARNING: couldn't find offset 0x962 in binary!
WARNING: couldn't find offset 0x962 in binary!
WARNING: couldn't find address 0xb9800007840 (0x39800007840) in binary!
	0x0  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>
WARNING: couldn't find offset 0x94a in binary!
WARNING: couldn't find offset 0x94a in binary!
WARNING: couldn't find address 0xb8000007790 (0x38000007790) in binary!
	0x0  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>
WARNING: couldn't find offset 0xd90 in binary!
WARNING: couldn't find offset 0xd90 in binary!
WARNING: couldn't find address 0x9bc000076b0 (0x1bc000076b0) in binary!
	0x0  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>
WARNING: couldn't find offset 0xd78 in binary!
WARNING: couldn't find offset 0xd78 in binary!
WARNING: couldn't find address 0x9a4000077a0 (0x1a4000077a0) in binary!
	0x0  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>
WARNING: couldn't find offset 0xd60 in binary!
WARNING: couldn't find offset 0xd60 in binary!
WARNING: couldn't find address 0x98c00007808 (0x18c00007808) in binary!
	0x0  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>
WARNING: couldn't find offset 0xd7a in binary!
WARNING: couldn't find offset 0xd7a in binary!
WARNING: couldn't find address 0xd7e00007758 (0x57e00007758) in binary!
	0x0  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>
WARNING: couldn't find address 0x18000000c (0x18000000c) in binary!
	0xffff8c44  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>
WARNING: couldn't find address 0x98000000c (0x98000000c) in binary!
	0x7acffffbe30  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>
WARNING: couldn't find offset 0x930 in binary!
WARNING: couldn't find offset 0x930 in binary!
WARNING: couldn't find address 0xffffbf5c00000930 (0x0) in binary!
	0x744ffffbff4  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>
WARNING: couldn't find offset 0x89a in binary!
WARNING: couldn't find offset 0x89a in binary!
WARNING: couldn't find address 0xffffc0380000089a (0x0) in binary!
	0x70cffffc06c  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>
WARNING: couldn't find offset 0xce0 in binary!
WARNING: couldn't find offset 0xce0 in binary!
WARNING: couldn't find address 0xffffc06c00000ce0 (0x0) in binary!
	0x704ffffc074  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>
WARNING: couldn't find offset 0xcfa in binary!
WARNING: couldn't find offset 0xcfa in binary!
WARNING: couldn't find address 0xffffc07000000cfa (0x0) in binary!
	0xffffc374  @objc EnhancedTooltipCustomViewTrigger.(null) <stripped>

	// Swift methods
	0x5f98  func EnhancedTooltipCustomViewTrigger.tooltipId.getter // getter 
	0x6164  func EnhancedTooltipCustomViewTrigger.keyboardShortcutCommand.getter // getter 
	0x62fc  func EnhancedTooltipCustomViewTrigger.bounds.getter // getter 
	0x63d8  func EnhancedTooltipCustomViewTrigger.screenRect.getter // getter 
	0x64b4  func EnhancedTooltipCustomViewTrigger.windowRect.getter // getter 
	0x658c  func EnhancedTooltipCustomViewTrigger.preferVerticalPlacement.getter // getter 
 }

 enum EnhancedTooltipManager.Constants { }

 class EnhancedTooltipManager.EnhancedTooltipTime : _SwiftObject /usr/lib/swift/libswiftCore.dylib, EnhancedTooltipTimeProtocol {
	// Swift methods
	0x7330  class func EnhancedTooltipTime.__allocating_init() // init 
	0x7348  func EnhancedTooltipTime.currentTime.getter // getter 
 }

 class EnhancedTooltipManager.EnhancedTooltipTimerDelayProvider : _SwiftObject /usr/lib/swift/libswiftCore.dylib, EnhancedTooltipTimerDelayProviderProtocol {

	// Properties
	var lastTooltipCloseTime : Double?
	let time : EnhancedTooltipTimeProtocol

	// Swift methods
	0x7368  class func EnhancedTooltipTimerDelayProvider.__allocating_init(time:) // init 
	0x73f4  func EnhancedTooltipTimerDelayProvider.delayToDisplayTooltip() // method 
	0x746c  func EnhancedTooltipTimerDelayProvider.delayToHideTooltip() // method 
	0x7474  func EnhancedTooltipTimerDelayProvider.tooltipClosed() // method 
 }

 enum EnhancedTooltipManager.Constants { }

 class EnhancedTooltipManager.PresenterTimingFactory : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let timerDelayProvider : EnhancedTooltipTimerDelayProviderProtocol

	// Swift methods
	0x75d8  class func PresenterTimingFactory.__allocating_init(timerDelayProvider:) // init 
	0x7634  func PresenterTimingFactory.createTiming() // method 
 }

 class EnhancedTooltipManager.NonRepeatingTimerFactory : _SwiftObject /usr/lib/swift/libswiftCore.dylib {
	// Swift methods
	0x77bc  func NonRepeatingTimerFactory.createTimer() // method 
 }

 class EnhancedTooltipManager.NonRepeatingTimer : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var timer : NSTimer?
	var interval : Double?
	var block : ()?

	// Swift methods
	0x77f4  class func NonRepeatingTimer.__allocating_init() // init 
	0x7874  func NonRepeatingTimer.schedule(timerInterval:block:) // method 
	0x78bc  func NonRepeatingTimer.restart() // method 
	0x7aa4  func NonRepeatingTimer.cancel() // method 
	0x7acc  func NonRepeatingTimer.isActive.getter // getter 
 }

 class EnhancedTooltipManager.PresenterTiming : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let timingsProvider : EnhancedTooltipTimerDelayProviderProtocol
WARNING: couldn't find address 0x0 (0x0) in binary!
	let showTimer : …	
WARNING: couldn't find address 0x0 (0x0) in binary!
	let hideTimer : …	

	// Swift methods
	0x76cc  class func PresenterTiming.__allocating_init(timingsProvider:) // init 
	0x7d44  class func PresenterTiming.__allocating_init(timingsProvider:timerFactory:) // init 
	0x7efc  func PresenterTiming.schedule(onTimer:block:) // method 
	0x7ff8  func PresenterTiming.restart(timer:) // method 
	0x8064  func PresenterTiming.cancel(timer:) // method 
	0x80d0  func PresenterTiming.isActive(timer:) // method 
 }


