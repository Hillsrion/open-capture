@protocol NSURLSessionDelegate <NSObject>
@optional
  // instance methods
 -[NSURLSessionDelegate URLSession:didBecomeInvalidWithError:]
 -[NSURLSessionDelegate URLSession:didBecomeInvalidWithError:]
 -[NSURLSessionDelegate URLSession:didReceiveChallenge:completionHandler:]
 -[NSURLSessionDelegate URLSession:didReceiveChallenge:completionHandler:]
 -[NSURLSessionDelegate URLSessionDidFinishEventsForBackgroundURLSession:]
 -[NSURLSessionDelegate URLSessionDidFinishEventsForBackgroundURLSession:]

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

@protocol NSURLSessionWebSocketDelegate <NSURLSessionTaskDelegate>
@optional
  // instance methods
 -[NSURLSessionWebSocketDelegate URLSession:webSocketTask:didOpenWithProtocol:]
 -[NSURLSessionWebSocketDelegate URLSession:webSocketTask:didOpenWithProtocol:]
 -[NSURLSessionWebSocketDelegate URLSession:webSocketTask:didCloseWithCode:reason:]
 -[NSURLSessionWebSocketDelegate URLSession:webSocketTask:didCloseWithCode:reason:]

@end

@protocol NSURLSessionTaskDelegate <NSURLSessionDelegate>
@optional
  // instance methods
 -[NSURLSessionTaskDelegate URLSession:didCreateTask:]
 -[NSURLSessionTaskDelegate URLSession:didCreateTask:]
 -[NSURLSessionTaskDelegate URLSession:task:willBeginDelayedRequest:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:task:willBeginDelayedRequest:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:taskIsWaitingForConnectivity:]
 -[NSURLSessionTaskDelegate URLSession:taskIsWaitingForConnectivity:]
 -[NSURLSessionTaskDelegate URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:task:didReceiveChallenge:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:task:didReceiveChallenge:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:task:needNewBodyStream:]
 -[NSURLSessionTaskDelegate URLSession:task:needNewBodyStream:]
 -[NSURLSessionTaskDelegate URLSession:task:needNewBodyStreamFromOffset:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:task:needNewBodyStreamFromOffset:completionHandler:]
 -[NSURLSessionTaskDelegate URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:]
 -[NSURLSessionTaskDelegate URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:]
 -[NSURLSessionTaskDelegate URLSession:task:didReceiveInformationalResponse:]
 -[NSURLSessionTaskDelegate URLSession:task:didReceiveInformationalResponse:]
 -[NSURLSessionTaskDelegate URLSession:task:didFinishCollectingMetrics:]
 -[NSURLSessionTaskDelegate URLSession:task:didFinishCollectingMetrics:]
 -[NSURLSessionTaskDelegate URLSession:task:didCompleteWithError:]
 -[NSURLSessionTaskDelegate URLSession:task:didCompleteWithError:]

@end

0x0000004b198 PodsDummy_SwiftSignalRClient : NSObject /usr/lib/libobjc.A.dylib

0x0000004c2d0 _TtC18SwiftSignalRClient17DefaultHttpClient : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004b220 _TtC18SwiftSignalRClientP33_99825DA413F0D5447A88385D411B9DC432DefaultHttpClientSessionDelegate : NSObject /usr/lib/libobjc.A.dylib <NSURLSessionDelegate>
  // instance methods
  0x00000005694 -[_TtC18SwiftSignalRClientP33_99825DA413F0D5447A88385D411B9DC432DefaultHttpClientSessionDelegate URLSession:didReceiveChallenge:completionHandler:]
  0x000000057bc -[_TtC18SwiftSignalRClientP33_99825DA413F0D5447A88385D411B9DC432DefaultHttpClientSessionDelegate init]


0x0000004c3d8 _TtC18SwiftSignalRClient23DefaultTransportFactory : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004c4c0 _TtC18SwiftSignalRClient17HandshakeProtocol : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004c5e8 _TtC18SwiftSignalRClient14HttpConnection : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004c7f0 _TtC18SwiftSignalRClient27ConnectionTransportDelegate : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004c910 _TtC18SwiftSignalRClient21HttpConnectionOptions : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004caa0 _TtC18SwiftSignalRClient12HttpResponse : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004cb50 _TtC18SwiftSignalRClient13HubConnection : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004cde8 _TtC18SwiftSignalRClientP33_BCC7D37BC150A1E312A2AFABE4B9B5C631HubConnectionConnectionDelegate : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004ced0 _TtC18SwiftSignalRClient17ArgumentExtractor : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004d020 _TtC18SwiftSignalRClient20HubConnectionBuilder : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004d1f8 _TtC18SwiftSignalRClient20HubConnectionOptions : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004d3b0 _TtC18SwiftSignalRClient23ServerInvocationMessage : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004d478 _TtC18SwiftSignalRClient23ClientInvocationMessage : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004d568 _TtC18SwiftSignalRClient17StreamItemMessage : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004d650 _TtC18SwiftSignalRClient17CompletionMessage : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004d728 _TtC18SwiftSignalRClient23StreamInvocationMessage : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004d7f0 _TtC18SwiftSignalRClient23CancelInvocationMessage : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004d8a0 _TtC18SwiftSignalRClient11PingMessage : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004d948 _TtC18SwiftSignalRClient12CloseMessage : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004db08 _TtC18SwiftSignalRClient15JSONHubProtocol : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004dc70 _TtC18SwiftSignalRClient11PrintLogger : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004dd18 _TtC18SwiftSignalRClient10NullLogger : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004ddb8 _TtC18SwiftSignalRClient15FilteringLogger : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004de98 _TtC18SwiftSignalRClient20LongPollingTransport : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004e078 _TtC18SwiftSignalRClient20TransportDescription : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004e120 _TtC18SwiftSignalRClient19NegotiationResponse : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004e1e8 _TtC18SwiftSignalRClient11Redirection : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004e290 _TtC18SwiftSignalRClient24NegotiationPayloadParser : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004e348 _TtC18SwiftSignalRClient23ReconnectableConnection : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004e518 _TtCC18SwiftSignalRClient23ReconnectableConnectionP33_1336F574AC026F4B99A30FBFFAE277DA31ReconnectableConnectionDelegate : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004e6b8 _TtC18SwiftSignalRClient22DefaultReconnectPolicy : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004e760 _TtC18SwiftSignalRClient17NoReconnectPolicy : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004e900 _TtC18SwiftSignalRClient12StreamHandle : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x0000004b858 _TtC18SwiftSignalRClient19WebsocketsTransport : NSObject /usr/lib/libobjc.A.dylib <NSURLSessionWebSocketDelegate>
  // instance methods
  0x00000031a9c -[_TtC18SwiftSignalRClient19WebsocketsTransport URLSession:webSocketTask:didOpenWithProtocol:]
  0x0000003240c -[_TtC18SwiftSignalRClient19WebsocketsTransport URLSession:task:didCompleteWithError:]
  0x000000325c4 -[_TtC18SwiftSignalRClient19WebsocketsTransport URLSession:webSocketTask:didCloseWithCode:reason:]
  0x000000327e4 -[_TtC18SwiftSignalRClient19WebsocketsTransport URLSession:didReceiveChallenge:completionHandler:]
  0x00000032cf0 -[_TtC18SwiftSignalRClient19WebsocketsTransport init]


0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSDateFormatter 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSHTTPURLResponse 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSJSONSerialization 
0x00000000000 01 00 0200 /usr/lib/libobjc.A.dylib: NSObject 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSOperationQueue 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSURLSession 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSURLSessionConfiguration 
0x00000000000 01 00 0300 /usr/lib/libSystem.B.dylib: OS_dispatch_queue 
0x00000000000 01 00 0500 /usr/lib/swift/libswiftCore.dylib: _TtCs12_SwiftObject 
