@protocol _TtP22EnhancedTooltipManager30EnhancedTooltipTriggerProtocol_
 @property  NSString *tooltipId
 @property  {CGRect={CGPoint=dd}{CGSize=dd}} bounds
 @property  NSString *keyboardShortcutCommand
 @property  {CGRect={CGPoint=dd}{CGSize=dd}} screenRect
 @property  {CGRect={CGPoint=dd}{CGSize=dd}} windowRect
 @property  BOOL preferVerticalPlacement

  // instance methods
 -[_TtP22EnhancedTooltipManager30EnhancedTooltipTriggerProtocol_ tooltipId]
 -[_TtP22EnhancedTooltipManager30EnhancedTooltipTriggerProtocol_ bounds]
 -[_TtP22EnhancedTooltipManager30EnhancedTooltipTriggerProtocol_ keyboardShortcutCommand]
 -[_TtP22EnhancedTooltipManager30EnhancedTooltipTriggerProtocol_ screenRect]
 -[_TtP22EnhancedTooltipManager30EnhancedTooltipTriggerProtocol_ windowRect]
 -[_TtP22EnhancedTooltipManager30EnhancedTooltipTriggerProtocol_ preferVerticalPlacement]

@end

@protocol _TtP22EnhancedTooltipManager45EnhancedTooltipKeyboardShortcutMapperProtocol_
  // instance methods
 -[_TtP22EnhancedTooltipManager45EnhancedTooltipKeyboardShortcutMapperProtocol_ keyboardShortcutForCommand:]

@end

@protocol EnhancedTooltipSegmentedControlCellProtocol
 @property  BOOL preferTooltipVerticalPlacement

  // instance methods
 -[EnhancedTooltipSegmentedControlCellProtocol enhancedTooltipIdForPoint:]
 -[EnhancedTooltipSegmentedControlCellProtocol enhancedTooltipIdForPoint:]
 -[EnhancedTooltipSegmentedControlCellProtocol segmentRectForPoint:]
 -[EnhancedTooltipSegmentedControlCellProtocol segmentRectForPoint:]
 -[EnhancedTooltipSegmentedControlCellProtocol keyboardShortcutActionForPoint:]
 -[EnhancedTooltipSegmentedControlCellProtocol keyboardShortcutActionForPoint:]
 -[EnhancedTooltipSegmentedControlCellProtocol preferTooltipVerticalPlacement]

@end

@protocol EnhancedTooltipCustomProtocol
 @property  NSString *enhancedTooltipId
 @property  NSString *enhancedTooltipKeyboardShortcutAction
 @property  BOOL preferTooltipVerticalPlacement

  // instance methods
 -[EnhancedTooltipCustomProtocol enhancedTooltipId]
 -[EnhancedTooltipCustomProtocol enhancedTooltipKeyboardShortcutAction]

@optional
  // instance methods
 -[EnhancedTooltipCustomProtocol preferTooltipVerticalPlacement]

@end

0x00000011378 _TtC22EnhancedTooltipManager35EnhancedTooltipDataRepositoryCompat : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000002448 +[_TtC22EnhancedTooltipManager35EnhancedTooltipDataRepositoryCompat initializeSharedInstanceFromFolderPath:]
  0x0000000258c +[_TtC22EnhancedTooltipManager35EnhancedTooltipDataRepositoryCompat hasDataWithId:]
  0x00000002648 +[_TtC22EnhancedTooltipManager35EnhancedTooltipDataRepositoryCompat addSimpleTooltipWithId:title:description:]

  // instance methods
  0x00000002724 -[_TtC22EnhancedTooltipManager35EnhancedTooltipDataRepositoryCompat init]


0x000000114e0 _TtC22EnhancedTooltipManager29EnhancedTooltipTriggerFactory : NSObject /usr/lib/libobjc.A.dylib
  // instance methods
  0x00000002c70 -[_TtC22EnhancedTooltipManager29EnhancedTooltipTriggerFactory init]


0x00000011700 _TtC22EnhancedTooltipManager23EnhancedTooltipsManager : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x00000011830 _TtC22EnhancedTooltipManager27EnhancedTooltipEventHandler : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x000000118f8 _TtC22EnhancedTooltipManager38EnhancedTooltipSegmentedControlTrigger : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib <_TtP22EnhancedTooltipManager30EnhancedTooltipTriggerProtocol_>
 @property  {CGRect={CGPoint=dd}{CGSize=dd}} screenRect
 @property  {CGRect={CGPoint=dd}{CGSize=dd}} windowRect
 @property  NSString *tooltipId
 @property  {CGRect={CGPoint=dd}{CGSize=dd}} bounds
 @property  BOOL preferVerticalPlacement
 @property  NSString *keyboardShortcutCommand

  // instance methods
  0x00000005928 -[_TtC22EnhancedTooltipManager38EnhancedTooltipSegmentedControlTrigger screenRect]
  0x00000005a60 -[_TtC22EnhancedTooltipManager38EnhancedTooltipSegmentedControlTrigger windowRect]
  0x00000005b04 -[_TtC22EnhancedTooltipManager38EnhancedTooltipSegmentedControlTrigger tooltipId]
  0x00000005b54 -[_TtC22EnhancedTooltipManager38EnhancedTooltipSegmentedControlTrigger setTooltipId:]
  0x00000005b94 -[_TtC22EnhancedTooltipManager38EnhancedTooltipSegmentedControlTrigger bounds]
  0x00000005ba0 -[_TtC22EnhancedTooltipManager38EnhancedTooltipSegmentedControlTrigger setBounds:]
  0x00000005bb4 -[_TtC22EnhancedTooltipManager38EnhancedTooltipSegmentedControlTrigger preferVerticalPlacement]
  0x00000005bbc -[_TtC22EnhancedTooltipManager38EnhancedTooltipSegmentedControlTrigger setPreferVerticalPlacement:]
  0x00000005ecc -[_TtC22EnhancedTooltipManager38EnhancedTooltipSegmentedControlTrigger keyboardShortcutCommand]


0x00000011a30 _TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib <_TtP22EnhancedTooltipManager30EnhancedTooltipTriggerProtocol_>
 @property  NSString *tooltipId
 @property  NSString *keyboardShortcutCommand
 @property  {CGRect={CGPoint=dd}{CGSize=dd}} bounds
 @property  {CGRect={CGPoint=dd}{CGSize=dd}} screenRect
 @property  {CGRect={CGPoint=dd}{CGSize=dd}} windowRect
 @property  BOOL preferVerticalPlacement

  // instance methods
  0x00000005f24 -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger tooltipId]
  0x00000005fe0 -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger setTooltipId:]
  0x000000060f0 -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger keyboardShortcutCommand]
  0x000000061ac -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger setKeyboardShortcutCommand:]
  0x000000062bc -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger bounds]
  0x00000006330 -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger setBounds:]
  0x00000006398 -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger screenRect]
  0x0000000640c -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger setScreenRect:]
  0x00000006474 -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger windowRect]
  0x000000064e8 -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger setWindowRect:]
  0x00000006550 -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger preferVerticalPlacement]
  0x000000065bc -[_TtC22EnhancedTooltipManager32EnhancedTooltipCustomViewTrigger setPreferVerticalPlacement:]


0x00000011ba0 _TtC22EnhancedTooltipManager19EnhancedTooltipTime : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x00000011c40 _TtC22EnhancedTooltipManager33EnhancedTooltipTimerDelayProvider : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x00000011d18 _TtC22EnhancedTooltipManager22PresenterTimingFactory : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x00000011dc0 _TtC22EnhancedTooltipManager24NonRepeatingTimerFactory : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x00000011e60 _TtC22EnhancedTooltipManager17NonRepeatingTimer : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x00000011f78 _TtC22EnhancedTooltipManager15PresenterTiming : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSApplication 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSEvent 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSFileManager 
0x00000000000 01 00 0400 /usr/lib/libobjc.A.dylib: NSObject 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSRunLoop 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSScreen 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSSegmentedControl 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSTimer 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSWindow 
0x00000000000 01 00 0a00 /usr/lib/swift/libswiftCore.dylib: _TtCs12_SwiftObject 
