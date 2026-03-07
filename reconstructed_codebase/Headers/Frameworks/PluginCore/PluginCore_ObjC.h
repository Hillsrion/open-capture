@protocol COSettingsRendering
  // instance methods
 -[COSettingsRendering renderInRect:ofView:skinned:]

@end

@protocol NSObject
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
 -[NSObject isEqual:]
 -[NSObject class]
 -[NSObject self]
 -[NSObject performSelector:]
 -[NSObject performSelector:withObject:]
 -[NSObject performSelector:withObject:withObject:]
 -[NSObject isProxy]
 -[NSObject isKindOfClass:]
 -[NSObject isMemberOfClass:]
 -[NSObject conformsToProtocol:]
 -[NSObject respondsToSelector:]
 -[NSObject retain]
 -[NSObject release]
 -[NSObject autorelease]
 -[NSObject retainCount]
 -[NSObject zone]
 -[NSObject superclass]

@optional
  // instance methods

@end

@protocol COSettingsItemDelegate <NSObject>
  // instance methods
 -[COSettingsItemDelegate settingsItemDidUpdateValue:]
 -[COSettingsItemDelegate settingsItem:handleEvent:]

@optional
  // instance methods
 -[COSettingsItemDelegate settingsItemWillUpdateValue:]
 -[COSettingsItemDelegate settingsItemDidBecomeFirstResponder:]
 -[COSettingsItemDelegate settingsItemDidResignFirstResponder:]

@end

@protocol NSTabViewDelegate <NSObject>
@optional
  // instance methods
 -[NSTabViewDelegate tabView:shouldSelectTabViewItem:]
 -[NSTabViewDelegate tabView:willSelectTabViewItem:]
 -[NSTabViewDelegate tabView:didSelectTabViewItem:]
 -[NSTabViewDelegate tabViewDidChangeNumberOfTabViewItems:]

@end

@protocol NSCopying
  // instance methods
 -[NSCopying copyWithZone:]

@end

@protocol NSCoding
  // instance methods
 -[NSCoding encodeWithCoder:]
 -[NSCoding initWithCoder:]

@end

@protocol NSSecureCoding <NSCoding>
  // class methods
 +[NSSecureCoding supportsSecureCoding]

@end

@protocol COFileHandlingHostProtocol <NSObject>
  // instance methods
 -[COFileHandlingHostProtocol plugin:tasksForAction:forFiles:reply:]

@end

@protocol COVariantProcessingHostProtocol <NSObject>
  // instance methods
 -[COVariantProcessingHostProtocol plugin:processingSettingsForAction:reply:]
 -[COVariantProcessingHostProtocol plugin:processingSettingsVisibilityForAction:reply:]

@end

@protocol COEditingPluginHostProtocol <COFileHandlingHostProtocol, COVariantProcessingHostProtocol>
  // instance methods
 -[COEditingPluginHostProtocol plugin:editingActionsWithFileInfo:reply:]
 -[COEditingPluginHostProtocol plugin:startEditingTask:reply:]

@end

@protocol COPublishingPluginHostProtocol <COFileHandlingHostProtocol, COVariantProcessingHostProtocol>
  // instance methods
 -[COPublishingPluginHostProtocol plugin:publishingActionsWithFileCount:reply:]
 -[COPublishingPluginHostProtocol plugin:startPublishingTask:reply:]

@end

@protocol COColorProfilingPluginHostProtocol <COFileHandlingHostProtocol, COVariantProcessingHostProtocol>
  // instance methods
 -[COColorProfilingPluginHostProtocol plugin:colorProfilingActionsWithFileInfo:reply:]
 -[COColorProfilingPluginHostProtocol plugin:startColorProfilingTask:reply:]

@end

@protocol COOpenWithPluginHostProtocol <COFileHandlingHostProtocol>
  // instance methods
 -[COOpenWithPluginHostProtocol plugin:openWithActionsWithFileInfo:pluginRole:reply:]
 -[COOpenWithPluginHostProtocol plugin:startOpenWithTask:reply:]

@end

@protocol COSettingsHostProtocol <NSObject>
  // instance methods
 -[COSettingsHostProtocol pluginSettings:reply:]
 -[COSettingsHostProtocol plugin:didUpdateValue:forSetting:reply:]
 -[COSettingsHostProtocol plugin:handleEvent:forSettingsItem:reply:]

@end

@protocol COActionSettingsHostProtocol <NSObject>
  // instance methods
 -[COActionSettingsHostProtocol plugin:settingsForAction:settings:reply:]
 -[COActionSettingsHostProtocol plugin:didUpdateValue:forSetting:action:settings:reply:]
 -[COActionSettingsHostProtocol plugin:validateSettings:forAction:reply:]

@end

@protocol COInternalPluginHostProtocol <NSObject>
  // instance methods
 -[COInternalPluginHostProtocol plugin:setup:reply:]

@end

@protocol COPluginHostProtocol <COEditingPluginHostProtocol, COPublishingPluginHostProtocol, COColorProfilingPluginHostProtocol, COOpenWithPluginHostProtocol, COSettingsHostProtocol, COActionSettingsHostProtocol, COInternalPluginHostProtocol>
  // instance methods
 -[COPluginHostProtocol validatePlugin:reply:]
 -[COPluginHostProtocol plugin:conformsToProtocolNamed:reply:]

@end

@protocol COProgressReporting <NSObject>
@optional
  // instance methods
 -[COProgressReporting task:setProgress:total:message:reply:]

@end

@protocol COSettingsCallback <NSObject>
@optional
  // instance methods
 -[COSettingsCallback plugin:performCallbackAction:payload:reply:]

@end

@protocol COPluginAgentProtocol <COProgressReporting, COSettingsCallback>
@end

@protocol COSettingsItemUIFocusDelegate
  // instance methods
 -[COSettingsItemUIFocusDelegate settingsItemControlDidBecomeFirstResponder:]
 -[COSettingsItemUIFocusDelegate settingsItemControlDidResignFirstResponder:]

@end

@protocol COFileHandling
  // instance methods
 -[COFileHandling tasksForAction:forFiles:error:]

@end

@protocol COVariantProcessing
@optional
  // instance methods
 -[COVariantProcessing processingSettingsForAction:error:]
 -[COVariantProcessing processingSettingsVisibilityForAction:]

@end

@protocol COActionSettings
@optional
  // instance methods
 -[COActionSettings settingsForAction:settings:error:]
 -[COActionSettings didUpdateValue:forSetting:action:settings:callbackAction:error:]
 -[COActionSettings validateSettings:forAction:error:]

@end

@protocol COEditingPlugin <COFileHandling, COVariantProcessing, COActionSettings>
  // instance methods
 -[COEditingPlugin editingActionsWithFileInfo:error:]
 -[COEditingPlugin startEditingTask:error:progress:]

@end

@protocol COPublishingPlugin <COFileHandling, COVariantProcessing, COActionSettings>
  // instance methods
 -[COPublishingPlugin publishingActionsFileCount:error:]
 -[COPublishingPlugin startPublishingTask:error:progress:]

@end

@protocol COColorProfilingPlugin <COFileHandling, COVariantProcessing, COActionSettings>
  // instance methods
 -[COColorProfilingPlugin colorProfilingActionsWithFileInfo:error:]
 -[COColorProfilingPlugin startColorProfilingTask:error:progress:]

@end

@protocol COOpenWithPlugin <COFileHandling>
  // instance methods
 -[COOpenWithPlugin openWithActionsWithFileInfo:pluginRole:error:]
 -[COOpenWithPlugin startOpenWithTask:error:progress:]

@end

@protocol COSettings
  // instance methods
 -[COSettings settingsWithError:]
 -[COSettings didUpdateValue:forSetting:error:callback:]
 -[COSettings handleEvent:forSettingsItem:error:callback:]

@end

@protocol COInternalPlugin
  // instance methods
 -[COInternalPlugin setup:error:]

@end

@protocol ExternalProcessHelperProtocol
  // instance methods
 -[ExternalProcessHelperProtocol launchctl:plist:error:]
 -[ExternalProcessHelperProtocol posixSpawn:args:retries:wait:pid:error:]

@end

0x000000342c8 COSettingsTextItemTextField : NSTextField /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
 @property  <COSettingsItemUIFocusDelegate> *focusDelegate

  // instance methods
  0x00000004050 -[COSettingsTextItemTextField focusDelegate]
  0x0000000405c -[COSettingsTextItemTextField setFocusDelegate:]
  0x0000000406c -[COSettingsTextItemTextField becomeFirstResponder]
  0x000000040e0 -[COSettingsTextItemTextField resignFirstResponder]


0x00000034318 COIsolationQueue : NSObject /usr/lib/libobjc.A.dylib
 @property  NSObject<OS_dispatch_queue> *queue
 @property  NSObject *owner

  // class methods
  0x00000006638 +[COIsolationQueue syncQueueWithObject:]
  0x00000006684 +[COIsolationQueue syncQueueWithObject:targetQueue:]

  // instance methods
  0x000000066f0 -[COIsolationQueue initWithObject:]
  0x000000066f8 -[COIsolationQueue initWithObject:targetQueue:]
  0x000000068c4 -[COIsolationQueue dispatchBlock:completion:]
  0x00000006a18 -[COIsolationQueue dispatchBlockSync:]
  0x00000006a68 -[COIsolationQueue queue]
  0x00000006a70 -[COIsolationQueue setQueue:]
  0x00000006a7c -[COIsolationQueue owner]
  0x00000006a94 -[COIsolationQueue setOwner:]


0x00000034390 COPluginSettingsDocumentView : COUIView @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI

0x000000343e0 COPluginSettingsScrollView : NSScrollView /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit

0x00000034408 COPluginSettingsManager : NSObject /usr/lib/libobjc.A.dylib <COSettingsItemDelegate, NSTabViewDelegate>
 @property  NSMutableSet *renderedGroupIndices
 @property  COPluginSettingsTabSelectorSegmentedControl *tabSelector
 @property  NSTabView *tabView
 @property  unsigned long tabIndexOffset
 @property  COSettingsItem *selectedSettingsItem
 @property  <COPluginSettingsManagerDelegate> *delegate
 @property  COPlugin *plugin
 @property  NSArray *settings
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000006f54 +[COPluginSettingsManager loadSettingsValues:fromValuesDictionary:]
  0x00000006fe4 +[COPluginSettingsManager loadSettingsValueForSettings:fromValuesDictionary:]
  0x00000007604 +[COPluginSettingsManager loadSettingsValues:intoValuesDictionary:]
  0x00000007694 +[COPluginSettingsManager loadSettingsValueForSettings:intoValuesDictionary:]

  // instance methods
  0x00000006df8 -[COPluginSettingsManager init]
  0x00000006e4c -[COPluginSettingsManager initWithPlugin:settings:delegate:]
  0x000000079c0 -[COPluginSettingsManager renderSettingsInView:selectGroupAtIndex:]
  0x00000007f28 -[COPluginSettingsManager insertSettingsInTabView:tabSelector:atIndex:]
  0x0000000816c -[COPluginSettingsManager removeSettingsFromTabView:tabSelector:]
  0x00000008364 -[COPluginSettingsManager renderSettingsGroupAtIndex:inView:]
  0x000000089c8 -[COPluginSettingsManager settingsItemValue:]
  0x00000008b60 -[COPluginSettingsManager settingsItemDidUpdateValue:]
  0x00000008c38 -[COPluginSettingsManager settingsItemWillUpdateValue:]
  0x00000008d10 -[COPluginSettingsManager settingsItem:handleEvent:]
  0x00000008dac -[COPluginSettingsManager settingsItemDidBecomeFirstResponder:]
  0x00000008db0 -[COPluginSettingsManager settingsItemDidResignFirstResponder:]
  0x00000008db8 -[COPluginSettingsManager findSettingsItemWithIdenitifier:]
  0x0000000910c -[COPluginSettingsManager uiState]
  0x00000009150 -[COPluginSettingsManager restoreUIState:]
  0x000000091d0 -[COPluginSettingsManager selectedTabChanged:]
  0x000000092d0 -[COPluginSettingsManager tabView:willSelectTabViewItem:]
  0x0000000941c -[COPluginSettingsManager tabView:didSelectTabViewItem:]
  0x00000009554 -[COPluginSettingsManager viewIsSkinned:]
  0x0000000969c -[COPluginSettingsManager delegate]
  0x000000096a4 -[COPluginSettingsManager setDelegate:]
  0x000000096b0 -[COPluginSettingsManager plugin]
  0x000000096b8 -[COPluginSettingsManager settings]
  0x000000096c0 -[COPluginSettingsManager renderedGroupIndices]
  0x000000096c8 -[COPluginSettingsManager setRenderedGroupIndices:]
  0x000000096d4 -[COPluginSettingsManager tabSelector]
  0x000000096dc -[COPluginSettingsManager setTabSelector:]
  0x000000096e8 -[COPluginSettingsManager tabView]
  0x000000096f0 -[COPluginSettingsManager setTabView:]
  0x000000096fc -[COPluginSettingsManager tabIndexOffset]
  0x00000009704 -[COPluginSettingsManager setTabIndexOffset:]
  0x0000000970c -[COPluginSettingsManager selectedSettingsItem]
  0x00000009714 -[COPluginSettingsManager setSelectedSettingsItem:]


0x00000034458 COPlugin : NSObject /usr/lib/libobjc.A.dylib <NSCopying, NSSecureCoding>
 @property  unsigned long capabilities
 @property  NSBundle *bundle
 @property  NSString *name
 @property  NSString *identifier
 @property  NSString *copyright
 @property  NSString *version
 @property  NSImage *icon
 @property  NSString *infoText
 @property  NSString *author
 @property  NSString *authorURL
 @property  BOOL builtin
 @property  BOOL enabled
 @property  BOOL canBeDisabled

  // class methods
  0x00000009c6c +[COPlugin pluginWithBundle:]
  0x00000009f58 +[COPlugin supportsSecureCoding]

  // instance methods
  0x0000000978c -[COPlugin name]
  0x000000097dc -[COPlugin identifier]
  0x00000009820 -[COPlugin icon]
  0x0000000999c -[COPlugin copyright]
  0x000000099e8 -[COPlugin canBeDisabled]
  0x00000009a98 -[COPlugin version]
  0x00000009ae4 -[COPlugin infoText]
  0x00000009b30 -[COPlugin author]
  0x00000009b7c -[COPlugin authorURL]
  0x00000009bc8 -[COPlugin builtin]
  0x00000009cb8 -[COPlugin init]
  0x00000009d0c -[COPlugin initWithBundle:enabled:]
  0x00000009ebc -[COPlugin isEqual:]
  0x00000009ec0 -[COPlugin isEqualTo:]
  0x00000009ec4 -[COPlugin isEqualToPlugin:]
  0x00000009f60 -[COPlugin encodeWithCoder:]
  0x0000000a014 -[COPlugin initWithCoder:]
  0x0000000a0e4 -[COPlugin copyWithZone:]
  0x0000000a130 -[COPlugin bundle]
  0x0000000a138 -[COPlugin capabilities]
  0x0000000a140 -[COPlugin setCapabilities:]
  0x0000000a148 -[COPlugin enabled]
  0x0000000a150 -[COPlugin setEnabled:]


0x000000344a8 COPluginHostConnection : NSXPCConnection /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
 @property  NSError *error
 @property  NSObject<OS_dispatch_semaphore> *semaphore
 @property  COPlugin *plugin

  // class methods
  0x0000000ace0 +[COPluginHostConnection pluginHostConnectionWithPlugin:exportedObject:]

  // instance methods
  0x0000000ad90 -[COPluginHostConnection initWithServiceName:exportedObject:]
  0x0000000b088 -[COPluginHostConnection wait]
  0x0000000b0c0 -[COPluginHostConnection wait:]
  0x0000000b100 -[COPluginHostConnection performWaitAndReturnError:]
  0x0000000b1a8 -[COPluginHostConnection done]
  0x0000000b1d8 -[COPluginHostConnection error]
  0x0000000b1e8 -[COPluginHostConnection setError:]
  0x0000000b1fc -[COPluginHostConnection plugin]
  0x0000000b20c -[COPluginHostConnection setPlugin:]
  0x0000000b220 -[COPluginHostConnection semaphore]
  0x0000000b230 -[COPluginHostConnection setSemaphore:]


0x000000344f8 COSettingsTextItemUIState : COSettingsItemUIState
 @property  unsigned long cursorPosition

  // instance methods
  0x0000000b298 -[COSettingsTextItemUIState initWithIdentifier:cursorPosition:]
  0x0000000b2e8 -[COSettingsTextItemUIState cursorPosition]


0x00000034570 COPluginHostInterface : NSXPCInterface /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
  // class methods
  0x0000000bc08 +[COPluginHostInterface plistAllowedClasses]
  0x0000000bcd0 +[COPluginHostInterface pluginActionAllowedClasses]
  0x0000000bd90 +[COPluginHostInterface pluginHostReplyAllowedClasses]
  0x0000000be3c +[COPluginHostInterface fileHandlingReplyAllowedClasses]
  0x0000000bf6c +[COPluginHostInterface editingPluginReplyAllowedClasses]
  0x0000000c0b0 +[COPluginHostInterface publishingPluginReplyAllowedClasses]
  0x0000000c1f4 +[COPluginHostInterface colorProfilingPluginReplyAllowedClasses]
  0x0000000c338 +[COPluginHostInterface openWithPluginReplyAllowedClasses]
  0x0000000c47c +[COPluginHostInterface settingsAllowedClasses]
  0x0000000c518 +[COPluginHostInterface settingsReplyAllowedClasses]
  0x0000000c61c +[COPluginHostInterface actionSettingsAllowedClasses]
  0x0000000c690 +[COPluginHostInterface actionSettingsReplyAllowedClasses]
  0x0000000c794 +[COPluginHostInterface internalPluginAllowedClasses]
  0x0000000c808 +[COPluginHostInterface internalPluginReplyAllowedClasses]
  0x0000000c8a4 +[COPluginHostInterface defaultInterface]


0x00000034598 COPluginAgent : NSObject /usr/lib/libobjc.A.dylib <COPluginAgentProtocol>
 @property  COPluginLogger *logger
 @property  COIsolationQueue *syncQueue
 @property  <COPluginAgentProgressReportingDelegate> *progressReportingDelegate
 @property  <COPluginAgentSettingsCallbackDelegate> *settingsCallbackDelegate
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000000d654 +[COPluginAgent sharedAgent]
  0x0000000d7d4 +[COPluginAgent XPCServiceBaseNameForPlugin:]
  0x0000000d854 +[COPluginAgent XPCServiceIdentifierForPlugin:]

  // instance methods
  0x0000000d700 -[COPluginAgent init]
  0x0000000d8c0 -[COPluginAgent plugin:errorWithStatus:forPayload:]
  0x0000000da24 -[COPluginAgent validatePlugin:error:]
  0x0000000de78 -[COPluginAgent plugin:conformsToProtocol:error:]
  0x0000000e2bc -[COPluginAgent plugin:tasksForAction:forFiles:error:]
  0x0000000e8b8 -[COPluginAgent plugin:editingActionsWithFileInfo:error:]
  0x0000000ed98 -[COPluginAgent plugin:startEditingTask:error:]
  0x0000000f18c -[COPluginAgent plugin:openWithActionsWithFileInfo:pluginRole:error:]
  0x0000000f674 -[COPluginAgent plugin:startOpenWithTask:error:]
  0x0000000fa68 -[COPluginAgent plugin:publishingActionsWithFileCount:error:]
  0x0000000ff18 -[COPluginAgent plugin:startPublishingTask:error:]
  0x0000001030c -[COPluginAgent plugin:colorProfilingActionsWithFileInfo:error:]
  0x000000107ec -[COPluginAgent plugin:startColorProfilingTask:error:]
  0x00000010be0 -[COPluginAgent pluginSettings:error:]
  0x00000010f8c -[COPluginAgent plugin:didUpdateValue:forSetting:error:]
  0x000000113b8 -[COPluginAgent plugin:handleEvent:forSettingsItem:error:]
  0x000000117fc -[COPluginAgent plugin:settingsForAction:settings:error:]
  0x00000011be4 -[COPluginAgent plugin:didUpdateValue:forSetting:action:settings:error:]
  0x00000011ff0 -[COPluginAgent plugin:validateSettings:forAction:error:]
  0x000000123dc -[COPluginAgent plugin:processingSettingsForAction:error:]
  0x000000127c4 -[COPluginAgent plugin:processingSettingsVisibilityForAction:error:]
  0x00000012b78 -[COPluginAgent task:setProgress:total:message:reply:]
  0x00000012da0 -[COPluginAgent plugin:performCallbackAction:payload:reply:]
  0x00000012f64 -[COPluginAgent plugin:setup:error:]
  0x000000132f8 -[COPluginAgent progressReportingDelegate]
  0x00000013310 -[COPluginAgent setProgressReportingDelegate:]
  0x0000001331c -[COPluginAgent settingsCallbackDelegate]
  0x00000013334 -[COPluginAgent setSettingsCallbackDelegate:]
  0x00000013340 -[COPluginAgent logger]
  0x00000013348 -[COPluginAgent setLogger:]
  0x00000013354 -[COPluginAgent syncQueue]
  0x0000001335c -[COPluginAgent setSyncQueue:]


0x000000345e8 COSettingsItemUIState : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *identifier

  // instance methods
  0x000000133a8 -[COSettingsItemUIState initWithIdentifier:]
  0x00000013420 -[COSettingsItemUIState identifier]
  0x00000013428 -[COSettingsItemUIState setIdentifier:]


0x00000034638 COSettingsTextItemSecureTextField : NSSecureTextField /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
 @property  <COSettingsItemUIFocusDelegate> *focusDelegate

  // instance methods
  0x00000013aa0 -[COSettingsTextItemSecureTextField focusDelegate]
  0x00000013aac -[COSettingsTextItemSecureTextField setFocusDelegate:]
  0x00000013abc -[COSettingsTextItemSecureTextField becomeFirstResponder]
  0x00000013b1c -[COSettingsTextItemSecureTextField resignFirstResponder]


0x00000034688 COPluginManager : NSObject /usr/lib/libobjc.A.dylib
 @property  NSBundle *hostBundle
 @property  NSArray *registeredPlugins

  // class methods
  0x00000015000 +[COPluginManager builtinPluginsPath]
  0x0000001504c +[COPluginManager userPluginsPath]
  0x000000150ec +[COPluginManager pluginsPaths]
  0x00000016acc +[COPluginManager defaultManager]

  // instance methods
  0x00000014954 -[COPluginManager pluginForURL:files:error:]
  0x00000014ad0 -[COPluginManager actionForURL:files:error:]
  0x0000001579c -[COPluginManager persistPluginEnabledStates]
  0x00000015820 -[COPluginManager getPersistedPluginEnabledStates]
  0x000000158e0 -[COPluginManager createTemporaryDirectory]
  0x000000159d8 -[COPluginManager isPluginCompressed:]
  0x00000015a7c -[COPluginManager unpackPlugin:tempDir:newURL:error:]
  0x00000015dd0 -[COPluginManager pluginForBundleId:]
  0x00000015f34 -[COPluginManager installPluginFromURL:overwrite:plugin:error:]
  0x00000016724 -[COPluginManager deletePlugin:error:]
  0x00000016c08 -[COPluginManager init]
  0x00000016c74 -[COPluginManager initWithAgent:externalProcessHelper:]
  0x00000016ed4 -[COPluginManager pluginsConformingToProtocol:]
  0x0000001710c -[COPluginManager plugin:conformsToProtocol:]
  0x0000001725c -[COPluginManager pluginsWithCapability:]
  0x00000017340 -[COPluginManager plugin:hasCapability:]
  0x0000001736c -[COPluginManager registeredPlugins]
  0x00000017484 -[COPluginManager registerPluginsInDirectories:error:]
  0x000000177ec -[COPluginManager spawnEnabledPlugins:error:]
  0x00000017b00 -[COPluginManager registerPluginsInDirectory:error:]
  0x00000018350 -[COPluginManager spawnPluginProcess:error:]
  0x00000019160 -[COPluginManager unregisterPlugin:error:]
  0x000000192e0 -[COPluginManager shutdownPluginHost:error:]
  0x000000196f4 -[COPluginManager disablePlugin:error:]
  0x00000019758 -[COPluginManager enablePlugin:error:]
  0x000000197bc -[COPluginManager isAppleSiliconSupportedByPlugin:]
  0x00000019a20 -[COPluginManager hostBundle]
  0x00000019a28 -[COPluginManager setHostBundle:]


0x00000034700 COPluginSettingsTabSelectorContainer : COUIView @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI
  // instance methods
  0x0000001a228 -[COPluginSettingsTabSelectorContainer drawRect:]


0x00000034728 COPluginSettingsTabSelectorSegmentedCell : NSSegmentedCell /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
 @property  ^d initialWidths
 @property  double explicitWidth
 @property  unsigned long autoSizedSegments

  // class methods
  0x0000001a368 +[COPluginSettingsTabSelectorSegmentedCell coActiveHighlightColor]

  // instance methods
  0x0000001a39c -[COPluginSettingsTabSelectorSegmentedCell labelAttributesForSegment:]
  0x0000001a520 -[COPluginSettingsTabSelectorSegmentedCell fontForSegment:]
  0x0000001a524 -[COPluginSettingsTabSelectorSegmentedCell labelColorForSegment:]
  0x0000001a5c8 -[COPluginSettingsTabSelectorSegmentedCell attributedLabelForSegment:]
  0x0000001a658 -[COPluginSettingsTabSelectorSegmentedCell segmentWidthForTitleWidth:]
  0x0000001a664 -[COPluginSettingsTabSelectorSegmentedCell segmentTitleRectForSegment:inFrame:]
  0x0000001a708 -[COPluginSettingsTabSelectorSegmentedCell calculateWidthsOfSegmentsInFrame:]
  0x0000001aa0c -[COPluginSettingsTabSelectorSegmentedCell dealloc]
  0x0000001aa60 -[COPluginSettingsTabSelectorSegmentedCell drawWithFrame:inView:]
  0x0000001ab68 -[COPluginSettingsTabSelectorSegmentedCell drawSegment:inFrame:withView:]
  0x0000001ac2c -[COPluginSettingsTabSelectorSegmentedCell initialWidths]
  0x0000001ac3c -[COPluginSettingsTabSelectorSegmentedCell setInitialWidths:]
  0x0000001ac4c -[COPluginSettingsTabSelectorSegmentedCell explicitWidth]
  0x0000001ac5c -[COPluginSettingsTabSelectorSegmentedCell setExplicitWidth:]
  0x0000001ac6c -[COPluginSettingsTabSelectorSegmentedCell autoSizedSegments]
  0x0000001ac7c -[COPluginSettingsTabSelectorSegmentedCell setAutoSizedSegments:]


0x00000034778 COPluginSettingsTabSelectorSegmentedControl : NSSegmentedControl /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
  // instance methods
  0x0000001ac8c -[COPluginSettingsTabSelectorSegmentedControl initWithFrame:]
  0x0000001acf8 -[COPluginSettingsTabSelectorSegmentedControl segmentAtPoint:]
  0x0000001ade4 -[COPluginSettingsTabSelectorSegmentedControl mouseUp:]
  0x0000001ae94 -[COPluginSettingsTabSelectorSegmentedControl mouseDown:]


0x000000347f0 COPluginAgentInterface : NSXPCInterface /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
  // class methods
  0x0000001b5dc +[COPluginAgentInterface plistAllowedClasses]
  0x0000001b6a4 +[COPluginAgentInterface pluginActionResultAllowedClasses]
  0x0000001b740 +[COPluginAgentInterface pluginTaskParamAllowedClasses]
  0x0000001b82c +[COPluginAgentInterface settingsCallbackAllowedClasses]
  0x0000001b8ec +[COPluginAgentInterface defaultInterface]


0x00000034818 COPluginLogger : NSObject /usr/lib/libobjc.A.dylib
 @property  COIsolationQueue *syncQueue

  // class methods
  0x0000001bb6c +[COPluginLogger logger]

  // instance methods
  0x0000001bb80 -[COPluginLogger init]
  0x0000001bc28 -[COPluginLogger logDebug:]
  0x0000001bc2c -[COPluginLogger logDebugFormat:]
  0x0000001bc30 -[COPluginLogger logDebugFormat:args:]
  0x0000001bc34 -[COPluginLogger logMsg:]
  0x0000001bc38 -[COPluginLogger logMsgFormat:]
  0x0000001bc60 -[COPluginLogger logMsgFormat:args:]
  0x0000001bc70 -[COPluginLogger logErr:]
  0x0000001bc74 -[COPluginLogger logErrFormat:]
  0x0000001bc9c -[COPluginLogger logErrFormat:args:]
  0x0000001bcac -[COPluginLogger writeFormat:args:toFile:]
  0x0000001be8c -[COPluginLogger syncQueue]
  0x0000001be94 -[COPluginLogger setSyncQueue:]


0x00000034868 ExternalProcessHelper : NSObject /usr/lib/libobjc.A.dylib <ExternalProcessHelperProtocol>
  // class methods
  0x0000001c3ac +[ExternalProcessHelper sharedHelper]

  // instance methods
  0x0000001c424 -[ExternalProcessHelper launchctl:plist:error:]
  0x0000001c510 -[ExternalProcessHelper posixSpawn:args:retries:wait:pid:error:]


0x00000030340 COSettingsItemsGroup(SettingsRendering)
	// instance methods
	0x00400004154 -[COSettingsItemsGroup(SettingsRendering) renderInRect:ofView:skinned:]

0x00000030380 COSettingsFileItem(SettingsRendering)
	// instance methods
	0x004000043c8 -[COSettingsFileItem(SettingsRendering) textField]
	0x004000043d4 -[COSettingsFileItem(SettingsRendering) setTextField:]
	0x004000043e4 -[COSettingsFileItem(SettingsRendering) button]
	0x004000043f0 -[COSettingsFileItem(SettingsRendering) setButton:]
	0x00400004400 -[COSettingsFileItem(SettingsRendering) lineHeightForRect:skinned:]
	0x00400004448 -[COSettingsFileItem(SettingsRendering) renderControlInRect:ofView:skinned:]
	0x00400004888 -[COSettingsFileItem(SettingsRendering) didPress:]
	0x00400004d10 -[COSettingsFileItem(SettingsRendering) updateValue:]
	0x00400004e40 -[COSettingsFileItem(SettingsRendering) setTextFieldValue]

0x000000303c0 COSettingsMultipleListItem(SettingsRendering)
	// instance methods
	0x00400005268 -[COSettingsMultipleListItem(SettingsRendering) tableView]
	0x00400005274 -[COSettingsMultipleListItem(SettingsRendering) setTableView:]
	0x00400005284 -[COSettingsMultipleListItem(SettingsRendering) searchField]
	0x00400005290 -[COSettingsMultipleListItem(SettingsRendering) setSearchField:]
	0x004000052a0 -[COSettingsMultipleListItem(SettingsRendering) renderControlInRect:ofView:skinned:]
	0x00400005aa0 -[COSettingsMultipleListItem(SettingsRendering) selectedValueIndexes]
	0x00400005d08 -[COSettingsMultipleListItem(SettingsRendering) filteredOptions]
	0x00400005e2c -[COSettingsMultipleListItem(SettingsRendering) tableView:heightOfRow:]
	0x00400005e34 -[COSettingsMultipleListItem(SettingsRendering) tableView:shouldEditTableColumn:row:]
	0x00400005e7c -[COSettingsMultipleListItem(SettingsRendering) numberOfRowsInTableView:]
	0x00400005eb8 -[COSettingsMultipleListItem(SettingsRendering) tableView:objectValueForTableColumn:row:]
	0x00400006054 -[COSettingsMultipleListItem(SettingsRendering) tableView:setObjectValue:forTableColumn:row:]
	0x004000061cc -[COSettingsMultipleListItem(SettingsRendering) controlTextDidChange:]
	0x00400006258 -[COSettingsMultipleListItem(SettingsRendering) selectAll:]
	0x004000063d4 -[COSettingsMultipleListItem(SettingsRendering) deselectAll:]
	0x00400006550 -[COSettingsMultipleListItem(SettingsRendering) updateValue:]

0x00000030558 COSettingsBase(SettingsRendering)
	// instance methods
	0x00400006acc -[COSettingsBase(SettingsRendering) delegate]
	0x00400006ad8 -[COSettingsBase(SettingsRendering) setDelegate:]
	0x00400006ae8 -[COSettingsBase(SettingsRendering) renderInRect:ofView:skinned:]

0x000000306b8 NSObject(Cast)
	// class methods
	0x00400006b78 +[NSObject(Cast) cast:]

0x000000306f8 NSSegmentedControl(Insert)
	// instance methods
	0x00400006bc4 -[NSSegmentedControl(Insert) insertSegment:atIndex:]
	0x00400006ca4 -[NSSegmentedControl(Insert) removeSegmentAtIndex:]
	0x00400006d68 -[NSSegmentedControl(Insert) updateSegmentsWithArray:]

0x000000310e8 NSTextView(Markdown)
	// class methods
	0x0040000a188 +[NSTextView(Markdown) parseString:]
	0x0040000a2bc +[NSTextView(Markdown) appendTextCheckingResult:fromString:toString:range:attributes:]

	// instance methods
	0x0040000a6b8 -[NSTextView(Markdown) loadMarkdownString:]

0x00000031328 COSettingsTextItem(SettingsRendering)
	// instance methods
	0x0040000b2f8 -[COSettingsTextItem(SettingsRendering) commitTimer]
	0x0040000b304 -[COSettingsTextItem(SettingsRendering) setCommitTimer:]
	0x0040000b314 -[COSettingsTextItem(SettingsRendering) renderControlInRect:ofView:skinned:]
	0x0040000b628 -[COSettingsTextItem(SettingsRendering) controlTextDidChange:]
	0x0040000b768 -[COSettingsTextItem(SettingsRendering) commitTimerTick:]
	0x0040000b7d0 -[COSettingsTextItem(SettingsRendering) controlTextDidEndEditing:]
	0x0040000b8b4 -[COSettingsTextItem(SettingsRendering) updateValue:]
	0x0040000b9dc -[COSettingsTextItem(SettingsRendering) uiState]
	0x0040000baf0 -[COSettingsTextItem(SettingsRendering) restoreUIState:]

0x00000031c80 COSettingsItem(SettingsRendering)
	// instance methods
	0x0040001343c -[COSettingsItem(SettingsRendering) control]
	0x00400013448 -[COSettingsItem(SettingsRendering) setControl:]
	0x00400013458 -[COSettingsItem(SettingsRendering) renderInRect:ofView:skinned:]
	0x004000134d8 -[COSettingsItem(SettingsRendering) labelWidthForRect:skinned:]
	0x00400013510 -[COSettingsItem(SettingsRendering) lineHeightForRect:skinned:]
	0x00400013524 -[COSettingsItem(SettingsRendering) lineSpacingForRect:skinned:]
	0x00400013538 -[COSettingsItem(SettingsRendering) layoutSpacingForRect:skinned:]
	0x0040001354c -[COSettingsItem(SettingsRendering) renderLabelInRect:ofView:skinned:]
	0x00400013774 -[COSettingsItem(SettingsRendering) renderControlInRect:ofView:skinned:]
	0x00400013918 -[COSettingsItem(SettingsRendering) uiState]
	0x004000139a0 -[COSettingsItem(SettingsRendering) restoreUIState:]
	0x00400013a30 -[COSettingsItem(SettingsRendering) settingsItemControlDidBecomeFirstResponder:]
	0x00400013a68 -[COSettingsItem(SettingsRendering) settingsItemControlDidResignFirstResponder:]

0x00000031d68 COSettingsButtonItem(SettingsRendering)
	// instance methods
	0x00400013b7c -[COSettingsButtonItem(SettingsRendering) renderLabelInRect:ofView:skinned:]
	0x00400013bf4 -[COSettingsButtonItem(SettingsRendering) renderControlInRect:ofView:skinned:]
	0x00400013dac -[COSettingsButtonItem(SettingsRendering) didPress:]

0x00000031da8 COSettingsElementsGroup(SettingsRendering)
	// instance methods
	0x00400013e6c -[COSettingsElementsGroup(SettingsRendering) renderInRect:ofView:skinned:]

0x00000031de8 COSettingsLabelItem(SettingsRendering)
	// instance methods
	0x004000140e0 -[COSettingsLabelItem(SettingsRendering) renderControlInRect:ofView:skinned:]

0x00000031e28 COSettingsBoolItem(SettingsRendering)
	// instance methods
	0x00400014598 -[COSettingsBoolItem(SettingsRendering) lineHeightForRect:skinned:]
	0x004000145e0 -[COSettingsBoolItem(SettingsRendering) renderLabelInRect:ofView:skinned:]
	0x00400014658 -[COSettingsBoolItem(SettingsRendering) renderControlInRect:ofView:skinned:]
	0x00400014844 -[COSettingsBoolItem(SettingsRendering) changeValue:]

0x00000032318 COSettingsListItem(SettingsRendering)
	// instance methods
	0x00400019b1c -[COSettingsListItem(SettingsRendering) lineHeightForRect:skinned:]
	0x00400019b64 -[COSettingsListItem(SettingsRendering) renderControlInRect:ofView:skinned:]
	0x0040001a050 -[COSettingsListItem(SettingsRendering) changeValue:]
	0x0040001a188 -[COSettingsListItem(SettingsRendering) optionIsSeparator:]

0x000000325f0 NSURL(COActionSettings)
	// instance methods
	0x0040001ae98 -[NSURL(COActionSettings) initWithAction:actionSettings:]
	0x0040001af58 -[NSURL(COActionSettings) initWithPluginIdentifier:actionIdentifier:actionSettings:]
	0x0040001b1f8 -[NSURL(COActionSettings) isPluginURL]
	0x0040001b23c -[NSURL(COActionSettings) pluginIdentifier]
	0x0040001b2d8 -[NSURL(COActionSettings) actionIdentifier]
	0x0040001b3c4 -[NSURL(COActionSettings) actionSettings]

0x00000032720 NSNumber(COPluginCapability)
	// instance methods
	0x0040001ba78 -[NSNumber(COPluginCapability) pluginCapabilityValue]

0x00000032798 COPluginAction(Plugin)
	// instance methods
	0x0040001ba7c -[COPluginAction(Plugin) plugin]
	0x0040001ba88 -[COPluginAction(Plugin) setPlugin:]
	0x0040001ba98 -[COPluginAction(Plugin) capability]
	0x0040001badc -[COPluginAction(Plugin) setCapability:]
	0x0040001bb38 -[COPluginAction(Plugin) urlRepresentation]

0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COFileHandlingPluginTask 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COPluginAction 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COPluginActionColorProfilingResult 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COPluginActionImageResult 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COPluginActionOpenWithResult 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COPluginActionPublishResult 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COPluginTask 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsBase 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsBoolItem 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsButtonItem 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsElement 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsElementsGroup 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsFileItem 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsItem 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsItemsGroup 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsLabelItem 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsListItem 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsListOption 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsMultipleListItem 
0x00000000000 01 00 0200 @rpath/Frameworks/CaptureOnePlugins.framework/Versions/A/CaptureOnePlugins: COSettingsTextItem 
0x00000000000 01 00 0100 @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI: COUIButtonCell 
0x00000000000 01 00 0100 @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI: COUIContentView 
0x00000000000 01 00 0100 @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI: COUIPanel 
0x00000000000 01 00 0100 @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI: COUIPopUpButtonCell 
0x00000000000 01 00 0100 @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI: COUITextFieldCell 
0x00000000000 01 00 0100 @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI: COUIView 
0x00000000000 01 00 0100 @rpath/Frameworks/CaptureOneUI.framework/Versions/A/CaptureOneUI: COUIWindow 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSArray 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSAttributedString 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSBezierPath 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSBox 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSBundle 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSButton 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSButtonCell 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSCharacterSet 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSColor 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSConstantDictionary 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSCursor 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSData 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSDate 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSDictionary 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSError 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSException 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSFileManager 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSFont 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSFontManager 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSGraphicsContext 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSImage 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSImageCell 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSKeyedArchiver 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSKeyedUnarchiver 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSMenuItem 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableArray 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableDictionary 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSMutableIndexSet 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSMutableParagraphStyle 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableSet 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSMutableString 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSNotificationCenter 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSNull 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSNumber 
0x00000000000 01 00 0400 /usr/lib/libobjc.A.dylib: NSObject 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSOpenPanel 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSPipe 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSPopUpButton 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSPredicate 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSProcessInfo 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSPropertyListSerialization 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSRegularExpression 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSRunLoop 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSScrollView 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSSearchField 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSSecureTextField 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSSegmentedCell 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSSegmentedControl 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSSet 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSString 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSTabView 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSTabViewItem 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSTableColumn 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSTableView 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSTask 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSTextField 
0x00000000000 01 00 0600 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSTextView 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSTimer 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSURL 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSUUID 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSUserDefaults 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSXPCConnection 
0x00000000000 01 00 0300 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSXPCInterface 
