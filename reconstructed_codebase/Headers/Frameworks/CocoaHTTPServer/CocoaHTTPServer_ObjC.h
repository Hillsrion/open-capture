@protocol HTTPResponse
  // instance methods
 -[HTTPResponse contentLength]
 -[HTTPResponse offset]
 -[HTTPResponse setOffset:]
 -[HTTPResponse readDataOfLength:]
 -[HTTPResponse isDone]

@optional
  // instance methods
 -[HTTPResponse delayResponseHeaders]
 -[HTTPResponse status]
 -[HTTPResponse httpHeaders]
 -[HTTPResponse isChunked]
 -[HTTPResponse connectionDidClose]

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

@protocol NSNetServiceDelegate <NSObject>
@optional
  // instance methods
 -[NSNetServiceDelegate netServiceWillPublish:]
 -[NSNetServiceDelegate netServiceDidPublish:]
 -[NSNetServiceDelegate netService:didNotPublish:]
 -[NSNetServiceDelegate netServiceWillResolve:]
 -[NSNetServiceDelegate netServiceDidResolveAddress:]
 -[NSNetServiceDelegate netService:didNotResolve:]
 -[NSNetServiceDelegate netServiceDidStop:]
 -[NSNetServiceDelegate netService:didUpdateTXTRecordData:]
 -[NSNetServiceDelegate netService:didAcceptConnectionWithInputStream:outputStream:]

@end

0x00000023b80 PodsDummy_CocoaHTTPServer : NSObject /usr/lib/libobjc.A.dylib

0x00000023ba8 DAVConnection : HTTPConnection
  // instance methods
  0x00000004b30 -[DAVConnection dealloc]
  0x00000004b80 -[DAVConnection supportsMethod:atPath:]
  0x00000004c90 -[DAVConnection expectsRequestBodyFromMethod:atPath:]
  0x00000004d4c -[DAVConnection prepareForBodyWithSize:]
  0x00000004e94 -[DAVConnection processBodyData:]
  0x00000004f38 -[DAVConnection finishBody]
  0x00000004f7c -[DAVConnection finishResponse]
  0x00000004fd0 -[DAVConnection httpResponseForMethod:URI:]


0x00000023bf8 DAVResponse : NSObject /usr/lib/libobjc.A.dylib <HTTPResponse>
  // instance methods
  0x0000000553c -[DAVResponse initWithMethod:headers:bodyData:resourcePath:rootPath:]
  0x00000006cbc -[DAVResponse contentLength]
  0x00000006ccc -[DAVResponse offset]
  0x00000006cd4 -[DAVResponse setOffset:]
  0x00000006cdc -[DAVResponse readDataOfLength:]
  0x00000006d4c -[DAVResponse isDone]
  0x00000006d88 -[DAVResponse status]
  0x00000006d90 -[DAVResponse httpHeaders]


0x00000023c48 DELETEResponse : NSObject /usr/lib/libobjc.A.dylib <HTTPResponse>
  // instance methods
  0x0000000785c -[DELETEResponse initWithFilePath:]
  0x00000007984 -[DELETEResponse contentLength]
  0x0000000798c -[DELETEResponse offset]
  0x00000007994 -[DELETEResponse setOffset:]
  0x00000007998 -[DELETEResponse readDataOfLength:]
  0x000000079a0 -[DELETEResponse isDone]
  0x000000079a8 -[DELETEResponse status]


0x00000023c98 HTTPAsyncFileResponse : NSObject /usr/lib/libobjc.A.dylib <HTTPResponse>
  // instance methods
  0x000000079b0 -[HTTPAsyncFileResponse initWithFilePath:forConnection:]
  0x00000007bb0 -[HTTPAsyncFileResponse abort]
  0x00000007be0 -[HTTPAsyncFileResponse processReadBuffer]
  0x00000007c30 -[HTTPAsyncFileResponse pauseReadSource]
  0x00000007c4c -[HTTPAsyncFileResponse resumeReadSource]
  0x00000007c64 -[HTTPAsyncFileResponse cancelReadSource]
  0x00000007ca4 -[HTTPAsyncFileResponse openFileAndSetupReadSource]
  0x00000008040 -[HTTPAsyncFileResponse openFileIfNeeded]
  0x00000008068 -[HTTPAsyncFileResponse contentLength]
  0x00000008070 -[HTTPAsyncFileResponse offset]
  0x00000008078 -[HTTPAsyncFileResponse setOffset:]
  0x00000008160 -[HTTPAsyncFileResponse readDataOfLength:]
  0x0000000821c -[HTTPAsyncFileResponse isDone]
  0x0000000822c -[HTTPAsyncFileResponse filePath]
  0x00000008234 -[HTTPAsyncFileResponse isAsynchronous]
  0x0000000823c -[HTTPAsyncFileResponse connectionDidClose]
  0x000000082d0 -[HTTPAsyncFileResponse dealloc]


0x00000023ce8 HTTPAuthenticationRequest : NSObject /usr/lib/libobjc.A.dylib
  // instance methods
  0x00000008358 -[HTTPAuthenticationRequest initWithRequest:]
  0x00000008684 -[HTTPAuthenticationRequest isBasic]
  0x0000000868c -[HTTPAuthenticationRequest isDigest]
  0x00000008694 -[HTTPAuthenticationRequest base64Credentials]
  0x0000000869c -[HTTPAuthenticationRequest username]
  0x000000086a4 -[HTTPAuthenticationRequest realm]
  0x000000086ac -[HTTPAuthenticationRequest nonce]
  0x000000086b4 -[HTTPAuthenticationRequest uri]
  0x000000086bc -[HTTPAuthenticationRequest qop]
  0x000000086c4 -[HTTPAuthenticationRequest nc]
  0x000000086cc -[HTTPAuthenticationRequest cnonce]
  0x000000086d4 -[HTTPAuthenticationRequest response]
  0x000000086dc -[HTTPAuthenticationRequest quotedSubHeaderFieldValue:fromHeaderFieldValue:]
  0x000000087c4 -[HTTPAuthenticationRequest nonquotedSubHeaderFieldValue:fromHeaderFieldValue:]


0x00000023d38 HTTPConnection : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000008964 +[HTTPConnection initialize]
  0x000000089d8 +[HTTPConnection generateNonce]
  0x00000008b70 +[HTTPConnection hasRecentNonce:]

  // instance methods
  0x00000008cc8 -[HTTPConnection initWithAsyncSocket:configuration:]
  0x00000008df0 -[HTTPConnection dealloc]
  0x00000008e64 -[HTTPConnection supportsMethod:atPath:]
  0x00000008ec0 -[HTTPConnection expectsRequestBodyFromMethod:atPath:]
  0x00000008f1c -[HTTPConnection isSecureServer]
  0x00000008f24 -[HTTPConnection sslIdentityAndCertificates]
  0x00000008f2c -[HTTPConnection isPasswordProtected:]
  0x00000008f34 -[HTTPConnection useDigestAccessAuthentication]
  0x00000008f3c -[HTTPConnection realm]
  0x00000008f48 -[HTTPConnection passwordForUser:]
  0x00000008f50 -[HTTPConnection isAuthenticated]
  0x00000009514 -[HTTPConnection addDigestAuthChallenge:]
  0x000000095d0 -[HTTPConnection addBasicAuthChallenge:]
  0x0000000966c -[HTTPConnection start]
  0x00000009708 -[HTTPConnection stop]
  0x00000009794 -[HTTPConnection startConnection]
  0x0000000988c -[HTTPConnection startReadingRequest]
  0x000000098dc -[HTTPConnection parseParams:]
  0x00000009ab4 -[HTTPConnection parseGetParams]
  0x00000009b58 -[HTTPConnection parseRangeRequest:withContentLength:]
  0x00000009fac -[HTTPConnection requestURI]
  0x0000000a000 -[HTTPConnection replyToHTTPRequest]
  0x0000000a240 -[HTTPConnection newUniRangeResponse:]
  0x0000000a37c -[HTTPConnection newMultiRangeResponse:]
  0x0000000a6b0 -[HTTPConnection chunkedTransferSizeLineForLength:]
  0x0000000a714 -[HTTPConnection chunkedTransferFooter]
  0x0000000a724 -[HTTPConnection sendResponseHeadersAndBody]
  0x0000000aca8 -[HTTPConnection writeQueueSize]
  0x0000000ad28 -[HTTPConnection continueSendingStandardResponseBody]
  0x0000000aed4 -[HTTPConnection continueSendingSingleRangeResponseBody]
  0x0000000affc -[HTTPConnection continueSendingMultiRangeResponseBody]
  0x0000000b278 -[HTTPConnection directoryIndexFileNames]
  0x0000000b2b0 -[HTTPConnection filePathForURI:]
  0x0000000b2b8 -[HTTPConnection filePathForURI:allowDirectory:]
  0x0000000b75c -[HTTPConnection httpResponseForMethod:URI:]
  0x0000000b818 -[HTTPConnection webSocketForURI:]
  0x0000000b820 -[HTTPConnection prepareForBodyWithSize:]
  0x0000000b824 -[HTTPConnection processBodyData:]
  0x0000000b828 -[HTTPConnection finishBody]
  0x0000000b82c -[HTTPConnection handleVersionNotSupported:]
  0x0000000b944 -[HTTPConnection handleAuthenticationFailed]
  0x0000000ba04 -[HTTPConnection handleInvalidRequest:]
  0x0000000bb18 -[HTTPConnection handleUnknownMethod:]
  0x0000000bc48 -[HTTPConnection handleResourceNotFound]
  0x0000000bce0 -[HTTPConnection dateAsString:]
  0x0000000be18 -[HTTPConnection preprocessResponse:]
  0x0000000bf8c -[HTTPConnection preprocessErrorResponse:]
  0x0000000c100 -[HTTPConnection socket:didReadData:withTag:]
  0x0000000c8c0 -[HTTPConnection socket:didWriteDataWithTag:]
  0x0000000ca24 -[HTTPConnection socketDidDisconnect:withError:]
  0x0000000ca50 -[HTTPConnection responseHasAvailableData:]
  0x0000000cc54 -[HTTPConnection responseDidAbort:]
  0x0000000cdcc -[HTTPConnection finishResponse]
  0x0000000ce20 -[HTTPConnection shouldDie]
  0x0000000cf24 -[HTTPConnection die]


0x00000023d88 HTTPConfig : NSObject /usr/lib/libobjc.A.dylib
 @property  HTTPServer *server
 @property  NSString *documentRoot
 @property  ^{dispatch_queue_s=} queue

  // instance methods
  0x0000000d018 -[HTTPConfig initWithServer:documentRoot:]
  0x0000000d0b0 -[HTTPConfig initWithServer:documentRoot:queue:]
  0x0000000d1a4 -[HTTPConfig dealloc]
  0x0000000d1d8 -[HTTPConfig server]
  0x0000000d1f0 -[HTTPConfig documentRoot]
  0x0000000d1f8 -[HTTPConfig queue]


0x00000023dd8 HTTPDataResponse : NSObject /usr/lib/libobjc.A.dylib <HTTPResponse>
  // instance methods
  0x0000000d22c -[HTTPDataResponse initWithData:]
  0x0000000d2a8 -[HTTPDataResponse dealloc]
  0x0000000d2dc -[HTTPDataResponse contentLength]
  0x0000000d2e4 -[HTTPDataResponse offset]
  0x0000000d2ec -[HTTPDataResponse setOffset:]
  0x0000000d2f4 -[HTTPDataResponse readDataOfLength:]
  0x0000000d354 -[HTTPDataResponse isDone]


0x00000023e28 HTTPDynamicFileResponse : HTTPAsyncFileResponse
  // instance methods
  0x0000000d388 -[HTTPDynamicFileResponse initWithFilePath:forConnection:separator:replacementDictionary:]
  0x0000000d460 -[HTTPDynamicFileResponse isChunked]
  0x0000000d468 -[HTTPDynamicFileResponse contentLength]
  0x0000000d470 -[HTTPDynamicFileResponse setOffset:]
  0x0000000d474 -[HTTPDynamicFileResponse isDone]
  0x0000000d4c0 -[HTTPDynamicFileResponse processReadBuffer]
  0x0000000d8b4 -[HTTPDynamicFileResponse dealloc]


0x00000023e78 HTTPFileResponse : NSObject /usr/lib/libobjc.A.dylib <HTTPResponse>
  // instance methods
  0x0000000d928 -[HTTPFileResponse initWithFilePath:forConnection:]
  0x0000000db40 -[HTTPFileResponse abort]
  0x0000000db70 -[HTTPFileResponse openFile]
  0x0000000dc44 -[HTTPFileResponse openFileIfNeeded]
  0x0000000dc6c -[HTTPFileResponse contentLength]
  0x0000000dc74 -[HTTPFileResponse offset]
  0x0000000dc7c -[HTTPFileResponse setOffset:]
  0x0000000dd64 -[HTTPFileResponse readDataOfLength:]
  0x0000000df20 -[HTTPFileResponse isDone]
  0x0000000df30 -[HTTPFileResponse filePath]
  0x0000000df38 -[HTTPFileResponse dealloc]


0x00000023ec8 HTTPMessage : NSObject /usr/lib/libobjc.A.dylib
  // instance methods
  0x0000000dfc4 -[HTTPMessage initEmptyRequest]
  0x0000000e01c -[HTTPMessage initRequestWithMethod:URL:version:]
  0x0000000e0cc -[HTTPMessage initResponseWithStatusCode:description:version:]
  0x0000000e168 -[HTTPMessage dealloc]
  0x0000000e1b4 -[HTTPMessage appendData:]
  0x0000000e21c -[HTTPMessage isHeaderComplete]
  0x0000000e23c -[HTTPMessage version]
  0x0000000e254 -[HTTPMessage method]
  0x0000000e26c -[HTTPMessage url]
  0x0000000e284 -[HTTPMessage statusCode]
  0x0000000e28c -[HTTPMessage allHeaderFields]
  0x0000000e2a4 -[HTTPMessage headerField:]
  0x0000000e2c0 -[HTTPMessage setHeaderField:value:]
  0x0000000e2d0 -[HTTPMessage messageData]
  0x0000000e2e8 -[HTTPMessage body]
  0x0000000e300 -[HTTPMessage setBody:]


0x00000023f18 HTTPRedirectResponse : NSObject /usr/lib/libobjc.A.dylib <HTTPResponse>
  // instance methods
  0x0000000e30c -[HTTPRedirectResponse initWithPath:]
  0x0000000e384 -[HTTPRedirectResponse contentLength]
  0x0000000e38c -[HTTPRedirectResponse offset]
  0x0000000e394 -[HTTPRedirectResponse setOffset:]
  0x0000000e398 -[HTTPRedirectResponse readDataOfLength:]
  0x0000000e3a0 -[HTTPRedirectResponse isDone]
  0x0000000e3a8 -[HTTPRedirectResponse httpHeaders]
  0x0000000e3c4 -[HTTPRedirectResponse status]
  0x0000000e3cc -[HTTPRedirectResponse dealloc]


0x00000023f68 HTTPServer : NSObject /usr/lib/libobjc.A.dylib <NSNetServiceDelegate>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000010314 +[HTTPServer startBonjourThreadIfNeeded]
  0x000000103d4 +[HTTPServer bonjourThread]
  0x00000010478 +[HTTPServer executeBonjourBlock:]
  0x00000010484 +[HTTPServer performBonjourBlock:]

  // instance methods
  0x0000000e40c -[HTTPServer init]
  0x0000000e5dc -[HTTPServer dealloc]
  0x0000000e65c -[HTTPServer documentRoot]
  0x0000000e73c -[HTTPServer setDocumentRoot:]
  0x0000000e8bc -[HTTPServer connectionClass]
  0x0000000e968 -[HTTPServer setConnectionClass:]
  0x0000000e9cc -[HTTPServer interface]
  0x0000000ea94 -[HTTPServer setInterface:]
  0x0000000eb24 -[HTTPServer port]
  0x0000000ebc4 -[HTTPServer listeningPort]
  0x0000000ec94 -[HTTPServer setPort:]
  0x0000000ed00 -[HTTPServer domain]
  0x0000000edc8 -[HTTPServer setDomain:]
  0x0000000ee58 -[HTTPServer name]
  0x0000000ef20 -[HTTPServer publishedName]
  0x0000000f0d0 -[HTTPServer setName:]
  0x0000000f160 -[HTTPServer type]
  0x0000000f228 -[HTTPServer setType:]
  0x0000000f2b8 -[HTTPServer TXTRecordDictionary]
  0x0000000f380 -[HTTPServer setTXTRecordDictionary:]
  0x0000000f50c -[HTTPServer start:]
  0x0000000f7f8 -[HTTPServer stop]
  0x0000000f800 -[HTTPServer stop:]
  0x0000000fa68 -[HTTPServer isRunning]
  0x0000000fb08 -[HTTPServer addWebSocket:]
  0x0000000fb5c -[HTTPServer numberOfHTTPConnections]
  0x0000000fb98 -[HTTPServer numberOfWebSocketConnections]
  0x0000000fbd4 -[HTTPServer config]
  0x0000000fc0c -[HTTPServer socket:didAcceptNewSocket:]
  0x0000000fcac -[HTTPServer publishBonjour]
  0x0000000ff28 -[HTTPServer unpublishBonjour]
  0x0000000ffe0 -[HTTPServer republishBonjour]
  0x00000010060 -[HTTPServer netServiceDidPublish:]
  0x00000010138 -[HTTPServer netService:didNotPublish:]
  0x0000001022c -[HTTPServer connectionDidDie:]
  0x000000102a0 -[HTTPServer webSocketDidDie:]


0x00000023fb8 MultipartFormDataParser : NSObject /usr/lib/libobjc.A.dylib
 @property  id delegate
 @property  unsigned long formEncoding

  // class methods
  0x000000114ac +[MultipartFormDataParser decodedDataFromData:encoding:]
  0x00000011530 +[MultipartFormDataParser decodedDataFromQuotedPrintableData:]

  // instance methods
  0x00000010594 -[MultipartFormDataParser initWithBoundary:formEncoding:]
  0x000000106dc -[MultipartFormDataParser appendData:]
  0x00000010f50 -[MultipartFormDataParser offsetTillNewlineSinceOffset:inData:]
  0x00000010fd8 -[MultipartFormDataParser processPreamble:]
  0x00000011268 -[MultipartFormDataParser findHeaderEnd:fromOffset:]
  0x000000112fc -[MultipartFormDataParser findContentEnd:fromOffset:]
  0x000000113e0 -[MultipartFormDataParser numberOfBytesToLeavePendingWithData:length:encoding:]
  0x000000116f0 -[MultipartFormDataParser delegate]
  0x00000011708 -[MultipartFormDataParser setDelegate:]
  0x00000011714 -[MultipartFormDataParser formEncoding]
  0x0000001171c -[MultipartFormDataParser setFormEncoding:]


0x00000024008 MultipartMessageHeader : NSObject /usr/lib/libobjc.A.dylib
 @property  NSDictionary *fields
 @property  int encoding

  // instance methods
  0x00000011768 -[MultipartMessageHeader initWithData:formEncoding:]
  0x00000011a10 -[MultipartMessageHeader fields]
  0x00000011a1c -[MultipartMessageHeader encoding]


0x00000024080 MultipartMessageHeaderField : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *value
 @property  NSDictionary *params
 @property  NSString *name

  // instance methods
  0x00000011a54 -[MultipartMessageHeaderField initWithData:contentEncoding:]
  0x00000011ddc -[MultipartMessageHeaderField parseHeaderValueBytes:length:encoding:]
  0x00000012240 -[MultipartMessageHeaderField name]
  0x0000001224c -[MultipartMessageHeaderField value]
  0x00000012258 -[MultipartMessageHeaderField params]


0x000000240a8 PUTResponse : NSObject /usr/lib/libobjc.A.dylib <HTTPResponse>
  // instance methods
  0x000000122a0 -[PUTResponse initWithFilePath:headers:body:]
  0x000000124c4 -[PUTResponse initWithFilePath:headers:bodyData:]
  0x000000124c8 -[PUTResponse initWithFilePath:headers:bodyFile:]
  0x000000124cc -[PUTResponse contentLength]
  0x000000124d4 -[PUTResponse offset]
  0x000000124dc -[PUTResponse setOffset:]
  0x000000124e0 -[PUTResponse readDataOfLength:]
  0x000000124e8 -[PUTResponse isDone]
  0x000000124f0 -[PUTResponse status]


0x000000240f8 WebSocket : NSObject /usr/lib/libobjc.A.dylib
 @property  id delegate
 @property  ^{dispatch_queue_s=} websocketQueue

  // class methods
  0x000000124f8 +[WebSocket isWebSocketRequest:]
  0x000000125bc +[WebSocket isVersion76Request:]
  0x00000012644 +[WebSocket isRFC6455Request:]

  // instance methods
  0x00000012684 -[WebSocket initWithRequest:socket:]
  0x000000127c8 -[WebSocket dealloc]
  0x00000012820 -[WebSocket delegate]
  0x00000012900 -[WebSocket setDelegate:]
  0x00000012990 -[WebSocket start]
  0x00000012a44 -[WebSocket stop]
  0x00000012ad0 -[WebSocket readRequestBody]
  0x00000012ae4 -[WebSocket originResponseHeaderValue]
  0x00000012ba8 -[WebSocket locationResponseHeaderValue]
  0x00000012cf4 -[WebSocket secWebSocketKeyResponseHeaderValue]
  0x00000012da8 -[WebSocket sendResponseHeaders]
  0x00000012f2c -[WebSocket processKey:]
  0x00000013054 -[WebSocket sendResponseBody:]
  0x00000013198 -[WebSocket didOpen]
  0x00000013200 -[WebSocket sendMessage:]
  0x000000133fc -[WebSocket didReceiveMessage:]
  0x0000001344c -[WebSocket didClose]
  0x000000134b4 -[WebSocket isValidWebSocketFrame:]
  0x000000134d0 -[WebSocket socket:didReadData:withTag:]
  0x000000137f4 -[WebSocket socketDidDisconnect:withError:]
  0x000000137f8 -[WebSocket websocketQueue]


0x00000020690 NSData(DDData)
	// instance methods
	0x00400006dc8 -[NSData(DDData) md5Digest]
	0x00400006e58 -[NSData(DDData) sha1Digest]
	0x00400006ee8 -[NSData(DDData) hexStringValue]
	0x00400006fac -[NSData(DDData) base64Encoded]
	0x00400007168 -[NSData(DDData) base64Decoded]

0x000000206d0 NSNumber(DDNumber)
	// class methods
	0x00400007338 +[NSNumber(DDNumber) parseString:intoSInt64:]
	0x004000073c0 +[NSNumber(DDNumber) parseString:intoUInt64:]
	0x00400007448 +[NSNumber(DDNumber) parseString:intoNSInteger:]
	0x004000074d0 +[NSNumber(DDNumber) parseString:intoNSUInteger:]

0x00000020710 NSValue(NSValueDDRangeExtensions)
	// class methods
	0x00400007778 +[NSValue(NSValueDDRangeExtensions) valueWithDDRange:]

	// instance methods
	0x004000077b4 -[NSValue(NSValueDDRangeExtensions) ddrangeValue]
	0x004000077d8 -[NSValue(NSValueDDRangeExtensions) ddrangeCompare:]

0x00000000000 01 00 0300 @rpath/CocoaLumberjack.framework/Versions/A/CocoaLumberjack: DDLog 
0x00000000000 01 00 0200 @rpath/CocoaAsyncSocket.framework/Versions/A/CocoaAsyncSocket: GCDAsyncSocket 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSArray 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSCharacterSet 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSData 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSDate 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSDateFormatter 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSDictionary 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSFileManager 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSLocale 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSLock 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableArray 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableData 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableDictionary 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSMutableString 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSNetService 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSNotificationCenter 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSNull 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSNumber 
0x00000000000 01 00 0800 /usr/lib/libobjc.A.dylib: NSObject 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSOutputStream 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSProcessInfo 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSRunLoop 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSScanner 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSString 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSThread 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSTimeZone 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSTimer 
0x00000000000 01 00 0b00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSURL 
0x00000000000 01 00 0700 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSValue 
