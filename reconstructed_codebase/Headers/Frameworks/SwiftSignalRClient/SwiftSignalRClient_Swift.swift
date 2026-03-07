 protocol SwiftSignalRClient.Connection // 8 requirements
 protocol SwiftSignalRClient.ConnectionDelegate // 6 requirements
 protocol SwiftSignalRClient.HttpClientProtocol // 3 requirements
 protocol SwiftSignalRClient.HubConnectionDelegate // 5 requirements
 protocol SwiftSignalRClient.HubProtocol // 5 requirements
 protocol SwiftSignalRClient.HubMessage // 1 requirements
 protocol SwiftSignalRClient.Logger // 1 requirements
 protocol SwiftSignalRClient.NegotiationPayload // 0 requirements
 protocol SwiftSignalRClient.ReconnectPolicy // 1 requirements
 protocol SwiftSignalRClient.ServerInvocationHandler // 4 requirements
 protocol SwiftSignalRClient.Transport // 7 requirements
 protocol SwiftSignalRClient.TransportFactory // 1 requirements
 protocol SwiftSignalRClient.TransportDelegate // 3 requirements

 struct SwiftSignalRClient.AnyEncodable {

	// Properties
	let value : Encodable
 }

 struct SwiftSignalRClient.DecodableVoid { }

 class SwiftSignalRClient.DefaultHttpClient : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let options : HttpConnectionOptions
	let session : NSURLSession

	// Swift methods
	0x4f3c  func DefaultHttpClient.get(url:completionHandler:) // method 
	0x4f5c  func DefaultHttpClient.post(url:body:completionHandler:) // method 
	0x4f7c  func DefaultHttpClient.delete(url:completionHandler:) // method 
	0x4fa0  func DefaultHttpClient.sendHttpRequest(url:method:body:completionHandler:) // method 
 }

 class SwiftSignalRClient.DefaultHttpClientSessionDelegate : NSObject /usr/lib/libobjc.A.dylib {

	// Properties
	var authenticationChallengeHandler : AuthChallengeDisposition

	// ObjC -> Swift bridged methods
WARNING: couldn't find address 0x2d0400014618 (0x50400014618) in binary!
	0x5198a  @objc DefaultHttpClientSessionDelegate.(null) <stripped>
WARNING: couldn't find address 0x2d06000145f0 (0x506000145f0) in binary!
	0x25029232840  @objc DefaultHttpClientSessionDelegate.(null) <stripped>
WARNING: couldn't find address 0x666977533a4d4152 (0x7533a4d4152) in binary!
	0x46e65696c43  @objc DefaultHttpClientSessionDelegate.(null) <stripped>

	// Swift methods
 }

 class SwiftSignalRClient.DefaultTransportFactory : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let logger : Logger
	let permittedTransportTypes : TransportType
	var orderOfPreference : TransportType

	// Swift methods
	0x5b24  func DefaultTransportFactory.determineAvailableTypes(availableTransports:) // method 
	0x5c68  func DefaultTransportFactory.buildTransport(type:) // method 
 }

 class SwiftSignalRClient.HandshakeProtocol : _SwiftObject /usr/lib/swift/libswiftCore.dylib {
	// Swift methods
 }

 class SwiftSignalRClient.HttpConnection : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let connectionQueue : OS_dispatch_queue
	let startDispatchGroup : OS_dispatch_group
WARNING: couldn't find address 0x0 (0x0) in binary!
	var url : §o
	let options : HttpConnectionOptions
	let transportFactory : TransportFactory
	let logger : Logger
	var transportDelegate : TransportDelegate
	var state : State
	var transport : Transport
WARNING: couldn't find address 0x0 (0x0) in binary!
	var stopError : 1r
	var delegate : ConnectionDelegate
	var connectionId : String?

	// Swift methods
	0x6c28  func HttpConnection.delegate.getter // getter 
	0x6c74  func HttpConnection.delegate.setter // setter 
	0x6cdc  func HttpConnection.delegate.modify // modifyCoroutine 
	0x6e80  func HttpConnection.connectionId.getter // getter 
	0x6ed4  func HttpConnection.inherentKeepAlive.getter // getter 
	0x77c4  func HttpConnection.start() // method 
	0x7d54  func HttpConnection.negotiate(negotiateUrl:accessToken:negotiateDidComplete:) // method 
	0x8a10  func HttpConnection.startTransport(connectionId:connectionToken:) // method 
	0x8d6c  func HttpConnection.createNegotiateUrl() // method 
	0x90a4  func HttpConnection.createStartUrl(connectionId:) // method 
	0x93e0  func HttpConnection.failOpenWithError(error:changeState:leaveStartDispatchGroup:) // method 
	0x9788  func HttpConnection.send(data:sendDidComplete:) // method 
	0x9be4  func HttpConnection.stop(stopError:) // method 
	0xa2f4  func HttpConnection.transportDidOpen(connectionId:) // method 
	0xa764  func HttpConnection.transportDidReceiveData(_:) // method 
	0xaabc  func HttpConnection.transportDidClose(_:) // method 
	0xb3f4  func HttpConnection.changeState(from:to:) // method 
 }

 class SwiftSignalRClient.ConnectionTransportDelegate : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var connection : HttpConnection
	let connectionId : String?

	// Swift methods
	0xbaec  func ConnectionTransportDelegate.transportDidOpen() // method 
	0xbb30  func ConnectionTransportDelegate.transportDidReceiveData(_:) // method 
	0xbb8c  func ConnectionTransportDelegate.transportDidClose(_:) // method 
 }

 enum SwiftSignalRClient.State {

	// Properties
	case initial  
	case connecting  
	case connected  
	case stopped  
 }

 class SwiftSignalRClient.HttpConnectionOptions : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var headers : [String : String]
	var accessTokenProvider : ()
	var httpClientFactory : HttpClientProtocol
	var skipNegotiationValue : Bool
	var requestTimeout : Double
	var authenticationChallengeHandler : AuthChallengeDisposition
	var callbackQueue : OS_dispatch_queue

	// Swift methods
	0xc714  func HttpConnectionOptions.headers.getter // getter 
	0xc748  func HttpConnectionOptions.headers.setter // setter 
	0xc78c  func HttpConnectionOptions.headers.modify // modifyCoroutine 
	0xc7e4  func HttpConnectionOptions.accessTokenProvider.getter // getter 
	0xc82c  func HttpConnectionOptions.accessTokenProvider.setter // setter 
	0xc87c  func HttpConnectionOptions.accessTokenProvider.modify // modifyCoroutine 
	0xc934  func HttpConnectionOptions.httpClientFactory.getter // getter 
	0xc97c  func HttpConnectionOptions.httpClientFactory.setter // setter 
	0xc9cc  func HttpConnectionOptions.httpClientFactory.modify // modifyCoroutine 
	0xca08  func HttpConnectionOptions.skipNegotiation.getter // getter 
	0xca10  func HttpConnectionOptions.skipNegotiation.setter // setter 
	0xca18  func HttpConnectionOptions.skipNegotiation.modify // modifyCoroutine 
	0xca44  func HttpConnectionOptions.requestTimeout.getter // getter 
	0xca74  func HttpConnectionOptions.requestTimeout.setter // setter 
	0xcab0  func HttpConnectionOptions.requestTimeout.modify // modifyCoroutine 
	0xcaec  func HttpConnectionOptions.authenticationChallengeHandler.getter // getter 
	0xcb38  func HttpConnectionOptions.authenticationChallengeHandler.setter // setter 
	0xcb88  func HttpConnectionOptions.authenticationChallengeHandler.modify // modifyCoroutine 
	0xcbc4  func HttpConnectionOptions.callbackQueue.getter // getter 
	0xcbf4  func HttpConnectionOptions.callbackQueue.setter // setter 
	0xcc38  func HttpConnectionOptions.callbackQueue.modify // modifyCoroutine 
	0xc6e0  class func HttpConnectionOptions.__allocating_init() // init 
 }

 class SwiftSignalRClient.HttpResponse : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let statusCode : Int
WARNING: couldn't find address 0x0 (0x0) in binary!
	let contents : Ñn

	// Swift methods
	0xcef4  class func HttpResponse.__allocating_init(statusCode:contents:) // init 
 }

 class SwiftSignalRClient.HubConnection : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var invocationId : Int
	let hubConnectionQueue : OS_dispatch_queue
	var pendingCalls : ServerInvocationHandler
	var callbacks : ArgumentExtractor
	var handshakeStatus : HandshakeStatus
	let logger : Logger
	var connection : Connection
	var connectionDelegate : HubConnectionConnectionDelegate
	var hubProtocol : HubProtocol
	let keepAliveIntervalInSeconds : Double?
WARNING: couldn't find address 0x0 (0x0) in binary!
	var keepAlivePingTask : …o
	let callbackQueue : OS_dispatch_queue
	var delegate : HubConnectionDelegate

	// Swift methods
	0xcfe8  func HubConnection.delegate.getter // getter 
	0xd02c  func HubConnection.delegate.setter // setter 
	0xd08c  func HubConnection.delegate.modify // modifyCoroutine 
	0xd168  func HubConnection.connectionId.getter // getter 
	0xd37c  class func HubConnection.__allocating_init(connection:hubProtocol:hubConnectionOptions:logger:) // init 
	0xd5d0  func HubConnection.start() // method 
	0xd734  func HubConnection.initiateHandshake() // method 
	0xdae4  func HubConnection.stop() // method 
	0xdbb4  func HubConnection.on(method:callback:) // method 
	0xe024  func HubConnection.send(method:arguments:sendDidComplete:) // method 
	0xe8d8  func HubConnection.invoke(method:arguments:invocationDidComplete:) // method 
	0xe984  func HubConnection.invoke<A>(method:arguments:resultType:invocationDidComplete:) // method 
	0xec50  func HubConnection.stream<A>(method:arguments:streamItemReceived:invocationDidComplete:) // method 
	0xee8c  func HubConnection.cancelStreamInvocation(streamHandle:cancelDidFail:) // method 
	0xfd78  func HubConnection.ensureConnectionStarted(errorHandler:) // method 
	0x10038  func HubConnection.connectionDidReceiveData(data:) // method 
	0x10e88  func HubConnection.handleCompletion(message:) // method 
	0x1135c  func HubConnection.handleStreamItem(message:) // method 
	0x11844  func HubConnection.handleInvocation(message:) // method 
	0x11f58  func HubConnection.connectionDidClose(error:) // method 
	0x127d8  func HubConnection.connectionDidFailToOpen(error:) // method 
	0x12a44  func HubConnection.connectionWillReconnect(error:) // method 
	0x12cb8  func HubConnection.resetKeepAlive() // method 
	0x1324c  func HubConnection.sendKeepAlivePing() // method 
 }

 class SwiftSignalRClient.HubConnectionConnectionDelegate : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var hubConnection : HubConnection

	// Swift methods
 }

 class SwiftSignalRClient.ArgumentExtractor : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let clientInvocationMessage : ClientInvocationMessage

	// Swift methods
	0x13924  func ArgumentExtractor.getArgument<A>(type:) // method 
	0x13944  func ArgumentExtractor.hasMoreArgs() // method 
 }

 enum SwiftSignalRClient.HandshakeStatus {

	// Properties
	case needsHandling : Bool
	case handled  
 }

 class SwiftSignalRClient.HubConnectionBuilder : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	let url : §o
	var hubProtocolFactory : HubProtocol
	let httpConnectionOptions : HttpConnectionOptions
	let hubConnectionOptions : HubConnectionOptions
	var logger : Logger
	var delegate : HubConnectionDelegate
	var reconnectPolicy : ReconnectPolicy
	var permittedTransportTypes : TransportType
	var transportFactory : TransportFactory

	// Swift methods
	0x17964  class func HubConnectionBuilder.__allocating_init(url:) // init 
	0x17b24  func HubConnectionBuilder.withHubProtocol(hubProtocolFactory:) // method 
	0x17b64  func HubConnectionBuilder.withHttpConnectionOptions(configureHttpOptions:) // method 
	0x17b70  func HubConnectionBuilder.withHubConnectionOptions(configureHubConnectionOptions:) // method 
	0x17bb0  func HubConnectionBuilder.withLogging(minLogLevel:) // method 
	0x17c90  func HubConnectionBuilder.withLogging(logger:) // method 
	0x17ca4  func HubConnectionBuilder.withLogging(minLogLevel:logger:) // method 
	0x17dbc  func HubConnectionBuilder.withHubConnectionDelegate(delegate:) // method 
	0x17df8  func HubConnectionBuilder.withAutoReconnect(reconnectPolicy:) // method 
	0x17e7c  func HubConnectionBuilder.withPermittedTransportTypes(_:) // method 
	0x17e90  func HubConnectionBuilder.build() // method 
 }

 class SwiftSignalRClient.HubConnectionOptions : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var keepAliveInterval : Double?
	var callbackQueue : OS_dispatch_queue

	// Swift methods
	0x1e194  func HubConnectionOptions.keepAliveInterval.getter // getter 
	0x1e1c8  func HubConnectionOptions.keepAliveInterval.setter // setter 
	0x1e218  func HubConnectionOptions.keepAliveInterval.modify // modifyCoroutine 
	0x1e254  func HubConnectionOptions.callbackQueue.getter // getter 
	0x1e284  func HubConnectionOptions.callbackQueue.setter // setter 
	0x1e2c8  func HubConnectionOptions.callbackQueue.modify // modifyCoroutine 
	0x1e144  class func HubConnectionOptions.__allocating_init() // init 
 }

 enum SwiftSignalRClient.ProtocolType {

	// Properties
	case Text  
	case Binary  
 }

 enum SwiftSignalRClient.MessageType {

	// Properties
	case Invocation  
	case StreamItem  
	case Completion  
	case StreamInvocation  
	case CancelInvocation  
	case Ping  
	case Close  
 }

 class SwiftSignalRClient.ServerInvocationMessage : _SwiftObject /usr/lib/swift/libswiftCore.dylib, HubMessage {

	// Properties
	let type : MessageType
	let invocationId : String?
	let target : String
	let arguments : [Encodable]
	let streamIds : [String]?

	// Swift methods
	0x1e708  func ServerInvocationMessage.encode(to:) // method 
 }

 class SwiftSignalRClient.ClientInvocationMessage : _SwiftObject /usr/lib/swift/libswiftCore.dylib, HubMessage {

	// Properties
	let type : MessageType
	let target : String
WARNING: couldn't find address 0x0 (0x0) in binary!
	var arguments : ±p

	// Swift methods
	0x1ecd0  class func ClientInvocationMessage.__allocating_init(from:) // init 
	0x1efc8  func ClientInvocationMessage.getArgument<A>(type:) // method 
 }

 class SwiftSignalRClient.StreamItemMessage : _SwiftObject /usr/lib/swift/libswiftCore.dylib, HubMessage {

	// Properties
	let type : MessageType
	let invocationId : String
WARNING: couldn't find address 0x0 (0x0) in binary!
	let container : ™m
	let item : Encodable?

	// Swift methods
	0x1f298  class func StreamItemMessage.__allocating_init(from:) // init 
	0x1f520  class func StreamItemMessage.__allocating_init(invocationId:item:) // init 
	0x1f640  func StreamItemMessage.getItem<A>(_:) // method 
	0x1f810  func StreamItemMessage.encode(to:) // method 
 }

 class SwiftSignalRClient.CompletionMessage : _SwiftObject /usr/lib/swift/libswiftCore.dylib, HubMessage {

	// Properties
	let type : MessageType
	let invocationId : String
	let error : String?
	let hasResult : Bool
WARNING: couldn't find address 0x0 (0x0) in binary!
	let container : em

	// Swift methods
	0x1fd48  class func CompletionMessage.__allocating_init(from:) // init 
	0x20260  class func CompletionMessage.__allocating_init(invocationId:error:) // init 
	0x2035c  func CompletionMessage.getResult<A>(_:) // method 
	0x20568  func CompletionMessage.encode(to:) // method 
 }

 class SwiftSignalRClient.StreamInvocationMessage : _SwiftObject /usr/lib/swift/libswiftCore.dylib, HubMessage {

	// Properties
	let type : MessageType
	let invocationId : String
	let target : String
	let arguments : [Encodable]
	let streamIds : [String]?

	// Swift methods
	0x209f0  func StreamInvocationMessage.encode(to:) // method 
 }

 class SwiftSignalRClient.CancelInvocationMessage : _SwiftObject /usr/lib/swift/libswiftCore.dylib, HubMessage {

	// Properties
	let type : MessageType
	let invocationId : String

	// Swift methods
	0x21044  func CancelInvocationMessage.encode(to:) // method 
 }

 class SwiftSignalRClient.PingMessage : _SwiftObject /usr/lib/swift/libswiftCore.dylib, HubMessage {

	// Properties
	let type : MessageType

	// Swift methods
	0x21360  func PingMessage.encode(to:) // method 
 }

 class SwiftSignalRClient.CloseMessage : _SwiftObject /usr/lib/swift/libswiftCore.dylib, HubMessage {

	// Properties
	var type : MessageType
	let error : String?

	// Swift methods
	0x214cc  func CloseMessage.type.getter // getter 
	0x216f8  class func CloseMessage.__allocating_init(from:) // init 
 }

 enum SwiftSignalRClient.CodingKeys {

	// Properties
	case type  
	case error  
 }

 enum SwiftSignalRClient.CodingKeys {

	// Properties
	case type  
 }

 enum SwiftSignalRClient.CodingKeys {

	// Properties
	case type  
	case invocationId  
 }

 enum SwiftSignalRClient.CodingKeys {

	// Properties
	case type  
	case target  
	case invocationId  
	case arguments  
	case streamIds  
 }

 enum SwiftSignalRClient.CodingKeys {

	// Properties
	case type  
	case invocationId  
	case error  
	case result  
 }

 enum SwiftSignalRClient.CodingKeys {

	// Properties
	case type  
	case invocationId  
	case item  
 }

 enum SwiftSignalRClient.CodingKeys {

	// Properties
	case type  
	case target  
	case invocationId  
	case arguments  
 }

 enum SwiftSignalRClient.CodingKeys {

	// Properties
	case type  
	case target  
	case invocationId  
	case arguments  
	case streamIds  
 }

 class SwiftSignalRClient.JSONHubProtocol : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	let encoder : %i
WARNING: couldn't find address 0x0 (0x0) in binary!
	let decoder : i
	let logger : Logger
	let name : String
	let version : Int
	let type : ProtocolType

	// Swift methods
	0x23024  class func JSONHubProtocol.__allocating_init(logger:encoder:decoder:) // init 
	0x23124  func JSONHubProtocol.parseMessages(input:) // method 
	0x234b4  func JSONHubProtocol.createHubMessage(payload:) // method 
	0x23990  func JSONHubProtocol.getMessageType(payload:) // method 
	0x23b58  func JSONHubProtocol.writeMessage(message:) // method 
	0x23d34  func JSONHubProtocol.createMessageData(message:) // method 
 }

 struct SwiftSignalRClient.MessageTypeHelper {

	// Properties
	let type : MessageType
 }

 enum SwiftSignalRClient.CodingKeys {

	// Properties
	case type  
 }

 enum SwiftSignalRClient.LogLevel {

	// Properties
	case error  
	case warning  
	case info  
	case debug  
 }

 class SwiftSignalRClient.PrintLogger : _SwiftObject /usr/lib/swift/libswiftCore.dylib, Logger {

	// Properties
	let dateFormatter : NSDateFormatter

	// Swift methods
	0x25140  class func PrintLogger.__allocating_init() // init 
	0x255d8  func PrintLogger.log(logLevel:message:) // method 
 }

 class SwiftSignalRClient.NullLogger : _SwiftObject /usr/lib/swift/libswiftCore.dylib, Logger {
	// Swift methods
	0x25130  class func NullLogger.__allocating_init() // init 
	0x25800  func NullLogger.log(logLevel:message:) // method 
 }

 class SwiftSignalRClient.FilteringLogger : _SwiftObject /usr/lib/swift/libswiftCore.dylib, Logger {

	// Properties
	let minLogLevel : LogLevel
	let logger : Logger

	// Swift methods
 }

 class SwiftSignalRClient.LongPollingTransport : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var delegate : TransportDelegate
	let logger : Logger
	let closeQueue : OS_dispatch_queue
	var active : Bool
	var opened : Bool
	var closeCalled : Bool
	var httpClient : HttpClientProtocol
WARNING: couldn't find address 0x0 (0x0) in binary!
	var url : =o
WARNING: couldn't find address 0x0 (0x0) in binary!
	var closeError : 1r
	let inherentKeepAlive : Bool

	// Swift methods
	0x25bd0  func LongPollingTransport.delegate.getter // getter 
	0x25c10  func LongPollingTransport.delegate.setter // setter 
	0x25c60  func LongPollingTransport.delegate.modify // modifyCoroutine 
	0x25ed0  func LongPollingTransport.start(url:options:) // method 
	0x26108  func LongPollingTransport.send(data:sendDidComplete:) // method 
	0x263f8  func LongPollingTransport.close() // method 
	0x26908  func LongPollingTransport.triggerPoll() // method 
	0x26d58  func LongPollingTransport.handlePollResponse(response:error:) // method 
	0x274a0  func LongPollingTransport.getPollUrl() // method 
 }

 class SwiftSignalRClient.TransportDescription : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let transportType : TransportType
	let transferFormats : TransferFormat

	// Swift methods
 }

 class SwiftSignalRClient.NegotiationResponse : _SwiftObject /usr/lib/swift/libswiftCore.dylib, NegotiationPayload {

	// Properties
	let connectionId : String
	let connectionToken : String?
	let version : Int
	let availableTransports : TransportDescription

	// Swift methods
 }

 class SwiftSignalRClient.Redirection : _SwiftObject /usr/lib/swift/libswiftCore.dylib, NegotiationPayload {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	let url : §o
	let accessToken : String

	// Swift methods
 }

 class SwiftSignalRClient.NegotiationPayloadParser : _SwiftObject /usr/lib/swift/libswiftCore.dylib {
	// Swift methods
 }

 class SwiftSignalRClient.ReconnectableConnection : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let connectionQueue : OS_dispatch_queue
	let callbackQueue : OS_dispatch_queue
	let connectionFactory : Connection
	let reconnectPolicy : ReconnectPolicy
	let logger : Logger
	var underlyingConnection : Connection
	var wrappedDelegate : ConnectionDelegate
	var state : State
	var failedAttemptsCount : Int
WARNING: couldn't find address 0x0 (0x0) in binary!
	var reconnectStartTime : h
	var delegate : ConnectionDelegate

	// Swift methods
	0x29e84  func ReconnectableConnection.start() // method 
	0x29ff4  func ReconnectableConnection.send(data:sendDidComplete:) // method 
	0x2a3c8  func ReconnectableConnection.stop(stopError:) // method 
	0x2a554  func ReconnectableConnection.startInternal() // method 
	0x2aaa0  func ReconnectableConnection.changeState(from:to:) // method 
	0x2b058  func ReconnectableConnection.restartConnection(error:) // method 
	0x2c06c  func ReconnectableConnection.updateAndCreateRetryContext(error:) // method 
 }

 class SwiftSignalRClient.ReconnectableConnectionDelegate : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var connection : ReconnectableConnection

	// Swift methods
	0x2c41c  func ReconnectableConnection.ReconnectableConnectionDelegate.connectionDidOpen(connection:) // method 
	0x2c894  func ReconnectableConnection.ReconnectableConnectionDelegate.connectionDidClose(error:) // method 
 }

 enum SwiftSignalRClient.State {

	// Properties
	case disconnected  
	case starting  
	case reconnecting  
	case running  
	case stopping  
 }

 struct SwiftSignalRClient.RetryContext {

	// Properties
	let failedAttemptsCount : Int
WARNING: couldn't find address 0x0 (0x0) in binary!
	let reconnectStartTime : h
WARNING: couldn't find address 0x0 (0x0) in binary!
	let error : Uq
 }

 class SwiftSignalRClient.DefaultReconnectPolicy : _SwiftObject /usr/lib/swift/libswiftCore.dylib, ReconnectPolicy {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	let retryIntervals :  empty-list 

	// Swift methods
	0x2dc54  class func DefaultReconnectPolicy.__allocating_init(retryIntervals:) // init 
	0x2dd50  func DefaultReconnectPolicy.nextAttemptInterval(retryContext:) // method 
 }

 class SwiftSignalRClient.NoReconnectPolicy : _SwiftObject /usr/lib/swift/libswiftCore.dylib, ReconnectPolicy {
	// Swift methods
 }

 class SwiftSignalRClient.InvocationHandler {
 class SwiftSignalRClient.StreamInvocationHandler {
 enum SwiftSignalRClient.SignalRError {

	// Properties
	case webError : (statusCode: Int)
	case hubInvocationError : (message: String)
WARNING: couldn't find address 0x0 (0x0) in binary!
	case serializationError : i
	case invalidOperation : (message: String)
WARNING: couldn't find address 0x0 (0x0) in binary!
	case protocolViolation : i
	case handshakeError : (message: String)
	case invalidNegotiationResponse : (message: String)
	case serverClose : (message: String?)
	case invalidState  
	case hubInvocationCancelled  
	case unknownMessageType  
	case invalidMessage  
	case unsupportedType  
	case connectionIsBeingClosed  
	case noSupportedTransportAvailable  
	case connectionIsReconnecting  
 }

 class SwiftSignalRClient.StreamHandle : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	let invocationId : String

	// Swift methods
 }

 enum SwiftSignalRClient.TransferFormat {

	// Properties
	case text  
	case binary  
 }

 struct SwiftSignalRClient.TransportType {

	// Properties
	let rawValue : Int
 }

 class SwiftSignalRClient.WebsocketsTransport : NSObject /usr/lib/libobjc.A.dylib {

	// Properties
	let logger : Logger
	let dispatchQueue : OS_dispatch_queue
	var urlSession : NSURLSession?
	var webSocketTask : NSURLSessionWebSocketTask?
	var authenticationChallengeHandler : AuthChallengeDisposition
	var isTransportClosed : Bool
	var delegate : TransportDelegate
	let inherentKeepAlive : Bool

	// ObjC -> Swift bridged methods
WARNING: couldn't find address 0x57c400014680 (0x7c400014680) in binary!
	0x57b8  @objc WebsocketsTransport.(null) <stripped>
WARNING: couldn't find address 0x57cc00014660 (0x7cc00014660) in binary!
	0x519b0  @objc WebsocketsTransport.(null) <stripped>
WARNING: couldn't find address 0x2d3600014688 (0x53600014688) in binary!
	0x519b2  @objc WebsocketsTransport.(null) <stripped>
WARNING: couldn't find address 0x38000000c (0x38000000c) in binary!
	0x65cfffcec44  @objc WebsocketsTransport.(null) <stripped>
	0xfffcedd8  @objc WebsocketsTransport. <stripped>
WARNING: couldn't find address 0x474f525029232840 (0x25029232840) in binary!
	0x16e67695374  @objc WebsocketsTransport.(null) <stripped>

	// Swift methods
	0x31230  func WebsocketsTransport.delegate.getter // getter 
	0x3127c  func WebsocketsTransport.delegate.setter // setter 
	0x312d8  func WebsocketsTransport.delegate.modify // modifyCoroutine 
	0x31574  func WebsocketsTransport.start(url:options:) // method 
	0x3191c  func WebsocketsTransport.send(data:sendDidComplete:) // method 
	0x31a34  func WebsocketsTransport.close() // method 
	0x31a7c  func WebsocketsTransport.urlSession(_:webSocketTask:didOpenWithProtocol:) // method 
	0x31cc8  func WebsocketsTransport.handleMessage(message:) // method 
	0x31f78  func WebsocketsTransport.handleError(error:) // method 
	0x32228  func WebsocketsTransport.urlSession(_:task:didCompleteWithError:) // method 
	0x324a4  func WebsocketsTransport.urlSession(_:webSocketTask:didCloseWith:reason:) // method 
	0x32698  func _$s18SwiftSignalRClient19WebsocketsTransportC10urlSession_10didReceive17completionHandlerySo12NSURLSessionC_So28NSURLAuthenticationChallengeCySo0l4AuthN11DispositionV_So15NSURLCredentialCSgtYbctF // method 
	0x3288c  func WebsocketsTransport.markTransportClosed() // method 
	0x32a24  func WebsocketsTransport.convertUrl(url:) // method 
 }

 enum SwiftSignalRClient.WebSocketsTransportError {

	// Properties
	case webSocketClosed : (statusCode: Int, reason: String)
 }

 enum __C.AuthChallengeDisposition { }


