@protocol CALayerDelegate <NSObject>
@optional
  // instance methods
 -[CALayerDelegate displayLayer:]
 -[CALayerDelegate displayLayer:]
 -[CALayerDelegate drawLayer:inContext:]
 -[CALayerDelegate drawLayer:inContext:]
 -[CALayerDelegate layerWillDraw:]
 -[CALayerDelegate layoutSublayersOfLayer:]
 -[CALayerDelegate layoutSublayersOfLayer:]
 -[CALayerDelegate actionForLayer:forKey:]
 -[CALayerDelegate actionForLayer:forKey:]

@end

@protocol NSObject
 @property  long long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
 -[NSObject isEqual:]
 -[NSObject superclass]
 -[NSObject class]
 -[NSObject self]
 -[NSObject performSelector:]
 -[NSObject performSelector:]
 -[NSObject performSelector:withObject:]
 -[NSObject performSelector:withObject:]
 -[NSObject performSelector:withObject:withObject:]
 -[NSObject performSelector:withObject:withObject:]
 -[NSObject isProxy]
 -[NSObject isKindOfClass:]
 -[NSObject isKindOfClass:]
 -[NSObject isMemberOfClass:]
 -[NSObject isMemberOfClass:]
 -[NSObject conformsToProtocol:]
 -[NSObject conformsToProtocol:]
 -[NSObject respondsToSelector:]
 -[NSObject respondsToSelector:]
 -[NSObject retain]
 -[NSObject release]
 -[NSObject autorelease]
 -[NSObject retainCount]
 -[NSObject zone]

@optional
  // instance methods

@end

@protocol NSWindowDelegate <NSObject>
@optional
  // instance methods
 -[NSWindowDelegate windowShouldClose:]
 -[NSWindowDelegate windowWillReturnFieldEditor:toObject:]
 -[NSWindowDelegate windowWillReturnFieldEditor:toObject:]
 -[NSWindowDelegate windowWillResize:toSize:]
 -[NSWindowDelegate windowWillResize:toSize:]
 -[NSWindowDelegate windowWillUseStandardFrame:defaultFrame:]
 -[NSWindowDelegate windowShouldZoom:toFrame:]
 -[NSWindowDelegate windowWillReturnUndoManager:]
 -[NSWindowDelegate window:willPositionSheet:usingRect:]
 -[NSWindowDelegate window:willPositionSheet:usingRect:]
 -[NSWindowDelegate window:shouldPopUpDocumentPathMenu:]
 -[NSWindowDelegate window:shouldDragDocumentWithEvent:from:withPasteboard:]
 -[NSWindowDelegate window:shouldDragDocumentWithEvent:from:withPasteboard:]
 -[NSWindowDelegate window:willUseFullScreenContentSize:]
 -[NSWindowDelegate window:willUseFullScreenPresentationOptions:]
 -[NSWindowDelegate customWindowsToEnterFullScreenForWindow:]
 -[NSWindowDelegate customWindowsToEnterFullScreenForWindow:]
 -[NSWindowDelegate window:startCustomAnimationToEnterFullScreenWithDuration:]
 -[NSWindowDelegate windowDidFailToEnterFullScreen:]
 -[NSWindowDelegate customWindowsToExitFullScreenForWindow:]
 -[NSWindowDelegate customWindowsToExitFullScreenForWindow:]
 -[NSWindowDelegate window:startCustomAnimationToExitFullScreenWithDuration:]
 -[NSWindowDelegate customWindowsToEnterFullScreenForWindow:onScreen:]
 -[NSWindowDelegate customWindowsToEnterFullScreenForWindow:onScreen:]
 -[NSWindowDelegate window:startCustomAnimationToEnterFullScreenOnScreen:withDuration:]
 -[NSWindowDelegate window:startCustomAnimationToEnterFullScreenOnScreen:withDuration:]
 -[NSWindowDelegate windowDidFailToExitFullScreen:]
 -[NSWindowDelegate window:willResizeForVersionBrowserWithMaxPreferredSize:maxAllowedSize:]
 -[NSWindowDelegate window:willEncodeRestorableState:]
 -[NSWindowDelegate window:didDecodeRestorableState:]
 -[NSWindowDelegate previewRepresentableActivityItemsForWindow:]
 -[NSWindowDelegate previewRepresentableActivityItemsForWindow:]
 -[NSWindowDelegate windowDidResize:]
 -[NSWindowDelegate windowDidExpose:]
 -[NSWindowDelegate windowWillMove:]
 -[NSWindowDelegate windowDidMove:]
 -[NSWindowDelegate windowDidBecomeKey:]
 -[NSWindowDelegate windowDidResignKey:]
 -[NSWindowDelegate windowDidBecomeMain:]
 -[NSWindowDelegate windowDidResignMain:]
 -[NSWindowDelegate windowWillClose:]
 -[NSWindowDelegate windowWillMiniaturize:]
 -[NSWindowDelegate windowDidMiniaturize:]
 -[NSWindowDelegate windowDidDeminiaturize:]
 -[NSWindowDelegate windowDidUpdate:]
 -[NSWindowDelegate windowDidChangeScreen:]
 -[NSWindowDelegate windowDidChangeScreenProfile:]
 -[NSWindowDelegate windowDidChangeBackingProperties:]
 -[NSWindowDelegate windowWillBeginSheet:]
 -[NSWindowDelegate windowDidEndSheet:]
 -[NSWindowDelegate windowWillStartLiveResize:]
 -[NSWindowDelegate windowDidEndLiveResize:]
 -[NSWindowDelegate windowWillEnterFullScreen:]
 -[NSWindowDelegate windowDidEnterFullScreen:]
 -[NSWindowDelegate windowWillExitFullScreen:]
 -[NSWindowDelegate windowDidExitFullScreen:]
 -[NSWindowDelegate windowWillEnterVersionBrowser:]
 -[NSWindowDelegate windowDidEnterVersionBrowser:]
 -[NSWindowDelegate windowWillExitVersionBrowser:]
 -[NSWindowDelegate windowDidExitVersionBrowser:]
 -[NSWindowDelegate windowDidChangeOcclusionState:]

@end

@protocol NSTextViewDelegate <NSTextDelegate>
@optional
  // instance methods
 -[NSTextViewDelegate textView:clickedOnLink:atIndex:]
 -[NSTextViewDelegate textView:clickedOnLink:atIndex:]
 -[NSTextViewDelegate textView:clickedOnCell:inRect:atIndex:]
 -[NSTextViewDelegate textView:clickedOnCell:inRect:atIndex:]
 -[NSTextViewDelegate textView:doubleClickedOnCell:inRect:atIndex:]
 -[NSTextViewDelegate textView:doubleClickedOnCell:inRect:atIndex:]
 -[NSTextViewDelegate textView:draggedCell:inRect:event:atIndex:]
 -[NSTextViewDelegate textView:draggedCell:inRect:event:atIndex:]
 -[NSTextViewDelegate textView:writablePasteboardTypesForCell:atIndex:]
 -[NSTextViewDelegate textView:writablePasteboardTypesForCell:atIndex:]
 -[NSTextViewDelegate textView:writeCell:atIndex:toPasteboard:type:]
 -[NSTextViewDelegate textView:writeCell:atIndex:toPasteboard:type:]
 -[NSTextViewDelegate textView:willChangeSelectionFromCharacterRange:toCharacterRange:]
 -[NSTextViewDelegate textView:willChangeSelectionFromCharacterRanges:toCharacterRanges:]
 -[NSTextViewDelegate textView:shouldChangeTextInRanges:replacementStrings:]
 -[NSTextViewDelegate textView:shouldChangeTypingAttributes:toAttributes:]
 -[NSTextViewDelegate textViewDidChangeSelection:]
 -[NSTextViewDelegate textViewDidChangeTypingAttributes:]
 -[NSTextViewDelegate textView:willDisplayToolTip:forCharacterAtIndex:]
 -[NSTextViewDelegate textView:willDisplayToolTip:forCharacterAtIndex:]
 -[NSTextViewDelegate textView:completions:forPartialWordRange:indexOfSelectedItem:]
 -[NSTextViewDelegate textView:shouldChangeTextInRange:replacementString:]
 -[NSTextViewDelegate textView:shouldChangeTextInRange:replacementString:]
 -[NSTextViewDelegate textView:doCommandBySelector:]
 -[NSTextViewDelegate textView:doCommandBySelector:]
 -[NSTextViewDelegate textView:shouldSetSpellingState:range:]
 -[NSTextViewDelegate textView:menu:forEvent:atIndex:]
 -[NSTextViewDelegate textView:menu:forEvent:atIndex:]
 -[NSTextViewDelegate textView:willCheckTextInRange:options:types:]
 -[NSTextViewDelegate textView:willCheckTextInRange:options:types:]
 -[NSTextViewDelegate textView:didCheckTextInRange:types:options:results:orthography:wordCount:]
 -[NSTextViewDelegate textView:didCheckTextInRange:types:options:results:orthography:wordCount:]
 -[NSTextViewDelegate textView:URLForContentsOfTextAttachment:atIndex:]
 -[NSTextViewDelegate textView:URLForContentsOfTextAttachment:atIndex:]
 -[NSTextViewDelegate textView:willShowSharingServicePicker:forItems:]
 -[NSTextViewDelegate textView:willShowSharingServicePicker:forItems:]
 -[NSTextViewDelegate undoManagerForTextView:]
 -[NSTextViewDelegate undoManagerForTextView:]
 -[NSTextViewDelegate textView:shouldUpdateTouchBarItemIdentifiers:]
 -[NSTextViewDelegate textView:candidatesForSelectedRange:]
 -[NSTextViewDelegate textView:candidates:forSelectedRange:]
 -[NSTextViewDelegate textView:shouldSelectCandidateAtIndex:]
 -[NSTextViewDelegate textView:shouldSelectCandidateAtIndex:]
 -[NSTextViewDelegate textView:clickedOnLink:]
 -[NSTextViewDelegate textView:clickedOnCell:inRect:]
 -[NSTextViewDelegate textView:clickedOnCell:inRect:]
 -[NSTextViewDelegate textView:doubleClickedOnCell:inRect:]
 -[NSTextViewDelegate textView:doubleClickedOnCell:inRect:]
 -[NSTextViewDelegate textView:draggedCell:inRect:event:]
 -[NSTextViewDelegate textView:draggedCell:inRect:event:]

@end

@protocol NSTextDelegate <NSObject>
@optional
  // instance methods
 -[NSTextDelegate textShouldBeginEditing:]
 -[NSTextDelegate textShouldEndEditing:]
 -[NSTextDelegate textDidBeginEditing:]
 -[NSTextDelegate textDidEndEditing:]
 -[NSTextDelegate textDidChange:]

@end

0x0000001aad0 _TtC20EnhancedTooltipScene21EnhancedTooltipRouter : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x00000019670 _TtC20EnhancedTooltipScene26EnhancedTooltipContentView : COUIContentView @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI <CALayerDelegate>
 @property  long long renderingMode

  // instance methods
  0x00000005374 -[_TtC20EnhancedTooltipScene26EnhancedTooltipContentView renderingMode]
  0x000000053fc -[_TtC20EnhancedTooltipScene26EnhancedTooltipContentView setRenderingMode:]
  0x00000005928 -[_TtC20EnhancedTooltipScene26EnhancedTooltipContentView awakeFromNib]
  0x00000005aa0 -[_TtC20EnhancedTooltipScene26EnhancedTooltipContentView setArrowPositionWithEdge:offset:]
  0x0000000618c -[_TtC20EnhancedTooltipScene26EnhancedTooltipContentView displayLayer:]
  0x000000062dc -[_TtC20EnhancedTooltipScene26EnhancedTooltipContentView initWithFrame:]
  0x0000000647c -[_TtC20EnhancedTooltipScene26EnhancedTooltipContentView initWithCoder:]


0x0000001acc0 _TtC20EnhancedTooltipScene25EnhancedTooltipInteractor : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x00000019b50 _TtC20EnhancedTooltipScene21EnhancedTooltipWindow : NSPanel /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
  // instance methods
  0x00000006eec -[_TtC20EnhancedTooltipScene21EnhancedTooltipWindow awakeFromNib]
  0x00000006f98 -[_TtC20EnhancedTooltipScene21EnhancedTooltipWindow mouseExited:]
  0x00000007160 -[_TtC20EnhancedTooltipScene21EnhancedTooltipWindow initWithContentRect:styleMask:backing:defer:]


0x0000001a1c8 _TtC20EnhancedTooltipScene31EnhancedTooltipWindowController : NSWindowController /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit <NSWindowDelegate>
  // instance methods
  0x00000007ed0 -[_TtC20EnhancedTooltipScene31EnhancedTooltipWindowController close]
  0x000000073f4 -[_TtC20EnhancedTooltipScene31EnhancedTooltipWindowController initWithWindow:]
  0x000000075bc -[_TtC20EnhancedTooltipScene31EnhancedTooltipWindowController initWithCoder:]


0x0000001a300 _TtC20EnhancedTooltipScene29EnhancedTooltipViewController : NSViewController /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit <NSTextViewDelegate>
 @property  NSTextField *titleView
 @property  NSTextField *descriptionView
 @property  NSImageView *coverImageView
 @property  NSTextField *keyboardShortcutView
 @property  NSTextView *tutorialTextView
 @property  NSButton *tutorialImageButton
 @property  NSTextView *helpTextView
 @property  NSButton *helpImageButton
 @property  NSLayoutConstraint *imageHeightConstraint

  // instance methods
  0x0000000af04 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController textView:clickedOnLink:atIndex:]
  0x00000009320 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController titleView]
  0x00000009330 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController setTitleView:]
  0x00000009364 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController descriptionView]
  0x00000009374 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController setDescriptionView:]
  0x000000093a8 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController coverImageView]
  0x000000093b8 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController setCoverImageView:]
  0x000000093ec -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController keyboardShortcutView]
  0x000000093fc -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController setKeyboardShortcutView:]
  0x00000009430 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController tutorialTextView]
  0x00000009440 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController setTutorialTextView:]
  0x00000009474 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController tutorialImageButton]
  0x00000009484 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController setTutorialImageButton:]
  0x000000094b8 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController helpTextView]
  0x000000094c8 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController setHelpTextView:]
  0x000000094fc -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController helpImageButton]
  0x0000000950c -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController setHelpImageButton:]
  0x00000009540 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController imageHeightConstraint]
  0x00000009550 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController setImageHeightConstraint:]
  0x00000009584 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController viewDidLoad]
  0x0000000a904 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController helpButtonAction:]
  0x0000000a9c0 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController tutorialButtonAction:]
  0x0000000ab88 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController initWithNibName:bundle:]
  0x0000000acf8 -[_TtC20EnhancedTooltipScene29EnhancedTooltipViewController initWithCoder:]


0x0000001aff8 _TtC20EnhancedTooltipScene24EnhancedTooltipPresenter : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x00000000000 01 00 0900 /System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore: CALayer 
0x00000000000 01 00 0900 /System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore: CAShapeLayer 
0x00000000000 01 00 0100 @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI: COUIContentView 
0x00000000000 01 00 0700 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSAnimationContext 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSAttributedString 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSBundle 
0x00000000000 01 00 0700 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSColor 
0x00000000000 01 00 0700 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSEvent 
0x00000000000 01 00 0700 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSFont 
0x00000000000 01 00 0700 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSPanel 
0x00000000000 01 00 0700 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSTextView 
0x00000000000 01 00 0700 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSTrackingArea 
0x00000000000 01 00 0700 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSViewController 
0x00000000000 01 00 0700 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSWindowController 
0x00000000000 01 00 0700 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSWorkspace 
0x00000000000 01 00 0a00 /usr/lib/swift/libswiftCore.dylib: _TtCs12_SwiftObject 
