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

@protocol NSURLSessionDelegate <NSObject>
@optional
  // instance methods
 -[NSURLSessionDelegate URLSession:didBecomeInvalidWithError:]
 -[NSURLSessionDelegate URLSession:didReceiveChallenge:completionHandler:]
 -[NSURLSessionDelegate URLSessionDidFinishEventsForBackgroundURLSession:]

@end

@protocol NSURLSessionTaskDelegate <NSURLSessionDelegate>
@optional
  // instance methods
 -[NSURLSessionTaskDelegate URLSession:didCreateTask:]
 -[NSURLSessionTaskDelegate URLSession:task:willBeginDelayedRequest:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:taskIsWaitingForConnectivity:]
 -[NSURLSessionTaskDelegate URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:task:didReceiveChallenge:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:task:needNewBodyStream:]
 -[NSURLSessionTaskDelegate URLSession:task:needNewBodyStreamFromOffset:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:]
 -[NSURLSessionTaskDelegate URLSession:task:didReceiveInformationalResponse:]
 -[NSURLSessionTaskDelegate URLSession:task:didFinishCollectingMetrics:]
 -[NSURLSessionTaskDelegate URLSession:task:didCompleteWithError:]

@end

@protocol NSURLSessionDataDelegate <NSURLSessionTaskDelegate>
@optional
  // instance methods
 -[NSURLSessionDataDelegate URLSession:dataTask:didReceiveResponse:completionHandler:]
 -[NSURLSessionDataDelegate URLSession:dataTask:didBecomeDownloadTask:]
 -[NSURLSessionDataDelegate URLSession:dataTask:didBecomeStreamTask:]
 -[NSURLSessionDataDelegate URLSession:dataTask:didReceiveData:]
 -[NSURLSessionDataDelegate URLSession:dataTask:willCacheResponse:completionHandler:]

@end

@protocol NSURLSessionWebSocketDelegate <NSURLSessionTaskDelegate>
@optional
  // instance methods
 -[NSURLSessionWebSocketDelegate URLSession:webSocketTask:didOpenWithProtocol:]
 -[NSURLSessionWebSocketDelegate URLSession:webSocketTask:didCloseWithCode:reason:]

@end

0x00000048ed8 COSyncCoreHTTPSessionWebSocketTaskCppObjectHolder : NSObject /usr/lib/libobjc.A.dylib
  // instance methods
  0x00000030828 -[COSyncCoreHTTPSessionWebSocketTaskCppObjectHolder .cxx_construct]


0x00000048f28 COSyncCoreHTTPSessionDataTaskDelegate : NSObject /usr/lib/libobjc.A.dylib <NSURLSessionDataDelegate>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000030840 -[COSyncCoreHTTPSessionDataTaskDelegate .cxx_construct]


0x00000048f78 COSyncCoreHTTPSessionWebSocketTaskDelegate : NSObject /usr/lib/libobjc.A.dylib <NSURLSessionWebSocketDelegate>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000030848 -[COSyncCoreHTTPSessionWebSocketTaskDelegate URLSession:webSocketTask:didOpenWithProtocol:]
  0x00000030a44 -[COSyncCoreHTTPSessionWebSocketTaskDelegate URLSession:webSocketTask:didCloseWithCode:reason:]
  0x00000030d94 -[COSyncCoreHTTPSessionWebSocketTaskDelegate URLSession:task:didCompleteWithError:]
  0x00000031034 -[COSyncCoreHTTPSessionWebSocketTaskDelegate .cxx_construct]


0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSBundle 
0x00000000000 01 00 0500 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSData 
0x00000000000 01 00 0500 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSDictionary 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSMutableURLRequest 
0x00000000000 01 00 0200 /usr/lib/libobjc.A.dylib: NSObject 
0x00000000000 01 00 0500 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSRunLoop 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSString 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSThread 
0x00000000000 01 00 0500 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSTimer 
0x00000000000 01 00 0500 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSURL 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSURLSession 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSURLSessionConfiguration 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSURLSessionWebSocketMessage 
