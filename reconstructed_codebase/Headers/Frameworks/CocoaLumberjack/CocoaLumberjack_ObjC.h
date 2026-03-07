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

@protocol DDLogger <NSObject>
 @property  <DDLogFormatter> *logFormatter
 @property  NSObject<OS_dispatch_queue> *loggerQueue
 @property  NSString *loggerName

  // instance methods
 -[DDLogger logMessage:]
 -[DDLogger logFormatter]
 -[DDLogger setLogFormatter:]

@optional
  // instance methods
 -[DDLogger didAddLogger]
 -[DDLogger didAddLoggerInQueue:]
 -[DDLogger willRemoveLogger]
 -[DDLogger flush]
 -[DDLogger loggerQueue]
 -[DDLogger loggerName]

@end

@protocol DDLogFormatter <NSObject>
  // instance methods
 -[DDLogFormatter formatLogMessage:]

@optional
  // instance methods
 -[DDLogFormatter didAddToLogger:]
 -[DDLogFormatter didAddToLogger:inQueue:]
 -[DDLogFormatter willRemoveFromLogger:]

@end

@protocol DDAtomicCountable <NSObject>
  // instance methods
 -[DDAtomicCountable initWithDefaultValue:]
 -[DDAtomicCountable increment]
 -[DDAtomicCountable decrement]
 -[DDAtomicCountable value]

@end

@protocol DDLogFileManager <NSObject>
 @property  unsigned long maximumNumberOfLogFiles
 @property  unsigned long logFilesDiskQuota
 @property  NSString *logsDirectory
 @property  NSArray *unsortedLogFilePaths
 @property  NSArray *unsortedLogFileNames
 @property  NSArray *unsortedLogFileInfos
 @property  NSArray *sortedLogFilePaths
 @property  NSArray *sortedLogFileNames
 @property  NSArray *sortedLogFileInfos

  // instance methods
 -[DDLogFileManager createNewLogFileWithError:]
 -[DDLogFileManager maximumNumberOfLogFiles]
 -[DDLogFileManager setMaximumNumberOfLogFiles:]
 -[DDLogFileManager logFilesDiskQuota]
 -[DDLogFileManager setLogFilesDiskQuota:]
 -[DDLogFileManager logsDirectory]
 -[DDLogFileManager unsortedLogFilePaths]
 -[DDLogFileManager unsortedLogFileNames]
 -[DDLogFileManager unsortedLogFileInfos]
 -[DDLogFileManager sortedLogFilePaths]
 -[DDLogFileManager sortedLogFileNames]
 -[DDLogFileManager sortedLogFileInfos]

@optional
  // instance methods
 -[DDLogFileManager createNewLogFile]
 -[DDLogFileManager didArchiveLogFile:wasRolled:]
 -[DDLogFileManager didArchiveLogFile:]
 -[DDLogFileManager didRollAndArchiveLogFile:]

@end

@protocol NSCopying
  // instance methods
 -[NSCopying copyWithZone:]

@end

0x00000021d98 CLIColor : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000001b7c +[CLIColor colorWithCalibratedRed:green:blue:alpha:]

  // instance methods
  0x00000001bc0 -[CLIColor getRed:green:blue:alpha:]


0x00000021e10 PodsDummy_CocoaLumberjack : NSObject /usr/lib/libobjc.A.dylib

0x00000021e38 DDAbstractDatabaseLogger : DDAbstractLogger
 @property  unsigned long saveThreshold
 @property  double saveInterval
 @property  double maxAge
 @property  double deleteInterval
 @property  BOOL deleteOnEverySave

  // instance methods
  0x00000001bf4 -[DDAbstractDatabaseLogger init]
  0x00000001c74 -[DDAbstractDatabaseLogger dealloc]
  0x00000001cc0 -[DDAbstractDatabaseLogger db_log:]
  0x00000001cc8 -[DDAbstractDatabaseLogger db_save]
  0x00000001ccc -[DDAbstractDatabaseLogger db_delete]
  0x00000001cd0 -[DDAbstractDatabaseLogger db_saveAndDelete]
  0x00000001cd4 -[DDAbstractDatabaseLogger performSaveAndSuspendSaveTimer]
  0x00000001d60 -[DDAbstractDatabaseLogger performDelete]
  0x00000001dac -[DDAbstractDatabaseLogger destroySaveTimer]
  0x00000001e1c -[DDAbstractDatabaseLogger updateAndResumeSaveTimer]
  0x00000001ed0 -[DDAbstractDatabaseLogger createSuspendedSaveTimer]
  0x00000001ff0 -[DDAbstractDatabaseLogger destroyDeleteTimer]
  0x00000002034 -[DDAbstractDatabaseLogger updateDeleteTimer]
  0x000000020d8 -[DDAbstractDatabaseLogger createAndStartDeleteTimer]
  0x00000002200 -[DDAbstractDatabaseLogger saveThreshold]
  0x000000023a0 -[DDAbstractDatabaseLogger setSaveThreshold:]
  0x00000002594 -[DDAbstractDatabaseLogger saveInterval]
  0x000000026dc -[DDAbstractDatabaseLogger setSaveInterval:]
  0x00000002894 -[DDAbstractDatabaseLogger maxAge]
  0x000000029dc -[DDAbstractDatabaseLogger setMaxAge:]
  0x00000002bb4 -[DDAbstractDatabaseLogger deleteInterval]
  0x00000002cfc -[DDAbstractDatabaseLogger setDeleteInterval:]
  0x00000002eb4 -[DDAbstractDatabaseLogger deleteOnEverySave]
  0x00000002ff4 -[DDAbstractDatabaseLogger setDeleteOnEverySave:]
  0x00000003140 -[DDAbstractDatabaseLogger savePendingLogEntries]
  0x00000003218 -[DDAbstractDatabaseLogger deleteOldLogEntries]
  0x000000032f0 -[DDAbstractDatabaseLogger didAddLogger]
  0x00000003314 -[DDAbstractDatabaseLogger willRemoveLogger]
  0x00000003340 -[DDAbstractDatabaseLogger logMessage:]
  0x000000033cc -[DDAbstractDatabaseLogger flush]


0x00000021eb0 DDASLLogCapture : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000003410 +[DDASLLogCapture start]
  0x000000034a8 +[DDASLLogCapture stop]
  0x000000034b4 +[DDASLLogCapture captureLevel]
  0x000000034c0 +[DDASLLogCapture setCaptureLevel:]
  0x000000034cc +[DDASLLogCapture configureAslQuery:]
  0x000000035c0 +[DDASLLogCapture aslMessageReceived:]
  0x000000037d8 +[DDASLLogCapture captureAslLogs]


0x00000021ed8 DDASLLogger : DDAbstractLogger <DDLogger>
 @property  <DDLogFormatter> *logFormatter
 @property  NSObject<OS_dispatch_queue> *loggerQueue
 @property  NSString *loggerName
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000003a80 +[DDASLLogger sharedInstance]

  // instance methods
  0x00000003b20 -[DDASLLogger init]
  0x00000003bac -[DDASLLogger loggerName]
  0x00000003bbc -[DDASLLogger logMessage:]


0x00000021f28 DDContextAllowlistFilterLogFormatter : NSObject /usr/lib/libobjc.A.dylib <DDLogFormatter>
 @property  NSArray *whitelist
 @property  NSArray *allowlist
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000041e8 -[DDContextAllowlistFilterLogFormatter addToWhitelist:]
  0x000000041ec -[DDContextAllowlistFilterLogFormatter removeFromWhitelist:]
  0x000000041f0 -[DDContextAllowlistFilterLogFormatter whitelist]
  0x000000041f4 -[DDContextAllowlistFilterLogFormatter isOnWhitelist:]
  0x00000003d8c -[DDContextAllowlistFilterLogFormatter init]
  0x00000003df0 -[DDContextAllowlistFilterLogFormatter addToAllowlist:]
  0x00000003df8 -[DDContextAllowlistFilterLogFormatter removeFromAllowlist:]
  0x00000003e00 -[DDContextAllowlistFilterLogFormatter allowlist]
  0x00000003e08 -[DDContextAllowlistFilterLogFormatter isOnAllowlist:]
  0x00000003e10 -[DDContextAllowlistFilterLogFormatter formatLogMessage:]


0x00000021fa0 DDContextDenylistFilterLogFormatter : NSObject /usr/lib/libobjc.A.dylib <DDLogFormatter>
 @property  NSArray *blacklist
 @property  NSArray *denylist
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000041f8 -[DDContextDenylistFilterLogFormatter addToBlacklist:]
  0x000000041fc -[DDContextDenylistFilterLogFormatter removeFromBlacklist:]
  0x00000004200 -[DDContextDenylistFilterLogFormatter blacklist]
  0x00000004204 -[DDContextDenylistFilterLogFormatter isOnBlacklist:]
  0x00000003e8c -[DDContextDenylistFilterLogFormatter init]
  0x00000003ef0 -[DDContextDenylistFilterLogFormatter addToDenylist:]
  0x00000003ef8 -[DDContextDenylistFilterLogFormatter removeFromDenylist:]
  0x00000003f00 -[DDContextDenylistFilterLogFormatter denylist]
  0x00000003f08 -[DDContextDenylistFilterLogFormatter isOnDenylist:]
  0x00000003f10 -[DDContextDenylistFilterLogFormatter formatLogMessage:]


0x00000021f50 DDLoggingContextSet : NSObject /usr/lib/libobjc.A.dylib
 @property  NSArray *currentSet

  // instance methods
  0x00000003f8c -[DDLoggingContextSet init]
  0x00000003ffc -[DDLoggingContextSet dealloc]
  0x00000004044 -[DDLoggingContextSet addToSet:]
  0x000000040b0 -[DDLoggingContextSet removeFromSet:]
  0x0000000411c -[DDLoggingContextSet currentSet]
  0x00000004164 -[DDLoggingContextSet isInSet:]


0x00000022018 DDDispatchQueueLogFormatter : NSObject /usr/lib/libobjc.A.dylib <DDLogFormatter>
 @property  unsigned long minQueueLength
 @property  unsigned long maxQueueLength
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000004208 -[DDDispatchQueueLogFormatter init]
  0x000000042b0 -[DDDispatchQueueLogFormatter initWithMode:]
  0x000000042b4 -[DDDispatchQueueLogFormatter dealloc]
  0x000000042fc -[DDDispatchQueueLogFormatter replacementStringForQueueLabel:]
  0x00000004364 -[DDDispatchQueueLogFormatter setReplacementString:forQueueLabel:]
  0x000000043e4 -[DDDispatchQueueLogFormatter createDateFormatter]
  0x00000004420 -[DDDispatchQueueLogFormatter configureDateFormatter:]
  0x000000044c8 -[DDDispatchQueueLogFormatter stringFromDate:]
  0x000000044d0 -[DDDispatchQueueLogFormatter queueThreadLabelForLogMessage:]
  0x000000047f8 -[DDDispatchQueueLogFormatter formatLogMessage:]
  0x00000004908 -[DDDispatchQueueLogFormatter minQueueLength]
  0x00000004910 -[DDDispatchQueueLogFormatter setMinQueueLength:]
  0x00000004918 -[DDDispatchQueueLogFormatter maxQueueLength]
  0x00000004920 -[DDDispatchQueueLogFormatter setMaxQueueLength:]


0x00000022068 DDAtomicCounter : NSObject /usr/lib/libobjc.A.dylib <DDAtomicCountable>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000004958 -[DDAtomicCounter initWithDefaultValue:]
  0x000000049a0 -[DDAtomicCounter value]
  0x000000049a8 -[DDAtomicCounter increment]
  0x000000049bc -[DDAtomicCounter decrement]


0x000000220b8 DDLogFileManagerDefault : NSObject /usr/lib/libobjc.A.dylib <DDLogFileManager>
 @property  NSString *newLogFileName
 @property  NSString *logFileHeader
 @property  unsigned long maximumNumberOfLogFiles
 @property  unsigned long logFilesDiskQuota
 @property  NSString *logsDirectory
 @property  NSArray *unsortedLogFilePaths
 @property  NSArray *unsortedLogFileNames
 @property  NSArray *unsortedLogFileInfos
 @property  NSArray *sortedLogFilePaths
 @property  NSArray *sortedLogFileNames
 @property  NSArray *sortedLogFileInfos
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000049d0 -[DDLogFileManagerDefault init]
  0x000000049d8 -[DDLogFileManagerDefault initWithLogsDirectory:]
  0x00000004b34 -[DDLogFileManagerDefault deleteOldFilesForConfigurationChange]
  0x00000004be0 -[DDLogFileManagerDefault setLogFilesDiskQuota:]
  0x00000004bf8 -[DDLogFileManagerDefault setMaximumNumberOfLogFiles:]
  0x00000004c10 -[DDLogFileManagerDefault deleteOldLogFiles]
  0x00000004e28 -[DDLogFileManagerDefault defaultLogsDirectory]
  0x00000004f1c -[DDLogFileManagerDefault logsDirectory]
  0x00000004fbc -[DDLogFileManagerDefault isLogFile:]
  0x0000000505c -[DDLogFileManagerDefault logFileDateFormatter]
  0x00000005064 -[DDLogFileManagerDefault unsortedLogFilePaths]
  0x00000005220 -[DDLogFileManagerDefault unsortedLogFileNames]
  0x00000005374 -[DDLogFileManagerDefault unsortedLogFileInfos]
  0x000000054d0 -[DDLogFileManagerDefault sortedLogFilePaths]
  0x00000005624 -[DDLogFileManagerDefault sortedLogFileNames]
  0x00000005778 -[DDLogFileManagerDefault sortedLogFileInfos]
  0x00000005abc -[DDLogFileManagerDefault newLogFileName]
  0x00000005b84 -[DDLogFileManagerDefault logFileHeader]
  0x00000005b8c -[DDLogFileManagerDefault logFileHeaderData]
  0x00000005c24 -[DDLogFileManagerDefault createNewLogFileWithError:]
  0x00000005ed0 -[DDLogFileManagerDefault applicationName]
  0x00000005fe0 -[DDLogFileManagerDefault maximumNumberOfLogFiles]
  0x00000005fe8 -[DDLogFileManagerDefault logFilesDiskQuota]


0x00000022130 DDLogFileFormatterDefault : NSObject /usr/lib/libobjc.A.dylib <DDLogFormatter>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000006020 -[DDLogFileFormatterDefault init]
  0x00000006028 -[DDLogFileFormatterDefault initWithDateFormatter:]
  0x0000000614c -[DDLogFileFormatterDefault formatLogMessage:]


0x00000022180 DDFileLogger : DDAbstractLogger <DDLogger>
 @property  unsigned long maximumFileSize
 @property  double rollingFrequency
 @property  BOOL doNotReuseLogFiles
 @property  <DDLogFileManager> *logFileManager
 @property  BOOL automaticallyAppendNewlineForCustomFormatters
 @property  DDLogFileInfo *currentLogFileInfo
 @property  <DDLogFormatter> *logFormatter
 @property  NSObject<OS_dispatch_queue> *loggerQueue
 @property  NSString *loggerName
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000009590 -[DDFileLogger wrapWithBuffer]
  0x000000095c0 -[DDFileLogger unwrapFromBuffer]
  0x00000007c70 -[DDFileLogger logData:]
  0x00000007dfc -[DDFileLogger lt_deprecationCatchAll]
  0x00000007e00 -[DDFileLogger methodSignatureForSelector:]
  0x00000007e70 -[DDFileLogger forwardInvocation:]
  0x00000007edc -[DDFileLogger lt_logData:]
  0x00000008120 -[DDFileLogger lt_dataForMessage:]
  0x00000006204 -[DDFileLogger init]
  0x00000006250 -[DDFileLogger initWithLogFileManager:]
  0x00000006258 -[DDFileLogger initWithLogFileManager:completionQueue:]
  0x00000006394 -[DDFileLogger lt_cleanup]
  0x0000000644c -[DDFileLogger dealloc]
  0x000000064fc -[DDFileLogger maximumFileSize]
  0x00000006670 -[DDFileLogger setMaximumFileSize:]
  0x000000067c4 -[DDFileLogger rollingFrequency]
  0x00000006938 -[DDFileLogger setRollingFrequency:]
  0x00000006a94 -[DDFileLogger lt_scheduleTimerToRollLogFileDueToAge]
  0x00000006cc0 -[DDFileLogger rollLogFile]
  0x00000006cc8 -[DDFileLogger rollLogFileWithCompletionBlock:]
  0x00000006ed4 -[DDFileLogger lt_rollLogFileNow]
  0x0000000711c -[DDFileLogger lt_maybeRollLogFileDueToAge]
  0x00000007184 -[DDFileLogger lt_maybeRollLogFileDueToSize]
  0x00000007208 -[DDFileLogger lt_shouldLogFileBeArchived:]
  0x000000072ac -[DDFileLogger currentLogFileInfo]
  0x00000007460 -[DDFileLogger lt_currentLogFileInfo]
  0x000000075c4 -[DDFileLogger lt_shouldUseLogFile:isResuming:]
  0x00000007770 -[DDFileLogger lt_monitorCurrentLogFileForExternalChanges]
  0x0000000789c -[DDFileLogger lt_currentLogFileHandle]
  0x0000000797c -[DDFileLogger logMessage:]
  0x000000079c0 -[DDFileLogger willLogMessage:]
  0x000000079c4 -[DDFileLogger didLogMessage:]
  0x000000079c8 -[DDFileLogger shouldArchiveRecentLogFileInfo:]
  0x000000079d0 -[DDFileLogger willRemoveLogger]
  0x000000079d4 -[DDFileLogger flush]
  0x00000007b34 -[DDFileLogger lt_flush]
  0x00000007b7c -[DDFileLogger loggerName]
  0x00000007b8c -[DDFileLogger doNotReuseLogFiles]
  0x00000007ba0 -[DDFileLogger setDoNotReuseLogFiles:]
  0x00000007bb0 -[DDFileLogger logFileManager]
  0x00000007bc0 -[DDFileLogger automaticallyAppendNewlineForCustomFormatters]
  0x00000007bd0 -[DDFileLogger setAutomaticallyAppendNewlineForCustomFormatters:]


0x000000220e0 DDLogFileInfo : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *filePath
 @property  NSString *fileName
 @property  NSDictionary *fileAttributes
 @property  NSDate *creationDate
 @property  NSDate *modificationDate
 @property  unsigned long fileSize
 @property  double age
 @property  BOOL isArchived

  // class methods
  0x0000000825c +[DDLogFileInfo logFileWithPath:]

  // instance methods
  0x000000082b0 -[DDLogFileInfo initWithFilePath:]
  0x00000008328 -[DDLogFileInfo fileAttributes]
  0x000000083ec -[DDLogFileInfo fileName]
  0x00000008434 -[DDLogFileInfo modificationDate]
  0x000000084a0 -[DDLogFileInfo creationDate]
  0x0000000850c -[DDLogFileInfo fileSize]
  0x00000008584 -[DDLogFileInfo age]
  0x00000008834 -[DDLogFileInfo isArchived]
  0x00000008840 -[DDLogFileInfo setIsArchived:]
  0x0000000885c -[DDLogFileInfo reset]
  0x000000088a4 -[DDLogFileInfo renameFile:]
  0x00000008a6c -[DDLogFileInfo hasExtendedAttributeWithName:]
  0x00000008b18 -[DDLogFileInfo addExtendedAttributeWithName:]
  0x00000008bc8 -[DDLogFileInfo removeExtendedAttributeWithName:]
  0x00000008c80 -[DDLogFileInfo isEqual:]
  0x00000008d14 -[DDLogFileInfo reverseCompareByCreationDate:]
  0x00000008d98 -[DDLogFileInfo reverseCompareByModificationDate:]
  0x00000008e1c -[DDLogFileInfo filePath]


0x000000221f8 DDBufferedProxy : NSProxy /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
 @property  DDFileLogger *fileLogger
 @property  NSOutputStream *buffer
 @property  unsigned long maxBufferSizeBytes
 @property  unsigned long currentBufferSizeBytes

  // instance methods
  0x00000008e84 -[DDBufferedProxy initWithFileLogger:]
  0x00000008efc -[DDBufferedProxy dealloc]
  0x00000008ffc -[DDBufferedProxy flushBuffer]
  0x00000009060 -[DDBufferedProxy lt_sendBufferedDataToFileLogger]
  0x000000090c4 -[DDBufferedProxy logMessage:]
  0x000000091c4 -[DDBufferedProxy flush]
  0x00000009388 -[DDBufferedProxy setMaxBufferSizeBytes:]
  0x000000093ec -[DDBufferedProxy wrapWithBuffer]
  0x000000093f0 -[DDBufferedProxy unwrapFromBuffer]
  0x000000093f4 -[DDBufferedProxy methodSignatureForSelector:]
  0x00000009440 -[DDBufferedProxy respondsToSelector:]
  0x00000009484 -[DDBufferedProxy forwardInvocation:]
  0x000000094d8 -[DDBufferedProxy fileLogger]
  0x000000094e8 -[DDBufferedProxy setFileLogger:]
  0x000000094fc -[DDBufferedProxy buffer]
  0x0000000950c -[DDBufferedProxy setBuffer:]
  0x00000009520 -[DDBufferedProxy maxBufferSizeBytes]
  0x00000009530 -[DDBufferedProxy currentBufferSizeBytes]
  0x00000009540 -[DDBufferedProxy setCurrentBufferSizeBytes:]


0x00000022248 DDLog : NSObject /usr/lib/libobjc.A.dylib
 @property  NSMutableArray *_loggers
 @property  NSArray *allLoggers
 @property  NSArray *allLoggersWithLevel

  // class methods
  0x00000009824 +[DDLog sharedInstance]
  0x000000098c0 +[DDLog initialize]
  0x00000009b24 +[DDLog loggingQueue]
  0x00000009b34 +[DDLog addLogger:]
  0x00000009b8c +[DDLog addLogger:withLevel:]
  0x00000009cc0 +[DDLog removeLogger:]
  0x00000009ddc +[DDLog removeAllLoggers]
  0x00000009e98 +[DDLog allLoggers]
  0x00000009ffc +[DDLog allLoggersWithLevel]
  0x0000000a258 +[DDLog log:level:flag:context:file:function:line:tag:format:]
  0x0000000a438 +[DDLog log:level:flag:context:file:function:line:tag:format:args:]
  0x0000000a5f0 +[DDLog log:message:level:flag:context:file:function:line:tag:]
  0x0000000a7e0 +[DDLog log:message:]
  0x0000000a850 +[DDLog flushLog]
  0x0000000a90c +[DDLog isRegisteredClass:]
  0x0000000a964 +[DDLog registeredClasses]
  0x0000000aa64 +[DDLog registeredClassNames]
  0x0000000abb8 +[DDLog levelForClass:]
  0x0000000abf0 +[DDLog levelForClassWithName:]
  0x0000000ac1c +[DDLog setLevel:forClass:]
  0x0000000ac5c +[DDLog setLevel:forClassWithName:]

  // instance methods
  0x0000000998c -[DDLog init]
  0x00000009b30 -[DDLog applicationWillTerminate:]
  0x00000009b84 -[DDLog addLogger:]
  0x00000009bec -[DDLog addLogger:withLevel:]
  0x00000009d10 -[DDLog removeLogger:]
  0x00000009e0c -[DDLog removeAllLoggers]
  0x00000009edc -[DDLog allLoggers]
  0x0000000a040 -[DDLog allLoggersWithLevel]
  0x0000000a148 -[DDLog queueLogMessage:asynchronously:]
  0x0000000a348 -[DDLog log:level:flag:context:file:function:line:tag:format:]
  0x0000000a4fc -[DDLog log:level:flag:context:file:function:line:tag:format:args:]
  0x0000000a6b4 -[DDLog log:message:level:flag:context:file:function:line:tag:]
  0x0000000a840 -[DDLog log:message:]
  0x0000000a880 -[DDLog flushLog]
  0x0000000ac90 -[DDLog lt_addLogger:level:]
  0x0000000afe0 -[DDLog lt_removeLogger:]
  0x0000000b1cc -[DDLog lt_removeAllLoggers]
  0x0000000b37c -[DDLog lt_allLoggers]
  0x0000000b4a4 -[DDLog lt_allLoggersWithLevel]
  0x0000000b5f8 -[DDLog lt_log:]
  0x0000000b908 -[DDLog lt_flush]
  0x0000000bb4c -[DDLog _loggers]
  0x0000000bb54 -[DDLog set_loggers:]


0x00000022298 DDLoggerNode : NSObject /usr/lib/libobjc.A.dylib
 @property  <DDLogger> *logger
 @property  unsigned long level
 @property  NSObject<OS_dispatch_queue> *loggerQueue

  // class methods
  0x0000000bc1c +[DDLoggerNode nodeWithLogger:loggerQueue:level:]

  // instance methods
  0x0000000bb6c -[DDLoggerNode initWithLogger:loggerQueue:level:]
  0x0000000bc90 -[DDLoggerNode dealloc]
  0x0000000bcc4 -[DDLoggerNode logger]
  0x0000000bccc -[DDLoggerNode level]
  0x0000000bcd4 -[DDLoggerNode loggerQueue]


0x00000022270 DDLogMessage : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSString *message
 @property  unsigned long level
 @property  unsigned long flag
 @property  long long context
 @property  NSString *file
 @property  NSString *fileName
 @property  NSString *function
 @property  unsigned long line
 @property  id tag
 @property  id representedObject
 @property  long long options
 @property  NSDate *timestamp
 @property  NSString *threadID
 @property  NSString *threadName
 @property  NSString *queueLabel
 @property  unsigned long qos

  // instance methods
  0x0000000bd0c -[DDLogMessage init]
  0x0000000bd40 -[DDLogMessage initWithMessage:level:flag:context:file:function:line:tag:options:timestamp:]
  0x0000000c030 -[DDLogMessage isEqual:]
  0x0000000c300 -[DDLogMessage copyWithZone:]
  0x0000000c3d8 -[DDLogMessage tag]
  0x0000000c3e0 -[DDLogMessage message]
  0x0000000c3e8 -[DDLogMessage level]
  0x0000000c3f0 -[DDLogMessage flag]
  0x0000000c3f8 -[DDLogMessage context]
  0x0000000c400 -[DDLogMessage file]
  0x0000000c408 -[DDLogMessage fileName]
  0x0000000c410 -[DDLogMessage function]
  0x0000000c418 -[DDLogMessage line]
  0x0000000c420 -[DDLogMessage representedObject]
  0x0000000c428 -[DDLogMessage options]
  0x0000000c430 -[DDLogMessage timestamp]
  0x0000000c438 -[DDLogMessage threadID]
  0x0000000c440 -[DDLogMessage threadName]
  0x0000000c448 -[DDLogMessage queueLabel]
  0x0000000c450 -[DDLogMessage qos]


0x00000022360 DDAbstractLogger : NSObject /usr/lib/libobjc.A.dylib <DDLogger>
 @property  <DDLogFormatter> *logFormatter
 @property  NSObject<OS_dispatch_queue> *loggerQueue
 @property  BOOL onGlobalLoggingQueue
 @property  BOOL onInternalLoggerQueue
 @property  NSString *loggerName
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000000c4e8 -[DDAbstractLogger init]
  0x0000000c5ac -[DDAbstractLogger dealloc]
  0x0000000c5e0 -[DDAbstractLogger logMessage:]
  0x0000000c5e4 -[DDAbstractLogger logFormatter]
  0x0000000c720 -[DDAbstractLogger setLogFormatter:]
  0x0000000c8d8 -[DDAbstractLogger loggerQueue]
  0x0000000c8e0 -[DDAbstractLogger loggerName]
  0x0000000c8f4 -[DDAbstractLogger isOnGlobalLoggingQueue]
  0x0000000c918 -[DDAbstractLogger isOnInternalLoggerQueue]
  0x0000000c934 -[DDAbstractLogger setLoggerQueue:]


0x000000222c0 DDLoggerInformation : NSObject /usr/lib/libobjc.A.dylib
 @property  <DDLogger> *logger
 @property  unsigned long level

  // class methods
  0x0000000c9f0 +[DDLoggerInformation informationWithLogger:andLevel:]

  // instance methods
  0x0000000c970 -[DDLoggerInformation initWithLogger:andLevel:]
  0x0000000ca48 -[DDLoggerInformation logger]
  0x0000000ca50 -[DDLoggerInformation level]


0x000000223d8 DDMultiFormatter : NSObject /usr/lib/libobjc.A.dylib <DDLogFormatter>
 @property  NSArray *formatters
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000000ca64 -[DDMultiFormatter init]
  0x0000000caec -[DDMultiFormatter formatLogMessage:]
  0x0000000cdd0 -[DDMultiFormatter logMessageForLine:originalMessage:]
  0x0000000ce20 -[DDMultiFormatter formatters]
  0x0000000cf10 -[DDMultiFormatter addFormatter:]
  0x0000000cfa0 -[DDMultiFormatter removeFormatter:]
  0x0000000d030 -[DDMultiFormatter removeAllFormatters]
  0x0000000d094 -[DDMultiFormatter isFormattingWithFormatter:]


0x00000022428 DDOSLogger : DDAbstractLogger <DDLogger>
 @property  NSString *subsystem
 @property  NSString *category
 @property  NSObject<OS_os_log> *logger
 @property  <DDLogFormatter> *logFormatter
 @property  NSObject<OS_dispatch_queue> *loggerQueue
 @property  NSString *loggerName
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000000d278 +[DDOSLogger sharedInstance]

  // instance methods
  0x0000000d1ac -[DDOSLogger initWithSubsystem:category:]
  0x0000000d26c -[DDOSLogger init]
  0x0000000d318 -[DDOSLogger getLogger]
  0x0000000d3e8 -[DDOSLogger logger]
  0x0000000d438 -[DDOSLogger loggerName]
  0x0000000d448 -[DDOSLogger logMessage:]
  0x0000000d5ec -[DDOSLogger subsystem]
  0x0000000d5fc -[DDOSLogger category]
  0x0000000d60c -[DDOSLogger setLogger:]


0x00000022478 DDTTYLogger : DDAbstractLogger <DDLogger>
 @property  BOOL colorsEnabled
 @property  BOOL automaticallyAppendNewlineForCustomFormatters
 @property  <DDLogFormatter> *logFormatter
 @property  NSObject<OS_dispatch_queue> *loggerQueue
 @property  NSString *loggerName
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000000d68c +[DDTTYLogger initialize_colors_16]
  0x0000000d968 +[DDTTYLogger initialize_colors_256]
  0x0000000dba4 +[DDTTYLogger getRed:green:blue:fromColor:]
  0x0000000dc08 +[DDTTYLogger codeIndexForColor:]
  0x0000000dda0 +[DDTTYLogger sharedInstance]

  // instance methods
  0x0000000dee4 -[DDTTYLogger init]
  0x0000000e154 -[DDTTYLogger loggerName]
  0x0000000e164 -[DDTTYLogger loadDefaultColorProfiles]
  0x0000000e220 -[DDTTYLogger colorsEnabled]
  0x0000000e360 -[DDTTYLogger setColorsEnabled:]
  0x0000000e4d4 -[DDTTYLogger setForegroundColor:backgroundColor:forFlag:]
  0x0000000e4dc -[DDTTYLogger setForegroundColor:backgroundColor:forFlag:context:]
  0x0000000e88c -[DDTTYLogger setForegroundColor:backgroundColor:forTag:]
  0x0000000eb34 -[DDTTYLogger clearColorsForFlag:]
  0x0000000eb3c -[DDTTYLogger clearColorsForFlag:context:]
  0x0000000ede8 -[DDTTYLogger clearColorsForTag:]
  0x0000000ef80 -[DDTTYLogger clearColorsForAllFlags]
  0x0000000f0ec -[DDTTYLogger clearColorsForAllTags]
  0x0000000f258 -[DDTTYLogger clearAllColors]
  0x0000000f3d8 -[DDTTYLogger logMessage:]
  0x0000000f98c -[DDTTYLogger automaticallyAppendNewlineForCustomFormatters]
  0x0000000f99c -[DDTTYLogger setAutomaticallyAppendNewlineForCustomFormatters:]


0x000000224a0 DDTTYLoggerColorProfile : NSObject /usr/lib/libobjc.A.dylib
  // instance methods
  0x0000000fa14 -[DDTTYLoggerColorProfile initWithForegroundColor:backgroundColor:flag:context:]


0x00000000000 01 00 0600 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSArray 
0x00000000000 01 00 0200 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSBundle 
0x00000000000 01 00 0600 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSCalendar 
0x00000000000 01 00 0500 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSColor 
0x00000000000 01 00 0600 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSData 
0x00000000000 01 00 0600 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSDate 
0x00000000000 01 00 0200 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSDateFormatter 
0x00000000000 01 00 0600 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSDictionary 
0x00000000000 01 00 0200 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSFileHandle 
0x00000000000 01 00 0200 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSFileManager 
0x00000000000 01 00 0600 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSLocale 
0x00000000000 01 00 0600 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableArray 
0x00000000000 01 00 0600 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableDictionary 
0x00000000000 01 00 0600 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableSet 
0x00000000000 01 00 0200 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSNotificationCenter 
0x00000000000 01 00 0200 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSNumber 
0x00000000000 01 00 0300 /usr/lib/libobjc.A.dylib: NSObject 
0x00000000000 01 00 0600 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSOutputStream 
0x00000000000 01 00 0200 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSProcessInfo 
0x00000000000 01 00 0200 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSProxy 
0x00000000000 01 00 0200 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSString 
0x00000000000 01 00 0200 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSThread 
0x00000000000 01 00 0600 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSTimeZone 
