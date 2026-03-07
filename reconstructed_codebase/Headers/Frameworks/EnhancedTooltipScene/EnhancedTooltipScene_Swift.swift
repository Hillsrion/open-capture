 protocol EnhancedTooltipScene.EnhancedTooltipRouterDelegate // 2 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipRouterProtocol // 3 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipHelpUrlBuilderProtocol // 2 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipInteractorProtocol // 8 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipAnalyticsReporterProtocol // 3 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipWindowDelegate // 1 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipWindowControllerProtocol // 13 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipViewDelegate // 1 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipPresenterProtocol // 8 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipPresenterTimingFactoryProtocol // 1 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipTimerFactoryProtocol // 1 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipTimerProtocol // 4 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipPresenterTimingProtocol // 4 requirements
 protocol EnhancedTooltipScene.EnhancedTooltipLocalizationProtocol // 2 requirements

 struct __C.CGRect {

	// Properties
	var origin : CGPoint
	var size : CGSize
 }

 struct __C.EnhancedTooltipPlacementInfo {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var error : ?M
	var x : Double
	var y : Double
	var arrowPosition : EnhancedTooltipEdge
	var arrowOffsetAlongTheEdge : Double
	var query : EnhancedTooltipPlacementQuery
 }

 struct __C.EnhancedTooltipPlacementQuery {

	// Properties
	var windowX : Double
	var windowY : Double
	var windowWidth : Double
	var windowHeight : Double
	var tooltipWidth : Double
	var tooltipHeight : Double
	var triggerX : Double
	var triggerY : Double
	var triggerWidth : Double
	var triggerHeight : Double
	var screenX : Double
	var screenY : Double
	var screenWidth : Double
	var screenHeight : Double
	var headerHeight : Double
	var minArrowCenterOffset : Double
	var preferVerticalPosition : Bool
 }

 struct __C.CGPoint {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var x : £L
WARNING: couldn't find address 0x0 (0x0) in binary!
	var y : £L
 }

 enum __C.EnhancedTooltipEdge { }

 struct __C.Key {

	// Properties
	var _rawValue : NSString
 }

 struct __C.CGSize {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var width : £L
WARNING: couldn't find address 0x0 (0x0) in binary!
	var height : £L
 }

 class EnhancedTooltipScene.EnhancedTooltipRouter : _SwiftObject /usr/lib/swift/libswiftCore.dylib, EnhancedTooltipRouterProtocol {

	// Properties
	let window : EnhancedTooltipWindowController
	let interactor : EnhancedTooltipInteractor
	let presenter : EnhancedTooltipPresenter
	let tooltipId : String
	let keyboardShortcut : String?
	var delegate : EnhancedTooltipRouterDelegate
	let placementQuery : EnhancedTooltipPlacementQuery

	// Swift methods
	0x3c04  func EnhancedTooltipRouter.delegate.getter // getter 
	0x3c48  func EnhancedTooltipRouter.delegate.setter // setter 
	0x3ca8  func EnhancedTooltipRouter.delegate.modify // modifyCoroutine 
	0x3d84  class func EnhancedTooltipRouter.__allocating_init(tooltipData:triggerRect:keyboardShortcut:timing:placementQuery:helpUrlBuilder:localization:analyticsReporter:) // init 
	0x4550  func EnhancedTooltipRouter.show() // method 
	0x45e4  func EnhancedTooltipRouter.showNow() // method 
	0x4698  func EnhancedTooltipRouter.closeNow() // method 
	0x46b8  func EnhancedTooltipRouter.tooltipFrameOnScreen.getter // getter 
	0x4748  func EnhancedTooltipRouter.mouseMoved(mouseLocation:) // method 
 }

 enum EnhancedTooltipScene.Constants { }

 enum EnhancedTooltipScene.EnhancedTooltipContentViewRenderingMode { }

 class EnhancedTooltipScene.EnhancedTooltipContentView : COUIContentView @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI {

	// Properties
	var renderingMode : EnhancedTooltipContentViewRenderingMode
	var mask : CAShapeLayer?
	var arrowEdge : EnhancedTooltipEdge
WARNING: couldn't find address 0x0 (0x0) in binary!
	var arrowOffset : ×K
	var backgroundColor : NSColor?

	// ObjC -> Swift bridged methods
WARNING: couldn't find offset 0x12af in binary!
WARNING: couldn't find offset 0x12af in binary!
WARNING: couldn't find address 0x1bc00000adc8 (0x3c00000adc8) in binary!
	0x0  @objc EnhancedTooltipContentView.(null) <stripped>
WARNING: couldn't find offset 0x12aa in binary!
WARNING: couldn't find offset 0x12aa in binary!
WARNING: couldn't find address 0x12ae0000ac48 (0x2ae0000ac48) in binary!
	0x0  @objc EnhancedTooltipContentView.(null) <stripped>
WARNING: couldn't find offset 0x12b0 in binary!
WARNING: couldn't find offset 0x12b0 in binary!
WARNING: couldn't find address 0x12ac0000acc0 (0x2ac0000acc0) in binary!
	0x0  @objc EnhancedTooltipContentView.(null) <stripped>
WARNING: couldn't find offset 0x1272 in binary!
WARNING: couldn't find offset 0x1272 in binary!
WARNING: couldn't find address 0x1bf00000acf8 (0x3f00000acf8) in binary!
	0x0  @objc EnhancedTooltipContentView.(null) <stripped>
WARNING: couldn't find address 0x198000000c (0x198000000c) in binary!
	0x69cffffc844  @objc EnhancedTooltipContentView.(null) <stripped>
WARNING: couldn't find offset 0x1b5c in binary!
WARNING: couldn't find offset 0x1b5c in binary!
WARNING: couldn't find address 0xffffac5400001b5c (0x0) in binary!
	0x45cffffac58  @objc EnhancedTooltipContentView.(null) <stripped>
WARNING: couldn't find offset 0x1b44 in binary!
WARNING: couldn't find offset 0x1b44 in binary!
WARNING: couldn't find address 0xffffac8000001b44 (0x0) in binary!
	0x424ffffac84  @objc EnhancedTooltipContentView.(null) <stripped>
WARNING: couldn't find offset 0x1b2c in binary!
WARNING: couldn't find offset 0x1b2c in binary!
WARNING: couldn't find address 0xffffacac00001b2c (0x0) in binary!
	0x4ccffffacb0  @objc EnhancedTooltipContentView.(null) <stripped>

	// Swift methods
	0x53b8  func EnhancedTooltipContentView.renderingMode.getter // getter 
	0x5444  func EnhancedTooltipContentView.renderingMode.setter // setter 
	0x548c  func EnhancedTooltipContentView.renderingMode.modify // modifyCoroutine 
	0x553c  func EnhancedTooltipContentView.mask.getter // getter 
	0x5548  func EnhancedTooltipContentView.arrowEdge.getter // getter 
	0x5554  func EnhancedTooltipContentView.arrowOffset.getter // getter 
	0x55a4  func EnhancedTooltipContentView.backgroundColor.getter // getter 
	0x55fc  func EnhancedTooltipContentView.backgroundColor.setter // setter 
	0x56dc  func EnhancedTooltipContentView.backgroundColor.modify // modifyCoroutine 
	0x5954  func EnhancedTooltipContentView.setArrowPosition(edge:offset:) // method 
	0x5aec  func EnhancedTooltipContentView.createArrow() // method 
	0x5e4c  func EnhancedTooltipContentView.display(_:) // method 
 }

 enum EnhancedTooltipScene.Constants { }

 class EnhancedTooltipScene.EnhancedTooltipInteractor : _SwiftObject /usr/lib/swift/libswiftCore.dylib, EnhancedTooltipInteractorProtocol {

	// Properties
	var presenter : EnhancedTooltipPresenterProtocol
	let tooltipId : String
WARNING: couldn't find address 0x0 (0x0) in binary!
	let model : •K
	let helpUrlBuilder : EnhancedTooltipHelpUrlBuilderProtocol
	let analyticsReporter : EnhancedTooltipAnalyticsReporterProtocol

	// Swift methods
	0x66f4  func <stripped> // method 
	0x68f8  func <stripped> // method 
	0x6afc  func <stripped> // method 
	0x6bcc  func <stripped> // method 
 }

 class EnhancedTooltipScene.EnhancedTooltipWindow : NSPanel /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit {
	// ObjC -> Swift bridged methods
WARNING: couldn't find offset 0x1300 in binary!
WARNING: couldn't find offset 0x1300 in binary!
WARNING: couldn't find address 0x12f60000ac90 (0x2f60000ac90) in binary!
	0x0  @objc EnhancedTooltipWindow.(null) <stripped>
WARNING: couldn't find address 0x16340000ad60 (0x6340000ad60) in binary!
	0x88000000c  @objc EnhancedTooltipWindow.(null) <stripped>
WARNING: couldn't find offset 0x12af in binary!
WARNING: couldn't find offset 0x12af in binary!
WARNING: couldn't find address 0x1bc00000adc8 (0x3c00000adc8) in binary!
	0x0  @objc EnhancedTooltipWindow.(null) <stripped>
 }

 class EnhancedTooltipScene.EnhancedTooltipWindowController : NSWindowController /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit, EnhancedTooltipWindowControllerProtocol {

	// Properties
	var viewModel : EnhancedTooltipViewModel
	var interactor : EnhancedTooltipInteractorProtocol
	var delegate : EnhancedTooltipViewDelegate
	var closing : Bool

	// ObjC -> Swift bridged methods
WARNING: couldn't find offset 0x1a8c in binary!
WARNING: couldn't find offset 0x1a8c in binary!
WARNING: couldn't find address 0x11260000aae0 (0x1260000aae0) in binary!
	0x0  @objc EnhancedTooltipWindowController.(null) <stripped>
WARNING: couldn't find offset 0x1102 in binary!
WARNING: couldn't find offset 0x1102 in binary!
WARNING: couldn't find address 0x1a800000ab88 (0x2800000ab88) in binary!
	0x0  @objc EnhancedTooltipWindowController.(null) <stripped>
WARNING: couldn't find address 0x474f525029232840 (0x25029232840) in binary!
	0x7546465636e  @objc EnhancedTooltipWindowController.(null) <stripped>
WARNING: couldn't find address 0x656e656353706974 (0x56353706974) in binary!
	0x1686e453a54  @objc EnhancedTooltipWindowController.(null) <stripped>

	// Swift methods
 }

 enum EnhancedTooltipScene.Constants { }

 struct EnhancedTooltipScene.EnhancedTooltipViewModel {

	// Properties
	let triggerRect : CGRect
	let title : String
	let description : String
	let keyboardShortcut : String?
	let coverImage : NSImage?
	let tutorialUrlTitle : String?
WARNING: couldn't find address 0x0 (0x0) in binary!
	let tutorialUrl : 'K
	let helpUrlTitle : String?
WARNING: couldn't find address 0x0 (0x0) in binary!
	let helpUrl : 'K
 }

 class EnhancedTooltipScene.EnhancedTooltipViewController : NSViewController /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit {

	// Properties
	var titleView : NSTextField?
	var descriptionView : NSTextField?
	var coverImageView : NSImageView?
	var keyboardShortcutView : NSTextField?
	var tutorialTextView : NSTextView?
	var tutorialImageButton : NSButton?
	var helpTextView : NSTextView?
	var helpImageButton : NSButton?
	var imageHeightConstraint : NSLayoutConstraint?
	var interactor : EnhancedTooltipInteractorProtocol
	var viewModel : EnhancedTooltipViewModel

	// ObjC -> Swift bridged methods
WARNING: couldn't find offset 0x1b5c in binary!
WARNING: couldn't find offset 0x1b5c in binary!
WARNING: couldn't find address 0x1ed40000aea0 (0x6d40000aea0) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1b44 in binary!
WARNING: couldn't find offset 0x1b44 in binary!
WARNING: couldn't find address 0x125c0000ae40 (0x25c0000ae40) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1b2c in binary!
WARNING: couldn't find offset 0x1b2c in binary!
WARNING: couldn't find address 0x12440000ad80 (0x2440000ad80) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1b14 in binary!
WARNING: couldn't find offset 0x1b14 in binary!
WARNING: couldn't find address 0x122c0000ad58 (0x22c0000ad58) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1afc in binary!
WARNING: couldn't find offset 0x1afc in binary!
WARNING: couldn't find address 0x12140000ad98 (0x2140000ad98) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1ae4 in binary!
WARNING: couldn't find offset 0x1ae4 in binary!
WARNING: couldn't find address 0x11fc0000adf0 (0x1fc0000adf0) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1acc in binary!
WARNING: couldn't find offset 0x1acc in binary!
WARNING: couldn't find address 0x11e40000add0 (0x1e40000add0) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1ab4 in binary!
WARNING: couldn't find offset 0x1ab4 in binary!
WARNING: couldn't find address 0x11cc0000ad30 (0x1cc0000ad30) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1a9c in binary!
WARNING: couldn't find offset 0x1a9c in binary!
WARNING: couldn't find address 0x11b40000ad10 (0x1b40000ad10) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x117a in binary!
WARNING: couldn't find offset 0x117a in binary!
WARNING: couldn't find address 0x119c0000ad10 (0x19c0000ad10) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1178 in binary!
WARNING: couldn't find offset 0x1178 in binary!
WARNING: couldn't find address 0x11840000abb8 (0x1840000abb8) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1abc in binary!
WARNING: couldn't find offset 0x1abc in binary!
WARNING: couldn't find address 0x15080000abe8 (0x5080000abe8) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find address 0x113e0000aab8 (0x13e0000aab8) in binary!
	0x48000000c  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1a8c in binary!
WARNING: couldn't find offset 0x1a8c in binary!
WARNING: couldn't find address 0x11260000aae0 (0x1260000aae0) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find offset 0x1102 in binary!
WARNING: couldn't find offset 0x1102 in binary!
WARNING: couldn't find address 0x1a800000ab88 (0x2800000ab88) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find address 0x474f525029232840 (0x25029232840) in binary!
	0x7546465636e  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find address 0x656e656353706974 (0x56353706974) in binary!
	0x1686e453a54  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find address 0x69746c6f6f546465 (0x46f6f546465) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find address 0x3fc999999999999a (0x1999999999a) in binary!
	0x0  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find address 0x436c00004300 (0x36c00004300) in binary!
	0x35c00005ca1  @objc EnhancedTooltipViewController.(null) <stripped>
	0x0  @objc EnhancedTooltipViewController.âª˜! <stripped>
WARNING: couldn't find address 0x6465636e61686e45 (0x36e61686e45) in binary!
	0x656e6563  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find address 0x0 (0x0) in binary!
	0x1746c6f6f54  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find address 0x6c6544726574756f (0x4726574756f) in binary!
	0x36e61686e45  @objc EnhancedTooltipViewController.(null) <stripped>
WARNING: couldn't find address 0x527069746c6f6f54 (0x1746c6f6f54) in binary!
	0x6c6f636f74  @objc EnhancedTooltipViewController.(null) <stripped>

	// Swift methods
	0x95ec  func <stripped> // method 
	0x9840  func <stripped> // method 
	0xa854  func <stripped> // method 
	0xa910  func <stripped> // method 
 }

 enum EnhancedTooltipScene.TimerType {

	// Properties
	case show  
	case hide  
 }

 class EnhancedTooltipScene.EnhancedTooltipPresenter : _SwiftObject /usr/lib/swift/libswiftCore.dylib, EnhancedTooltipPresenterProtocol {

	// Properties
	let timing : EnhancedTooltipPresenterTimingProtocol
	var isClosed : Bool
	var router : EnhancedTooltipRouterProtocol
	var view : EnhancedTooltipWindowControllerProtocol
	var placement : EnhancedTooltipPlacementInfo
	var triggerRect : CGRect
	var viewModel : EnhancedTooltipViewModel

	// Swift methods
	0xca6c  func <stripped> // method 
	0xcbf4  func <stripped> // method 
	0xcdac  func <stripped> // method 
 }


