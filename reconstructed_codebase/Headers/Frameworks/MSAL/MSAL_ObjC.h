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

@protocol MSALAccount <NSObject>
 @property  NSString *username
 @property  NSString *identifier
 @property  NSString *environment
 @property  NSDictionary *accountClaims

  // instance methods
 -[MSALAccount username]
 -[MSALAccount identifier]
 -[MSALAccount environment]
 -[MSALAccount accountClaims]

@end

@protocol NSCopying
  // instance methods
 -[NSCopying copyWithZone:]

@end

@protocol MSALAuthenticationSchemeProtocolInternal <NSObject>
  // instance methods
 -[MSALAuthenticationSchemeProtocolInternal createMSIDAuthenticationSchemeWithParams:]
 -[MSALAuthenticationSchemeProtocolInternal getSchemeParameters:]
 -[MSALAuthenticationSchemeProtocolInternal getAuthorizationHeader:]
 -[MSALAuthenticationSchemeProtocolInternal getClientAccessToken:popManager:error:]

@end

@protocol MSALAuthenticationSchemeProtocol <NSObject>
 @property  unsigned long scheme
 @property  NSString *authenticationScheme

  // instance methods
 -[MSALAuthenticationSchemeProtocol scheme]
 -[MSALAuthenticationSchemeProtocol authenticationScheme]

@end

@protocol MSALJsonSerializable <NSObject>
  // instance methods
 -[MSALJsonSerializable jsonString]

@end

@protocol MSALJsonDeserializable <NSObject>
  // instance methods
 -[MSALJsonDeserializable initWithJsonString:error:]

@end

@protocol MSIDTelemetryEventsObserving <NSObject>
  // instance methods
 -[MSIDTelemetryEventsObserving onEventsReceived:]

@end

@protocol MSIDMacTokenCacheDelegate <NSObject>
  // instance methods
 -[MSIDMacTokenCacheDelegate willAccessCache:]
 -[MSIDMacTokenCacheDelegate didAccessCache:]
 -[MSIDMacTokenCacheDelegate willWriteCache:]
 -[MSIDMacTokenCacheDelegate didWriteCache:]

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

@protocol MSIDJsonSerializable <NSObject>
  // instance methods
 -[MSIDJsonSerializable initWithJSONDictionary:error:]
 -[MSIDJsonSerializable jsonDictionary]

@end

@protocol MSIDRefreshableToken <NSObject>
 @property  NSString *refreshToken
 @property  NSString *familyId

  // instance methods
 -[MSIDRefreshableToken refreshToken]
 -[MSIDRefreshableToken familyId]

@end

@protocol MSIDRequestControlling <NSObject>
  // instance methods
 -[MSIDRequestControlling acquireToken:]

@end

@protocol NSCopying
  // instance methods
 -[NSCopying copyWithZone:]

@end

@protocol MSIDKeyGenerator <NSObject>
  // instance methods
 -[MSIDKeyGenerator generateCacheKey]

@end

@protocol MSIDIntuneCacheDataSource <NSObject>
  // instance methods
 -[MSIDIntuneCacheDataSource jsonDictionaryForKey:]
 -[MSIDIntuneCacheDataSource setJsonDictionary:forKey:]
 -[MSIDIntuneCacheDataSource removeObjectForKey:]

@end

@protocol MSIDResponseSerialization <NSObject>
  // instance methods
 -[MSIDResponseSerialization responseObjectForResponse:data:context:error:]

@end

@protocol MSIDTelemetryStringSerializable <NSObject>
  // instance methods
 -[MSIDTelemetryStringSerializable telemetryString]

@end

@protocol MSIDAssymetricKeyGenerating <NSObject>
  // instance methods
 -[MSIDAssymetricKeyGenerating generateKeyPairForAttributes:error:]
 -[MSIDAssymetricKeyGenerating readOrGenerateKeyPairForAttributes:error:]
 -[MSIDAssymetricKeyGenerating readKeyPairForAttributes:error:]
 -[MSIDAssymetricKeyGenerating generateEphemeralKeyPair:]
 -[MSIDAssymetricKeyGenerating deleteItemWithAttributes:error:]

@end

@protocol MSIDHttpRequestErrorHandling <NSObject>
  // instance methods
 -[MSIDHttpRequestErrorHandling handleError:httpResponse:data:httpRequest:responseSerializer:externalSSOContext:context:completionBlock:]

@end

@protocol MSIDCacheItemSerializing <NSObject>
  // instance methods
 -[MSIDCacheItemSerializing serializeCredentialCacheItem:]
 -[MSIDCacheItemSerializing deserializeCredentialCacheItem:]
 -[MSIDCacheItemSerializing serializeCredentialStorageItem:]
 -[MSIDCacheItemSerializing deserializeCredentialStorageItem:]

@end

@protocol MSIDExtendedCacheItemSerializing <MSIDCacheItemSerializing>
  // instance methods
 -[MSIDExtendedCacheItemSerializing serializeCacheItem:]
 -[MSIDExtendedCacheItemSerializing deserializeCacheItem:ofClass:]

@end

@protocol ASAuthorizationControllerPresentationContextProviding <NSObject>
  // instance methods
 -[ASAuthorizationControllerPresentationContextProviding presentationAnchorForAuthorizationController:]

@end

@protocol ASAuthorizationControllerDelegate <NSObject>
@optional
  // instance methods
 -[ASAuthorizationControllerDelegate authorizationController:didCompleteWithAuthorization:]
 -[ASAuthorizationControllerDelegate authorizationController:didCompleteWithError:]
 -[ASAuthorizationControllerDelegate authorizationController:didCompleteWithCustomMethod:]

@end

@protocol MSIDHttpRequestConfiguratorProtocol <NSObject>
  // instance methods
 -[MSIDHttpRequestConfiguratorProtocol configure:]

@end

@protocol NSWindowDelegate <NSObject>
@optional
  // instance methods
 -[NSWindowDelegate windowShouldClose:]
 -[NSWindowDelegate windowWillReturnFieldEditor:toObject:]
 -[NSWindowDelegate windowWillResize:toSize:]
 -[NSWindowDelegate windowWillUseStandardFrame:defaultFrame:]
 -[NSWindowDelegate windowShouldZoom:toFrame:]
 -[NSWindowDelegate windowWillReturnUndoManager:]
 -[NSWindowDelegate window:willPositionSheet:usingRect:]
 -[NSWindowDelegate window:shouldPopUpDocumentPathMenu:]
 -[NSWindowDelegate window:shouldDragDocumentWithEvent:from:withPasteboard:]
 -[NSWindowDelegate window:willUseFullScreenContentSize:]
 -[NSWindowDelegate window:willUseFullScreenPresentationOptions:]
 -[NSWindowDelegate customWindowsToEnterFullScreenForWindow:]
 -[NSWindowDelegate window:startCustomAnimationToEnterFullScreenWithDuration:]
 -[NSWindowDelegate windowDidFailToEnterFullScreen:]
 -[NSWindowDelegate customWindowsToExitFullScreenForWindow:]
 -[NSWindowDelegate window:startCustomAnimationToExitFullScreenWithDuration:]
 -[NSWindowDelegate customWindowsToEnterFullScreenForWindow:onScreen:]
 -[NSWindowDelegate window:startCustomAnimationToEnterFullScreenOnScreen:withDuration:]
 -[NSWindowDelegate windowDidFailToExitFullScreen:]
 -[NSWindowDelegate window:willResizeForVersionBrowserWithMaxPreferredSize:maxAllowedSize:]
 -[NSWindowDelegate window:willEncodeRestorableState:]
 -[NSWindowDelegate window:didDecodeRestorableState:]
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

@protocol MSIDCacheAccessor <NSObject>
  // instance methods
 -[MSIDCacheAccessor saveTokensWithConfiguration:response:factory:context:error:]
 -[MSIDCacheAccessor saveSSOStateWithConfiguration:response:factory:context:error:]
 -[MSIDCacheAccessor getRefreshTokenWithAccount:familyId:configuration:context:error:]
 -[MSIDCacheAccessor getPrimaryRefreshTokenWithAccount:familyId:configuration:context:error:]
 -[MSIDCacheAccessor accountsWithAuthority:clientId:familyId:accountIdentifier:context:error:]
 -[MSIDCacheAccessor clearWithContext:error:]
 -[MSIDCacheAccessor allTokensWithContext:error:]
 -[MSIDCacheAccessor clearCacheForAccount:authority:clientId:familyId:context:error:]
 -[MSIDCacheAccessor validateAndRemoveRefreshToken:context:error:]
 -[MSIDCacheAccessor validateAndRemovePrimaryRefreshToken:context:error:]
 -[MSIDCacheAccessor removeAccessToken:context:error:]

@end

@protocol MSIDLegacyCredentialCacheCompatible <NSObject>
  // instance methods
 -[MSIDLegacyCredentialCacheCompatible initWithLegacyTokenCacheItem:]
 -[MSIDLegacyCredentialCacheCompatible legacyTokenCacheItem]

@end

@protocol MSIDAuthorityResolving <NSObject>
  // instance methods
 -[MSIDAuthorityResolving resolveAuthority:userPrincipalName:validate:context:completionBlock:]

@end

@protocol MSIDChallengeHandling
  // class methods
 +[MSIDChallengeHandling handleChallenge:webview:context:completionHandler:]
 +[MSIDChallengeHandling resetHandler]

@end

@protocol MSIDRequestSerialization <NSObject>
  // instance methods
 -[MSIDRequestSerialization serializeWithRequest:parameters:headers:]

@end

@protocol MSIDWebviewInteracting
  // instance methods
 -[MSIDWebviewInteracting startWithCompletionHandler:]
 -[MSIDWebviewInteracting cancelProgrammatically]
 -[MSIDWebviewInteracting dismiss]
 -[MSIDWebviewInteracting userCancel]
 -[MSIDWebviewInteracting startURL]

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

@protocol MSIDTokenRequestProviding <NSObject>
  // instance methods
 -[MSIDTokenRequestProviding interactiveTokenRequestWithParameters:]
 -[MSIDTokenRequestProviding silentTokenRequestWithParameters:forceRefresh:]
 -[MSIDTokenRequestProviding brokerTokenRequestWithParameters:brokerKey:brokerApplicationToken:sdkCapabilities:error:]
 -[MSIDTokenRequestProviding interactiveSSOExtensionTokenRequestWithParameters:]
 -[MSIDTokenRequestProviding silentSSOExtensionTokenRequestWithParameters:forceRefresh:]

@end

@protocol MSIDHttpRequestServerTelemetryHandling <NSObject>
  // instance methods
 -[MSIDHttpRequestServerTelemetryHandling handleError:context:]
 -[MSIDHttpRequestServerTelemetryHandling handleError:errorString:context:]
 -[MSIDHttpRequestServerTelemetryHandling setTelemetryToRequest:]

@end

@protocol MSIDTokenCacheDataSource <NSObject>
  // instance methods
 -[MSIDTokenCacheDataSource saveToken:key:serializer:context:error:]
 -[MSIDTokenCacheDataSource tokenWithKey:serializer:context:error:]
 -[MSIDTokenCacheDataSource tokensWithKey:serializer:context:error:]
 -[MSIDTokenCacheDataSource saveWipeInfoWithContext:error:]
 -[MSIDTokenCacheDataSource wipeInfo:error:]
 -[MSIDTokenCacheDataSource removeTokensWithKey:context:error:]
 -[MSIDTokenCacheDataSource clearWithContext:error:]

@end

@protocol MSIDThumbprintCalculatable <NSObject>
 @property  NSString *fullRequestThumbprint
 @property  NSString *strictRequestThumbprint

  // class methods
 +[MSIDThumbprintCalculatable fullRequestThumbprintExcludeParams]
 +[MSIDThumbprintCalculatable strictRequestThumbprintIncludeParams]

  // instance methods
 -[MSIDThumbprintCalculatable fullRequestThumbprint]
 -[MSIDThumbprintCalculatable strictRequestThumbprint]

@end

@protocol MSIDHttpRequestProtocol <NSObject>
 @property  long long retryCounter
 @property  double retryInterval
 @property  NSURLRequest *urlRequest

  // instance methods
 -[MSIDHttpRequestProtocol sendWithBlock:]
 -[MSIDHttpRequestProtocol retryCounter]
 -[MSIDHttpRequestProtocol setRetryCounter:]
 -[MSIDHttpRequestProtocol retryInterval]
 -[MSIDHttpRequestProtocol setRetryInterval:]
 -[MSIDHttpRequestProtocol urlRequest]
 -[MSIDHttpRequestProtocol setUrlRequest:]

@end

@protocol MSIDRequestContext
  // instance methods
 -[MSIDRequestContext correlationId]
 -[MSIDRequestContext logComponent]
 -[MSIDRequestContext telemetryRequestId]
 -[MSIDRequestContext appRequestMetadata]

@end

@protocol MSIDMetadataCacheDataSource <NSObject>
  // instance methods
 -[MSIDMetadataCacheDataSource saveAccountMetadata:key:serializer:context:error:]
 -[MSIDMetadataCacheDataSource accountMetadataWithKey:serializer:context:error:]
 -[MSIDMetadataCacheDataSource accountsMetadataWithKey:serializer:context:error:]
 -[MSIDMetadataCacheDataSource removeAccountMetadataForKey:context:error:]
 -[MSIDMetadataCacheDataSource saveAppMetadata:key:serializer:context:error:]
 -[MSIDMetadataCacheDataSource appMetadataEntriesWithKey:serializer:context:error:]
 -[MSIDMetadataCacheDataSource removeMetadataItemsWithKey:context:error:]

@end

@protocol MSIDExtendedTokenCacheDataSource <MSIDTokenCacheDataSource, MSIDMetadataCacheDataSource>
  // instance methods
 -[MSIDExtendedTokenCacheDataSource saveAccount:key:serializer:context:error:]
 -[MSIDExtendedTokenCacheDataSource accountWithKey:serializer:context:error:]
 -[MSIDExtendedTokenCacheDataSource accountsWithKey:serializer:context:error:]
 -[MSIDExtendedTokenCacheDataSource removeAccountsWithKey:context:error:]
 -[MSIDExtendedTokenCacheDataSource jsonObjectsWithKey:serializer:context:error:]
 -[MSIDExtendedTokenCacheDataSource saveJsonObject:serializer:key:context:error:]

@end

@protocol MSIDAADEndpointProviding <NSObject>
  // instance methods
 -[MSIDAADEndpointProviding oauth2AuthorizeEndpointWithUrl:]
 -[MSIDAADEndpointProviding oauth2TokenEndpointWithUrl:]
 -[MSIDAADEndpointProviding oauth2IssuerWithUrl:]
 -[MSIDAADEndpointProviding oauth2jwksEndpointWithUrl:]
 -[MSIDAADEndpointProviding drsDiscoveryEndpointWithDomain:adfsType:]
 -[MSIDAADEndpointProviding webFingerDiscoveryEndpointWithIssuer:]
 -[MSIDAADEndpointProviding openIdConfigurationEndpointWithUrl:]
 -[MSIDAADEndpointProviding aadAuthorityDiscoveryEndpointWithHost:]

@end

@protocol MSIDTelemetryEventInterface <NSObject>
 @property  NSDictionary *propertyMap
 @property  BOOL errorInEvent

  // class methods
 +[MSIDTelemetryEventInterface propertiesToAggregate]

  // instance methods
 -[MSIDTelemetryEventInterface setProperty:value:]
 -[MSIDTelemetryEventInterface propertyWithName:]
 -[MSIDTelemetryEventInterface getProperties]
 -[MSIDTelemetryEventInterface addDefaultProperties]
 -[MSIDTelemetryEventInterface setStartTime:]
 -[MSIDTelemetryEventInterface setStopTime:]
 -[MSIDTelemetryEventInterface setResponseTime:]
 -[MSIDTelemetryEventInterface deleteProperty:]
 -[MSIDTelemetryEventInterface propertyMap]
 -[MSIDTelemetryEventInterface errorInEvent]
 -[MSIDTelemetryEventInterface setErrorInEvent:]

@end

@protocol MSIDTelemetryDispatcher <NSObject>
  // instance methods
 -[MSIDTelemetryDispatcher containsObserver:]
 -[MSIDTelemetryDispatcher receive:event:]
 -[MSIDTelemetryDispatcher flush:]

@end

@protocol WKNavigationDelegate <NSObject>
@optional
  // instance methods
 -[WKNavigationDelegate webView:decidePolicyForNavigationAction:decisionHandler:]
 -[WKNavigationDelegate webView:decidePolicyForNavigationAction:preferences:decisionHandler:]
 -[WKNavigationDelegate webView:decidePolicyForNavigationResponse:decisionHandler:]
 -[WKNavigationDelegate webView:didStartProvisionalNavigation:]
 -[WKNavigationDelegate webView:didReceiveServerRedirectForProvisionalNavigation:]
 -[WKNavigationDelegate webView:didFailProvisionalNavigation:withError:]
 -[WKNavigationDelegate webView:didCommitNavigation:]
 -[WKNavigationDelegate webView:didFinishNavigation:]
 -[WKNavigationDelegate webView:didFailNavigation:withError:]
 -[WKNavigationDelegate webView:didReceiveAuthenticationChallenge:completionHandler:]
 -[WKNavigationDelegate webViewWebContentProcessDidTerminate:]
 -[WKNavigationDelegate webView:authenticationChallenge:shouldAllowDeprecatedTLS:]
 -[WKNavigationDelegate webView:navigationAction:didBecomeDownload:]
 -[WKNavigationDelegate webView:navigationResponse:didBecomeDownload:]

@end

@protocol ASWebAuthenticationPresentationContextProviding <NSObject>
  // instance methods
 -[ASWebAuthenticationPresentationContextProviding presentationAnchorForWebAuthenticationSession:]

@end

@protocol MSIDInteractiveRequestControlling <NSObject>
  // instance methods
 -[MSIDInteractiveRequestControlling executeRequestWithCompletion:]

@end

@protocol MSIDMacTokenCacheDelegate <NSObject>
  // instance methods
 -[MSIDMacTokenCacheDelegate willAccessCache:]
 -[MSIDMacTokenCacheDelegate didAccessCache:]
 -[MSIDMacTokenCacheDelegate willWriteCache:]
 -[MSIDMacTokenCacheDelegate didWriteCache:]

@end

@protocol MSIDErrorConverting <NSObject>
  // instance methods
 -[MSIDErrorConverting errorWithDomain:code:errorDescription:oauthError:subError:underlyingError:correlationId:userInfo:]
 -[MSIDErrorConverting oauthErrorKey]
 -[MSIDErrorConverting subErrorKey]

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

@protocol MSIDJsonSerializing <NSObject>
  // instance methods
 -[MSIDJsonSerializing toJsonData:context:error:]
 -[MSIDJsonSerializing fromJsonData:ofType:context:error:]
 -[MSIDJsonSerializing toJsonString:context:error:]
 -[MSIDJsonSerializing fromJsonString:ofType:context:error:]

@end

@protocol MSIDHttpRequestTelemetryHandling <NSObject>
  // instance methods
 -[MSIDHttpRequestTelemetryHandling sendRequestEventWithId:]
 -[MSIDHttpRequestTelemetryHandling responseReceivedEventWithContext:urlRequest:httpResponse:data:error:]

@end

0x0000017b1c8 MSALTokenParameters : MSALParameters
 @property  NSArray *scopes
 @property  MSALAccount *account
 @property  MSALAuthority *authority
 @property  MSALClaimsRequest *claimsRequest
 @property  NSDictionary *extraQueryParameters
 @property  NSUUID *correlationId
 @property  <MSALAuthenticationSchemeProtocol> *authenticationScheme

  // instance methods
  0x00000004e14 -[MSALTokenParameters initWithScopes:]
  0x00000004ee4 -[MSALTokenParameters scopes]
  0x00000004ef4 -[MSALTokenParameters setScopes:]
  0x00000004f08 -[MSALTokenParameters account]
  0x00000004f18 -[MSALTokenParameters setAccount:]
  0x00000004f2c -[MSALTokenParameters authority]
  0x00000004f3c -[MSALTokenParameters setAuthority:]
  0x00000004f50 -[MSALTokenParameters claimsRequest]
  0x00000004f60 -[MSALTokenParameters setClaimsRequest:]
  0x00000004f74 -[MSALTokenParameters extraQueryParameters]
  0x00000004f84 -[MSALTokenParameters setExtraQueryParameters:]
  0x00000004f98 -[MSALTokenParameters correlationId]
  0x00000004fa8 -[MSALTokenParameters setCorrelationId:]
  0x00000004fbc -[MSALTokenParameters authenticationScheme]
  0x00000004fcc -[MSALTokenParameters setAuthenticationScheme:]


0x0000017b240 MSALParameters : NSObject /usr/lib/libobjc.A.dylib
 @property  NSObject<OS_dispatch_queue> *completionBlockQueue

  // instance methods
  0x00000005084 -[MSALParameters completionBlockQueue]
  0x0000000508c -[MSALParameters setCompletionBlockQueue:]


0x0000017b268 MSALGlobalConfig : NSObject /usr/lib/libobjc.A.dylib
 @property  MSALHTTPConfig *httpConfig
 @property  MSALTelemetryConfig *telemetryConfig
 @property  MSALLoggerConfig *loggerConfig
 @property  MSALCacheConfig *cacheConfig

  // class methods
  0x000000050a4 +[MSALGlobalConfig sharedInstance]
  0x000000051fc +[MSALGlobalConfig httpConfig]
  0x00000005248 +[MSALGlobalConfig telemetryConfig]
  0x00000005294 +[MSALGlobalConfig loggerConfig]
  0x000000052e0 +[MSALGlobalConfig brokerAvailability]
  0x000000052ec +[MSALGlobalConfig setBrokerAvailability:]
  0x000000052f8 +[MSALGlobalConfig defaultWebviewType]
  0x00000005304 +[MSALGlobalConfig setDefaultWebviewType:]

  // instance methods
  0x00000005310 -[MSALGlobalConfig httpConfig]
  0x0000000531c -[MSALGlobalConfig setHttpConfig:]
  0x00000005324 -[MSALGlobalConfig telemetryConfig]
  0x00000005330 -[MSALGlobalConfig setTelemetryConfig:]
  0x00000005338 -[MSALGlobalConfig loggerConfig]
  0x00000005344 -[MSALGlobalConfig setLoggerConfig:]
  0x0000000534c -[MSALGlobalConfig cacheConfig]
  0x00000005358 -[MSALGlobalConfig setCacheConfig:]


0x0000017b2e0 MSALHTTPConfig : NSObject /usr/lib/libobjc.A.dylib
 @property  long long retryCount
 @property  double retryInterval
 @property  double timeoutIntervalForRequest

  // class methods
  0x000000053a8 +[MSALHTTPConfig sharedInstance]

  // instance methods
  0x00000005474 -[MSALHTTPConfig retryCount]
  0x00000005480 -[MSALHTTPConfig setRetryCount:]
  0x0000000548c -[MSALHTTPConfig retryInterval]
  0x00000005498 -[MSALHTTPConfig setRetryInterval:]
  0x000000054a4 -[MSALHTTPConfig timeoutIntervalForRequest]
  0x000000054b0 -[MSALHTTPConfig setTimeoutIntervalForRequest:]


0x0000017b308 MSALAccount : NSObject /usr/lib/libobjc.A.dylib <MSALAccount, NSCopying>
 @property  MSALAccountId *homeAccountId
 @property  NSString *username
 @property  NSString *environment
 @property  NSMutableDictionary *mTenantProfiles
 @property  NSDictionary *accountClaims
 @property  NSString *identifier
 @property  MSIDAccountIdentifier *lookupAccountIdentifier
 @property  BOOL isSSOAccount
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000054bc -[MSALAccount initWithUsername:homeAccountId:environment:tenantProfiles:]
  0x00000005650 -[MSALAccount initWithMSIDAccount:createTenantProfile:]
  0x00000005994 -[MSALAccount initWithMSALExternalAccount:oauth2Provider:]
  0x00000005cc0 -[MSALAccount copyWithZone:]
  0x00000005e34 -[MSALAccount isEqual:]
  0x00000005eb4 -[MSALAccount isEqualToAccount:]
  0x00000006078 -[MSALAccount tenantProfiles]
  0x000000060bc -[MSALAccount addTenantProfiles:]
  0x000000062dc -[MSALAccount homeAccountId]
  0x000000062e4 -[MSALAccount setHomeAccountId:]
  0x000000062f0 -[MSALAccount username]
  0x000000062f8 -[MSALAccount setUsername:]
  0x00000006304 -[MSALAccount environment]
  0x0000000630c -[MSALAccount setEnvironment:]
  0x00000006318 -[MSALAccount mTenantProfiles]
  0x00000006320 -[MSALAccount setMTenantProfiles:]
  0x0000000632c -[MSALAccount accountClaims]
  0x00000006334 -[MSALAccount setAccountClaims:]
  0x00000006340 -[MSALAccount identifier]
  0x00000006348 -[MSALAccount setIdentifier:]
  0x00000006354 -[MSALAccount lookupAccountIdentifier]
  0x0000000635c -[MSALAccount setLookupAccountIdentifier:]
  0x00000006368 -[MSALAccount isSSOAccount]
  0x00000006370 -[MSALAccount setIsSSOAccount:]


0x0000017b358 MSALOauth2Authority : MSALAuthority
  // instance methods
  0x000000063e4 -[MSALOauth2Authority initWithURL:error:]


0x0000017b3d0 MSALLoggerConfig : NSObject /usr/lib/libobjc.A.dylib
 @property  @? callback
 @property  long long logLevel
 @property  BOOL piiEnabled
 @property  long long logMaskingLevel

  // class methods
  0x000000064e0 +[MSALLoggerConfig sharedInstance]

  // instance methods
  0x000000065fc -[MSALLoggerConfig setLogCallback:]
  0x00000006758 -[MSALLoggerConfig setLogLevel:]
  0x00000006798 -[MSALLoggerConfig logLevel]
  0x000000067dc -[MSALLoggerConfig setPiiEnabled:]
  0x00000006824 -[MSALLoggerConfig piiEnabled]
  0x0000000686c -[MSALLoggerConfig logMaskingLevel]
  0x000000068b0 -[MSALLoggerConfig setLogMaskingLevel:]
  0x000000068f0 -[MSALLoggerConfig callback]
  0x000000068f8 -[MSALLoggerConfig setCallback:]


0x0000017b420 MSALADFSOauth2Provider : MSALOauth2Provider
  // instance methods
  0x0000000690c -[MSALADFSOauth2Provider resultWithTokenResult:authScheme:popManager:error:]
  0x00000006b28 -[MSALADFSOauth2Provider isSupportedAuthority:]
  0x00000006b78 -[MSALADFSOauth2Provider initOauth2Factory]


0x0000017b448 MSALAuthenticationSchemeBearer : NSObject /usr/lib/libobjc.A.dylib <MSALAuthenticationSchemeProtocolInternal, MSALAuthenticationSchemeProtocol>
 @property  unsigned long scheme
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription
 @property  NSString *authenticationScheme

  // instance methods
  0x00000006b7c -[MSALAuthenticationSchemeBearer init]
  0x00000006be4 -[MSALAuthenticationSchemeBearer authenticationScheme]
  0x00000006bf8 -[MSALAuthenticationSchemeBearer createMSIDAuthenticationSchemeWithParams:]
  0x00000006c44 -[MSALAuthenticationSchemeBearer getSchemeParameters:]
  0x00000006c60 -[MSALAuthenticationSchemeBearer getClientAccessToken:popManager:error:]
  0x00000006c68 -[MSALAuthenticationSchemeBearer getAuthorizationHeader:]
  0x00000006cfc -[MSALAuthenticationSchemeBearer scheme]


0x0000017b498 MSALClaimsRequest : NSObject /usr/lib/libobjc.A.dylib <MSALJsonSerializable, MSALJsonDeserializable>
 @property  MSIDClaimsRequest *msidClaimsRequest
 @property  <MSIDJsonSerializing> *jsonSerializer
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000006d04 -[MSALClaimsRequest init]
  0x00000006de0 -[MSALClaimsRequest requestClaim:forTarget:error:]
  0x00000006e8c -[MSALClaimsRequest claimsRequestsForTarget:]
  0x00000007000 -[MSALClaimsRequest removeClaimRequestWithName:target:error:]
  0x00000007084 -[MSALClaimsRequest initWithJsonString:error:]
  0x000000071e0 -[MSALClaimsRequest jsonString]
  0x00000007350 -[MSALClaimsRequest commonInit]
  0x0000000738c -[MSALClaimsRequest msidTargetFromTarget:]
  0x000000073a4 -[MSALClaimsRequest msidClaimsRequest]
  0x000000073ac -[MSALClaimsRequest setMsidClaimsRequest:]
  0x000000073b8 -[MSALClaimsRequest jsonSerializer]
  0x000000073c0 -[MSALClaimsRequest setJsonSerializer:]


0x0000017b4e8 MSALRedirectUri : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSURL *url
 @property  BOOL brokerCapable

  // class methods
  0x000000074f8 +[MSALRedirectUri defaultNonBrokerRedirectUri:]
  0x00000007504 +[MSALRedirectUri defaultBrokerCapableRedirectUri]
  0x00000007510 +[MSALRedirectUri redirectUriIsBrokerCapable:]

  // instance methods
  0x000000073fc -[MSALRedirectUri initWithRedirectUri:brokerCapable:]
  0x000000074a8 -[MSALRedirectUri copyWithZone:]
  0x00000007534 -[MSALRedirectUri url]
  0x0000000753c -[MSALRedirectUri brokerCapable]


0x0000017b560 MSALDeviceInfoProvider : MSALSSOExtensionRequestHandler
  // instance methods
  0x00000007550 -[MSALDeviceInfoProvider deviceInfoWithRequestParameters:completionBlock:]
  0x00000007f3c -[MSALDeviceInfoProvider wpjMetaDataDeviceInfoWithRequestParameters:tenantId:completionBlock:]


0x0000017b5b0 MSALTelemetryEventsObservingProxy : NSObject /usr/lib/libobjc.A.dylib <MSIDTelemetryEventsObserving>
 @property  @? telemetryCallback
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000008154 -[MSALTelemetryEventsObservingProxy onEventsReceived:]
  0x000000081d8 -[MSALTelemetryEventsObservingProxy telemetryCallback]
  0x000000081e0 -[MSALTelemetryEventsObservingProxy setTelemetryCallback:]


0x0000017b600 MSALTelemetry : NSObject /usr/lib/libobjc.A.dylib
 @property  BOOL piiEnabled
 @property  BOOL notifyOnFailureOnly
 @property  @? telemetryCallback

  // class methods
  0x000000081f4 +[MSALTelemetry sharedInstance]

  // instance methods
  0x000000082c0 -[MSALTelemetry piiEnabled]
  0x00000008304 -[MSALTelemetry setPiiEnabled:]
  0x00000008344 -[MSALTelemetry notifyOnFailureOnly]
  0x00000008388 -[MSALTelemetry setNotifyOnFailureOnly:]
  0x000000083c8 -[MSALTelemetry telemetryCallback]
  0x00000008414 -[MSALTelemetry setTelemetryCallback:]


0x0000017b628 MSALTenantProfile : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSString *identifier
 @property  NSString *environment
 @property  NSString *tenantId
 @property  BOOL isHomeTenantProfile
 @property  NSDictionary *claims

  // instance methods
  0x00000008468 -[MSALTenantProfile initWithIdentifier:tenantId:environment:isHomeTenantProfile:claims:]
  0x00000008598 -[MSALTenantProfile copyWithZone:]
  0x0000000865c -[MSALTenantProfile identifier]
  0x00000008668 -[MSALTenantProfile setIdentifier:]
  0x00000008670 -[MSALTenantProfile environment]
  0x0000000867c -[MSALTenantProfile setEnvironment:]
  0x00000008684 -[MSALTenantProfile tenantId]
  0x00000008690 -[MSALTenantProfile setTenantId:]
  0x00000008698 -[MSALTenantProfile isHomeTenantProfile]
  0x000000086a4 -[MSALTenantProfile setIsHomeTenantProfile:]
  0x000000086ac -[MSALTenantProfile claims]
  0x000000086b8 -[MSALTenantProfile setClaims:]


0x0000017b678 MSALExternalAccountHandler : NSObject /usr/lib/libobjc.A.dylib
 @property  NSArray *externalAccountProviders
 @property  MSALOauth2Provider *oauth2Provider

  // instance methods
  0x00000008708 -[MSALExternalAccountHandler initWithExternalAccountProviders:oauth2Provider:error:]
  0x0000000889c -[MSALExternalAccountHandler removeAccount:wipeAccount:error:]
  0x00000008b0c -[MSALExternalAccountHandler updateWithResult:error:]
  0x00000008ddc -[MSALExternalAccountHandler allExternalAccountsWithParameters:error:]
  0x00000009154 -[MSALExternalAccountHandler fillAndLogParameterError:parameterName:]
  0x00000009294 -[MSALExternalAccountHandler externalAccountProviders]
  0x0000000929c -[MSALExternalAccountHandler setExternalAccountProviders:]
  0x000000092a8 -[MSALExternalAccountHandler oauth2Provider]
  0x000000092b0 -[MSALExternalAccountHandler setOauth2Provider:]


0x0000017b6f0 MSALADFSAuthority : MSALAuthority
  // instance methods
  0x000000092ec -[MSALADFSAuthority initWithURL:error:]
  0x00000009398 -[MSALADFSAuthority url]


0x0000017b718 MSALWPJMetaData : NSObject /usr/lib/libobjc.A.dylib
 @property  NSDictionary *extraDeviceInformation

  // instance methods
  0x000000093dc -[MSALWPJMetaData init]
  0x0000000946c -[MSALWPJMetaData extraDeviceInformation]
  0x00000009474 -[MSALWPJMetaData addRegisteredDeviceMetadataInformation:]


0x0000017b790 MSALCIAMOauth2Provider : MSALOauth2Provider
  // instance methods
  0x00000009488 -[MSALCIAMOauth2Provider resultWithTokenResult:authScheme:popManager:error:]
  0x000000096a8 -[MSALCIAMOauth2Provider issuerAuthorityWithAccount:requestAuthority:instanceAware:error:]
  0x00000009934 -[MSALCIAMOauth2Provider isSupportedAuthority:]
  0x00000009984 -[MSALCIAMOauth2Provider tenantProfileWithClaims:homeAccountId:environment:error:]
  0x00000009a78 -[MSALCIAMOauth2Provider initOauth2Factory]


0x0000017b7b8 MSALAADAuthority : MSALAuthority
  // instance methods
  0x00000009ab4 -[MSALAADAuthority initWithURL:error:]
  0x00000009ac0 -[MSALAADAuthority initWithURL:rawTenant:error:]
  0x00000009be0 -[MSALAADAuthority initWithCloudInstance:audienceType:rawTenant:error:]
  0x00000009d00 -[MSALAADAuthority initWithEnvironment:audienceType:rawTenant:error:]
  0x00000009ef8 -[MSALAADAuthority environmentFromCloudInstance:]
  0x00000009f18 -[MSALAADAuthority audienceFromType:error:]
  0x0000000a008 -[MSALAADAuthority url]


0x0000017b808 MSALWebviewParameters : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSViewController *parentViewController
 @property  BOOL prefersEphemeralWebBrowserSession
 @property  long long webviewType
 @property  WKWebView *customWebview

  // class methods
  0x0000000a168 +[MSALWebviewParameters defaultWKWebviewConfiguration]

  // instance methods
  0x0000000a04c -[MSALWebviewParameters initWithParentViewController:]
  0x0000000a050 -[MSALWebviewParameters initWithAuthPresentationViewController:]
  0x0000000a0e8 -[MSALWebviewParameters copyWithZone:]
  0x0000000a174 -[MSALWebviewParameters parentViewController]
  0x0000000a18c -[MSALWebviewParameters setParentViewController:]
  0x0000000a198 -[MSALWebviewParameters prefersEphemeralWebBrowserSession]
  0x0000000a1a0 -[MSALWebviewParameters setPrefersEphemeralWebBrowserSession:]
  0x0000000a1a8 -[MSALWebviewParameters webviewType]
  0x0000000a1b0 -[MSALWebviewParameters setWebviewType:]
  0x0000000a1b8 -[MSALWebviewParameters customWebview]
  0x0000000a1c0 -[MSALWebviewParameters setCustomWebview:]


0x0000017b880 MSALRedirectUriVerifier : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000000a258 +[MSALRedirectUriVerifier msalRedirectUriWithCustomUri:clientId:bypassRedirectValidation:error:]
  0x0000000a2f0 +[MSALRedirectUriVerifier verifyAdditionalRequiredSchemesAreRegistered:]


0x0000017b8d0 MSALOauth2ProviderFactory : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000000a2fc +[MSALOauth2ProviderFactory oauthProviderForAuthority:clientId:tokenCache:accountMetadataCache:context:error:]


0x0000017b8f8 MSALExtraQueryParameters : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSMutableDictionary *extraURLQueryParameters
 @property  NSMutableDictionary *extraTokenURLParameters
 @property  NSMutableDictionary *extraAuthorizeURLQueryParameters

  // instance methods
  0x0000000a48c -[MSALExtraQueryParameters init]
  0x0000000a56c -[MSALExtraQueryParameters copyWithZone:]
  0x0000000a5e4 -[MSALExtraQueryParameters extraURLQueryParameters]
  0x0000000a5f0 -[MSALExtraQueryParameters setExtraURLQueryParameters:]
  0x0000000a5f8 -[MSALExtraQueryParameters extraTokenURLParameters]
  0x0000000a604 -[MSALExtraQueryParameters setExtraTokenURLParameters:]
  0x0000000a60c -[MSALExtraQueryParameters extraAuthorizeURLQueryParameters]
  0x0000000a618 -[MSALExtraQueryParameters setExtraAuthorizeURLQueryParameters:]


0x0000017b970 MSALB2COauth2Provider : MSALOauth2Provider
  // instance methods
  0x0000000a65c -[MSALB2COauth2Provider resultWithTokenResult:authScheme:popManager:error:]
  0x0000000a87c -[MSALB2COauth2Provider issuerAuthorityWithAccount:requestAuthority:instanceAware:error:]
  0x0000000ab08 -[MSALB2COauth2Provider isSupportedAuthority:]
  0x0000000ab58 -[MSALB2COauth2Provider tenantProfileWithClaims:homeAccountId:environment:error:]
  0x0000000ac4c -[MSALB2COauth2Provider initOauth2Factory]


0x0000017b9c0 MSALTelemetryConfig : NSObject /usr/lib/libobjc.A.dylib
 @property  MSALTelemetryEventsObservingProxy *proxyObserver
 @property  BOOL piiEnabled
 @property  BOOL notifyOnFailureOnly
 @property  @? telemetryCallback

  // class methods
  0x0000000ac88 +[MSALTelemetryConfig sharedInstance]

  // instance methods
  0x0000000ad64 -[MSALTelemetryConfig piiEnabled]
  0x0000000ada8 -[MSALTelemetryConfig setPiiEnabled:]
  0x0000000ade8 -[MSALTelemetryConfig notifyOnFailureOnly]
  0x0000000ae2c -[MSALTelemetryConfig setNotifyOnFailureOnly:]
  0x0000000ae6c -[MSALTelemetryConfig initDispatchers]
  0x0000000afe4 -[MSALTelemetryConfig telemetryCallback]
  0x0000000aff0 -[MSALTelemetryConfig setTelemetryCallback:]
  0x0000000aff8 -[MSALTelemetryConfig proxyObserver]
  0x0000000b000 -[MSALTelemetryConfig setProxyObserver:]


0x0000017ba10 MSALLogger : NSObject /usr/lib/libobjc.A.dylib
 @property  long long level
 @property  BOOL PiiLoggingEnabled

  // class methods
  0x0000000b03c +[MSALLogger sharedLogger]

  // instance methods
  0x0000000b108 -[MSALLogger setCallback:]
  0x0000000b15c -[MSALLogger setPiiLoggingEnabled:]
  0x0000000b19c -[MSALLogger PiiLoggingEnabled]
  0x0000000b1e0 -[MSALLogger setLevel:]
  0x0000000b220 -[MSALLogger level]


0x0000017ba38 MSALSerializedADALCacheProvider : NSObject /usr/lib/libobjc.A.dylib <MSIDMacTokenCacheDelegate, NSCopying>
 @property  <MSALSerializedADALCacheProviderDelegate> *delegate
 @property  MSIDMacTokenCache *macTokenCache
 @property  MSIDMacLegacyCachePersistenceHandler *cachePersistenceHandler
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000000b264 -[MSALSerializedADALCacheProvider initWithDelegate:error:]
  0x0000000b330 -[MSALSerializedADALCacheProvider initWithKeychainAttributes:trustedApplications:accessLabel:error:]
  0x0000000b554 -[MSALSerializedADALCacheProvider serializeDataWithError:]
  0x0000000b598 -[MSALSerializedADALCacheProvider deserialize:error:]
  0x0000000b604 -[MSALSerializedADALCacheProvider copyWithZone:]
  0x0000000b664 -[MSALSerializedADALCacheProvider msidTokenCacheDataSource]
  0x0000000b668 -[MSALSerializedADALCacheProvider willAccessCache:]
  0x0000000b6a0 -[MSALSerializedADALCacheProvider didAccessCache:]
  0x0000000b6d8 -[MSALSerializedADALCacheProvider willWriteCache:]
  0x0000000b710 -[MSALSerializedADALCacheProvider didWriteCache:]
  0x0000000b748 -[MSALSerializedADALCacheProvider delegate]
  0x0000000b750 -[MSALSerializedADALCacheProvider setDelegate:]
  0x0000000b75c -[MSALSerializedADALCacheProvider macTokenCache]
  0x0000000b764 -[MSALSerializedADALCacheProvider setMacTokenCache:]
  0x0000000b770 -[MSALSerializedADALCacheProvider cachePersistenceHandler]
  0x0000000b778 -[MSALSerializedADALCacheProvider setCachePersistenceHandler:]


0x0000017ba88 MSALAccountEnumerationParameters : MSALParameters
 @property  NSString *identifier
 @property  NSString *tenantProfileIdentifier
 @property  NSString *username
 @property  BOOL ignoreSignedInStatus
 @property  BOOL returnOnlySignedInAccounts

  // instance methods
  0x0000000b7c0 -[MSALAccountEnumerationParameters init]
  0x0000000b834 -[MSALAccountEnumerationParameters initWithIdentifier:]
  0x0000000b8f0 -[MSALAccountEnumerationParameters initWithIdentifier:username:]
  0x0000000b9e0 -[MSALAccountEnumerationParameters initWithTenantProfileIdentifier:]
  0x0000000bb84 -[MSALAccountEnumerationParameters identifier]
  0x0000000bb94 -[MSALAccountEnumerationParameters setIdentifier:]
  0x0000000bba8 -[MSALAccountEnumerationParameters tenantProfileIdentifier]
  0x0000000bbb8 -[MSALAccountEnumerationParameters setTenantProfileIdentifier:]
  0x0000000bbcc -[MSALAccountEnumerationParameters username]
  0x0000000bbdc -[MSALAccountEnumerationParameters setUsername:]
  0x0000000bbf0 -[MSALAccountEnumerationParameters returnOnlySignedInAccounts]
  0x0000000bc00 -[MSALAccountEnumerationParameters setReturnOnlySignedInAccounts:]
  0x0000000bc10 -[MSALAccountEnumerationParameters ignoreSignedInStatus]
  0x0000000bc20 -[MSALAccountEnumerationParameters setIgnoreSignedInStatus:]


0x0000017bad8 MSALDevicePopManagerUtil : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000000bc84 +[MSALDevicePopManagerUtil test_initWithValidCacheConfig]
  0x0000000bd84 +[MSALDevicePopManagerUtil keyGeneratorWithConfig:]


0x0000017bb28 MSALIndividualClaimRequestAdditionalInfo : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDIndividualClaimRequestAdditionalInfo *msidAdditionalInfo
 @property  <MSIDJsonSerializing> *jsonSerializer
 @property  NSNumber *essential
 @property  id value
 @property  NSArray *values

  // instance methods
  0x0000000be4c -[MSALIndividualClaimRequestAdditionalInfo init]
  0x0000000bf44 -[MSALIndividualClaimRequestAdditionalInfo initWithMsidIndividualClaimRequestAdditionalInfo:]
  0x0000000c00c -[MSALIndividualClaimRequestAdditionalInfo setEssential:]
  0x0000000c05c -[MSALIndividualClaimRequestAdditionalInfo essential]
  0x0000000c0a0 -[MSALIndividualClaimRequestAdditionalInfo setValue:]
  0x0000000c0f0 -[MSALIndividualClaimRequestAdditionalInfo value]
  0x0000000c134 -[MSALIndividualClaimRequestAdditionalInfo setValues:]
  0x0000000c184 -[MSALIndividualClaimRequestAdditionalInfo values]
  0x0000000c1c8 -[MSALIndividualClaimRequestAdditionalInfo msidAdditionalInfo]
  0x0000000c1d0 -[MSALIndividualClaimRequestAdditionalInfo setMsidAdditionalInfo:]
  0x0000000c1dc -[MSALIndividualClaimRequestAdditionalInfo jsonSerializer]
  0x0000000c1e4 -[MSALIndividualClaimRequestAdditionalInfo setJsonSerializer:]


0x0000017bb78 MSALSignoutParameters : MSALParameters
 @property  MSALWebviewParameters *webviewParameters
 @property  BOOL signoutFromBrowser
 @property  BOOL wipeAccount
 @property  BOOL wipeCacheForAllAccounts

  // instance methods
  0x0000000c220 -[MSALSignoutParameters initWithWebviewParameters:]
  0x0000000c2d8 -[MSALSignoutParameters webviewParameters]
  0x0000000c2e8 -[MSALSignoutParameters signoutFromBrowser]
  0x0000000c2f8 -[MSALSignoutParameters setSignoutFromBrowser:]
  0x0000000c308 -[MSALSignoutParameters wipeAccount]
  0x0000000c318 -[MSALSignoutParameters setWipeAccount:]
  0x0000000c328 -[MSALSignoutParameters wipeCacheForAllAccounts]
  0x0000000c338 -[MSALSignoutParameters setWipeCacheForAllAccounts:]


0x0000017bbc8 MSALPublicClientApplicationConfig : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  MSALExtraQueryParameters *extraQueryParameters
 @property  MSALRedirectUri *verifiedRedirectUri
 @property  MSALCacheConfig *cacheConfig
 @property  NSString *clientId
 @property  NSString *redirectUri
 @property  NSString *nestedAuthBrokerClientId
 @property  NSString *nestedAuthBrokerRedirectUri
 @property  MSALAuthority *authority
 @property  NSArray *knownAuthorities
 @property  BOOL extendedLifetimeEnabled
 @property  NSArray *clientApplicationCapabilities
 @property  double tokenExpirationBuffer
 @property  MSALSliceConfig *sliceConfig
 @property  BOOL multipleCloudsSupported
 @property  BOOL bypassRedirectURIValidation

  // instance methods
  0x0000000c3c0 -[MSALPublicClientApplicationConfig initWithClientId:]
  0x0000000c3cc -[MSALPublicClientApplicationConfig initWithClientId:redirectUri:authority:nestedAuthBrokerClientId:nestedAuthBrokerRedirectUri:]
  0x0000000c5bc -[MSALPublicClientApplicationConfig initWithClientId:redirectUri:authority:]
  0x0000000c5c8 -[MSALPublicClientApplicationConfig setSliceConfig:]
  0x0000000c6ec -[MSALPublicClientApplicationConfig sliceConfig]
  0x0000000c6f4 -[MSALPublicClientApplicationConfig copyWithZone:]
  0x0000000c8c4 -[MSALPublicClientApplicationConfig clientId]
  0x0000000c8d0 -[MSALPublicClientApplicationConfig setClientId:]
  0x0000000c8d8 -[MSALPublicClientApplicationConfig redirectUri]
  0x0000000c8e4 -[MSALPublicClientApplicationConfig setRedirectUri:]
  0x0000000c8ec -[MSALPublicClientApplicationConfig nestedAuthBrokerClientId]
  0x0000000c8f8 -[MSALPublicClientApplicationConfig setNestedAuthBrokerClientId:]
  0x0000000c900 -[MSALPublicClientApplicationConfig nestedAuthBrokerRedirectUri]
  0x0000000c90c -[MSALPublicClientApplicationConfig setNestedAuthBrokerRedirectUri:]
  0x0000000c914 -[MSALPublicClientApplicationConfig authority]
  0x0000000c920 -[MSALPublicClientApplicationConfig setAuthority:]
  0x0000000c928 -[MSALPublicClientApplicationConfig knownAuthorities]
  0x0000000c930 -[MSALPublicClientApplicationConfig setKnownAuthorities:]
  0x0000000c93c -[MSALPublicClientApplicationConfig extendedLifetimeEnabled]
  0x0000000c948 -[MSALPublicClientApplicationConfig setExtendedLifetimeEnabled:]
  0x0000000c950 -[MSALPublicClientApplicationConfig clientApplicationCapabilities]
  0x0000000c95c -[MSALPublicClientApplicationConfig setClientApplicationCapabilities:]
  0x0000000c964 -[MSALPublicClientApplicationConfig tokenExpirationBuffer]
  0x0000000c96c -[MSALPublicClientApplicationConfig setTokenExpirationBuffer:]
  0x0000000c974 -[MSALPublicClientApplicationConfig cacheConfig]
  0x0000000c980 -[MSALPublicClientApplicationConfig setCacheConfig:]
  0x0000000c988 -[MSALPublicClientApplicationConfig multipleCloudsSupported]
  0x0000000c990 -[MSALPublicClientApplicationConfig setMultipleCloudsSupported:]
  0x0000000c998 -[MSALPublicClientApplicationConfig bypassRedirectURIValidation]
  0x0000000c9a4 -[MSALPublicClientApplicationConfig setBypassRedirectURIValidation:]
  0x0000000c9ac -[MSALPublicClientApplicationConfig extraQueryParameters]
  0x0000000c9b8 -[MSALPublicClientApplicationConfig setExtraQueryParameters:]
  0x0000000c9c0 -[MSALPublicClientApplicationConfig verifiedRedirectUri]
  0x0000000c9cc -[MSALPublicClientApplicationConfig setVerifiedRedirectUri:]


0x0000017bc18 MSALAccountId : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSString *identifier
 @property  NSString *objectId
 @property  NSString *tenantId

  // instance methods
  0x0000000ca70 -[MSALAccountId initWithAccountIdentifier:objectId:tenantId:]
  0x0000000cb6c -[MSALAccountId copyWithZone:]
  0x0000000cc00 -[MSALAccountId isEqual:]
  0x0000000cc78 -[MSALAccountId isEqualToItem:]
  0x0000000ce60 -[MSALAccountId identifier]
  0x0000000ce68 -[MSALAccountId objectId]
  0x0000000ce70 -[MSALAccountId tenantId]


0x0000017bc68 MSALCIAMAuthority : MSALAuthority
  // instance methods
  0x0000000ceb4 -[MSALCIAMAuthority initWithURL:error:]
  0x0000000cec0 -[MSALCIAMAuthority initWithURL:validateFormat:error:]
  0x0000000cfcc -[MSALCIAMAuthority url]


0x0000017bcb8 MSALIndividualClaimRequest : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDIndividualClaimRequest *msidIndividualClaimRequest
 @property  NSString *name
 @property  MSALIndividualClaimRequestAdditionalInfo *additionalInfo

  // instance methods
  0x0000000d010 -[MSALIndividualClaimRequest initWithName:]
  0x0000000d104 -[MSALIndividualClaimRequest initWithMsidIndividualClaimRequest:]
  0x0000000d1a8 -[MSALIndividualClaimRequest setName:]
  0x0000000d1f8 -[MSALIndividualClaimRequest name]
  0x0000000d23c -[MSALIndividualClaimRequest setAdditionalInfo:]
  0x0000000d294 -[MSALIndividualClaimRequest additionalInfo]
  0x0000000d310 -[MSALIndividualClaimRequest msidIndividualClaimRequest]
  0x0000000d318 -[MSALIndividualClaimRequest setMsidIndividualClaimRequest:]


0x0000017bd08 MSALOauth2Provider : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDOauth2Factory *msidOauth2Factory
 @property  NSString *clientId
 @property  MSIDAccountMetadataCacheAccessor *accountMetadataCache
 @property  MSIDDefaultTokenCacheAccessor *tokenCache

  // instance methods
  0x0000000d330 -[MSALOauth2Provider initWithClientId:tokenCache:accountMetadataCache:]
  0x0000000d434 -[MSALOauth2Provider resultWithTokenResult:authScheme:popManager:error:]
  0x0000000d5f4 -[MSALOauth2Provider removeAdditionalAccountInfo:error:]
  0x0000000d5fc -[MSALOauth2Provider issuerAuthorityWithAccount:requestAuthority:instanceAware:error:]
  0x0000000d614 -[MSALOauth2Provider isSupportedAuthority:]
  0x0000000d61c -[MSALOauth2Provider tenantProfileWithClaims:homeAccountId:environment:error:]
  0x0000000d710 -[MSALOauth2Provider initOauth2Factory]
  0x0000000d74c -[MSALOauth2Provider msidOauth2Factory]
  0x0000000d754 -[MSALOauth2Provider setMsidOauth2Factory:]
  0x0000000d760 -[MSALOauth2Provider clientId]
  0x0000000d768 -[MSALOauth2Provider accountMetadataCache]
  0x0000000d770 -[MSALOauth2Provider tokenCache]


0x0000017bd58 MSALPublicClientApplication : NSObject /usr/lib/libobjc.A.dylib
 @property  MSALPublicClientApplicationConfig *internalConfig
 @property  MSIDExternalAADCacheSeeder *externalCacheSeeder
 @property  MSIDCacheConfig *msidCacheConfig
 @property  MSIDDevicePopManager *popManager
 @property  MSIDAssymetricKeyLookupAttributes *keyPairAttributes
 @property  MSIDDefaultTokenCacheAccessor *tokenCache
 @property  MSIDAccountMetadataCacheAccessor *accountMetadataCache
 @property  MSALOauth2Provider *msalOauth2Provider
 @property  MSALExternalAccountHandler *externalAccountHandler
 @property  MSALPublicClientApplicationConfig *configuration
 @property  BOOL validateAuthority
 @property  long long webviewType
 @property  WKWebView *customWebview
 @property  BOOL isCompatibleAADBrokerAvailable

  // class methods
  0x0000000d7c0 +[MSALPublicClientApplication load]
  0x00000010188 +[MSALPublicClientApplication cancelCurrentWebAuthSession]
  0x00000011ec8 +[MSALPublicClientApplication logOperation:result:error:context:]
  0x000000157cc +[MSALPublicClientApplication defaultOIDCScopes]
  0x0000001581c +[MSALPublicClientApplication sdkVersion]

  // instance methods
  0x0000000d8f4 -[MSALPublicClientApplication webviewType]
  0x0000000d900 -[MSALPublicClientApplication setWebviewType:]
  0x0000000d90c -[MSALPublicClientApplication initWithClientId:error:]
  0x0000000d990 -[MSALPublicClientApplication initWithClientId:authority:error:]
  0x0000000da34 -[MSALPublicClientApplication initWithClientId:authority:redirectUri:error:]
  0x0000000daf0 -[MSALPublicClientApplication initWithConfiguration:error:]
  0x0000000df90 -[MSALPublicClientApplication initWithClientId:keychainGroup:authority:redirectUri:error:]
  0x0000000df94 -[MSALPublicClientApplication setupTokenCacheWithConfiguration:error:]
  0x0000000e494 -[MSALPublicClientApplication allAccounts:]
  0x0000000e614 -[MSALPublicClientApplication accountForHomeAccountId:error:]
  0x0000000e618 -[MSALPublicClientApplication accountForIdentifier:error:]
  0x0000000e978 -[MSALPublicClientApplication accountsForParameters:error:]
  0x0000000ecfc -[MSALPublicClientApplication accountForUsername:error:]
  0x0000000f130 -[MSALPublicClientApplication allAccountsFilteredByAuthority:]
  0x0000000f374 -[MSALPublicClientApplication accountsFromDeviceForParameters:completionBlock:]
  0x0000000f95c -[MSALPublicClientApplication getCurrentAccountWithParameters:completionBlock:]
  0x000000101d0 -[MSALPublicClientApplication acquireTokenWithParameters:completionBlock:]
  0x000000101dc -[MSALPublicClientApplication acquireTokenForScopes:completionBlock:]
  0x00000010290 -[MSALPublicClientApplication acquireTokenForScopes:loginHint:completionBlock:]
  0x00000010368 -[MSALPublicClientApplication acquireTokenForScopes:account:completionBlock:]
  0x00000010440 -[MSALPublicClientApplication acquireTokenForScopes:account:promptType:extraQueryParameters:completionBlock:]
  0x00000010554 -[MSALPublicClientApplication acquireTokenSilentWithParameters:completionBlock:]
  0x00000011958 -[MSALPublicClientApplication accountStateForParameters:error:]
  0x00000011ae8 -[MSALPublicClientApplication acquireTokenSilentForScopes:account:completionBlock:]
  0x00000011b98 -[MSALPublicClientApplication acquireTokenSilentForScopes:account:authority:completionBlock:]
  0x00000011c6c -[MSALPublicClientApplication acquireTokenSilentForScopes:account:authority:claimsRequest:forceRefresh:correlationId:completionBlock:]
  0x00000011da8 -[MSALPublicClientApplication initPrivateWithClientId:keychainGroup:authority:redirectUri:error:]
  0x0000001217c -[MSALPublicClientApplication updateExternalAccountsWithResult:context:]
  0x0000001230c -[MSALPublicClientApplication acquireTokenWithParameters:useWebviewTypeFromGlobalConfig:completionBlock:]
  0x00000013674 -[MSALPublicClientApplication removeAccount:error:]
  0x00000013680 -[MSALPublicClientApplication removeAccountImpl:wipeAccount:error:]
  0x00000013b60 -[MSALPublicClientApplication signoutWithAccount:signoutParameters:completionBlock:]
  0x00000014af8 -[MSALPublicClientApplication getDeviceInformationWithParameters:completionBlock:]
  0x00000015000 -[MSALPublicClientApplication getWPJMetaDataDeviceWithParameters:forTenantId:completionBlock:]
  0x00000015554 -[MSALPublicClientApplication isCompatibleAADBrokerAvailable]
  0x0000001555c -[MSALPublicClientApplication shouldValidateAuthorityForRequestAuthority:]
  0x000000155bc -[MSALPublicClientApplication shouldExcludeValidationForAuthority:]
  0x00000015828 -[MSALPublicClientApplication getInternalAuthenticationSchemeProtocolForScheme:withError:]
  0x000000158ec -[MSALPublicClientApplication requestType]
  0x00000015964 -[MSALPublicClientApplication interactiveRequestAuthorityWithCustomAuthority:error:]
  0x00000015ab0 -[MSALPublicClientApplication defaultRequestParametersWithError:]
  0x00000015c5c -[MSALPublicClientApplication configuration]
  0x00000015c68 -[MSALPublicClientApplication validateAuthority]
  0x00000015c74 -[MSALPublicClientApplication setValidateAuthority:]
  0x00000015c7c -[MSALPublicClientApplication customWebview]
  0x00000015c88 -[MSALPublicClientApplication setCustomWebview:]
  0x00000015c90 -[MSALPublicClientApplication internalConfig]
  0x00000015c98 -[MSALPublicClientApplication setInternalConfig:]
  0x00000015ca4 -[MSALPublicClientApplication externalCacheSeeder]
  0x00000015cac -[MSALPublicClientApplication setExternalCacheSeeder:]
  0x00000015cb8 -[MSALPublicClientApplication msidCacheConfig]
  0x00000015cc0 -[MSALPublicClientApplication setMsidCacheConfig:]
  0x00000015ccc -[MSALPublicClientApplication popManager]
  0x00000015cd4 -[MSALPublicClientApplication setPopManager:]
  0x00000015ce0 -[MSALPublicClientApplication keyPairAttributes]
  0x00000015ce8 -[MSALPublicClientApplication setKeyPairAttributes:]
  0x00000015cf4 -[MSALPublicClientApplication tokenCache]
  0x00000015cfc -[MSALPublicClientApplication setTokenCache:]
  0x00000015d08 -[MSALPublicClientApplication accountMetadataCache]
  0x00000015d10 -[MSALPublicClientApplication setAccountMetadataCache:]
  0x00000015d1c -[MSALPublicClientApplication msalOauth2Provider]
  0x00000015d24 -[MSALPublicClientApplication setMsalOauth2Provider:]
  0x00000015d30 -[MSALPublicClientApplication externalAccountHandler]
  0x00000015d38 -[MSALPublicClientApplication setExternalAccountHandler:]


0x0000017bdd0 MSALSSOExtensionRequestHandler : NSObject /usr/lib/libobjc.A.dylib
 @property  id currentRequest

  // instance methods
  0x00000015dec -[MSALSSOExtensionRequestHandler setCurrentSSOExtensionRequest:]
  0x00000015f18 -[MSALSSOExtensionRequestHandler copyAndClearCurrentSSOExtensionRequest]
  0x00000016034 -[MSALSSOExtensionRequestHandler currentRequest]
  0x0000001603c -[MSALSSOExtensionRequestHandler setCurrentRequest:]


0x0000017be20 MSIDVersion : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000016054 +[MSIDVersion platformName]
  0x00000016060 +[MSIDVersion sdkName]
  0x0000001606c +[MSIDVersion sdkVersion]
  0x00000016078 +[MSIDVersion telemetryEventPrefix]
  0x00000016084 +[MSIDVersion aadApiVersion]


0x0000017be48 MSALCacheConfig : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSArray *externalAccountProviders
 @property  NSString *keychainSharingGroup
 @property  MSALSerializedADALCacheProvider *serializedADALCache
 @property  NSArray *trustedApplications

  // class methods
  0x0000001615c +[MSALCacheConfig defaultKeychainSharingGroup]
  0x00000016168 +[MSALCacheConfig defaultConfig]

  // instance methods
  0x000000160b8 -[MSALCacheConfig initWithKeychainSharingGroup:]
  0x000000161c0 -[MSALCacheConfig copyWithZone:]
  0x00000016248 -[MSALCacheConfig addExternalAccountProvider:]
  0x000000162e0 -[MSALCacheConfig createTrustedApplicationListFromPaths:error:]
  0x00000016594 -[MSALCacheConfig keychainSharingGroup]
  0x000000165a0 -[MSALCacheConfig setKeychainSharingGroup:]
  0x000000165a8 -[MSALCacheConfig externalAccountProviders]
  0x000000165b0 -[MSALCacheConfig setExternalAccountProviders:]
  0x000000165bc -[MSALCacheConfig serializedADALCache]
  0x000000165c4 -[MSALCacheConfig setSerializedADALCache:]
  0x000000165d0 -[MSALCacheConfig trustedApplications]
  0x000000165d8 -[MSALCacheConfig setTrustedApplications:]


0x0000017be98 MSALInteractiveTokenParameters : MSALTokenParameters
 @property  unsigned long promptType
 @property  NSString *loginHint
 @property  NSArray *extraScopesToConsent
 @property  MSALWebviewParameters *webviewParameters
 @property  long long webviewType
 @property  WKWebView *customWebview

  // instance methods
  0x0000001662c -[MSALInteractiveTokenParameters initWithScopes:webviewParameters:]
  0x00000016704 -[MSALInteractiveTokenParameters initWithScopes:]
  0x00000016770 -[MSALInteractiveTokenParameters setWebviewType:]
  0x000000167a8 -[MSALInteractiveTokenParameters webviewType]
  0x000000167e4 -[MSALInteractiveTokenParameters setCustomWebview:]
  0x00000016834 -[MSALInteractiveTokenParameters customWebview]
  0x00000016878 -[MSALInteractiveTokenParameters telemetryApiId]
  0x00000016888 -[MSALInteractiveTokenParameters setTelemetryApiId:]
  0x00000016898 -[MSALInteractiveTokenParameters promptType]
  0x000000168a8 -[MSALInteractiveTokenParameters setPromptType:]
  0x000000168b8 -[MSALInteractiveTokenParameters loginHint]
  0x000000168c8 -[MSALInteractiveTokenParameters setLoginHint:]
  0x000000168dc -[MSALInteractiveTokenParameters extraScopesToConsent]
  0x000000168ec -[MSALInteractiveTokenParameters setExtraScopesToConsent:]
  0x00000016900 -[MSALInteractiveTokenParameters webviewParameters]


0x0000017bee8 MSALDeviceInformation : NSObject /usr/lib/libobjc.A.dylib
 @property  unsigned long deviceMode
 @property  BOOL hasAADSSOExtension
 @property  NSDictionary *extraDeviceInformation
 @property  unsigned long platformSSOStatus

  // instance methods
  0x00000016964 -[MSALDeviceInformation init]
  0x00000016a20 -[MSALDeviceInformation initWithMSIDDeviceInfo:]
  0x00000016b34 -[MSALDeviceInformation extraDeviceInformation]
  0x00000016b3c -[MSALDeviceInformation msalDeviceModeFromMSIDMode:]
  0x00000016b48 -[MSALDeviceInformation msalDeviceModeString]
  0x00000016b74 -[MSALDeviceInformation msalPlatformSSOStatusFromMSIDPlatformSSOStatus:]
  0x00000016b8c -[MSALDeviceInformation initExtraDeviceInformation:]
  0x00000016c38 -[MSALDeviceInformation addRegisteredDeviceMetadataInformation:]
  0x00000016ca4 -[MSALDeviceInformation deviceMode]
  0x00000016cac -[MSALDeviceInformation setDeviceMode:]
  0x00000016cb4 -[MSALDeviceInformation hasAADSSOExtension]
  0x00000016cbc -[MSALDeviceInformation platformSSOStatus]


0x0000017bf38 MSALAuthority : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  MSIDAuthority *msidAuthority
 @property  NSURL *url

  // class methods
  0x00000016d30 +[MSALAuthority authorityWithURL:error:]

  // instance methods
  0x00000016cd0 -[MSALAuthority initWithURL:error:]
  0x00000016e80 -[MSALAuthority copyWithZone:]
  0x00000016ed4 -[MSALAuthority isEqual:]
  0x00000016f88 -[MSALAuthority isEqualToAuthority:]
  0x0000001706c -[MSALAuthority url]
  0x00000017078 -[MSALAuthority msidAuthority]
  0x00000017080 -[MSALAuthority setMsidAuthority:]


0x0000017bfb0 MSALAADOauth2Provider : MSALOauth2Provider
  // instance methods
  0x000000170bc -[MSALAADOauth2Provider resultWithTokenResult:authScheme:popManager:error:]
  0x000000172d8 -[MSALAADOauth2Provider removeAdditionalAccountInfo:error:]
  0x00000017528 -[MSALAADOauth2Provider issuerAuthorityWithAccount:requestAuthority:instanceAware:error:]
  0x00000017b38 -[MSALAADOauth2Provider isSupportedAuthority:]
  0x00000017b88 -[MSALAADOauth2Provider tenantProfileWithClaims:homeAccountId:environment:error:]
  0x00000017ce4 -[MSALAADOauth2Provider initOauth2Factory]


0x0000017bfd8 MSALErrorConverter : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000017d20 +[MSALErrorConverter initialize]
  0x0000001862c +[MSALErrorConverter msalErrorFromMsidError:]
  0x00000018638 +[MSALErrorConverter msalErrorFromMsidError:classifyErrors:msalOauth2Provider:]
  0x00000018648 +[MSALErrorConverter msalErrorFromMsidError:classifyErrors:msalOauth2Provider:correlationId:authScheme:popManager:]
  0x000000188fc +[MSALErrorConverter errorWithDomain:code:errorDescription:oauthError:subError:underlyingError:correlationId:userInfo:classifyErrors:msalOauth2Provider:authScheme:popManager:]


0x0000017c050 MSALResult : NSObject /usr/lib/libobjc.A.dylib
 @property  <MSALAuthenticationSchemeProtocol><MSALAuthenticationSchemeProtocolInternal> *authScheme
 @property  NSString *accessToken
 @property  NSDate *expiresOn
 @property  BOOL extendedLifeTimeToken
 @property  NSString *tenantId
 @property  NSString *idToken
 @property  NSArray *scopes
 @property  MSALTenantProfile *tenantProfile
 @property  MSALAccount *account
 @property  NSString *uniqueId
 @property  MSALAuthority *authority
 @property  NSUUID *correlationId
 @property  NSString *authorizationHeader
 @property  NSString *authenticationScheme

  // class methods
  0x00000019460 +[MSALResult resultWithAccessToken:expiresOn:isExtendedLifetimeToken:tenantId:tenantProfile:account:idToken:uniqueId:scopes:authority:correlationId:authScheme:]
  0x000000196ec +[MSALResult resultWithMSIDTokenResult:authority:authScheme:popManager:error:]

  // instance methods
  0x00000019230 -[MSALResult authorizationHeader]
  0x000000192e8 -[MSALResult authenticationScheme]
  0x0000001932c -[MSALResult accessToken]
  0x00000019338 -[MSALResult expiresOn]
  0x00000019344 -[MSALResult extendedLifeTimeToken]
  0x00000019350 -[MSALResult tenantId]
  0x0000001935c -[MSALResult idToken]
  0x00000019368 -[MSALResult scopes]
  0x00000019374 -[MSALResult tenantProfile]
  0x00000019380 -[MSALResult account]
  0x0000001938c -[MSALResult uniqueId]
  0x00000019398 -[MSALResult authority]
  0x000000193a4 -[MSALResult correlationId]
  0x000000193b0 -[MSALResult authScheme]
  0x000000193bc -[MSALResult setAuthScheme:]


0x0000017c078 MSALAuthenticationSchemePop : NSObject /usr/lib/libobjc.A.dylib <MSALAuthenticationSchemeProtocolInternal, MSALAuthenticationSchemeProtocol>
 @property  unsigned long httpMethod
 @property  NSURL *requestUrl
 @property  NSString *nonce
 @property  NSDictionary *additionalParameters
 @property  unsigned long scheme
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription
 @property  NSString *authenticationScheme

  // instance methods
  0x00000019c94 -[MSALAuthenticationSchemePop initWithHttpMethod:requestUrl:nonce:additionalParameters:]
  0x00000019dfc -[MSALAuthenticationSchemePop authenticationScheme]
  0x00000019e10 -[MSALAuthenticationSchemePop createMSIDAuthenticationSchemeWithParams:]
  0x00000019e5c -[MSALAuthenticationSchemePop getSchemeParameters:]
  0x00000019fbc -[MSALAuthenticationSchemePop getClientAccessToken:popManager:error:]
  0x0000001a1a8 -[MSALAuthenticationSchemePop getAuthorizationHeader:]
  0x0000001a23c -[MSALAuthenticationSchemePop scheme]
  0x0000001a244 -[MSALAuthenticationSchemePop httpMethod]
  0x0000001a24c -[MSALAuthenticationSchemePop setHttpMethod:]
  0x0000001a254 -[MSALAuthenticationSchemePop requestUrl]
  0x0000001a25c -[MSALAuthenticationSchemePop setRequestUrl:]
  0x0000001a268 -[MSALAuthenticationSchemePop nonce]
  0x0000001a270 -[MSALAuthenticationSchemePop setNonce:]
  0x0000001a27c -[MSALAuthenticationSchemePop additionalParameters]
  0x0000001a284 -[MSALAuthenticationSchemePop setAdditionalParameters:]


0x0000017c0c8 MSALB2CAuthority : MSALAuthority
  // instance methods
  0x0000001a2cc -[MSALB2CAuthority initWithURL:error:]
  0x0000001a2d8 -[MSALB2CAuthority initWithURL:validateFormat:error:]
  0x0000001a3e4 -[MSALB2CAuthority url]


0x0000017c118 MSALSliceConfig : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSString *slice
 @property  NSString *dc
 @property  NSDictionary *sliceDictionary

  // class methods
  0x0000001a4ec +[MSALSliceConfig configWithSlice:dc:]

  // instance methods
  0x0000001a428 -[MSALSliceConfig initWithSlice:dc:]
  0x0000001a55c -[MSALSliceConfig sliceDictionary]
  0x0000001a62c -[MSALSliceConfig copyWithZone:]
  0x0000001a6a0 -[MSALSliceConfig slice]
  0x0000001a6ac -[MSALSliceConfig setSlice:]
  0x0000001a6b4 -[MSALSliceConfig dc]
  0x0000001a6c0 -[MSALSliceConfig setDc:]


0x0000017c168 MSALAccountsProvider : MSALSSOExtensionRequestHandler
 @property  MSIDDefaultTokenCacheAccessor *tokenCache
 @property  MSIDAccountMetadataCacheAccessor *accountMetadataCache
 @property  NSString *clientId
 @property  MSALExternalAccountHandler *externalAccountProvider
 @property  NSPredicate *homeTenantFilterPredicate

  // instance methods
  0x0000001a6f8 -[MSALAccountsProvider initWithTokenCache:accountMetadataCache:clientId:]
  0x0000001a700 -[MSALAccountsProvider initWithTokenCache:accountMetadataCache:clientId:externalAccountProvider:]
  0x0000001a87c -[MSALAccountsProvider allAccounts:]
  0x0000001a8e0 -[MSALAccountsProvider accountsForParameters:error:]
  0x0000001a8ec -[MSALAccountsProvider accountForParameters:error:]
  0x0000001ae30 -[MSALAccountsProvider accountsForParameters:authority:error:]
  0x0000001ae3c -[MSALAccountsProvider accountsForParameters:authority:brokerAccounts:error:]
  0x0000001b18c -[MSALAccountsProvider filteredAccountsForParameters:msidAccounts:includeExternalAccounts:]
  0x0000001b6d0 -[MSALAccountsProvider msalAccountsFromMSIDAccounts:externalAccounts:]
  0x0000001ba1c -[MSALAccountsProvider addMSALAccount:toSet:claims:]
  0x0000001bb40 -[MSALAccountsProvider allAccountsFilteredByAuthority:completionBlock:]
  0x0000001bd80 -[MSALAccountsProvider allAccountsFromDevice:requestParameters:completionBlock:]
  0x0000001beb0 -[MSALAccountsProvider allAccountsFromSSOExtension:requestParameters:completionBlock:]
  0x0000001c1dc -[MSALAccountsProvider appMetadataItem]
  0x0000001c3c4 -[MSALAccountsProvider signInStateForHomeAccountId:context:error:]
  0x0000001c4b8 -[MSALAccountsProvider currentPrincipalAccount:]
  0x0000001c704 -[MSALAccountsProvider setCurrentPrincipalAccountId:accountEnvironment:error:]
  0x0000001c7bc -[MSALAccountsProvider tokenCache]
  0x0000001c7cc -[MSALAccountsProvider setTokenCache:]
  0x0000001c7e0 -[MSALAccountsProvider accountMetadataCache]
  0x0000001c7f0 -[MSALAccountsProvider setAccountMetadataCache:]
  0x0000001c804 -[MSALAccountsProvider clientId]
  0x0000001c814 -[MSALAccountsProvider setClientId:]
  0x0000001c828 -[MSALAccountsProvider externalAccountProvider]
  0x0000001c838 -[MSALAccountsProvider setExternalAccountProvider:]
  0x0000001c84c -[MSALAccountsProvider homeTenantFilterPredicate]
  0x0000001c85c -[MSALAccountsProvider setHomeTenantFilterPredicate:]


0x0000017c1e0 MSALWipeCacheForAllAccountsConfig : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000001c8ec +[MSALWipeCacheForAllAccountsConfig additionalPartnerLocations]


0x0000017c208 MSALSilentTokenParameters : MSALTokenParameters
 @property  BOOL forceRefresh
 @property  BOOL allowUsingLocalCachedRtWhenSsoExtFailed

  // instance methods
  0x0000001cbac -[MSALSilentTokenParameters initWithScopes:account:]
  0x0000001cc6c -[MSALSilentTokenParameters telemetryApiId]
  0x0000001cc7c -[MSALSilentTokenParameters setTelemetryApiId:]
  0x0000001cc8c -[MSALSilentTokenParameters forceRefresh]
  0x0000001cc9c -[MSALSilentTokenParameters setForceRefresh:]
  0x0000001ccac -[MSALSilentTokenParameters allowUsingLocalCachedRtWhenSsoExtFailed]
  0x0000001ccbc -[MSALSilentTokenParameters setAllowUsingLocalCachedRtWhenSsoExtFailed:]


0x0000017c258 MSIDWorkPlaceJoinUtilBase : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000001cccc +[MSIDWorkPlaceJoinUtilBase getWPJStringDataForIdentifier:accessGroup:context:error:]
  0x0000001cce8 +[MSIDWorkPlaceJoinUtilBase getWPJStringDataFromV2ForTenantId:identifier:key:accessGroup:context:error:]
  0x0000001cfe8 +[MSIDWorkPlaceJoinUtilBase getRegisteredDeviceMetadataInformation:]
  0x0000001cff4 +[MSIDWorkPlaceJoinUtilBase v2AccessGroupAllowedWithContext:]
  0x0000001d14c +[MSIDWorkPlaceJoinUtilBase getRegisteredDeviceMetadataInformation:tenantId:usePrimaryFormat:]
  0x0000001d510 +[MSIDWorkPlaceJoinUtilBase findWPJRegistrationInfoWithAdditionalPrivateKeyAttributes:certAttributes:context:]
  0x0000001d954 +[MSIDWorkPlaceJoinUtilBase getWPJKeysWithTenantId:context:]
  0x0000001e1c0 +[MSIDWorkPlaceJoinUtilBase getPrimaryEccTenantWithSharedAccessGroup:context:error:]
  0x0000001e470 +[MSIDWorkPlaceJoinUtilBase readWPJMetadataWithSharedAccessGroup:tenantIdentifier:domainName:context:error:]


0x0000017c2a8 MSIDSignoutController : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDInteractiveRequestParameters *parameters
 @property  BOOL shouldSignoutFromBrowser
 @property  MSIDOauth2Factory *factory
 @property  MSIDOIDCSignoutRequest *currentRequest

  // instance methods
  0x0000001e91c -[MSIDSignoutController initWithRequestParameters:shouldSignoutFromBrowser:oauthFactory:error:]
  0x0000001ea7c -[MSIDSignoutController executeRequestWithCompletion:]
  0x0000001ed7c -[MSIDSignoutController parameters]
  0x0000001ed84 -[MSIDSignoutController setParameters:]
  0x0000001ed90 -[MSIDSignoutController shouldSignoutFromBrowser]
  0x0000001ed98 -[MSIDSignoutController setShouldSignoutFromBrowser:]
  0x0000001eda0 -[MSIDSignoutController factory]
  0x0000001eda8 -[MSIDSignoutController setFactory:]
  0x0000001edb4 -[MSIDSignoutController currentRequest]
  0x0000001edbc -[MSIDSignoutController setCurrentRequest:]


0x0000017c2f8 MSIDBrokerNativeAppOperationResponse : MSIDBrokerOperationResponse <MSIDJsonSerializable>
 @property  BOOL success
 @property  NSString *clientAppVersion
 @property  MSIDDeviceInfo *deviceInfo
 @property  NSNumber *httpStatusCode
 @property  NSDictionary *httpHeaders
 @property  NSString *httpVersion
 @property  NSDate *responseGenerationTimeStamp
 @property  NSDate *requestReceivedTimeStamp
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000001ee04 +[MSIDBrokerNativeAppOperationResponse load]
  0x0000001ef00 +[MSIDBrokerNativeAppOperationResponse responseType]
  0x0000001ef64 +[MSIDBrokerNativeAppOperationResponse defaultHttpStatusCode]

  // instance methods
  0x0000001ee54 -[MSIDBrokerNativeAppOperationResponse initWithDeviceInfo:]
  0x0000001ef10 -[MSIDBrokerNativeAppOperationResponse httpStatusCode]
  0x0000001ef70 -[MSIDBrokerNativeAppOperationResponse httpVersion]
  0x0000001efb0 -[MSIDBrokerNativeAppOperationResponse initWithJSONDictionary:error:]
  0x0000001f220 -[MSIDBrokerNativeAppOperationResponse jsonDictionary]
  0x0000001f450 -[MSIDBrokerNativeAppOperationResponse trackPerfTelemetryWithLastRequest:requestStartDate:telemetryType:]
  0x0000001f634 -[MSIDBrokerNativeAppOperationResponse success]
  0x0000001f644 -[MSIDBrokerNativeAppOperationResponse setSuccess:]
  0x0000001f654 -[MSIDBrokerNativeAppOperationResponse clientAppVersion]
  0x0000001f664 -[MSIDBrokerNativeAppOperationResponse setClientAppVersion:]
  0x0000001f678 -[MSIDBrokerNativeAppOperationResponse deviceInfo]
  0x0000001f688 -[MSIDBrokerNativeAppOperationResponse setDeviceInfo:]
  0x0000001f69c -[MSIDBrokerNativeAppOperationResponse setHttpStatusCode:]
  0x0000001f6b0 -[MSIDBrokerNativeAppOperationResponse httpHeaders]
  0x0000001f6c0 -[MSIDBrokerNativeAppOperationResponse setHttpHeaders:]
  0x0000001f6d4 -[MSIDBrokerNativeAppOperationResponse setHttpVersion:]
  0x0000001f6e8 -[MSIDBrokerNativeAppOperationResponse responseGenerationTimeStamp]
  0x0000001f6f8 -[MSIDBrokerNativeAppOperationResponse setResponseGenerationTimeStamp:]
  0x0000001f70c -[MSIDBrokerNativeAppOperationResponse requestReceivedTimeStamp]
  0x0000001f71c -[MSIDBrokerNativeAppOperationResponse setRequestReceivedTimeStamp:]


0x0000017c370 MSIDBrowserNativeMessageSignOutResponse : MSIDBrokerNativeAppOperationResponse
  // instance methods
  0x0000001f7d4 -[MSIDBrowserNativeMessageSignOutResponse initWithJSONDictionary:error:]
  0x0000001f874 -[MSIDBrowserNativeMessageSignOutResponse jsonDictionary]


0x0000017c398 MSIDLegacySingleResourceToken : MSIDLegacyAccessToken <MSIDRefreshableToken>
 @property  NSString *refreshToken
 @property  NSString *familyId
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000001f880 -[MSIDLegacySingleResourceToken copyWithZone:]
  0x0000001f948 -[MSIDLegacySingleResourceToken isEqual:]
  0x0000001fa98 -[MSIDLegacySingleResourceToken isEqualToItem:]
  0x0000001fc60 -[MSIDLegacySingleResourceToken initWithTokenCacheItem:]
  0x0000001fd18 -[MSIDLegacySingleResourceToken tokenCacheItem]
  0x0000001fdc8 -[MSIDLegacySingleResourceToken initWithLegacyTokenCacheItem:]
  0x0000001fea8 -[MSIDLegacySingleResourceToken legacyTokenCacheItem]
  0x0000001ff88 -[MSIDLegacySingleResourceToken credentialType]
  0x0000001ff90 -[MSIDLegacySingleResourceToken supportsCredentialType:]
  0x000000200e4 -[MSIDLegacySingleResourceToken refreshToken]
  0x000000200f4 -[MSIDLegacySingleResourceToken setRefreshToken:]
  0x00000020100 -[MSIDLegacySingleResourceToken familyId]
  0x00000020110 -[MSIDLegacySingleResourceToken setFamilyId:]


0x0000017c3e8 MSIDAggregatedDispatcher : MSIDDefaultDispatcher
  // class methods
  0x0000002015c +[MSIDAggregatedDispatcher initialize]

  // instance methods
  0x00000020260 -[MSIDAggregatedDispatcher flush:]
  0x000000203ec -[MSIDAggregatedDispatcher addProperties:fromEvent:]


0x0000017c460 MSIDAuthorityCacheRecord : NSObject /usr/lib/libobjc.A.dylib
 @property  NSURL *openIdConfigurationEndpoint
 @property  BOOL validated
 @property  NSError *error

  // instance methods
  0x000000205bc -[MSIDAuthorityCacheRecord openIdConfigurationEndpoint]
  0x000000205c4 -[MSIDAuthorityCacheRecord setOpenIdConfigurationEndpoint:]
  0x000000205d0 -[MSIDAuthorityCacheRecord validated]
  0x000000205d8 -[MSIDAuthorityCacheRecord setValidated:]
  0x000000205e0 -[MSIDAuthorityCacheRecord error]
  0x000000205e8 -[MSIDAuthorityCacheRecord setError:]


0x0000017c488 MSIDBrokerKeyProvider : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *keychainAccessGroup
 @property  NSString *keyIdentifier

  // instance methods
  0x00000020624 -[MSIDBrokerKeyProvider initWithGroup:]
  0x00000020634 -[MSIDBrokerKeyProvider initWithGroup:keyIdentifier:]
  0x000000208d0 -[MSIDBrokerKeyProvider brokerKeyWithError:]
  0x00000020af8 -[MSIDBrokerKeyProvider base64BrokerKeyWithContext:error:]
  0x00000020dc4 -[MSIDBrokerKeyProvider createBrokerKeyWithError:]
  0x00000021208 -[MSIDBrokerKeyProvider deleteSymmetricKeyWithError:]
  0x000000213cc -[MSIDBrokerKeyProvider saveApplicationToken:forClientId:error:]
  0x00000021688 -[MSIDBrokerKeyProvider getApplicationToken:error:]
  0x000000218e4 -[MSIDBrokerKeyProvider keychainAccessGroup]
  0x000000218ec -[MSIDBrokerKeyProvider setKeychainAccessGroup:]
  0x000000218f8 -[MSIDBrokerKeyProvider keyIdentifier]
  0x00000021900 -[MSIDBrokerKeyProvider setKeyIdentifier:]


0x0000017c4d8 MSIDLocalInteractiveController : MSIDBaseRequestController <MSIDRequestControlling>
 @property  MSIDInteractiveTokenRequestParameters *interactiveRequestParamaters
 @property  MSIDInteractiveTokenRequest *currentRequest
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000002193c -[MSIDLocalInteractiveController initWithInteractiveRequestParameters:tokenRequestProvider:error:]
  0x00000021a08 -[MSIDLocalInteractiveController acquireToken:]
  0x00000021ef0 -[MSIDLocalInteractiveController handleWebMSAuthResponse:completion:]
  0x000000223bc -[MSIDLocalInteractiveController promptBrokerInstallWithResponse:completionBlock:]
  0x000000224c4 -[MSIDLocalInteractiveController telemetryAPIEvent]
  0x00000022628 -[MSIDLocalInteractiveController acquireTokenWithRequest:completionBlock:]
  0x00000022910 -[MSIDLocalInteractiveController interactiveRequestParamaters]
  0x00000022920 -[MSIDLocalInteractiveController setInteractiveRequestParamaters:]
  0x00000022934 -[MSIDLocalInteractiveController currentRequest]
  0x00000022944 -[MSIDLocalInteractiveController setCurrentRequest:]


0x0000017c528 MSIDDefaultCredentialCacheKey : MSIDCacheKey <NSCopying>
 @property  NSString *homeAccountId
 @property  NSString *environment
 @property  NSString *realm
 @property  NSString *clientId
 @property  NSString *familyId
 @property  NSString *target
 @property  NSString *applicationIdentifier
 @property  long long credentialType
 @property  NSString *tokenType
 @property  NSString *requestedClaims

  // instance methods
  0x00000022998 -[MSIDDefaultCredentialCacheKey serviceWithType:clientID:realm:applicationIdentifier:target:appKey:tokenType:requestedClaims:]
  0x00000022cd8 -[MSIDDefaultCredentialCacheKey credentialIdWithType:clientId:realm:applicationIdentifier:]
  0x00000022e74 -[MSIDDefaultCredentialCacheKey accountIdWithHomeAccountId:environment:]
  0x00000022f54 -[MSIDDefaultCredentialCacheKey credentialTypeNumber:]
  0x00000022f60 -[MSIDDefaultCredentialCacheKey initWithHomeAccountId:environment:clientId:credentialType:]
  0x00000023084 -[MSIDDefaultCredentialCacheKey generic]
  0x00000023184 -[MSIDDefaultCredentialCacheKey type]
  0x000000231ac -[MSIDDefaultCredentialCacheKey account]
  0x00000023224 -[MSIDDefaultCredentialCacheKey service]
  0x0000002339c -[MSIDDefaultCredentialCacheKey isShared]
  0x000000233b8 -[MSIDDefaultCredentialCacheKey appKeyHash]
  0x00000023440 -[MSIDDefaultCredentialCacheKey copyWithZone:]
  0x000000235d4 -[MSIDDefaultCredentialCacheKey homeAccountId]
  0x000000235e4 -[MSIDDefaultCredentialCacheKey setHomeAccountId:]
  0x000000235f8 -[MSIDDefaultCredentialCacheKey environment]
  0x00000023608 -[MSIDDefaultCredentialCacheKey setEnvironment:]
  0x0000002361c -[MSIDDefaultCredentialCacheKey realm]
  0x0000002362c -[MSIDDefaultCredentialCacheKey setRealm:]
  0x00000023640 -[MSIDDefaultCredentialCacheKey clientId]
  0x00000023650 -[MSIDDefaultCredentialCacheKey setClientId:]
  0x00000023664 -[MSIDDefaultCredentialCacheKey familyId]
  0x00000023674 -[MSIDDefaultCredentialCacheKey setFamilyId:]
  0x00000023688 -[MSIDDefaultCredentialCacheKey target]
  0x00000023698 -[MSIDDefaultCredentialCacheKey setTarget:]
  0x000000236ac -[MSIDDefaultCredentialCacheKey applicationIdentifier]
  0x000000236bc -[MSIDDefaultCredentialCacheKey setApplicationIdentifier:]
  0x000000236d0 -[MSIDDefaultCredentialCacheKey credentialType]
  0x000000236e0 -[MSIDDefaultCredentialCacheKey setCredentialType:]
  0x000000236f0 -[MSIDDefaultCredentialCacheKey tokenType]
  0x00000023700 -[MSIDDefaultCredentialCacheKey setTokenType:]
  0x00000023714 -[MSIDDefaultCredentialCacheKey requestedClaims]
  0x00000023724 -[MSIDDefaultCredentialCacheKey setRequestedClaims:]


0x0000017c578 MSIDCredentialCacheItem : NSObject /usr/lib/libobjc.A.dylib <NSCopying, MSIDJsonSerializable, MSIDKeyGenerator>
 @property  NSDictionary *json
 @property  NSString *clientId
 @property  long long credentialType
 @property  NSString *secret
 @property  NSString *target
 @property  NSString *realm
 @property  NSString *environment
 @property  NSDate *expiresOn
 @property  NSDate *extendedExpiresOn
 @property  NSDate *refreshOn
 @property  NSDate *cachedAt
 @property  NSString *expiryInterval
 @property  NSDate *lastRecoveryAttempt
 @property  NSString *familyId
 @property  NSString *homeAccountId
 @property  NSString *enrollmentId
 @property  NSString *speInfo
 @property  NSString *appKey
 @property  NSString *applicationIdentifier
 @property  NSDate *lastModificationTime
 @property  NSString *lastModificationApp
 @property  NSString *tokenType
 @property  NSString *kid
 @property  NSString *requestedClaims
 @property  NSString *redirectUri
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000065818 -[MSIDCredentialCacheItem tokenWithType:]
  0x00000023adc -[MSIDCredentialCacheItem isEqual:]
  0x00000023b50 -[MSIDCredentialCacheItem isEqualToItem:]
  0x00000024a84 -[MSIDCredentialCacheItem copyWithZone:]
  0x00000025004 -[MSIDCredentialCacheItem initWithJSONDictionary:error:]
  0x000000256cc -[MSIDCredentialCacheItem jsonDictionary]
  0x00000025a20 -[MSIDCredentialCacheItem matchesTarget:comparisonOptions:]
  0x00000025b84 -[MSIDCredentialCacheItem matchesWithHomeAccountId:environment:environmentAliases:]
  0x00000025d94 -[MSIDCredentialCacheItem matchByEnvironment:environmentAliases:]
  0x00000026008 -[MSIDCredentialCacheItem matchesWithRealm:clientId:familyId:target:requestedClaims:targetMatching:clientIdMatching:]
  0x00000026a4c -[MSIDCredentialCacheItem isTombstone]
  0x00000026a90 -[MSIDCredentialCacheItem generateCacheKey]
  0x00000026c10 -[MSIDCredentialCacheItem clientId]
  0x00000026c1c -[MSIDCredentialCacheItem setClientId:]
  0x00000026c24 -[MSIDCredentialCacheItem credentialType]
  0x00000026c2c -[MSIDCredentialCacheItem setCredentialType:]
  0x00000026c34 -[MSIDCredentialCacheItem secret]
  0x00000026c40 -[MSIDCredentialCacheItem setSecret:]
  0x00000026c48 -[MSIDCredentialCacheItem target]
  0x00000026c54 -[MSIDCredentialCacheItem setTarget:]
  0x00000026c5c -[MSIDCredentialCacheItem realm]
  0x00000026c68 -[MSIDCredentialCacheItem setRealm:]
  0x00000026c70 -[MSIDCredentialCacheItem environment]
  0x00000026c7c -[MSIDCredentialCacheItem setEnvironment:]
  0x00000026c84 -[MSIDCredentialCacheItem expiresOn]
  0x00000026c90 -[MSIDCredentialCacheItem setExpiresOn:]
  0x00000026c98 -[MSIDCredentialCacheItem extendedExpiresOn]
  0x00000026ca4 -[MSIDCredentialCacheItem setExtendedExpiresOn:]
  0x00000026cac -[MSIDCredentialCacheItem refreshOn]
  0x00000026cb8 -[MSIDCredentialCacheItem setRefreshOn:]
  0x00000026cc0 -[MSIDCredentialCacheItem cachedAt]
  0x00000026ccc -[MSIDCredentialCacheItem setCachedAt:]
  0x00000026cd4 -[MSIDCredentialCacheItem expiryInterval]
  0x00000026ce0 -[MSIDCredentialCacheItem setExpiryInterval:]
  0x00000026ce8 -[MSIDCredentialCacheItem lastRecoveryAttempt]
  0x00000026cf4 -[MSIDCredentialCacheItem setLastRecoveryAttempt:]
  0x00000026cfc -[MSIDCredentialCacheItem familyId]
  0x00000026d08 -[MSIDCredentialCacheItem setFamilyId:]
  0x00000026d10 -[MSIDCredentialCacheItem homeAccountId]
  0x00000026d1c -[MSIDCredentialCacheItem setHomeAccountId:]
  0x00000026d24 -[MSIDCredentialCacheItem enrollmentId]
  0x00000026d30 -[MSIDCredentialCacheItem setEnrollmentId:]
  0x00000026d38 -[MSIDCredentialCacheItem speInfo]
  0x00000026d44 -[MSIDCredentialCacheItem setSpeInfo:]
  0x00000026d4c -[MSIDCredentialCacheItem appKey]
  0x00000026d58 -[MSIDCredentialCacheItem setAppKey:]
  0x00000026d60 -[MSIDCredentialCacheItem applicationIdentifier]
  0x00000026d6c -[MSIDCredentialCacheItem setApplicationIdentifier:]
  0x00000026d74 -[MSIDCredentialCacheItem lastModificationTime]
  0x00000026d80 -[MSIDCredentialCacheItem setLastModificationTime:]
  0x00000026d88 -[MSIDCredentialCacheItem lastModificationApp]
  0x00000026d94 -[MSIDCredentialCacheItem setLastModificationApp:]
  0x00000026d9c -[MSIDCredentialCacheItem tokenType]
  0x00000026da8 -[MSIDCredentialCacheItem setTokenType:]
  0x00000026db0 -[MSIDCredentialCacheItem kid]
  0x00000026dbc -[MSIDCredentialCacheItem setKid:]
  0x00000026dc4 -[MSIDCredentialCacheItem requestedClaims]
  0x00000026dd0 -[MSIDCredentialCacheItem setRequestedClaims:]
  0x00000026dd8 -[MSIDCredentialCacheItem redirectUri]
  0x00000026de4 -[MSIDCredentialCacheItem setRedirectUri:]
  0x00000026dec -[MSIDCredentialCacheItem json]
  0x00000026df8 -[MSIDCredentialCacheItem setJson:]


0x0000017c5f0 MSIDAADIdTokenClaimsFactory : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000026f38 +[MSIDAADIdTokenClaimsFactory claimsFromRawIdToken:error:]


0x0000017c618 MSIDAADOpenIdConfigurationInfoResponseSerializer : MSIDHttpResponseSerializer
 @property  NSURL *endpoint

  // instance methods
  0x000000270e0 -[MSIDAADOpenIdConfigurationInfoResponseSerializer init]
  0x00000027178 -[MSIDAADOpenIdConfigurationInfoResponseSerializer responseObjectForResponse:data:context:error:]
  0x00000027750 -[MSIDAADOpenIdConfigurationInfoResponseSerializer endpoint]
  0x00000027760 -[MSIDAADOpenIdConfigurationInfoResponseSerializer setEndpoint:]


0x0000017c668 MSIDIntuneUserDefaultsCacheDataSource : NSObject /usr/lib/libobjc.A.dylib <MSIDIntuneCacheDataSource>
 @property  NSUserDefaults *userDefaults
 @property  MSIDJsonSerializer *jsonSerializer
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000027788 -[MSIDIntuneUserDefaultsCacheDataSource initWithUserDefaults:]
  0x00000027864 -[MSIDIntuneUserDefaultsCacheDataSource init]
  0x0000002786c -[MSIDIntuneUserDefaultsCacheDataSource jsonDictionaryForKey:]
  0x0000002795c -[MSIDIntuneUserDefaultsCacheDataSource setJsonDictionary:forKey:]
  0x00000027a18 -[MSIDIntuneUserDefaultsCacheDataSource removeObjectForKey:]
  0x00000027a68 -[MSIDIntuneUserDefaultsCacheDataSource userDefaults]
  0x00000027a70 -[MSIDIntuneUserDefaultsCacheDataSource jsonSerializer]


0x0000017c6e0 MSIDInteractiveRequestParameters : MSIDRequestParameters
 @property  long long webviewType
 @property  WKWebView *customWebview
 @property  NSDictionary *customWebviewHeaders
 @property  NSViewController *parentViewController
 @property  NSWindow *presentationAnchorWindow
 @property  BOOL prefersEphemeralWebBrowserSession
 @property  NSString *telemetryWebviewType

  // instance methods
  0x00000019050 -[MSIDInteractiveRequestParameters fillWithWebViewParameters:useWebviewTypeFromGlobalConfig:customWebView:error:]
  0x000000191f0 -[MSIDInteractiveRequestParameters setAccountIdentifierFromMSALAccount:]
  0x00000027aa8 -[MSIDInteractiveRequestParameters webviewType]
  0x00000027ab8 -[MSIDInteractiveRequestParameters setWebviewType:]
  0x00000027ac8 -[MSIDInteractiveRequestParameters customWebview]
  0x00000027ad8 -[MSIDInteractiveRequestParameters setCustomWebview:]
  0x00000027aec -[MSIDInteractiveRequestParameters customWebviewHeaders]
  0x00000027afc -[MSIDInteractiveRequestParameters setCustomWebviewHeaders:]
  0x00000027b08 -[MSIDInteractiveRequestParameters parentViewController]
  0x00000027b28 -[MSIDInteractiveRequestParameters setParentViewController:]
  0x00000027b3c -[MSIDInteractiveRequestParameters presentationAnchorWindow]
  0x00000027b4c -[MSIDInteractiveRequestParameters setPresentationAnchorWindow:]
  0x00000027b60 -[MSIDInteractiveRequestParameters prefersEphemeralWebBrowserSession]
  0x00000027b70 -[MSIDInteractiveRequestParameters setPrefersEphemeralWebBrowserSession:]
  0x00000027b80 -[MSIDInteractiveRequestParameters telemetryWebviewType]
  0x00000027b90 -[MSIDInteractiveRequestParameters setTelemetryWebviewType:]


0x0000017c708 MSIDTelemetry : NSObject /usr/lib/libobjc.A.dylib
 @property  BOOL piiEnabled
 @property  BOOL notifyOnFailureOnly

  // class methods
  0x00000083a6c +[MSIDTelemetry startCacheEventWithName:context:]
  0x00000083b28 +[MSIDTelemetry stopCacheEvent:withItem:success:context:]
  0x00000083c18 +[MSIDTelemetry stopFailedCacheEvent:wipeData:context:]
  0x00000027d44 +[MSIDTelemetry sharedInstance]

  // instance methods
  0x00000027f40 -[MSIDTelemetry generateRequestId]
  0x00000027f8c -[MSIDTelemetry startEvent:eventName:]
  0x000000280ac -[MSIDTelemetry removeDispatcherByObserver:]
  0x0000002820c -[MSIDTelemetry stopEvent:event:]
  0x000000283c0 -[MSIDTelemetry dispatchEventNow:event:]
  0x00000028630 -[MSIDTelemetry getEventTrackingKey:eventName:]
  0x0000002866c -[MSIDTelemetry flush:]
  0x00000027c1c -[MSIDTelemetry init]
  0x00000027c98 -[MSIDTelemetry initInternal]
  0x00000027db4 -[MSIDTelemetry addDispatcher:]
  0x00000027e30 -[MSIDTelemetry removeDispatcher:]
  0x00000027e9c -[MSIDTelemetry removeAllDispatchers]
  0x00000027ee8 -[MSIDTelemetry piiEnabled]
  0x00000027ef4 -[MSIDTelemetry setPiiEnabled:]
  0x00000027efc -[MSIDTelemetry notifyOnFailureOnly]
  0x00000027f08 -[MSIDTelemetry setNotifyOnFailureOnly:]


0x0000017c758 MSIDBrokerInvocationOptions : NSObject /usr/lib/libobjc.A.dylib
 @property  long long minRequiredBrokerType
 @property  long long protocolType
 @property  long long brokerAADRequestVersion
 @property  NSArray *requiredSchemes
 @property  NSString *brokerBaseUrlString
 @property  NSString *versionDisplayableName
 @property  BOOL isUniversalLink
 @property  BOOL isRequiredBrokerPresent

  // instance methods
  0x000000287b8 -[MSIDBrokerInvocationOptions initWithRequiredBrokerType:protocolType:aadRequestVersion:]
  0x000000289f4 -[MSIDBrokerInvocationOptions init]
  0x00000028a04 -[MSIDBrokerInvocationOptions isRequiredBrokerPresent]
  0x00000028a0c -[MSIDBrokerInvocationOptions brokerBaseUrlForCommunicationProtocolType:aadRequestVersion:]
  0x00000028ad0 -[MSIDBrokerInvocationOptions displayableNameForBrokerType:]
  0x00000028afc -[MSIDBrokerInvocationOptions requiredSchemesForBrokerType:requestType:]
  0x00000028c08 -[MSIDBrokerInvocationOptions minRequiredBrokerType]
  0x00000028c10 -[MSIDBrokerInvocationOptions setMinRequiredBrokerType:]
  0x00000028c18 -[MSIDBrokerInvocationOptions protocolType]
  0x00000028c20 -[MSIDBrokerInvocationOptions setProtocolType:]
  0x00000028c28 -[MSIDBrokerInvocationOptions brokerAADRequestVersion]
  0x00000028c30 -[MSIDBrokerInvocationOptions setBrokerAADRequestVersion:]
  0x00000028c38 -[MSIDBrokerInvocationOptions brokerBaseUrlString]
  0x00000028c40 -[MSIDBrokerInvocationOptions setBrokerBaseUrlString:]
  0x00000028c4c -[MSIDBrokerInvocationOptions versionDisplayableName]
  0x00000028c54 -[MSIDBrokerInvocationOptions setVersionDisplayableName:]
  0x00000028c60 -[MSIDBrokerInvocationOptions isUniversalLink]
  0x00000028c68 -[MSIDBrokerInvocationOptions setIsUniversalLink:]
  0x00000028c70 -[MSIDBrokerInvocationOptions requiredSchemes]
  0x00000028c78 -[MSIDBrokerInvocationOptions setRequiredSchemes:]


0x0000017c7a8 MSIDIdTokenClaims : MSIDJsonObject
 @property  NSString *subject
 @property  NSString *issuer
 @property  NSString *preferredUsername
 @property  NSString *name
 @property  NSString *givenName
 @property  NSString *middleName
 @property  NSString *familyName
 @property  NSString *email
 @property  NSString *uniqueId
 @property  NSString *userId
 @property  BOOL userIdDisplayable
 @property  NSString *alternativeAccountId
 @property  MSIDAuthority *issuerAuthority
 @property  NSString *rawIdToken
 @property  NSString *realm

  // instance methods
  0x00000028cc0 -[MSIDIdTokenClaims subject]
  0x00000028d54 -[MSIDIdTokenClaims preferredUsername]
  0x00000028de8 -[MSIDIdTokenClaims name]
  0x00000028e7c -[MSIDIdTokenClaims givenName]
  0x00000028f10 -[MSIDIdTokenClaims familyName]
  0x00000028fa4 -[MSIDIdTokenClaims middleName]
  0x00000029038 -[MSIDIdTokenClaims email]
  0x000000290cc -[MSIDIdTokenClaims issuer]
  0x00000029160 -[MSIDIdTokenClaims initWithRawIdToken:error:]
  0x000000298d4 -[MSIDIdTokenClaims initWithJSONDictionary:error:]
  0x00000029950 -[MSIDIdTokenClaims initDerivedProperties]
  0x00000029a94 -[MSIDIdTokenClaims username]
  0x00000029af8 -[MSIDIdTokenClaims alternativeAccountId]
  0x00000029b00 -[MSIDIdTokenClaims realm]
  0x00000029b08 -[MSIDIdTokenClaims uniqueId]
  0x00000029b18 -[MSIDIdTokenClaims userId]
  0x00000029b28 -[MSIDIdTokenClaims userIdDisplayable]
  0x00000029b3c -[MSIDIdTokenClaims issuerAuthority]
  0x00000029b4c -[MSIDIdTokenClaims rawIdToken]


0x0000017c7f8 MSIDBrokerTokenRequest : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDInteractiveTokenRequestParameters *requestParameters
 @property  NSDictionary *resumeDictionary
 @property  NSString *brokerKey
 @property  NSURL *brokerRequestURL
 @property  NSString *brokerNonce
 @property  NSString *brokerApplicationToken
 @property  NSArray *sdkBrokerCapabilities

  // instance methods
  0x00000029bc4 -[MSIDBrokerTokenRequest initWithRequestParameters:brokerKey:brokerApplicationToken:sdkCapabilities:error:]
  0x00000029d58 -[MSIDBrokerTokenRequest initPayloadContentsWithError:]
  0x0000002a05c -[MSIDBrokerTokenRequest initResumeDictionary]
  0x0000002a0e8 -[MSIDBrokerTokenRequest defaultPayloadContents:]
  0x0000002a9d0 -[MSIDBrokerTokenRequest defaultResumeDictionaryContents]
  0x0000002ae1c -[MSIDBrokerTokenRequest checkParameter:parameterName:error:]
  0x0000002afa8 -[MSIDBrokerTokenRequest claimsParameter]
  0x0000002b124 -[MSIDBrokerTokenRequest intuneEnrollmentIdsParameter]
  0x0000002b2f0 -[MSIDBrokerTokenRequest intuneMAMResourceParameter]
  0x0000002b4bc -[MSIDBrokerTokenRequest brokerNonce]
  0x0000002b518 -[MSIDBrokerTokenRequest protocolPayloadContentsWithError:]
  0x0000002b524 -[MSIDBrokerTokenRequest protocolResumeDictionaryContents]
  0x0000002b530 -[MSIDBrokerTokenRequest requestParameters]
  0x0000002b538 -[MSIDBrokerTokenRequest setRequestParameters:]
  0x0000002b544 -[MSIDBrokerTokenRequest resumeDictionary]
  0x0000002b54c -[MSIDBrokerTokenRequest setResumeDictionary:]
  0x0000002b558 -[MSIDBrokerTokenRequest brokerRequestURL]
  0x0000002b560 -[MSIDBrokerTokenRequest setBrokerRequestURL:]
  0x0000002b56c -[MSIDBrokerTokenRequest setBrokerNonce:]
  0x0000002b578 -[MSIDBrokerTokenRequest sdkBrokerCapabilities]
  0x0000002b580 -[MSIDBrokerTokenRequest brokerKey]
  0x0000002b588 -[MSIDBrokerTokenRequest setBrokerKey:]
  0x0000002b594 -[MSIDBrokerTokenRequest brokerApplicationToken]
  0x0000002b59c -[MSIDBrokerTokenRequest setBrokerApplicationToken:]


0x0000017c870 MSIDAssymetricKeyLookupAttributes : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *privateKeyIdentifier
 @property  NSString *keyDisplayableLabel
 @property  NSString *certificateCommonName

  // instance methods
  0x0000002b614 -[MSIDAssymetricKeyLookupAttributes assymetricKeyPairAttributes]
  0x0000002b7ac -[MSIDAssymetricKeyLookupAttributes privateKeyAttributes]
  0x0000002b8ac -[MSIDAssymetricKeyLookupAttributes privateKeyIdentifier]
  0x0000002b8b4 -[MSIDAssymetricKeyLookupAttributes setPrivateKeyIdentifier:]
  0x0000002b8c0 -[MSIDAssymetricKeyLookupAttributes keyDisplayableLabel]
  0x0000002b8c8 -[MSIDAssymetricKeyLookupAttributes setKeyDisplayableLabel:]
  0x0000002b8d4 -[MSIDAssymetricKeyLookupAttributes certificateCommonName]
  0x0000002b8dc -[MSIDAssymetricKeyLookupAttributes setCertificateCommonName:]


0x0000017c898 MSIDBaseRequestController : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDRequestParameters *requestParameters
 @property  <MSIDTokenRequestProviding> *tokenRequestProvider
 @property  <MSIDRequestControlling> *fallbackController

  // instance methods
  0x0000002b924 -[MSIDBaseRequestController initWithRequestParameters:tokenRequestProvider:fallbackController:error:]
  0x0000002bb44 -[MSIDBaseRequestController telemetryAPIEvent]
  0x0000002bcd0 -[MSIDBaseRequestController stopTelemetryEvent:error:]
  0x0000002bee8 -[MSIDBaseRequestController requestParameters]
  0x0000002bef0 -[MSIDBaseRequestController setRequestParameters:]
  0x0000002befc -[MSIDBaseRequestController tokenRequestProvider]
  0x0000002bf04 -[MSIDBaseRequestController setTokenRequestProvider:]
  0x0000002bf10 -[MSIDBaseRequestController fallbackController]
  0x0000002bf18 -[MSIDBaseRequestController setFallbackController:]


0x0000017c910 MSIDJsonResponsePreprocessor : NSObject /usr/lib/libobjc.A.dylib <MSIDResponseSerialization>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000002bf60 -[MSIDJsonResponsePreprocessor responseObjectForResponse:data:context:error:]


0x0000017c938 MSIDWebWPJResponse : MSIDWebviewResponse
 @property  NSString *upn
 @property  NSString *appInstallLink
 @property  MSIDClientInfo *clientInfo

  // class methods
  0x0000002bf9c +[MSIDWebWPJResponse load]
  0x0000002c448 +[MSIDWebWPJResponse operation]

  // instance methods
  0x0000002bfd8 -[MSIDWebWPJResponse initWithURL:context:error:]
  0x0000002c2f8 -[MSIDWebWPJResponse isBrokerInstallResponse:]
  0x0000002c458 -[MSIDWebWPJResponse upn]
  0x0000002c468 -[MSIDWebWPJResponse appInstallLink]
  0x0000002c478 -[MSIDWebWPJResponse clientInfo]


0x0000017c9b0 MSIDNTLMUIPrompt : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000002c4dc +[MSIDNTLMUIPrompt dismissPrompt]
  0x0000002c590 +[MSIDNTLMUIPrompt presentPromptWithWebView:completion:]


0x0000017c9d8 MSIDBrowserNativeMessageRequest : MSIDBaseBrokerOperationRequest <MSIDJsonSerializable>
 @property  NSURL *sender
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000002cbb0 -[MSIDBrowserNativeMessageRequest initWithJSONDictionary:error:]
  0x0000002cd48 -[MSIDBrowserNativeMessageRequest jsonDictionary]
  0x0000002cde0 -[MSIDBrowserNativeMessageRequest sender]
  0x0000002cdf0 -[MSIDBrowserNativeMessageRequest setSender:]


0x0000017ca28 MSIDConfiguration : NSObject /usr/lib/libobjc.A.dylib <NSCopying, MSIDJsonSerializable>
 @property  NSString *resource
 @property  NSString *target
 @property  NSOrderedSet *scopes
 @property  MSIDAuthority *authority
 @property  NSString *redirectUri
 @property  NSString *clientId
 @property  MSIDAuthenticationScheme *authScheme
 @property  NSString *nestedAuthBrokerClientId
 @property  NSString *nestedAuthBrokerRedirectUri
 @property  NSString *applicationIdentifier
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000002ce90 -[MSIDConfiguration copyWithZone:]
  0x0000002d038 -[MSIDConfiguration initWithAuthority:redirectUri:clientId:target:]
  0x0000002d044 -[MSIDConfiguration initWithAuthority:redirectUri:clientId:resource:scopes:]
  0x0000002d068 -[MSIDConfiguration initWithAuthority:redirectUri:clientId:target:nestedAuthBrokerClientId:nestedAuthBrokerRedirectUri:]
  0x0000002d224 -[MSIDConfiguration initWithAuthority:redirectUri:clientId:resource:scopes:nestedAuthBrokerClientId:nestedAuthBrokerRedirectUri:]
  0x0000002d40c -[MSIDConfiguration initWithJSONDictionary:error:]
  0x0000002d6e0 -[MSIDConfiguration jsonDictionary]
  0x0000002dad8 -[MSIDConfiguration isNestedAuthProtocol]
  0x0000002db68 -[MSIDConfiguration authority]
  0x0000002db74 -[MSIDConfiguration setAuthority:]
  0x0000002db7c -[MSIDConfiguration redirectUri]
  0x0000002db88 -[MSIDConfiguration setRedirectUri:]
  0x0000002db90 -[MSIDConfiguration clientId]
  0x0000002db9c -[MSIDConfiguration setClientId:]
  0x0000002dba4 -[MSIDConfiguration target]
  0x0000002dbb0 -[MSIDConfiguration setTarget:]
  0x0000002dbb8 -[MSIDConfiguration authScheme]
  0x0000002dbc4 -[MSIDConfiguration setAuthScheme:]
  0x0000002dbcc -[MSIDConfiguration nestedAuthBrokerClientId]
  0x0000002dbd8 -[MSIDConfiguration setNestedAuthBrokerClientId:]
  0x0000002dbe0 -[MSIDConfiguration nestedAuthBrokerRedirectUri]
  0x0000002dbec -[MSIDConfiguration setNestedAuthBrokerRedirectUri:]
  0x0000002dbf4 -[MSIDConfiguration applicationIdentifier]
  0x0000002dc00 -[MSIDConfiguration setApplicationIdentifier:]
  0x0000002dc08 -[MSIDConfiguration resource]
  0x0000002dc14 -[MSIDConfiguration setResource:]
  0x0000002dc1c -[MSIDConfiguration scopes]
  0x0000002dc28 -[MSIDConfiguration setScopes:]


0x0000017caa0 MSIDCredentialTypeHelpers : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000002dcc0 +[MSIDCredentialTypeHelpers credentialTypeAsString:]
  0x0000002dcec +[MSIDCredentialTypeHelpers credentialTypeFromString:]
  0x0000002dfe0 +[MSIDCredentialTypeHelpers credentialTypeWithRefreshToken:accessToken:]
  0x0000002e060 +[MSIDCredentialTypeHelpers credentialTypeNumber:]


0x0000017cac8 MSIDSSOExtensionInteractiveTokenRequestController : MSIDLocalInteractiveController
  // class methods
  0x0000002e59c +[MSIDSSOExtensionInteractiveTokenRequestController canPerformRequest]

  // instance methods
  0x0000002e070 -[MSIDSSOExtensionInteractiveTokenRequestController initWithInteractiveRequestParameters:tokenRequestProvider:fallbackController:error:]
  0x0000002e140 -[MSIDSSOExtensionInteractiveTokenRequestController acquireToken:]
  0x0000002e5e0 -[MSIDSSOExtensionInteractiveTokenRequestController shouldFallback:]


0x0000017cb18 MSIDBrokerResponseHandler : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDOauth2Factory *oauthFactory
 @property  MSIDBrokerCryptoProvider *brokerCryptoProvider
 @property  MSIDTokenResponseValidator *tokenResponseValidator
 @property  <MSIDCacheAccessor> *tokenCache
 @property  MSIDAccountMetadataCacheAccessor *accountMetadataCacheAccessor
 @property  BOOL sourceApplicationAvailable
 @property  NSString *brokerNonce
 @property  NSURL *providedAuthority
 @property  BOOL instanceAware

  // instance methods
  0x0000002e8f4 -[MSIDBrokerResponseHandler initWithOauthFactory:tokenResponseValidator:]
  0x0000002e9c4 -[MSIDBrokerResponseHandler handleBrokerResponseWithURL:sourceApplication:error:]
  0x0000002f204 -[MSIDBrokerResponseHandler authSchemeFromResumeState:]
  0x0000002f324 -[MSIDBrokerResponseHandler canHandleBrokerResponse:hasCompletionBlock:protocolVersion:sdkName:]
  0x0000002f4cc -[MSIDBrokerResponseHandler verifyResumeStateDictionary:error:]
  0x0000002f7cc -[MSIDBrokerResponseHandler checkBrokerNonce:]
  0x0000002f86c -[MSIDBrokerResponseHandler brokerResponseFromEncryptedQueryParams:oidcScope:correlationId:authScheme:redirectUri:error:]
  0x0000002f874 -[MSIDBrokerResponseHandler cacheAccessorWithKeychainGroup:error:]
  0x0000002f87c -[MSIDBrokerResponseHandler accountMetadataCacheWithKeychainGroup:error:]
  0x0000002f884 -[MSIDBrokerResponseHandler canHandleBrokerResponse:hasCompletionBlock:]
  0x0000002f88c -[MSIDBrokerResponseHandler oauthFactory]
  0x0000002f894 -[MSIDBrokerResponseHandler setOauthFactory:]
  0x0000002f8a0 -[MSIDBrokerResponseHandler brokerCryptoProvider]
  0x0000002f8a8 -[MSIDBrokerResponseHandler setBrokerCryptoProvider:]
  0x0000002f8b4 -[MSIDBrokerResponseHandler tokenResponseValidator]
  0x0000002f8bc -[MSIDBrokerResponseHandler setTokenResponseValidator:]
  0x0000002f8c8 -[MSIDBrokerResponseHandler tokenCache]
  0x0000002f8d0 -[MSIDBrokerResponseHandler setTokenCache:]
  0x0000002f8dc -[MSIDBrokerResponseHandler accountMetadataCacheAccessor]
  0x0000002f8e4 -[MSIDBrokerResponseHandler setAccountMetadataCacheAccessor:]
  0x0000002f8f0 -[MSIDBrokerResponseHandler sourceApplicationAvailable]
  0x0000002f8f8 -[MSIDBrokerResponseHandler setSourceApplicationAvailable:]
  0x0000002f900 -[MSIDBrokerResponseHandler brokerNonce]
  0x0000002f908 -[MSIDBrokerResponseHandler setBrokerNonce:]
  0x0000002f914 -[MSIDBrokerResponseHandler providedAuthority]
  0x0000002f91c -[MSIDBrokerResponseHandler setProvidedAuthority:]
  0x0000002f928 -[MSIDBrokerResponseHandler instanceAware]
  0x0000002f930 -[MSIDBrokerResponseHandler setInstanceAware:]


0x0000017cb68 MSIDIntuneEnrollmentIdsCache : NSObject /usr/lib/libobjc.A.dylib
 @property  <MSIDIntuneCacheDataSource> *dataSource

  // class methods
  0x0000002fa48 +[MSIDIntuneEnrollmentIdsCache setSharedCache:]
  0x0000002fab4 +[MSIDIntuneEnrollmentIdsCache sharedCache]

  // instance methods
  0x0000002f9a4 -[MSIDIntuneEnrollmentIdsCache initWithDataSource:]
  0x0000002fb64 -[MSIDIntuneEnrollmentIdsCache enrollmentIdForUserObjectId:tenantId:context:error:]
  0x0000002fde4 -[MSIDIntuneEnrollmentIdsCache enrollmentIdForHomeAccountId:legacyUserId:context:error:]
  0x0000002fef4 -[MSIDIntuneEnrollmentIdsCache enrollmentIdForHomeAccountId:context:error:]
  0x0000002ff0c -[MSIDIntuneEnrollmentIdsCache enrollmentIdForUserId:context:error:]
  0x0000002ff24 -[MSIDIntuneEnrollmentIdsCache queryEnrollmentIdWithKey:validationId:context:error:]
  0x00000030280 -[MSIDIntuneEnrollmentIdsCache enrollmentIdIfAvailableWithContext:error:]
  0x00000030414 -[MSIDIntuneEnrollmentIdsCache fetchAllEnrollmentIdsWithContext:error:]
  0x00000030560 -[MSIDIntuneEnrollmentIdsCache setEnrollmentIdsJsonDictionary:context:error:]
  0x000000305ec -[MSIDIntuneEnrollmentIdsCache enrollmentIdsJsonDictionaryWithContext:error:]
  0x000000306a0 -[MSIDIntuneEnrollmentIdsCache clear]
  0x000000306d8 -[MSIDIntuneEnrollmentIdsCache isValid:context:error:]
  0x00000030b88 -[MSIDIntuneEnrollmentIdsCache dataSource]
  0x00000030b90 -[MSIDIntuneEnrollmentIdsCache setDataSource:]


0x0000017cbb8 MSIDCurrentRequestTelemetry : NSObject /usr/lib/libobjc.A.dylib <MSIDTelemetryStringSerializable>
 @property  long long schemaVersion
 @property  long long apiId
 @property  long long tokenCacheRefreshType
 @property  NSMutableArray *platformFields
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000030ba8 -[MSIDCurrentRequestTelemetry telemetryString]
  0x00000030bac -[MSIDCurrentRequestTelemetry initWithAppId:tokenCacheRefreshType:platformFields:]
  0x00000030c74 -[MSIDCurrentRequestTelemetry serializeCurrentTelemetryString]
  0x00000030cb8 -[MSIDCurrentRequestTelemetry createSerializedItem]
  0x00000030e14 -[MSIDCurrentRequestTelemetry schemaVersion]
  0x00000030e1c -[MSIDCurrentRequestTelemetry setSchemaVersion:]
  0x00000030e24 -[MSIDCurrentRequestTelemetry apiId]
  0x00000030e2c -[MSIDCurrentRequestTelemetry setApiId:]
  0x00000030e34 -[MSIDCurrentRequestTelemetry tokenCacheRefreshType]
  0x00000030e3c -[MSIDCurrentRequestTelemetry setTokenCacheRefreshType:]
  0x00000030e44 -[MSIDCurrentRequestTelemetry platformFields]
  0x00000030e4c -[MSIDCurrentRequestTelemetry setPlatformFields:]


0x0000017cc30 MSIDGetV1IdTokenCacheEvent : MSIDTelemetryBaseEvent
  // class methods
  0x000000312f8 +[MSIDGetV1IdTokenCacheEvent propertiesToAggregate]


0x0000017cc58 MSIDCIAMOauth2Factory : MSIDAADV2Oauth2Factory
  // class methods
  0x00000031478 +[MSIDCIAMOauth2Factory providerType]

  // instance methods
  0x00000031480 -[MSIDCIAMOauth2Factory checkResponseClass:context:error:]
  0x000000315ac -[MSIDCIAMOauth2Factory tokenResponseFromJSON:context:error:]
  0x00000031608 -[MSIDCIAMOauth2Factory tokenResponseFromJSON:refreshToken:context:error:]
  0x00000031680 -[MSIDCIAMOauth2Factory verifyResponse:context:error:]
  0x00000031758 -[MSIDCIAMOauth2Factory fillAccount:fromResponse:configuration:]
  0x00000031844 -[MSIDCIAMOauth2Factory cacheAuthorityWithConfiguration:tokenResponse:]
  0x00000031988 -[MSIDCIAMOauth2Factory resultAuthorityWithConfiguration:tokenResponse:error:]


0x0000017ccd0 MSIDLoginKeychainUtil : MSIDKeychainUtil
  // instance methods
  0x00000031a88 -[MSIDLoginKeychainUtil appIdPrefixFromSigningInformation:]


0x0000017cd20 MSIDLegacyBrokerResponseHandler : MSIDBrokerResponseHandler
  // instance methods
  0x00000031a90 -[MSIDLegacyBrokerResponseHandler cacheAccessorWithKeychainGroup:error:]
  0x00000031b04 -[MSIDLegacyBrokerResponseHandler brokerResponseFromEncryptedQueryParams:oidcScope:correlationId:authScheme:redirectUri:error:]
  0x000000320f0 -[MSIDLegacyBrokerResponseHandler resultFromBrokerErrorResponse:userDisplayableId:]
  0x0000003252c -[MSIDLegacyBrokerResponseHandler accountMetadataCacheWithKeychainGroup:error:]
  0x00000032534 -[MSIDLegacyBrokerResponseHandler canHandleBrokerResponse:hasCompletionBlock:]


0x0000017cd48 MSIDRedirectUri : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSURL *url
 @property  BOOL brokerCapable

  // class methods
  0x0000003264c +[MSIDRedirectUri defaultNonBrokerRedirectUri:]
  0x000000326ec +[MSIDRedirectUri defaultBrokerCapableRedirectUri]
  0x00000032798 +[MSIDRedirectUri redirectUriIsBrokerCapable:]

  // instance methods
  0x00000032550 -[MSIDRedirectUri initWithRedirectUri:brokerCapable:]
  0x000000325fc -[MSIDRedirectUri copyWithZone:]
  0x00000032d90 -[MSIDRedirectUri url]
  0x00000032d98 -[MSIDRedirectUri brokerCapable]


0x0000017cd98 MSIDDeviceHeader : MSIDCredentialHeader
 @property  NSString *tenantId

  // instance methods
  0x00000032dac -[MSIDDeviceHeader initWithJSONDictionary:error:]
  0x00000032e7c -[MSIDDeviceHeader jsonDictionary]
  0x00000032f8c -[MSIDDeviceHeader tenantId]
  0x00000032f9c -[MSIDDeviceHeader setTenantId:]


0x0000017ce10 MSIDRedirectUriVerifier : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000032fc4 +[MSIDRedirectUriVerifier msidRedirectUriWithCustomUri:clientId:bypassRedirectValidation:error:]
  0x000000330e8 +[MSIDRedirectUriVerifier verifyAdditionalRequiredSchemesAreRegistered:]


0x0000017ce38 MSIDSSOExtensionGetDeviceInfoRequest : NSObject /usr/lib/libobjc.A.dylib
 @property  ASAuthorizationController *authorizationController
 @property  @? requestCompletionBlock
 @property  MSIDSSOExtensionOperationRequestDelegate *extensionDelegate
 @property  ASAuthorizationSingleSignOnProvider *ssoProvider
 @property  MSIDRequestParameters *requestParameters
 @property  NSDate *requestSentDate
 @property  MSIDLastRequestTelemetry *lastRequestTelemetry

  // class methods
  0x000000337f4 +[MSIDSSOExtensionGetDeviceInfoRequest canPerformRequest]

  // instance methods
  0x000000330f0 -[MSIDSSOExtensionGetDeviceInfoRequest initWithRequestParameters:error:]
  0x00000033548 -[MSIDSSOExtensionGetDeviceInfoRequest executeRequestWithCompletion:]
  0x00000033738 -[MSIDSSOExtensionGetDeviceInfoRequest controllerWithRequest:]
  0x00000033838 -[MSIDSSOExtensionGetDeviceInfoRequest requestParameters]
  0x00000033840 -[MSIDSSOExtensionGetDeviceInfoRequest setRequestParameters:]
  0x0000003384c -[MSIDSSOExtensionGetDeviceInfoRequest authorizationController]
  0x00000033854 -[MSIDSSOExtensionGetDeviceInfoRequest setAuthorizationController:]
  0x00000033860 -[MSIDSSOExtensionGetDeviceInfoRequest requestCompletionBlock]
  0x00000033868 -[MSIDSSOExtensionGetDeviceInfoRequest setRequestCompletionBlock:]
  0x00000033870 -[MSIDSSOExtensionGetDeviceInfoRequest extensionDelegate]
  0x00000033878 -[MSIDSSOExtensionGetDeviceInfoRequest setExtensionDelegate:]
  0x00000033884 -[MSIDSSOExtensionGetDeviceInfoRequest ssoProvider]
  0x0000003388c -[MSIDSSOExtensionGetDeviceInfoRequest setSsoProvider:]
  0x00000033898 -[MSIDSSOExtensionGetDeviceInfoRequest requestSentDate]
  0x000000338a0 -[MSIDSSOExtensionGetDeviceInfoRequest setRequestSentDate:]
  0x000000338ac -[MSIDSSOExtensionGetDeviceInfoRequest lastRequestTelemetry]
  0x000000338b4 -[MSIDSSOExtensionGetDeviceInfoRequest setLastRequestTelemetry:]


0x0000017ce88 MSIDBrokerOperationBrowserNativeMessageRequest : MSIDBrokerOperationRequest
 @property  NSDictionary *payloadJson
 @property  NSString *method

  // class methods
  0x0000003392c +[MSIDBrokerOperationBrowserNativeMessageRequest load]
  0x000000339c8 +[MSIDBrokerOperationBrowserNativeMessageRequest operation]

  // instance methods
  0x0000003397c -[MSIDBrokerOperationBrowserNativeMessageRequest method]
  0x000000339d8 -[MSIDBrokerOperationBrowserNativeMessageRequest initWithJSONDictionary:error:]
  0x00000033ba8 -[MSIDBrokerOperationBrowserNativeMessageRequest jsonDictionary]
  0x00000033cc4 -[MSIDBrokerOperationBrowserNativeMessageRequest payloadJson]
  0x00000033cd4 -[MSIDBrokerOperationBrowserNativeMessageRequest setPayloadJson:]


0x0000017cf00 MSIDAADV2TokenResponseForV1Request : MSIDAADV2TokenResponse
  // instance methods
  0x00000033cfc -[MSIDAADV2TokenResponseForV1Request tokenClaimsFromRawIdToken:error:]


0x0000017cf28 MSIDBrowserNativeMessageGetTokenResponse : MSIDBrokerNativeAppOperationResponse
 @property  MSIDBrokerOperationTokenResponse *operationTokenResponse
 @property  NSString *state

  // instance methods
  0x00000033d58 -[MSIDBrowserNativeMessageGetTokenResponse initWithTokenResponse:]
  0x00000033eb8 -[MSIDBrowserNativeMessageGetTokenResponse initWithJSONDictionary:error:]
  0x00000033f58 -[MSIDBrowserNativeMessageGetTokenResponse jsonDictionary]
  0x00000034140 -[MSIDBrowserNativeMessageGetTokenResponse state]
  0x00000034150 -[MSIDBrowserNativeMessageGetTokenResponse setState:]
  0x00000034164 -[MSIDBrowserNativeMessageGetTokenResponse operationTokenResponse]
  0x00000034174 -[MSIDBrowserNativeMessageGetTokenResponse setOperationTokenResponse:]


0x0000017cf78 MSIDCredentialHeader : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable>
 @property  MSIDCredentialInfo *info
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000341c8 -[MSIDCredentialHeader initWithJSONDictionary:error:]
  0x0000003434c -[MSIDCredentialHeader jsonDictionary]
  0x0000003446c -[MSIDCredentialHeader info]
  0x00000034474 -[MSIDCredentialHeader setInfo:]


0x0000017cfc8 MSIDLogger : NSObject /usr/lib/libobjc.A.dylib
 @property  NSObject<OS_dispatch_queue> *loggerQueue
 @property  NSObject<OS_dispatch_semaphore> *queueSemaphore
 @property  @? callback
 @property  <MSIDLoggerConnecting> *loggerConnector
 @property  long long level
 @property  long long logMaskingLevel
 @property  BOOL nsLoggingEnabled
 @property  BOOL sourceLineLoggingEnabled

  // class methods
  0x000000349d0 +[MSIDLogger initialize]
  0x000000345d4 +[MSIDLogger sharedLogger]

  // instance methods
  0x00000034a54 -[MSIDLogger logWithLevel:context:correlationId:containsPII:filename:lineNumber:function:format:formatArgs:]
  0x00000034b70 -[MSIDLogger logWithLevel:context:correlationId:containsPII:filename:lineNumber:function:format:]
  0x00000034cc0 -[MSIDLogger logWithLevel:context:correlationId:containsPII:filename:lineNumber:function:message:]
  0x00000035544 -[MSIDLogger shouldLog:]
  0x000000355f4 -[MSIDLogger stringForLogLevel:]
  0x0000003561c -[MSIDLogger logToken:tokenType:expiresOnDate:additionaLog:context:]
  0x0000003448c -[MSIDLogger init]
  0x00000034640 -[MSIDLogger setCallback:]
  0x000000347c8 -[MSIDLogger level]
  0x00000034818 -[MSIDLogger nsLoggingEnabled]
  0x00000034870 -[MSIDLogger logMaskingLevel]
  0x000000348c0 -[MSIDLogger sourceLineLoggingEnabled]
  0x00000034918 -[MSIDLogger loggerConnector]
  0x00000034930 -[MSIDLogger setLoggerConnector:]
  0x0000003493c -[MSIDLogger setLevel:]
  0x00000034944 -[MSIDLogger setLogMaskingLevel:]
  0x0000003494c -[MSIDLogger setNsLoggingEnabled:]
  0x00000034954 -[MSIDLogger setSourceLineLoggingEnabled:]
  0x0000003495c -[MSIDLogger loggerQueue]
  0x00000034964 -[MSIDLogger setLoggerQueue:]
  0x00000034970 -[MSIDLogger queueSemaphore]
  0x00000034978 -[MSIDLogger setQueueSemaphore:]
  0x00000034984 -[MSIDLogger callback]


0x0000017d018 MSIDWebviewAuthorization : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000035894 +[MSIDWebviewAuthorization startSessionWithWebView:oauth2Factory:configuration:context:completionHandler:]
  0x00000035a54 +[MSIDWebviewAuthorization startSession:context:completionHandler:]
  0x00000035f90 +[MSIDWebviewAuthorization setCurrentSession:]
  0x000000360b8 +[MSIDWebviewAuthorization clearCurrentWebAuthSessionAndFactory]
  0x000000361ac +[MSIDWebviewAuthorization currentSession]
  0x000000361b8 +[MSIDWebviewAuthorization cancelCurrentSession]


0x0000017d090 MSIDAssymetricKeyGeneratorFactory : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000036248 +[MSIDAssymetricKeyGeneratorFactory defaultKeyGeneratorWithCacheConfig:error:]
  0x0000003624c +[MSIDAssymetricKeyGeneratorFactory iOSDefaultKeyGeneratorWithCacheConfig:error:]
  0x000000362cc +[MSIDAssymetricKeyGeneratorFactory macDefaultKeyGeneratorWithCacheConfig:error:]


0x0000017d0b8 MSIDAADRefreshTokenGrantRequest : MSIDRefreshTokenGrantRequest
 @property  NSMutableDictionary *thumbprintParameters

  // instance methods
  0x0000003634c -[MSIDAADRefreshTokenGrantRequest initWithEndpoint:authScheme:clientId:redirectUri:enrollmentId:scope:refreshToken:claims:extraParameters:ssoContext:context:]
  0x00000036544 -[MSIDAADRefreshTokenGrantRequest fullRequestThumbprint]
  0x000000365c8 -[MSIDAADRefreshTokenGrantRequest strictRequestThumbprint]
  0x0000003664c -[MSIDAADRefreshTokenGrantRequest thumbprintParameters]
  0x0000003665c -[MSIDAADRefreshTokenGrantRequest setThumbprintParameters:]


0x0000017d108 MSIDBrokerOperationGetSsoCookiesResponse : MSIDBrokerNativeAppOperationResponse
 @property  NSArray *prtHeaders
 @property  NSArray *deviceHeaders

  // class methods
  0x00000036684 +[MSIDBrokerOperationGetSsoCookiesResponse load]
  0x000000366d4 +[MSIDBrokerOperationGetSsoCookiesResponse responseType]

  // instance methods
  0x000000366e4 -[MSIDBrokerOperationGetSsoCookiesResponse initWithJSONDictionary:error:]
  0x000000368ac -[MSIDBrokerOperationGetSsoCookiesResponse jsonDictionary]
  0x00000036a48 -[MSIDBrokerOperationGetSsoCookiesResponse convertToJsonFrom:]
  0x00000036ba4 -[MSIDBrokerOperationGetSsoCookiesResponse parseCredentialHeaderFrom:credentialName:error:]
  0x00000036ec4 -[MSIDBrokerOperationGetSsoCookiesResponse prtHeaders]
  0x00000036ed4 -[MSIDBrokerOperationGetSsoCookiesResponse setPrtHeaders:]
  0x00000036ee8 -[MSIDBrokerOperationGetSsoCookiesResponse deviceHeaders]
  0x00000036ef8 -[MSIDBrokerOperationGetSsoCookiesResponse setDeviceHeaders:]


0x0000017d158 MSIDTelemetryDefaultEvent : MSIDTelemetryBaseEvent
  // instance methods
  0x00000036f4c -[MSIDTelemetryDefaultEvent initWithName:context:]


0x0000017d1a8 MSIDPRTCacheItem : MSIDLegacyTokenCacheItem
 @property  NSData *sessionKey
 @property  NSString *deviceID
 @property  NSString *prtProtocolVersion
 @property  long long externalKeyLocationType

  // class methods
  0x00000036fc8 +[MSIDPRTCacheItem supportsSecureCoding]

  // instance methods
  0x00000036fd0 -[MSIDPRTCacheItem encodeWithCoder:]
  0x00000037144 -[MSIDPRTCacheItem initWithCoder:]
  0x000000372e8 -[MSIDPRTCacheItem initWithJSONDictionary:error:]
  0x000000374ec -[MSIDPRTCacheItem jsonDictionary]
  0x00000037698 -[MSIDPRTCacheItem isEqual:]
  0x0000003770c -[MSIDPRTCacheItem isEqualToItem:]
  0x00000037ac0 -[MSIDPRTCacheItem sessionKey]
  0x00000037ad0 -[MSIDPRTCacheItem setSessionKey:]
  0x00000037adc -[MSIDPRTCacheItem deviceID]
  0x00000037aec -[MSIDPRTCacheItem setDeviceID:]
  0x00000037af8 -[MSIDPRTCacheItem prtProtocolVersion]
  0x00000037b08 -[MSIDPRTCacheItem setPrtProtocolVersion:]
  0x00000037b14 -[MSIDPRTCacheItem externalKeyLocationType]
  0x00000037b24 -[MSIDPRTCacheItem setExternalKeyLocationType:]


0x0000017d1f8 MSIDClientInfo : MSIDJsonObject <NSCopying>
 @property  NSString *uid
 @property  NSString *utid
 @property  NSString *rawClientInfo
 @property  NSString *accountIdentifier

  // instance methods
  0x00000037b88 -[MSIDClientInfo uid]
  0x00000037c28 -[MSIDClientInfo utid]
  0x00000037cc8 -[MSIDClientInfo rawClientInfo]
  0x00000037d5c -[MSIDClientInfo setRawClientInfo:]
  0x00000037da8 -[MSIDClientInfo initWithRawClientInfo:error:]
  0x00000037ea0 -[MSIDClientInfo accountIdentifier]
  0x00000037f20 -[MSIDClientInfo copyWithZone:]


0x0000017d248 MSIDCache : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSMutableDictionary *container
 @property  NSObject<OS_dispatch_queue> *synchronizationQueue

  // instance methods
  0x00000037f6c -[MSIDCache initWithDictionary:]
  0x000000380cc -[MSIDCache init]
  0x000000380d4 -[MSIDCache objectForKey:]
  0x00000038300 -[MSIDCache copyAndRemoveObjectForKey:]
  0x000000384d4 -[MSIDCache setObject:forKey:]
  0x00000038654 -[MSIDCache removeObjectForKey:]
  0x0000003878c -[MSIDCache removeAllObjects]
  0x00000038870 -[MSIDCache toDictionary]
  0x00000038a34 -[MSIDCache count]
  0x00000038b88 -[MSIDCache copyWithZone:]
  0x00000038be4 -[MSIDCache container]
  0x00000038bec -[MSIDCache setContainer:]
  0x00000038bf8 -[MSIDCache synchronizationQueue]
  0x00000038c00 -[MSIDCache setSynchronizationQueue:]


0x0000017d298 MSIDAssymetricKeyKeychainGenerator : NSObject /usr/lib/libobjc.A.dylib <MSIDAssymetricKeyGenerating>
 @property  NSString *keychainGroup
 @property  NSDictionary *defaultKeychainQuery
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000038c3c -[MSIDAssymetricKeyKeychainGenerator initWithGroup:error:]
  0x00000038fe4 -[MSIDAssymetricKeyKeychainGenerator generateKeyPairForAttributes:error:]
  0x0000003918c -[MSIDAssymetricKeyKeychainGenerator readOrGenerateKeyPairForAttributes:error:]
  0x00000039284 -[MSIDAssymetricKeyKeychainGenerator readKeyPairForAttributes:error:]
  0x000000393f0 -[MSIDAssymetricKeyKeychainGenerator deleteItemWithAttributes:error:]
  0x00000039478 -[MSIDAssymetricKeyKeychainGenerator keyAttributesWithQueryDictionary:error:]
  0x000000395c8 -[MSIDAssymetricKeyKeychainGenerator keychainQueryWithAttributes:]
  0x00000039634 -[MSIDAssymetricKeyKeychainGenerator generateEphemeralKeyPair:]
  0x00000039710 -[MSIDAssymetricKeyKeychainGenerator generateKeyPairForKeyDict:error:]
  0x00000039834 -[MSIDAssymetricKeyKeychainGenerator additionalPlatformKeychainAttributes]
  0x000000398b4 -[MSIDAssymetricKeyKeychainGenerator logAndFillError:status:error:]
  0x000000399f0 -[MSIDAssymetricKeyKeychainGenerator keychainGroup]
  0x000000399f8 -[MSIDAssymetricKeyKeychainGenerator setKeychainGroup:]
  0x00000039a04 -[MSIDAssymetricKeyKeychainGenerator defaultKeychainQuery]
  0x00000039a0c -[MSIDAssymetricKeyKeychainGenerator setDefaultKeychainQuery:]


0x0000017d2e8 MSIDJITTroubleshootingResponse : MSIDWebviewResponse
 @property  NSNumber *status
 @property  BOOL isRetryResponse

  // instance methods
  0x00000039abc -[MSIDJITTroubleshootingResponse initWithURL:context:error:]
  0x00000039c70 -[MSIDJITTroubleshootingResponse isJITRetryResponse:]
  0x00000039d40 -[MSIDJITTroubleshootingResponse isJITTroubleshootingResponse:]
  0x00000039df8 -[MSIDJITTroubleshootingResponse getErrorFromResponseWithContext:]
  0x00000039fb0 -[MSIDJITTroubleshootingResponse status]
  0x00000039fc0 -[MSIDJITTroubleshootingResponse isRetryResponse]


0x0000017d338 MSIDMacCredentialStorageItem : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable>
 @property  NSMutableDictionary *cacheObjects
 @property  NSObject<OS_dispatch_queue> *queue
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000039fe4 -[MSIDMacCredentialStorageItem init]
  0x0000003a12c -[MSIDMacCredentialStorageItem storeItem:forKey:]
  0x0000003a2f4 -[MSIDMacCredentialStorageItem mergeStorageItem:]
  0x0000003a618 -[MSIDMacCredentialStorageItem removeStoredItemForKey:]
  0x0000003a948 -[MSIDMacCredentialStorageItem storedItemsForKey:]
  0x0000003ad78 -[MSIDMacCredentialStorageItem count]
  0x0000003aea8 -[MSIDMacCredentialStorageItem initWithJSONDictionary:error:]
  0x0000003b298 -[MSIDMacCredentialStorageItem jsonDictionary]
  0x0000003b6e4 -[MSIDMacCredentialStorageItem getFilteredItems:forKey:]
  0x0000003b968 -[MSIDMacCredentialStorageItem getFilteredKeys:forKey:]
  0x0000003b9fc -[MSIDMacCredentialStorageItem getItemKey:]
  0x0000003baa4 -[MSIDMacCredentialStorageItem createPredicateForKey:]
  0x0000003bce4 -[MSIDMacCredentialStorageItem getItemWithType:forKey:error:]
  0x0000003bed0 -[MSIDMacCredentialStorageItem getItemTypeFromCacheKey:]
  0x0000003c0e4 -[MSIDMacCredentialStorageItem cacheObjects]
  0x0000003c0ec -[MSIDMacCredentialStorageItem setCacheObjects:]
  0x0000003c0f8 -[MSIDMacCredentialStorageItem queue]
  0x0000003c100 -[MSIDMacCredentialStorageItem setQueue:]


0x0000017d3b0 MSIDAuthorityFactory : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000003c13c +[MSIDAuthorityFactory authorityFromUrl:context:error:]
  0x0000003c14c +[MSIDAuthorityFactory authorityFromUrl:rawTenant:context:error:]


0x0000017d3d8 MSIDAADV2WebviewFactory : MSIDAADWebviewFactory
  // instance methods
  0x0000003c3f0 -[MSIDAADV2WebviewFactory authorizationParametersFromRequestParameters:pkce:requestState:]
  0x0000003c5a0 -[MSIDAADV2WebviewFactory metadataFromRequestParameters:]


0x0000017d450 MSIDTelemetryAPIEvent : MSIDTelemetryBaseEvent
  // class methods
  0x0000003cb30 +[MSIDTelemetryAPIEvent propertiesToAggregate]

  // instance methods
  0x0000003c7b4 -[MSIDTelemetryAPIEvent setCorrelationId:]
  0x0000003c80c -[MSIDTelemetryAPIEvent setExtendedExpiresOnSetting:]
  0x0000003c820 -[MSIDTelemetryAPIEvent setUserId:]
  0x0000003c834 -[MSIDTelemetryAPIEvent setClientId:]
  0x0000003c848 -[MSIDTelemetryAPIEvent setIsExtendedLifeTimeToken:]
  0x0000003c85c -[MSIDTelemetryAPIEvent setErrorDomain:]
  0x0000003c870 -[MSIDTelemetryAPIEvent setApiId:]
  0x0000003c884 -[MSIDTelemetryAPIEvent setWebviewType:]
  0x0000003c898 -[MSIDTelemetryAPIEvent setLoginHint:]
  0x0000003c8ac -[MSIDTelemetryAPIEvent setErrorCode:]
  0x0000003c928 -[MSIDTelemetryAPIEvent setErrorCodeString:]
  0x0000003c978 -[MSIDTelemetryAPIEvent setPromptType:]
  0x0000003c9c4 -[MSIDTelemetryAPIEvent setIsSuccessfulStatus:]
  0x0000003c9d8 -[MSIDTelemetryAPIEvent setResultStatus:]
  0x0000003c9ec -[MSIDTelemetryAPIEvent setUserInformation:]
  0x0000003caac -[MSIDTelemetryAPIEvent setOauthErrorCode:]
  0x0000003cac0 -[MSIDTelemetryAPIEvent setSsoExtFallBackFlow:]


0x0000017d4a0 MSIDBaseBrokerOperationRequest : NSObject /usr/lib/libobjc.A.dylib
 @property  NSUUID *correlationId

  // class methods
  0x0000003cd58 +[MSIDBaseBrokerOperationRequest operation]

  // instance methods
  0x0000003cd64 -[MSIDBaseBrokerOperationRequest logInfo]
  0x0000003cd70 -[MSIDBaseBrokerOperationRequest correlationId]
  0x0000003cd78 -[MSIDBaseBrokerOperationRequest setCorrelationId:]


0x0000017d4c8 MSIDBrokerOperationRequest : MSIDBaseBrokerOperationRequest <MSIDJsonSerializable>
 @property  NSString *brokerKey
 @property  long long protocolVersion
 @property  NSString *clientVersion
 @property  NSString *clientAppVersion
 @property  NSString *clientAppName
 @property  long long clientSDK
 @property  BOOL clientBrokerKeyCapabilityNotSupported
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000003cd90 +[MSIDBrokerOperationRequest fillRequest:keychainAccessGroup:clientMetadata:clientBrokerKeyCapabilityNotSupported:context:]

  // instance methods
  0x0000003cf7c -[MSIDBrokerOperationRequest initWithJSONDictionary:error:]
  0x0000003d274 -[MSIDBrokerOperationRequest jsonDictionary]
  0x0000003d62c -[MSIDBrokerOperationRequest logInfo]
  0x0000003d6b0 -[MSIDBrokerOperationRequest shouldIgnoreBrokerKey]
  0x0000003d714 -[MSIDBrokerOperationRequest brokerKey]
  0x0000003d724 -[MSIDBrokerOperationRequest setBrokerKey:]
  0x0000003d738 -[MSIDBrokerOperationRequest protocolVersion]
  0x0000003d748 -[MSIDBrokerOperationRequest setProtocolVersion:]
  0x0000003d758 -[MSIDBrokerOperationRequest clientVersion]
  0x0000003d768 -[MSIDBrokerOperationRequest setClientVersion:]
  0x0000003d77c -[MSIDBrokerOperationRequest clientAppVersion]
  0x0000003d78c -[MSIDBrokerOperationRequest setClientAppVersion:]
  0x0000003d7a0 -[MSIDBrokerOperationRequest clientAppName]
  0x0000003d7b0 -[MSIDBrokerOperationRequest setClientAppName:]
  0x0000003d7c4 -[MSIDBrokerOperationRequest clientSDK]
  0x0000003d7d4 -[MSIDBrokerOperationRequest setClientSDK:]
  0x0000003d7e4 -[MSIDBrokerOperationRequest clientBrokerKeyCapabilityNotSupported]
  0x0000003d7f4 -[MSIDBrokerOperationRequest setClientBrokerKeyCapabilityNotSupported:]


0x0000017d518 MSIDAADNetworkConfiguration : NSObject /usr/lib/libobjc.A.dylib
 @property  <MSIDAADEndpointProviding> *endpointProvider
 @property  NSString *aadApiVersion
 @property  NSString *aadAuthorityDiscoveryApiVersion
 @property  NSString *drsDiscoveryApiVersion

  // class methods
  0x0000003d9b8 +[MSIDAADNetworkConfiguration initialize]
  0x0000003dba8 +[MSIDAADNetworkConfiguration defaultConfiguration]
  0x0000003dbb4 +[MSIDAADNetworkConfiguration setDefaultConfiguration:]

  // instance methods
  0x0000003dacc -[MSIDAADNetworkConfiguration init]
  0x0000003dbc4 -[MSIDAADNetworkConfiguration isAADPublicCloud:]
  0x0000003dbdc -[MSIDAADNetworkConfiguration trustedHosts]
  0x0000003dbe8 -[MSIDAADNetworkConfiguration endpointProvider]
  0x0000003dbf0 -[MSIDAADNetworkConfiguration setEndpointProvider:]
  0x0000003dbfc -[MSIDAADNetworkConfiguration aadApiVersion]
  0x0000003dc04 -[MSIDAADNetworkConfiguration aadAuthorityDiscoveryApiVersion]
  0x0000003dc0c -[MSIDAADNetworkConfiguration setAadAuthorityDiscoveryApiVersion:]
  0x0000003dc18 -[MSIDAADNetworkConfiguration drsDiscoveryApiVersion]
  0x0000003dc20 -[MSIDAADNetworkConfiguration setDrsDiscoveryApiVersion:]


0x0000017d568 MSIDIndividualClaimRequest : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable>
 @property  NSString *name
 @property  MSIDIndividualClaimRequestAdditionalInfo *additionalInfo
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000003dc74 -[MSIDIndividualClaimRequest initWithName:]
  0x0000003ddfc -[MSIDIndividualClaimRequest initWithJSONDictionary:error:]
  0x0000003e1e0 -[MSIDIndividualClaimRequest jsonDictionary]
  0x0000003e364 -[MSIDIndividualClaimRequest isEqual:]
  0x0000003e418 -[MSIDIndividualClaimRequest isEqualToItem:]
  0x0000003e4fc -[MSIDIndividualClaimRequest name]
  0x0000003e504 -[MSIDIndividualClaimRequest setName:]
  0x0000003e510 -[MSIDIndividualClaimRequest additionalInfo]
  0x0000003e518 -[MSIDIndividualClaimRequest setAdditionalInfo:]


0x0000017d5e0 MSIDGetV1IdTokenHttpEvent : MSIDTelemetryBaseEvent
  // class methods
  0x0000003e554 +[MSIDGetV1IdTokenHttpEvent propertiesToAggregate]


0x0000017d608 MSIDDeviceInfo : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable>
 @property  long long deviceMode
 @property  long long ssoExtensionMode
 @property  long long wpjStatus
 @property  NSString *brokerVersion
 @property  NSDictionary *additionalExtensionData
 @property  long long platformSSOStatus
 @property  NSDictionary *extraDeviceInfo
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000003e6d4 -[MSIDDeviceInfo initWithDeviceMode:ssoExtensionMode:isWorkPlaceJoined:brokerVersion:]
  0x0000003e798 -[MSIDDeviceInfo initWithJSONDictionary:error:]
  0x0000003ea08 -[MSIDDeviceInfo jsonDictionary]
  0x0000003ec30 -[MSIDDeviceInfo deviceModeStringFromEnum:]
  0x0000003ec54 -[MSIDDeviceInfo deviceModeEnumFromString:]
  0x0000003ecb0 -[MSIDDeviceInfo ssoExtensionModeStringFromEnum:]
  0x0000003ecd4 -[MSIDDeviceInfo ssoExtensionModeEnumFromString:]
  0x0000003ed30 -[MSIDDeviceInfo wpjStatusStringFromEnum:]
  0x0000003ed54 -[MSIDDeviceInfo wpjStatusEnumFromString:]
  0x0000003edb0 -[MSIDDeviceInfo platformSSOStatusStringFromEnum:]
  0x0000003edd0 -[MSIDDeviceInfo platformSSOStatusEnumFromString:]
  0x0000003ee50 -[MSIDDeviceInfo deviceMode]
  0x0000003ee58 -[MSIDDeviceInfo setDeviceMode:]
  0x0000003ee60 -[MSIDDeviceInfo ssoExtensionMode]
  0x0000003ee68 -[MSIDDeviceInfo setSsoExtensionMode:]
  0x0000003ee70 -[MSIDDeviceInfo wpjStatus]
  0x0000003ee78 -[MSIDDeviceInfo setWpjStatus:]
  0x0000003ee80 -[MSIDDeviceInfo brokerVersion]
  0x0000003ee88 -[MSIDDeviceInfo setBrokerVersion:]
  0x0000003ee94 -[MSIDDeviceInfo additionalExtensionData]
  0x0000003ee9c -[MSIDDeviceInfo setAdditionalExtensionData:]
  0x0000003eea8 -[MSIDDeviceInfo platformSSOStatus]
  0x0000003eeb0 -[MSIDDeviceInfo setPlatformSSOStatus:]
  0x0000003eeb8 -[MSIDDeviceInfo extraDeviceInfo]
  0x0000003eec0 -[MSIDDeviceInfo setExtraDeviceInfo:]


0x0000017d680 MSIDAADV2Oauth2FactoryForV1Request : MSIDAADV2Oauth2Factory
  // instance methods
  0x0000003ef08 -[MSIDAADV2Oauth2FactoryForV1Request idTokenFromResponse:configuration:]
  0x0000003efb0 -[MSIDAADV2Oauth2FactoryForV1Request tokenResponseFromJSON:context:error:]
  0x0000003f00c -[MSIDAADV2Oauth2FactoryForV1Request tokenResponseFromJSON:refreshToken:context:error:]


0x0000017d6d0 MSIDAADRequestErrorHandler : NSObject /usr/lib/libobjc.A.dylib <MSIDHttpRequestErrorHandling>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000003f084 -[MSIDAADRequestErrorHandler handleError:httpResponse:data:httpRequest:responseSerializer:externalSSOContext:context:completionBlock:]


0x0000017d6f8 MSIDWebAADAuthCodeResponse : MSIDWebOAuth2AuthCodeResponse
 @property  NSString *cloudHostName
 @property  MSIDClientInfo *clientInfo

  // instance methods
  0x0000003f910 -[MSIDWebAADAuthCodeResponse initWithURL:context:error:]
  0x0000003fa50 -[MSIDWebAADAuthCodeResponse initWithURL:requestState:ignoreInvalidState:context:error:]
  0x0000003fb90 -[MSIDWebAADAuthCodeResponse cloudHostName]
  0x0000003fba0 -[MSIDWebAADAuthCodeResponse clientInfo]


0x0000017d770 MSIDJsonSerializableFactory : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000003fbf0 +[MSIDJsonSerializableFactory registerClass:forClassType:]
  0x0000003fcfc +[MSIDJsonSerializableFactory mapJSONKey:keyValue:kindOfClass:toClassType:]
  0x0000003fea0 +[MSIDJsonSerializableFactory unregisterAll]
  0x0000003fefc +[MSIDJsonSerializableFactory createFromJSONDictionary:classTypeJSONKey:assertKindOfClass:error:]
  0x000000400bc +[MSIDJsonSerializableFactory createFromJSONDictionary:classType:assertKindOfClass:error:]
  0x000000400c0 +[MSIDJsonSerializableFactory classTypeForJSONKey:keyValue:kindOfClass:]
  0x00000040120 +[MSIDJsonSerializableFactory mappingKeyForClass:key:keyValue:]
  0x000000401c4 +[MSIDJsonSerializableFactory createFromJSONDictionary:containerKey:assertKindOfClass:error:]


0x0000017d798 MSIDBrokerOperationRemoveAccountRequest : MSIDBrokerOperationRequest
 @property  MSIDAccountIdentifier *accountIdentifier
 @property  NSString *clientId

  // class methods
  0x00000040450 +[MSIDBrokerOperationRemoveAccountRequest load]
  0x000000404a0 +[MSIDBrokerOperationRemoveAccountRequest operation]

  // instance methods
  0x000000404b0 -[MSIDBrokerOperationRemoveAccountRequest initWithJSONDictionary:error:]
  0x0000004068c -[MSIDBrokerOperationRemoveAccountRequest jsonDictionary]
  0x000000407dc -[MSIDBrokerOperationRemoveAccountRequest accountIdentifier]
  0x000000407ec -[MSIDBrokerOperationRemoveAccountRequest setAccountIdentifier:]
  0x00000040800 -[MSIDBrokerOperationRemoveAccountRequest clientId]
  0x00000040810 -[MSIDBrokerOperationRemoveAccountRequest setClientId:]


0x0000017d810 MSIDSSOExtensionTokenRequestDelegate : MSIDSSOExtensionRequestDelegate
  // instance methods
  0x00000040864 -[MSIDSSOExtensionTokenRequestDelegate authorizationController:didCompleteWithAuthorization:]
  0x00000040f24 -[MSIDSSOExtensionTokenRequestDelegate forceRunOnBackgroundQueue:dispatchBlock:]


0x0000017d860 MSIDDefaultTokenResponseValidator : MSIDTokenResponseValidator
  // instance methods
  0x000000410d4 -[MSIDDefaultTokenResponseValidator validateTokenResult:configuration:oidcScope:correlationID:error:]
  0x00000041544 -[MSIDDefaultTokenResponseValidator validateAccount:tokenResult:correlationID:error:]


0x0000017d888 MSIDAADV1BrokerResponse : MSIDBrokerResponse
 @property  NSString *resource
 @property  NSString *httpHeaders
 @property  NSString *oauthErrorCode
 @property  NSString *errorDescription
 @property  NSString *subError
 @property  NSString *userId

  // instance methods
  0x00000041b40 -[MSIDAADV1BrokerResponse resource]
  0x00000041bd4 -[MSIDAADV1BrokerResponse httpHeaders]
  0x00000041c68 -[MSIDAADV1BrokerResponse errorDescription]
  0x00000041d08 -[MSIDAADV1BrokerResponse subError]
  0x00000041da8 -[MSIDAADV1BrokerResponse userId]
  0x00000041e3c -[MSIDAADV1BrokerResponse initWithDictionary:error:]
  0x00000041f0c -[MSIDAADV1BrokerResponse initDerivedProperties]
  0x00000041fec -[MSIDAADV1BrokerResponse oauthErrorCode]
  0x00000042060 -[MSIDAADV1BrokerResponse target]
  0x0000004207c -[MSIDAADV1BrokerResponse ignoreAccessTokenCache]


0x0000017d900 MSIDExternalSSOContext : NSObject /usr/lib/libobjc.A.dylib
 @property  ASAuthorizationProviderExtensionLoginManager *loginManager

  // instance methods
  0x000000421c0 -[MSIDExternalSSOContext wpjKeyPairWithCertWithContext:]
  0x00000042680 -[MSIDExternalSSOContext tokenEndpointURL]
  0x00000042728 -[MSIDExternalSSOContext getPlatformSSOIdentity:]
  0x00000042818 -[MSIDExternalSSOContext loginManager]
  0x00000042820 -[MSIDExternalSSOContext setLoginManager:]


0x0000017d928 MSIDAssymetricKeyPair : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *keyExponent
 @property  NSString *keyModulus
 @property  NSData *keyData
 @property  NSString *jsonWebKey
 @property  NSString *kid
 @property  NSString *stkJwk
 @property  NSDate *creationDate
 @property  NSDictionary *privateKeyDict
 @property  ^{__SecKey=} privateKeyRef
 @property  ^{__SecKey=} publicKeyRef

  // instance methods
  0x00000042838 -[MSIDAssymetricKeyPair initWithPrivateKey:publicKey:privateKeyDict:]
  0x00000042958 -[MSIDAssymetricKeyPair keyExponent]
  0x00000042a74 -[MSIDAssymetricKeyPair keyModulus]
  0x00000042b98 -[MSIDAssymetricKeyPair jsonWebKey]
  0x00000042cdc -[MSIDAssymetricKeyPair kid]
  0x00000042d7c -[MSIDAssymetricKeyPair stkJwk]
  0x00000042e20 -[MSIDAssymetricKeyPair derEncodingGetSizeFrom:at:]
  0x00000042e94 -[MSIDAssymetricKeyPair keyData]
  0x00000042fb4 -[MSIDAssymetricKeyPair decrypt:]
  0x000000430dc -[MSIDAssymetricKeyPair signData:]
  0x00000043214 -[MSIDAssymetricKeyPair creationDate]
  0x00000043468 -[MSIDAssymetricKeyPair dealloc]
  0x000000434f4 -[MSIDAssymetricKeyPair setKeyExponent:]
  0x00000043500 -[MSIDAssymetricKeyPair setKeyModulus:]
  0x0000004350c -[MSIDAssymetricKeyPair setKeyData:]
  0x00000043518 -[MSIDAssymetricKeyPair privateKeyRef]
  0x00000043520 -[MSIDAssymetricKeyPair publicKeyRef]
  0x00000043528 -[MSIDAssymetricKeyPair setJsonWebKey:]
  0x00000043534 -[MSIDAssymetricKeyPair setKid:]
  0x00000043540 -[MSIDAssymetricKeyPair setCreationDate:]
  0x0000004354c -[MSIDAssymetricKeyPair setStkJwk:]
  0x00000043558 -[MSIDAssymetricKeyPair privateKeyDict]
  0x00000043560 -[MSIDAssymetricKeyPair setPrivateKeyDict:]


0x0000017d978 MSIDBrokerBrowserOperationResponse : MSIDBrokerOperationResponse
 @property  MSIDUrlResponse *urlResponse

  // instance methods
  0x000000435e4 -[MSIDBrokerBrowserOperationResponse initWithURLResponse:]
  0x00000043690 -[MSIDBrokerBrowserOperationResponse handleResponse:completeRequestBlock:errorBlock:]
  0x0000004374c -[MSIDBrokerBrowserOperationResponse handleError:errorBlock:doNotHandleBlock:]
  0x00000043758 -[MSIDBrokerBrowserOperationResponse urlResponse]


0x0000017d9f0 MSIDRequestControllerFactory : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000004377c +[MSIDRequestControllerFactory silentControllerForParameters:forceRefresh:skipLocalRt:tokenRequestProvider:error:]
  0x000000438f8 +[MSIDRequestControllerFactory interactiveControllerForParameters:tokenRequestProvider:error:]
  0x000000439d0 +[MSIDRequestControllerFactory platformInteractiveController:tokenRequestProvider:error:]
  0x00000043aa4 +[MSIDRequestControllerFactory brokerController:tokenRequestProvider:fallbackController:error:]
  0x00000043aa8 +[MSIDRequestControllerFactory ssoExtensionInteractiveController:tokenRequestProvider:fallbackController:error:]
  0x00000043b54 +[MSIDRequestControllerFactory localInteractiveController:tokenRequestProvider:error:]
  0x00000043bcc +[MSIDRequestControllerFactory signoutControllerForParameters:oauthFactory:shouldSignoutFromBrowser:shouldWipeAccount:shouldWipeCacheForAllAccounts:error:]


0x0000017da18 MSIDCBAWebAADAuthResponse : MSIDWebAADAuthCodeResponse
 @property  NSString *redirectUri

  // class methods
  0x00000043ca4 +[MSIDCBAWebAADAuthResponse isCBAWebAADAuthResponse:]

  // instance methods
  0x00000043d48 -[MSIDCBAWebAADAuthResponse initWithURL:context:error:]
  0x00000043f24 -[MSIDCBAWebAADAuthResponse redirectUri]
  0x00000043f34 -[MSIDCBAWebAADAuthResponse setRedirectUri:]


0x0000017da68 MSIDAADAuthorityValidationRequest : MSIDHttpRequest
  // instance methods
  0x00000043f5c -[MSIDAADAuthorityValidationRequest initWithUrl:context:]


0x0000017dab8 MSIDCacheItemJsonSerializer : NSObject /usr/lib/libobjc.A.dylib <MSIDExtendedCacheItemSerializing>
 @property  <MSIDJsonSerializing> *jsonSerializer
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000044098 -[MSIDCacheItemJsonSerializer init]
  0x00000044128 -[MSIDCacheItemJsonSerializer serializeCredentialCacheItem:]
  0x0000004419c -[MSIDCacheItemJsonSerializer deserializeCredentialCacheItem:]
  0x00000044204 -[MSIDCacheItemJsonSerializer serializeCredentialStorageItem:]
  0x00000044278 -[MSIDCacheItemJsonSerializer deserializeCredentialStorageItem:]
  0x000000442e0 -[MSIDCacheItemJsonSerializer serializeCacheItem:]
  0x00000044354 -[MSIDCacheItemJsonSerializer deserializeCacheItem:ofClass:]
  0x000000444b8 -[MSIDCacheItemJsonSerializer jsonSerializer]
  0x000000444c0 -[MSIDCacheItemJsonSerializer setJsonSerializer:]


0x0000017db08 MSIDAADTokenResponseSerializer : MSIDTokenResponseSerializer
  // instance methods
  0x000000444d8 -[MSIDAADTokenResponseSerializer initWithOauth2Factory:]


0x0000017db58 MSIDSilentTokenRequest : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDRequestParameters *requestParameters
 @property  BOOL forceRefresh
 @property  MSIDOauth2Factory *oauthFactory
 @property  MSIDTokenResponseValidator *tokenResponseValidator
 @property  MSIDAccessToken *extendedLifetimeAccessToken
 @property  MSIDAccessToken *unexpiredRefreshNeededAccessToken
 @property  MSIDTokenResponseHandler *tokenResponseHandler
 @property  MSIDLastRequestTelemetry *lastRequestTelemetry
 @property  MSIDCurrentRequestTelemetry *currentRequestTelemetry
 @property  MSIDThrottlingService *throttlingService
 @property  BOOL skipLocalRt
 @property  MSIDExternalAADCacheSeeder *externalCacheSeeder

  // instance methods
  0x00000044570 -[MSIDSilentTokenRequest initWithRequestParameters:forceRefresh:oauthFactory:tokenResponseValidator:]
  0x000000446e0 -[MSIDSilentTokenRequest executeRequestWithCompletion:]
  0x000000449ec -[MSIDSilentTokenRequest executeRequestImpl:]
  0x00000045a38 -[MSIDSilentTokenRequest fetchCachedTokenAndCheckForFRTFirst:shouldComplete:completionHandler:]
  0x00000045e80 -[MSIDSilentTokenRequest tryRefreshToken:tokenType:completionBlock:]
  0x000000462a4 -[MSIDSilentTokenRequest handleErrorResponseForAppRefreshToken:completionBlock:]
  0x000000464a0 -[MSIDSilentTokenRequest handleErrorResponseForFamilyRefreshToken:]
  0x000000465e8 -[MSIDSilentTokenRequest isErrorRecoverableByUserInteraction:]
  0x000000466ec -[MSIDSilentTokenRequest redeemAccessTokenWith:completionBlock:]
  0x00000046aec -[MSIDSilentTokenRequest acquireTokenWithRefreshTokenImpl:completionBlock:]
  0x00000046fc8 -[MSIDSilentTokenRequest sendTokenRequestImpl:refreshToken:tokenRequest:]
  0x00000047b70 -[MSIDSilentTokenRequest accessTokenWithError:]
  0x00000047b78 -[MSIDSilentTokenRequest resultWithAccessToken:refreshToken:error:]
  0x00000047b80 -[MSIDSilentTokenRequest familyRefreshTokenWithError:]
  0x00000047b88 -[MSIDSilentTokenRequest appRefreshTokenWithError:]
  0x00000047b90 -[MSIDSilentTokenRequest updateFamilyIdCacheWithServerError:cacheError:]
  0x00000047b98 -[MSIDSilentTokenRequest shouldRemoveRefreshToken:]
  0x00000047ba0 -[MSIDSilentTokenRequest tokenCache]
  0x00000047ba8 -[MSIDSilentTokenRequest metadataCache]
  0x00000047bb0 -[MSIDSilentTokenRequest requestParameters]
  0x00000047bb8 -[MSIDSilentTokenRequest setRequestParameters:]
  0x00000047bc4 -[MSIDSilentTokenRequest oauthFactory]
  0x00000047bcc -[MSIDSilentTokenRequest setOauthFactory:]
  0x00000047bd8 -[MSIDSilentTokenRequest tokenResponseValidator]
  0x00000047be0 -[MSIDSilentTokenRequest setTokenResponseValidator:]
  0x00000047bec -[MSIDSilentTokenRequest throttlingService]
  0x00000047bf4 -[MSIDSilentTokenRequest setThrottlingService:]
  0x00000047c00 -[MSIDSilentTokenRequest skipLocalRt]
  0x00000047c08 -[MSIDSilentTokenRequest setSkipLocalRt:]
  0x00000047c10 -[MSIDSilentTokenRequest externalCacheSeeder]
  0x00000047c18 -[MSIDSilentTokenRequest setExternalCacheSeeder:]
  0x00000047c24 -[MSIDSilentTokenRequest lastRequestTelemetry]
  0x00000047c2c -[MSIDSilentTokenRequest setLastRequestTelemetry:]
  0x00000047c38 -[MSIDSilentTokenRequest forceRefresh]
  0x00000047c40 -[MSIDSilentTokenRequest setForceRefresh:]
  0x00000047c48 -[MSIDSilentTokenRequest extendedLifetimeAccessToken]
  0x00000047c50 -[MSIDSilentTokenRequest setExtendedLifetimeAccessToken:]
  0x00000047c5c -[MSIDSilentTokenRequest unexpiredRefreshNeededAccessToken]
  0x00000047c64 -[MSIDSilentTokenRequest setUnexpiredRefreshNeededAccessToken:]
  0x00000047c70 -[MSIDSilentTokenRequest tokenResponseHandler]
  0x00000047c78 -[MSIDSilentTokenRequest setTokenResponseHandler:]
  0x00000047c84 -[MSIDSilentTokenRequest currentRequestTelemetry]
  0x00000047c8c -[MSIDSilentTokenRequest setCurrentRequestTelemetry:]


0x0000017dba8 MSIDCertificateChooserHelper : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000047d28 +[MSIDCertificateChooserHelper showCertSelectionSheet:host:webview:correlationId:completionHandler:]

  // instance methods
  0x00000047ec8 -[MSIDCertificateChooserHelper beginSheet:message:]
  0x00000048018 -[MSIDCertificateChooserHelper showCertSelectionSheet:message:]
  0x000000481a0 -[MSIDCertificateChooserHelper sheetDidEnd:returnCode:contextInfo:]
  0x000000482f4 -[MSIDCertificateChooserHelper webAuthDidFail:]


0x0000017dbf8 MSIDSSOExtensionSignoutRequest : MSIDOIDCSignoutRequest <ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate>
 @property  ASAuthorizationController *authorizationController
 @property  @? requestCompletionBlock
 @property  MSIDSSOExtensionOperationRequestDelegate *extensionDelegate
 @property  ASAuthorizationSingleSignOnProvider *ssoProvider
 @property  long long providerType
 @property  BOOL shouldSignoutFromBrowser
 @property  BOOL clearSSOExtensionCookies
 @property  BOOL shouldWipeCacheForAllAccounts
 @property  NSDate *requestSentDate
 @property  MSIDLastRequestTelemetry *lastRequestTelemetry
 @property  BOOL shouldWipeAccount
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000484d8 -[MSIDSSOExtensionSignoutRequest initWithRequestParameters:shouldSignoutFromBrowser:shouldWipeAccount:clearSSOExtensionCookies:shouldWipeCacheForAllAccounts:oauthFactory:]
  0x00000048544 -[MSIDSSOExtensionSignoutRequest initWithRequestParameters:oauthFactory:]
  0x00000048908 -[MSIDSSOExtensionSignoutRequest executeRequestWithCompletion:]
  0x00000048f64 -[MSIDSSOExtensionSignoutRequest presentationAnchorForAuthorizationController:]
  0x00000048f68 -[MSIDSSOExtensionSignoutRequest presentationAnchor]
  0x00000049118 -[MSIDSSOExtensionSignoutRequest controllerWithRequest:]
  0x000000491d4 -[MSIDSSOExtensionSignoutRequest shouldSignoutFromBrowser]
  0x000000491e4 -[MSIDSSOExtensionSignoutRequest setShouldSignoutFromBrowser:]
  0x000000491f4 -[MSIDSSOExtensionSignoutRequest clearSSOExtensionCookies]
  0x00000049204 -[MSIDSSOExtensionSignoutRequest setClearSSOExtensionCookies:]
  0x00000049214 -[MSIDSSOExtensionSignoutRequest shouldWipeAccount]
  0x00000049224 -[MSIDSSOExtensionSignoutRequest authorizationController]
  0x00000049234 -[MSIDSSOExtensionSignoutRequest setAuthorizationController:]
  0x00000049248 -[MSIDSSOExtensionSignoutRequest requestCompletionBlock]
  0x00000049258 -[MSIDSSOExtensionSignoutRequest setRequestCompletionBlock:]
  0x00000049264 -[MSIDSSOExtensionSignoutRequest extensionDelegate]
  0x00000049274 -[MSIDSSOExtensionSignoutRequest setExtensionDelegate:]
  0x00000049288 -[MSIDSSOExtensionSignoutRequest ssoProvider]
  0x00000049298 -[MSIDSSOExtensionSignoutRequest setSsoProvider:]
  0x000000492ac -[MSIDSSOExtensionSignoutRequest providerType]
  0x000000492bc -[MSIDSSOExtensionSignoutRequest shouldWipeCacheForAllAccounts]
  0x000000492cc -[MSIDSSOExtensionSignoutRequest setShouldWipeCacheForAllAccounts:]
  0x000000492dc -[MSIDSSOExtensionSignoutRequest requestSentDate]
  0x000000492ec -[MSIDSSOExtensionSignoutRequest setRequestSentDate:]
  0x00000049300 -[MSIDSSOExtensionSignoutRequest lastRequestTelemetry]
  0x00000049310 -[MSIDSSOExtensionSignoutRequest setLastRequestTelemetry:]


0x0000017dc70 MSIDOAuthRequestConfigurator : NSObject /usr/lib/libobjc.A.dylib <MSIDHttpRequestConfiguratorProtocol>
 @property  double timeoutInterval
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000493b4 -[MSIDOAuthRequestConfigurator configure:]
  0x00000049438 -[MSIDOAuthRequestConfigurator timeoutInterval]
  0x00000049440 -[MSIDOAuthRequestConfigurator setTimeoutInterval:]


0x0000017dc98 MSIDSilentController : MSIDBaseRequestController <MSIDRequestControlling>
 @property  BOOL forceRefresh
 @property  MSIDSilentTokenRequest *currentRequest
 @property  BOOL skipLocalRt
 @property  BOOL isLocalFallbackMode
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000049448 -[MSIDSilentController initWithRequestParameters:forceRefresh:tokenRequestProvider:error:]
  0x00000049454 -[MSIDSilentController initWithRequestParameters:forceRefresh:tokenRequestProvider:fallbackInteractiveController:error:]
  0x000000494dc -[MSIDSilentController acquireToken:]
  0x00000049824 -[MSIDSilentController acquireTokenWithRequest:completionBlock:]
  0x00000049c84 -[MSIDSilentController forceRefresh]
  0x00000049c94 -[MSIDSilentController setForceRefresh:]
  0x00000049ca4 -[MSIDSilentController skipLocalRt]
  0x00000049cb4 -[MSIDSilentController setSkipLocalRt:]
  0x00000049cc4 -[MSIDSilentController isLocalFallbackMode]
  0x00000049cd4 -[MSIDSilentController setIsLocalFallbackMode:]
  0x00000049ce4 -[MSIDSilentController currentRequest]
  0x00000049cf4 -[MSIDSilentController setCurrentRequest:]


0x0000017dce8 MSIDWebviewUIController : NSWindowController /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit <NSWindowDelegate>
 @property  WKWebView *webView
 @property  <MSIDRequestContext> *context
 @property  BOOL loading
 @property  BOOL complete
 @property  MSIDWebViewPlatformParams *platformParams
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000049d1c +[MSIDWebviewUIController initialize]
  0x00000049d78 +[MSIDWebviewUIController defaultWKWebviewConfiguration]
  0x00000049dd8 +[MSIDWebviewUIController setSharedWKWebviewConfiguration:]

  // instance methods
  0x00000049e2c -[MSIDWebviewUIController initWithContext:]
  0x00000049ed8 -[MSIDWebviewUIController initWithContext:platformParams:]
  0x00000049fb8 -[MSIDWebviewUIController loadView:]
  0x0000004a120 -[MSIDWebviewUIController presentView]
  0x0000004a128 -[MSIDWebviewUIController dismissWebview:]
  0x0000004a168 -[MSIDWebviewUIController showLoadingIndicator]
  0x0000004a1dc -[MSIDWebviewUIController dismissLoadingIndicator]
  0x0000004a214 -[MSIDWebviewUIController obtainSignInWindow]
  0x0000004a3a8 -[MSIDWebviewUIController getCenterRect:rect2:]
  0x0000004a3d0 -[MSIDWebviewUIController windowWillClose:]
  0x0000004a3e8 -[MSIDWebviewUIController prepareLoadingIndicator]
  0x0000004a514 -[MSIDWebviewUIController cancel]
  0x0000004a518 -[MSIDWebviewUIController userCancel]
  0x0000004a51c -[MSIDWebviewUIController webView]
  0x0000004a52c -[MSIDWebviewUIController setWebView:]
  0x0000004a540 -[MSIDWebviewUIController context]
  0x0000004a550 -[MSIDWebviewUIController setContext:]
  0x0000004a564 -[MSIDWebviewUIController loading]
  0x0000004a574 -[MSIDWebviewUIController setLoading:]
  0x0000004a584 -[MSIDWebviewUIController complete]
  0x0000004a594 -[MSIDWebviewUIController setComplete:]
  0x0000004a5a4 -[MSIDWebviewUIController platformParams]


0x0000017dd38 MSIDRefreshToken : MSIDBaseToken <MSIDRefreshableToken>
 @property  NSString *refreshToken
 @property  NSString *familyId
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000004a61c -[MSIDRefreshToken copyWithZone:]
  0x0000004a6e4 -[MSIDRefreshToken isEqual:]
  0x0000004a834 -[MSIDRefreshToken isEqualToItem:]
  0x0000004a9fc -[MSIDRefreshToken initWithTokenCacheItem:]
  0x0000004ab80 -[MSIDRefreshToken tokenCacheItem]
  0x0000004ac60 -[MSIDRefreshToken credentialType]
  0x0000004ad44 -[MSIDRefreshToken refreshToken]
  0x0000004ad54 -[MSIDRefreshToken setRefreshToken:]
  0x0000004ad60 -[MSIDRefreshToken familyId]
  0x0000004ad70 -[MSIDRefreshToken setFamilyId:]


0x0000017dd88 MSIDInteractiveAuthorizationCodeRequest : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDLastRequestTelemetry *lastRequestTelemetry
 @property  MSIDClientInfo *authCodeClientInfo
 @property  MSIDAuthorizeWebRequestConfiguration *webViewConfiguration
 @property  MSIDInteractiveTokenRequestParameters *requestParameters
 @property  MSIDOauth2Factory *oauthFactory
 @property  @? externalDecidePolicyForBrowserAction

  // instance methods
  0x0000004adbc -[MSIDInteractiveAuthorizationCodeRequest initWithRequestParameters:oauthFactory:]
  0x0000004aeb0 -[MSIDInteractiveAuthorizationCodeRequest getAuthCodeWithCompletion:]
  0x0000004b1f4 -[MSIDInteractiveAuthorizationCodeRequest getAuthCodeWithCompletionImpl:]
  0x0000004b890 -[MSIDInteractiveAuthorizationCodeRequest showWebComponentWithCompletion:]
  0x0000004ba90 -[MSIDInteractiveAuthorizationCodeRequest returnResultWithCode:completion:]
  0x0000004bbb8 -[MSIDInteractiveAuthorizationCodeRequest requestParameters]
  0x0000004bbc0 -[MSIDInteractiveAuthorizationCodeRequest oauthFactory]
  0x0000004bbc8 -[MSIDInteractiveAuthorizationCodeRequest externalDecidePolicyForBrowserAction]
  0x0000004bbd0 -[MSIDInteractiveAuthorizationCodeRequest setExternalDecidePolicyForBrowserAction:]
  0x0000004bbd8 -[MSIDInteractiveAuthorizationCodeRequest lastRequestTelemetry]
  0x0000004bbe0 -[MSIDInteractiveAuthorizationCodeRequest setLastRequestTelemetry:]
  0x0000004bbec -[MSIDInteractiveAuthorizationCodeRequest authCodeClientInfo]
  0x0000004bbf4 -[MSIDInteractiveAuthorizationCodeRequest setAuthCodeClientInfo:]
  0x0000004bc00 -[MSIDInteractiveAuthorizationCodeRequest webViewConfiguration]
  0x0000004bc08 -[MSIDInteractiveAuthorizationCodeRequest setWebViewConfiguration:]


0x0000017ddd8 MSIDB2COauth2Factory : MSIDAADV2Oauth2Factory
  // class methods
  0x0000004bc74 +[MSIDB2COauth2Factory providerType]

  // instance methods
  0x0000004bc7c -[MSIDB2COauth2Factory checkResponseClass:context:error:]
  0x0000004bda8 -[MSIDB2COauth2Factory tokenResponseFromJSON:context:error:]
  0x0000004be04 -[MSIDB2COauth2Factory tokenResponseFromJSON:refreshToken:context:error:]
  0x0000004be7c -[MSIDB2COauth2Factory verifyResponse:context:error:]
  0x0000004bf54 -[MSIDB2COauth2Factory fillAccount:fromResponse:configuration:]
  0x0000004c0b0 -[MSIDB2COauth2Factory cacheAuthorityWithConfiguration:tokenResponse:]
  0x0000004c1f4 -[MSIDB2COauth2Factory resultAuthorityWithConfiguration:tokenResponse:error:]


0x0000017de28 MSIDWebviewResponse : NSObject /usr/lib/libobjc.A.dylib
 @property  NSDictionary *parameters
 @property  NSURL *url

  // class methods
  0x0000004c474 +[MSIDWebviewResponse msidWebResponseParametersFromURL:]
  0x0000004c510 +[MSIDWebviewResponse operation]

  // instance methods
  0x0000004c2f4 -[MSIDWebviewResponse initWithURL:context:error:]
  0x0000004c51c -[MSIDWebviewResponse parameters]
  0x0000004c528 -[MSIDWebviewResponse url]


0x0000017de78 MSIDDefaultTokenCacheAccessor : NSObject /usr/lib/libobjc.A.dylib <MSIDCacheAccessor>
 @property  MSIDAccountCredentialCache *accountCredentialCache
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000004c564 -[MSIDDefaultTokenCacheAccessor initWithDataSource:otherCacheAccessors:]
  0x0000004c640 -[MSIDDefaultTokenCacheAccessor saveTokensWithConfiguration:response:factory:context:error:]
  0x0000004c7c4 -[MSIDDefaultTokenCacheAccessor saveSSOStateWithConfiguration:response:factory:context:error:]
  0x0000004c980 -[MSIDDefaultTokenCacheAccessor getRefreshTokenWithAccount:familyId:configuration:context:error:]
  0x0000004cbe8 -[MSIDDefaultTokenCacheAccessor getPrimaryRefreshTokenWithAccount:familyId:configuration:context:error:]
  0x0000004ce50 -[MSIDDefaultTokenCacheAccessor getPrimaryRefreshTokensForConfiguration:context:error:]
  0x0000004cf7c -[MSIDDefaultTokenCacheAccessor getRefreshableTokenWithAccount:familyId:credentialType:configuration:context:error:]
  0x0000004d530 -[MSIDDefaultTokenCacheAccessor clearWithContext:error:]
  0x0000004d610 -[MSIDDefaultTokenCacheAccessor allTokensWithContext:error:]
  0x0000004d6f4 -[MSIDDefaultTokenCacheAccessor getAccessTokenForAccount:configuration:context:error:]
  0x0000004dae0 -[MSIDDefaultTokenCacheAccessor getIDTokenForAccount:configuration:idTokenType:context:error:]
  0x0000004df1c -[MSIDDefaultTokenCacheAccessor idTokensWithAuthority:accountIdentifier:clientId:context:error:]
  0x0000004e0a8 -[MSIDDefaultTokenCacheAccessor removeAccessToken:context:error:]
  0x0000004e0ac -[MSIDDefaultTokenCacheAccessor accountsWithAuthority:clientId:familyId:accountIdentifier:context:error:]
  0x0000004e0d4 -[MSIDDefaultTokenCacheAccessor accountsWithAuthority:clientId:familyId:accountIdentifier:accountMetadataCache:signedInAccountsOnly:context:error:]
  0x0000004ea6c -[MSIDDefaultTokenCacheAccessor getAccountForIdentifier:authority:realmHint:accountHomeTenantId:accountSelectionLog:context:error:]
  0x0000004f1f0 -[MSIDDefaultTokenCacheAccessor clearCacheForAccount:authority:clientId:familyId:context:error:]
  0x0000004f21c -[MSIDDefaultTokenCacheAccessor clearCacheForAccount:authority:clientId:familyId:clearAccounts:context:error:]
  0x0000004fa78 -[MSIDDefaultTokenCacheAccessor clearCacheForAllAccountsWithContext:error:]
  0x0000004fe34 -[MSIDDefaultTokenCacheAccessor validateAndRemoveRefreshToken:context:error:]
  0x0000004fe44 -[MSIDDefaultTokenCacheAccessor validateAndRemovePrimaryRefreshToken:context:error:]
  0x0000004fe54 -[MSIDDefaultTokenCacheAccessor validateAndRemoveRefreshableToken:credentialType:context:error:]
  0x00000050474 -[MSIDDefaultTokenCacheAccessor checkAccountIdentifier:context:error:]
  0x000000505b4 -[MSIDDefaultTokenCacheAccessor saveAccessTokenWithConfiguration:response:factory:context:error:]
  0x000000508c8 -[MSIDDefaultTokenCacheAccessor saveIDTokenWithConfiguration:response:factory:context:error:]
  0x00000050964 -[MSIDDefaultTokenCacheAccessor saveRefreshTokenWithConfiguration:response:factory:context:error:]
  0x00000050b88 -[MSIDDefaultTokenCacheAccessor saveAccountWithConfiguration:response:factory:context:error:]
  0x00000050ca4 -[MSIDDefaultTokenCacheAccessor removeToken:context:error:]
  0x00000050de8 -[MSIDDefaultTokenCacheAccessor homeAccountIdForLegacyId:authority:context:error:]
  0x00000050f8c -[MSIDDefaultTokenCacheAccessor getTokenWithEnvironment:cacheQuery:context:error:]
  0x000000513f8 -[MSIDDefaultTokenCacheAccessor getTokensWithEnvironment:cacheQuery:context:error:]
  0x00000051790 -[MSIDDefaultTokenCacheAccessor getRefreshableTokenByDisplayableId:authority:clientId:familyId:credentialType:context:error:]
  0x00000051af8 -[MSIDDefaultTokenCacheAccessor saveToken:context:error:]
  0x00000051c34 -[MSIDDefaultTokenCacheAccessor saveAccount:context:error:]
  0x00000051d70 -[MSIDDefaultTokenCacheAccessor validTokensFromCacheItems:]
  0x00000051ee8 -[MSIDDefaultTokenCacheAccessor homeAccountIdsFromRTsWithAuthority:clientId:familyId:accountCredentialCache:context:error:]
  0x000000520f4 -[MSIDDefaultTokenCacheAccessor filterAndFillIdTokenClaimsForAccounts:authority:accountIdsFromRT:idTokens:clientId:accountMetadataCache:signedInAccountsOnly:noReturnAccountUPNs:]
  0x000000526f0 -[MSIDDefaultTokenCacheAccessor filterSignedOutAccountsFromOtherAccessor:accountMetadataCache:clientId:noReturnAccountUPNs:knownReturnAccounts:]
  0x00000052964 -[MSIDDefaultTokenCacheAccessor saveAppMetadataWithConfiguration:response:factory:context:error:]
  0x00000052ad4 -[MSIDDefaultTokenCacheAccessor getAppMetadataEntries:context:error:]
  0x00000052be8 -[MSIDDefaultTokenCacheAccessor updateAppMetadataWithFamilyId:clientId:authority:context:error:]
  0x00000052f80 -[MSIDDefaultTokenCacheAccessor accountCredentialCache]


0x0000017dec8 MSIDPrimaryRefreshToken : MSIDLegacyRefreshToken <MSIDLegacyCredentialCacheCompatible>
 @property  NSData *sessionKey
 @property  NSString *deviceID
 @property  NSString *prtProtocolVersion
 @property  NSDate *expiresOn
 @property  NSDate *cachedAt
 @property  unsigned long expiryInterval
 @property  unsigned long refreshInterval
 @property  NSDate *lastRecoveryAttempt
 @property  long long externalKeyLocationType
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000052fb8 -[MSIDPrimaryRefreshToken initWithTokenCacheItem:]
  0x000000533b0 -[MSIDPrimaryRefreshToken tokenCacheItem]
  0x00000053604 -[MSIDPrimaryRefreshToken initWithLegacyTokenCacheItem:]
  0x000000537b4 -[MSIDPrimaryRefreshToken legacyTokenCacheItem]
  0x00000053878 -[MSIDPrimaryRefreshToken isEqual:]
  0x00000053a14 -[MSIDPrimaryRefreshToken isEqualToItem:]
  0x00000053c88 -[MSIDPrimaryRefreshToken copyWithZone:]
  0x00000053e00 -[MSIDPrimaryRefreshToken credentialType]
  0x00000053ee8 -[MSIDPrimaryRefreshToken isDevicelessPRT]
  0x00000053f78 -[MSIDPrimaryRefreshToken shouldRefreshWithInterval:]
  0x00000054080 -[MSIDPrimaryRefreshToken refreshInterval]
  0x000000540c4 -[MSIDPrimaryRefreshToken sessionKey]
  0x000000540d4 -[MSIDPrimaryRefreshToken setSessionKey:]
  0x000000540e8 -[MSIDPrimaryRefreshToken deviceID]
  0x000000540f8 -[MSIDPrimaryRefreshToken setDeviceID:]
  0x0000005410c -[MSIDPrimaryRefreshToken prtProtocolVersion]
  0x0000005411c -[MSIDPrimaryRefreshToken setPrtProtocolVersion:]
  0x00000054130 -[MSIDPrimaryRefreshToken expiresOn]
  0x00000054140 -[MSIDPrimaryRefreshToken setExpiresOn:]
  0x00000054154 -[MSIDPrimaryRefreshToken cachedAt]
  0x00000054164 -[MSIDPrimaryRefreshToken setCachedAt:]
  0x00000054178 -[MSIDPrimaryRefreshToken expiryInterval]
  0x00000054188 -[MSIDPrimaryRefreshToken setExpiryInterval:]
  0x00000054198 -[MSIDPrimaryRefreshToken lastRecoveryAttempt]
  0x000000541a8 -[MSIDPrimaryRefreshToken setLastRecoveryAttempt:]
  0x000000541bc -[MSIDPrimaryRefreshToken externalKeyLocationType]
  0x000000541cc -[MSIDPrimaryRefreshToken setExternalKeyLocationType:]


0x0000017df18 MSIDTokenResponse : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable>
 @property  NSString *error
 @property  NSString *errorDescription
 @property  long long expiresIn
 @property  long long expiresOn
 @property  NSString *accessToken
 @property  NSString *tokenType
 @property  NSString *requestConf
 @property  NSString *refreshToken
 @property  NSString *scope
 @property  NSString *state
 @property  NSString *idToken
 @property  NSDictionary *additionalServerInfo
 @property  NSString *clientAppVersion
 @property  long long oauthErrorCode
 @property  NSDate *expiryDate
 @property  BOOL isMultiResource
 @property  MSIDIdTokenClaims *idTokenObj
 @property  NSString *target
 @property  long long accountType
 @property  NSString *ccsRequestId
 @property  NSString *ccsRequestSequence
 @property  NSString *accountIdentifier
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000055a00 +[MSIDTokenResponse providerType]

  // instance methods
  0x000000553c8 -[MSIDTokenResponse initWithJSONDictionary:refreshToken:error:]
  0x000000555c4 -[MSIDTokenResponse setAdditionalServerInfo:]
  0x00000055720 -[MSIDTokenResponse setIdToken:]
  0x00000055930 -[MSIDTokenResponse expiryDate]
  0x000000559ac -[MSIDTokenResponse isMultiResource]
  0x000000559b4 -[MSIDTokenResponse target]
  0x000000559b8 -[MSIDTokenResponse accountType]
  0x000000559c0 -[MSIDTokenResponse oauthErrorCode]
  0x00000055a98 -[MSIDTokenResponse accountIdentifier]
  0x00000055adc -[MSIDTokenResponse tokenClaimsFromRawIdToken:error:]
  0x00000055b38 -[MSIDTokenResponse initWithJSONDictionary:error:]
  0x00000055e58 -[MSIDTokenResponse jsonDictionary]
  0x00000056208 -[MSIDTokenResponse error]
  0x00000056210 -[MSIDTokenResponse setError:]
  0x0000005621c -[MSIDTokenResponse errorDescription]
  0x00000056224 -[MSIDTokenResponse setErrorDescription:]
  0x00000056230 -[MSIDTokenResponse expiresIn]
  0x00000056238 -[MSIDTokenResponse setExpiresIn:]
  0x00000056240 -[MSIDTokenResponse expiresOn]
  0x00000056248 -[MSIDTokenResponse setExpiresOn:]
  0x00000056250 -[MSIDTokenResponse accessToken]
  0x00000056258 -[MSIDTokenResponse setAccessToken:]
  0x00000056264 -[MSIDTokenResponse tokenType]
  0x0000005626c -[MSIDTokenResponse setTokenType:]
  0x00000056278 -[MSIDTokenResponse requestConf]
  0x00000056280 -[MSIDTokenResponse setRequestConf:]
  0x0000005628c -[MSIDTokenResponse refreshToken]
  0x00000056294 -[MSIDTokenResponse setRefreshToken:]
  0x000000562a0 -[MSIDTokenResponse scope]
  0x000000562a8 -[MSIDTokenResponse setScope:]
  0x000000562b4 -[MSIDTokenResponse state]
  0x000000562bc -[MSIDTokenResponse setState:]
  0x000000562c8 -[MSIDTokenResponse idToken]
  0x000000562d0 -[MSIDTokenResponse additionalServerInfo]
  0x000000562d8 -[MSIDTokenResponse clientAppVersion]
  0x000000562e0 -[MSIDTokenResponse setClientAppVersion:]
  0x000000562ec -[MSIDTokenResponse idTokenObj]
  0x000000562f4 -[MSIDTokenResponse ccsRequestId]
  0x000000562fc -[MSIDTokenResponse setCcsRequestId:]
  0x00000056308 -[MSIDTokenResponse ccsRequestSequence]
  0x00000056310 -[MSIDTokenResponse setCcsRequestSequence:]


0x0000017df90 MSIDTokenFilteringHelper : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x000000563dc +[MSIDTokenFilteringHelper filterTokenCacheItems:tokenType:returnFirst:filterBy:]


0x0000017dfb8 MSIDAADV1TokenResponse : MSIDAADTokenResponse
 @property  NSString *resource

  // class methods
  0x00000056568 +[MSIDAADV1TokenResponse load]
  0x000000566dc +[MSIDAADV1TokenResponse providerType]

  // instance methods
  0x000000565e4 -[MSIDAADV1TokenResponse tokenClaimsFromRawIdToken:error:]
  0x00000056640 -[MSIDAADV1TokenResponse isMultiResource]
  0x000000566d0 -[MSIDAADV1TokenResponse target]
  0x000000566d4 -[MSIDAADV1TokenResponse accountType]
  0x000000566e4 -[MSIDAADV1TokenResponse initWithJSONDictionary:error:]
  0x000000567b8 -[MSIDAADV1TokenResponse jsonDictionary]
  0x00000056888 -[MSIDAADV1TokenResponse resource]
  0x00000056898 -[MSIDAADV1TokenResponse setResource:]


0x0000017e008 MSIDAadAuthorityResolver : NSObject /usr/lib/libobjc.A.dylib <MSIDAuthorityResolving>
 @property  MSIDAadAuthorityCache *aadCache
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000056ac8 +[MSIDAadAuthorityResolver initialize]

  // instance methods
  0x00000056b34 -[MSIDAadAuthorityResolver init]
  0x00000056bcc -[MSIDAadAuthorityResolver resolveAuthority:userPrincipalName:validate:context:completionBlock:]
  0x00000057030 -[MSIDAadAuthorityResolver sendDiscoverRequestWithAuthority:validate:context:completionBlock:]
  0x0000005760c -[MSIDAadAuthorityResolver handleRecord:authority:completionBlock:]
  0x0000005772c -[MSIDAadAuthorityResolver aadCache]
  0x00000057734 -[MSIDAadAuthorityResolver setAadCache:]


0x0000017e080 MSIDB2CAuthorityResolver : MSIDAadAuthorityResolver
  // instance methods
  0x0000005774c -[MSIDB2CAuthorityResolver resolveAuthority:userPrincipalName:validate:context:completionBlock:]


0x0000017e0a8 MSIDMaskedUsernameLogParameter : MSIDMaskedLogParameter
  // instance methods
  0x00000057908 -[MSIDMaskedUsernameLogParameter maskedDescription]
  0x00000057ad0 -[MSIDMaskedUsernameLogParameter isEUII]


0x0000017e120 MSIDClientTLSHandler : NSObject /usr/lib/libobjc.A.dylib <MSIDChallengeHandling>
  // class methods
  0x00000057ebc +[MSIDClientTLSHandler load]
  0x00000057ed8 +[MSIDClientTLSHandler resetHandler]
  0x00000057ee4 +[MSIDClientTLSHandler handleChallenge:webview:context:completionHandler:]


0x0000017e148 MSIDAccountCredentialCache : NSObject /usr/lib/libobjc.A.dylib
 @property  <MSIDExtendedTokenCacheDataSource> *dataSource

  // instance methods
  0x00000058088 -[MSIDAccountCredentialCache initWithDataSource:]
  0x00000058148 -[MSIDAccountCredentialCache getCredentialsWithQuery:context:error:]
  0x00000058ad8 -[MSIDAccountCredentialCache getCredential:context:error:]
  0x00000058c58 -[MSIDAccountCredentialCache getAllCredentialsWithType:context:error:]
  0x00000058d98 -[MSIDAccountCredentialCache getAccountsWithQuery:context:error:]
  0x000000590d8 -[MSIDAccountCredentialCache getAccount:context:error:]
  0x00000059258 -[MSIDAccountCredentialCache getAllAccountsWithType:context:error:]
  0x00000059390 -[MSIDAccountCredentialCache getAllItemsWithContext:error:]
  0x0000005949c -[MSIDAccountCredentialCache saveCredential:context:error:]
  0x000000597fc -[MSIDAccountCredentialCache saveAccount:context:error:]
  0x00000059b08 -[MSIDAccountCredentialCache removeCredentialsWithQuery:context:error:]
  0x00000059d74 -[MSIDAccountCredentialCache removeExpiredAccessTokensCredentialsWithQuery:context:error:]
  0x0000005a1b0 -[MSIDAccountCredentialCache removeCredential:context:error:]
  0x0000005a55c -[MSIDAccountCredentialCache removeAccountsWithQuery:context:error:]
  0x0000005a740 -[MSIDAccountCredentialCache removeAccount:context:error:]
  0x0000005a994 -[MSIDAccountCredentialCache clearWithContext:error:]
  0x0000005aa74 -[MSIDAccountCredentialCache removeAllCredentials:context:error:]
  0x0000005ac44 -[MSIDAccountCredentialCache removeAllAccounts:context:error:]
  0x0000005ae14 -[MSIDAccountCredentialCache wipeInfoWithContext:error:]
  0x0000005ae1c -[MSIDAccountCredentialCache saveWipeInfoWithContext:error:]
  0x0000005ae24 -[MSIDAccountCredentialCache saveAppMetadata:context:error:]
  0x0000005afdc -[MSIDAccountCredentialCache removeAppMetadata:context:error:]
  0x0000005b1a8 -[MSIDAccountCredentialCache getAppMetadataEntriesWithQuery:context:error:]
  0x0000005b4e0 -[MSIDAccountCredentialCache dataSource]


0x0000017e198 MSIDAccount : NSObject /usr/lib/libobjc.A.dylib <NSCopying, MSIDJsonSerializable>
 @property  long long accountType
 @property  NSString *localAccountId
 @property  NSString *storageEnvironment
 @property  NSString *environment
 @property  NSString *realm
 @property  MSIDIdTokenClaims *idTokenClaims
 @property  NSString *username
 @property  NSString *givenName
 @property  NSString *middleName
 @property  NSString *familyName
 @property  NSString *name
 @property  MSIDAccountIdentifier *accountIdentifier
 @property  MSIDClientInfo *clientInfo
 @property  NSString *alternativeAccountId
 @property  BOOL isSSOAccount
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000005b518 -[MSIDAccount copyWithZone:]
  0x0000005b6b0 -[MSIDAccount isEqual:]
  0x0000005b84c -[MSIDAccount isEqualToItem:]
  0x0000005bc1c -[MSIDAccount initWithAccountCacheItem:]
  0x0000005be8c -[MSIDAccount accountCacheItem]
  0x0000005c0b4 -[MSIDAccount isHomeTenantAccount]
  0x0000005c334 -[MSIDAccount initWithJSONDictionary:error:]
  0x0000005c7dc -[MSIDAccount jsonDictionary]
  0x0000005cb4c -[MSIDAccount accountType]
  0x0000005cb54 -[MSIDAccount setAccountType:]
  0x0000005cb5c -[MSIDAccount localAccountId]
  0x0000005cb68 -[MSIDAccount setLocalAccountId:]
  0x0000005cb70 -[MSIDAccount storageEnvironment]
  0x0000005cb7c -[MSIDAccount setStorageEnvironment:]
  0x0000005cb84 -[MSIDAccount environment]
  0x0000005cb90 -[MSIDAccount setEnvironment:]
  0x0000005cb98 -[MSIDAccount realm]
  0x0000005cba4 -[MSIDAccount setRealm:]
  0x0000005cbac -[MSIDAccount idTokenClaims]
  0x0000005cbb8 -[MSIDAccount setIdTokenClaims:]
  0x0000005cbc0 -[MSIDAccount username]
  0x0000005cbcc -[MSIDAccount setUsername:]
  0x0000005cbd4 -[MSIDAccount givenName]
  0x0000005cbe0 -[MSIDAccount setGivenName:]
  0x0000005cbe8 -[MSIDAccount middleName]
  0x0000005cbf4 -[MSIDAccount setMiddleName:]
  0x0000005cbfc -[MSIDAccount familyName]
  0x0000005cc08 -[MSIDAccount setFamilyName:]
  0x0000005cc10 -[MSIDAccount name]
  0x0000005cc1c -[MSIDAccount setName:]
  0x0000005cc24 -[MSIDAccount accountIdentifier]
  0x0000005cc30 -[MSIDAccount setAccountIdentifier:]
  0x0000005cc38 -[MSIDAccount clientInfo]
  0x0000005cc44 -[MSIDAccount setClientInfo:]
  0x0000005cc4c -[MSIDAccount alternativeAccountId]
  0x0000005cc58 -[MSIDAccount setAlternativeAccountId:]
  0x0000005cc60 -[MSIDAccount isSSOAccount]
  0x0000005cc6c -[MSIDAccount setIsSSOAccount:]


0x0000017e1e8 MSIDDefaultAccountCacheQuery : MSIDDefaultAccountCacheKey
 @property  BOOL exactMatch
 @property  NSArray *environmentAliases

  // instance methods
  0x0000005cd28 -[MSIDDefaultAccountCacheQuery init]
  0x0000005cda8 -[MSIDDefaultAccountCacheQuery account]
  0x0000005ce64 -[MSIDDefaultAccountCacheQuery exactMatch]
  0x0000005cef4 -[MSIDDefaultAccountCacheQuery environmentAliases]
  0x0000005cf04 -[MSIDDefaultAccountCacheQuery setEnvironmentAliases:]


0x0000017e238 MSIDB2CAuthority : MSIDAuthority
  // class methods
  0x0000005cf2c +[MSIDB2CAuthority load]
  0x0000005d2d8 +[MSIDB2CAuthority isAuthorityFormatValid:context:error:]
  0x0000005d52c +[MSIDB2CAuthority realmFromURL:context:error:]
  0x0000005d5f4 +[MSIDB2CAuthority normalizedAuthorityUrl:formatValidated:context:error:]

  // instance methods
  0x0000005cfa8 -[MSIDB2CAuthority initWithURL:validateFormat:context:error:]
  0x0000005d0d8 -[MSIDB2CAuthority initWithURL:context:error:]
  0x0000005d0e8 -[MSIDB2CAuthority initWithURL:validateFormat:rawTenant:context:error:]
  0x0000005d50c -[MSIDB2CAuthority telemetryAuthorityType]
  0x0000005d51c -[MSIDB2CAuthority supportsBrokeredAuthentication]
  0x0000005d524 -[MSIDB2CAuthority supportsClientIDAsScope]
  0x0000005d5d8 -[MSIDB2CAuthority resolver]
  0x0000005d8f4 -[MSIDB2CAuthority copyWithZone:]


0x0000017e288 MSIDAADOauth2Factory : MSIDOauth2Factory
  // instance methods
  0x0000005d9c8 -[MSIDAADOauth2Factory checkResponseClass:context:error:]
  0x0000005daf4 -[MSIDAADOauth2Factory tokenResponseFromJSON:context:error:]
  0x0000005db50 -[MSIDAADOauth2Factory tokenResponseFromJSON:refreshToken:context:error:]
  0x0000005dbc8 -[MSIDAADOauth2Factory verifyResponse:context:error:]
  0x0000005e078 -[MSIDAADOauth2Factory checkCorrelationId:response:]
  0x0000005e358 -[MSIDAADOauth2Factory fillAccessToken:fromResponse:configuration:]
  0x0000005e578 -[MSIDAADOauth2Factory fillLegacyToken:fromResponse:configuration:]
  0x0000005e65c -[MSIDAADOauth2Factory fillRefreshToken:fromResponse:configuration:]
  0x0000005e7bc -[MSIDAADOauth2Factory fillAppMetadata:fromResponse:configuration:]
  0x0000005e910 -[MSIDAADOauth2Factory fillAccount:fromResponse:configuration:]
  0x0000005ea7c -[MSIDAADOauth2Factory fillBaseToken:fromResponse:configuration:]
  0x0000005ebb0 -[MSIDAADOauth2Factory accountIdentifierFromResponse:]
  0x0000005ec84 -[MSIDAADOauth2Factory cacheAuthorityWithConfiguration:tokenResponse:]
  0x0000005eecc -[MSIDAADOauth2Factory webviewFactory]


0x0000017e2d8 MSIDDRSDiscoveryRequest : MSIDHttpRequest
 @property  NSString *domain
 @property  long long adfsType

  // instance methods
  0x0000005ef1c -[MSIDDRSDiscoveryRequest initWithDomain:adfsType:context:]
  0x0000005f16c -[MSIDDRSDiscoveryRequest endpointWithDomain:adfsType:]
  0x0000005f264 -[MSIDDRSDiscoveryRequest domain]
  0x0000005f274 -[MSIDDRSDiscoveryRequest setDomain:]
  0x0000005f288 -[MSIDDRSDiscoveryRequest adfsType]
  0x0000005f298 -[MSIDDRSDiscoveryRequest setAdfsType:]


0x0000017e328 MSIDAADAuthorityMetadataRequest : MSIDHttpRequest
  // instance methods
  0x0000005f2bc -[MSIDAADAuthorityMetadataRequest initWithEndpoint:authority:context:]


0x0000017e378 MSIDBrokerOperationPasskeyAssertionRequest : MSIDBrokerOperationRequest
 @property  NSData *clientDataHash
 @property  NSString *relyingPartyId
 @property  NSData *keyId

  // class methods
  0x0000005f56c +[MSIDBrokerOperationPasskeyAssertionRequest load]
  0x0000005f5bc +[MSIDBrokerOperationPasskeyAssertionRequest operation]

  // instance methods
  0x0000005f5cc -[MSIDBrokerOperationPasskeyAssertionRequest initWithJSONDictionary:error:]
  0x0000005f72c -[MSIDBrokerOperationPasskeyAssertionRequest jsonDictionary]
  0x0000005f880 -[MSIDBrokerOperationPasskeyAssertionRequest clientDataHash]
  0x0000005f890 -[MSIDBrokerOperationPasskeyAssertionRequest setClientDataHash:]
  0x0000005f8a4 -[MSIDBrokerOperationPasskeyAssertionRequest relyingPartyId]
  0x0000005f8b4 -[MSIDBrokerOperationPasskeyAssertionRequest setRelyingPartyId:]
  0x0000005f8c8 -[MSIDBrokerOperationPasskeyAssertionRequest keyId]
  0x0000005f8d8 -[MSIDBrokerOperationPasskeyAssertionRequest setKeyId:]


0x0000017e3f0 MSIDUrlRequestSerializer : NSObject /usr/lib/libobjc.A.dylib <MSIDRequestSerialization>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000005f9c0 -[MSIDUrlRequestSerializer serializeWithRequest:parameters:headers:]
  0x0000005fc18 -[MSIDUrlRequestSerializer shouldEncodeParametersInURL:]


0x0000017e440 MSIDAADAuthorityMetadataResponse : NSObject /usr/lib/libobjc.A.dylib
 @property  NSURL *openIdConfigurationEndpoint
 @property  NSArray *metadata

  // instance methods
  0x0000005fc84 -[MSIDAADAuthorityMetadataResponse openIdConfigurationEndpoint]
  0x0000005fc8c -[MSIDAADAuthorityMetadataResponse setOpenIdConfigurationEndpoint:]
  0x0000005fc98 -[MSIDAADAuthorityMetadataResponse metadata]
  0x0000005fca0 -[MSIDAADAuthorityMetadataResponse setMetadata:]


0x0000017e468 MSIDJsonObject : NSObject /usr/lib/libobjc.A.dylib <NSCopying, MSIDJsonSerializable>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000005fcdc -[MSIDJsonObject init]
  0x0000005fd30 -[MSIDJsonObject initWithJSONData:error:]
  0x0000005fe7c -[MSIDJsonObject initWithJSONDictionary:error:]
  0x0000005ffa4 -[MSIDJsonObject copyWithZone:]
  0x00000060000 -[MSIDJsonObject jsonDictionary]
  0x00000060008 -[MSIDJsonObject serialize:]
  0x00000060070 -[MSIDJsonObject isEqualToJsonObject:]
  0x000000600d0 -[MSIDJsonObject isEqual:]


0x0000017e4e0 MSIDSSOTokenResponseHandler : MSIDTokenResponseHandler
  // instance methods
  0x0000006015c -[MSIDSSOTokenResponseHandler handleOperationResponse:requestParameters:tokenResponseValidator:oauthFactory:tokenCache:accountMetadataCache:validateAccount:error:completionBlock:]


0x0000017e508 MSIDWebFingerRequest : MSIDHttpRequest
  // instance methods
  0x000000605bc -[MSIDWebFingerRequest initWithIssuer:authority:context:]


0x0000017e558 MSIDDefaultCredentialCacheQuery : MSIDDefaultCredentialCacheKey
 @property  unsigned long targetMatchingOptions
 @property  unsigned long clientIdMatchingOptions
 @property  BOOL matchAnyCredentialType
 @property  BOOL exactMatch
 @property  NSArray *environmentAliases

  // instance methods
  0x000000607d8 -[MSIDDefaultCredentialCacheQuery init]
  0x00000060860 -[MSIDDefaultCredentialCacheQuery account]
  0x0000006091c -[MSIDDefaultCredentialCacheQuery service]
  0x000000609c8 -[MSIDDefaultCredentialCacheQuery serviceForAccessToken]
  0x00000060b94 -[MSIDDefaultCredentialCacheQuery serviceForRefreshToken]
  0x00000060c7c -[MSIDDefaultCredentialCacheQuery serviceForIDToken]
  0x00000060d94 -[MSIDDefaultCredentialCacheQuery serviceForLegacyIDToken]
  0x00000060eac -[MSIDDefaultCredentialCacheQuery generic]
  0x00000061034 -[MSIDDefaultCredentialCacheQuery type]
  0x0000006107c -[MSIDDefaultCredentialCacheQuery exactMatch]
  0x000000610dc -[MSIDDefaultCredentialCacheQuery queryClientId]
  0x00000061194 -[MSIDDefaultCredentialCacheQuery targetMatchingOptions]
  0x000000611a4 -[MSIDDefaultCredentialCacheQuery setTargetMatchingOptions:]
  0x000000611b4 -[MSIDDefaultCredentialCacheQuery clientIdMatchingOptions]
  0x000000611c4 -[MSIDDefaultCredentialCacheQuery setClientIdMatchingOptions:]
  0x000000611d4 -[MSIDDefaultCredentialCacheQuery matchAnyCredentialType]
  0x000000611e4 -[MSIDDefaultCredentialCacheQuery setMatchAnyCredentialType:]
  0x000000611f4 -[MSIDDefaultCredentialCacheQuery environmentAliases]
  0x00000061204 -[MSIDDefaultCredentialCacheQuery setEnvironmentAliases:]


0x0000017e5a8 MSIDIntuneInMemoryCacheDataSource : NSObject /usr/lib/libobjc.A.dylib <MSIDIntuneCacheDataSource>
 @property  MSIDCache *cache
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000006122c -[MSIDIntuneInMemoryCacheDataSource initWithCache:]
  0x000000612e4 -[MSIDIntuneInMemoryCacheDataSource init]
  0x000000612ec -[MSIDIntuneInMemoryCacheDataSource jsonDictionaryForKey:]
  0x00000061358 -[MSIDIntuneInMemoryCacheDataSource setJsonDictionary:forKey:]
  0x000000613cc -[MSIDIntuneInMemoryCacheDataSource removeObjectForKey:]
  0x0000006141c -[MSIDIntuneInMemoryCacheDataSource cache]


0x0000017e620 MSIDDeviceId : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000061584 +[MSIDDeviceId getCPUInfo]
  0x000000616a8 +[MSIDDeviceId deviceId]
  0x000000618e0 +[MSIDDeviceId deviceOSVersion]
  0x00000061994 +[MSIDDeviceId deviceOSId]
  0x00000061aa4 +[MSIDDeviceId deviceTelemetryId]
  0x00000061af8 +[MSIDDeviceId applicationName]
  0x00000061b44 +[MSIDDeviceId applicationVersion]
  0x00000061b98 +[MSIDDeviceId setIdValue:forKey:]
  0x00000061c0c +[MSIDDeviceId deviceHardwareType]


0x0000017e670 MSIDCIAMAuthorityResolver : MSIDAadAuthorityResolver
  // instance methods
  0x00000061c88 -[MSIDCIAMAuthorityResolver resolveAuthority:userPrincipalName:validate:context:completionBlock:]


0x0000017e6c0 MSIDNTLMHandler : NSObject /usr/lib/libobjc.A.dylib <MSIDChallengeHandling>
  // class methods
  0x00000061e44 +[MSIDNTLMHandler load]
  0x00000061e60 +[MSIDNTLMHandler resetHandler]
  0x00000061eb0 +[MSIDNTLMHandler handleChallenge:webview:context:completionHandler:]
  0x000000623a8 +[MSIDNTLMHandler getCredentialPersistence]


0x0000017e6e8 MSIDAADV1Oauth2Factory : MSIDAADOauth2Factory
  // class methods
  0x000000623b0 +[MSIDAADV1Oauth2Factory providerType]

  // instance methods
  0x000000623b8 -[MSIDAADV1Oauth2Factory checkResponseClass:context:error:]
  0x000000624e4 -[MSIDAADV1Oauth2Factory tokenResponseFromJSON:context:error:]
  0x00000062540 -[MSIDAADV1Oauth2Factory tokenResponseFromJSON:refreshToken:context:error:]
  0x000000625b8 -[MSIDAADV1Oauth2Factory verifyResponse:context:error:]
  0x000000625c8 -[MSIDAADV1Oauth2Factory verifyResponse:fromRefreshToken:context:error:]
  0x00000062818 -[MSIDAADV1Oauth2Factory fillAccessToken:fromResponse:configuration:]
  0x00000062938 -[MSIDAADV1Oauth2Factory fillAccount:fromResponse:configuration:]
  0x00000062a88 -[MSIDAADV1Oauth2Factory fillIDToken:fromResponse:configuration:]
  0x00000062bc0 -[MSIDAADV1Oauth2Factory webviewFactory]
  0x00000062c10 -[MSIDAADV1Oauth2Factory authorizationGrantRequestWithRequestParameters:codeVerifier:authCode:homeAccountId:]
  0x00000062c18 -[MSIDAADV1Oauth2Factory refreshTokenRequestWithRequestParameters:refreshToken:]
  0x00000062c20 -[MSIDAADV1Oauth2Factory accountIdentifierFromResponse:]
  0x00000062cf4 -[MSIDAADV1Oauth2Factory resultAuthorityWithConfiguration:tokenResponse:error:]


0x0000017e738 MSIDLRUCacheNode : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *signature
 @property  NSMutableString *prevSignature
 @property  NSMutableString *nextSignature
 @property  id cacheRecord

  // instance methods
  0x00000062cfc -[MSIDLRUCacheNode initWithSignature:prevSignature:nextSignature:cacheRecord:]
  0x00000062e34 -[MSIDLRUCacheNode signature]
  0x00000062e3c -[MSIDLRUCacheNode prevSignature]
  0x00000062e44 -[MSIDLRUCacheNode setPrevSignature:]
  0x00000062e50 -[MSIDLRUCacheNode nextSignature]
  0x00000062e58 -[MSIDLRUCacheNode setNextSignature:]
  0x00000062e64 -[MSIDLRUCacheNode cacheRecord]
  0x00000062e6c -[MSIDLRUCacheNode setCacheRecord:]


0x0000017e788 MSIDLRUCache : NSObject /usr/lib/libobjc.A.dylib
 @property  unsigned long cacheSizeInt
 @property  unsigned long cacheUpdateCountInt
 @property  unsigned long cacheEvictionCountInt
 @property  unsigned long cacheAddCountInt
 @property  unsigned long cacheRemoveCountInt
 @property  NSMutableDictionary *container
 @property  NSMutableDictionary *keySignatureMap
 @property  NSObject<OS_dispatch_queue> *synchronizationQueue
 @property  unsigned long cacheSize
 @property  unsigned long numCacheRecords
 @property  unsigned long cacheUpdateCount
 @property  unsigned long cacheEvictionCount
 @property  unsigned long cacheAddCount
 @property  unsigned long cacheRemoveCount

  // class methods
  0x00000063160 +[MSIDLRUCache sharedInstance]

  // instance methods
  0x00000062ec0 -[MSIDLRUCache cacheSize]
  0x00000062ed8 -[MSIDLRUCache numCacheRecords]
  0x00000062f34 -[MSIDLRUCache cacheUpdateCount]
  0x00000062f38 -[MSIDLRUCache cacheEvictionCount]
  0x00000062f3c -[MSIDLRUCache cacheAddCount]
  0x00000062f40 -[MSIDLRUCache cacheRemoveCount]
  0x00000062f44 -[MSIDLRUCache initWithCacheSize:]
  0x000000631d4 -[MSIDLRUCache setObject:forKey:error:]
  0x00000063728 -[MSIDLRUCache removeObjectForKey:error:]
  0x00000063a58 -[MSIDLRUCache removeObjectForKeyImpl:error:]
  0x00000063e54 -[MSIDLRUCache objectForKey:error:]
  0x00000064244 -[MSIDLRUCache objectForKeyImpl:error:]
  0x0000006447c -[MSIDLRUCache addToFront:]
  0x0000006455c -[MSIDLRUCache addToFrontImpl:]
  0x000000648a4 -[MSIDLRUCache enumerateAndReturnAllObjects]
  0x000000649f8 -[MSIDLRUCache enumerateAndReturnAllObjectsImpl]
  0x00000064b90 -[MSIDLRUCache generateRandomSignature]
  0x00000064c20 -[MSIDLRUCache mapKeyToSignature:]
  0x00000064c98 -[MSIDLRUCache removeAllObjects:]
  0x0000006500c -[MSIDLRUCache cacheSizeInt]
  0x00000065014 -[MSIDLRUCache setCacheSizeInt:]
  0x0000006501c -[MSIDLRUCache cacheUpdateCountInt]
  0x00000065024 -[MSIDLRUCache setCacheUpdateCountInt:]
  0x0000006502c -[MSIDLRUCache cacheEvictionCountInt]
  0x00000065034 -[MSIDLRUCache setCacheEvictionCountInt:]
  0x0000006503c -[MSIDLRUCache cacheAddCountInt]
  0x00000065044 -[MSIDLRUCache setCacheAddCountInt:]
  0x0000006504c -[MSIDLRUCache cacheRemoveCountInt]
  0x00000065054 -[MSIDLRUCache setCacheRemoveCountInt:]
  0x0000006505c -[MSIDLRUCache container]
  0x00000065064 -[MSIDLRUCache setContainer:]
  0x00000065070 -[MSIDLRUCache keySignatureMap]
  0x00000065078 -[MSIDLRUCache setKeySignatureMap:]
  0x00000065084 -[MSIDLRUCache synchronizationQueue]
  0x0000006508c -[MSIDLRUCache setSynchronizationQueue:]


0x0000017e7d8 MSIDSSOExtensionGetSsoCookiesRequest : MSIDSSOExtensionGetDataBaseRequest
 @property  @? requestCompletionBlock
 @property  MSIDAccountIdentifier *accountIdentifier
 @property  NSString *ssoUrl
 @property  NSUUID *correlationId
 @property  NSString *types

  // instance methods
  0x000000650d4 -[MSIDSSOExtensionGetSsoCookiesRequest initWithRequestParameters:headerTypes:accountIdentifier:ssoUrl:correlationId:error:]
  0x0000006555c -[MSIDSSOExtensionGetSsoCookiesRequest executeRequestWithCompletion:]
  0x00000065740 -[MSIDSSOExtensionGetSsoCookiesRequest accountIdentifier]
  0x00000065750 -[MSIDSSOExtensionGetSsoCookiesRequest ssoUrl]
  0x00000065760 -[MSIDSSOExtensionGetSsoCookiesRequest correlationId]
  0x00000065770 -[MSIDSSOExtensionGetSsoCookiesRequest types]
  0x00000065780 -[MSIDSSOExtensionGetSsoCookiesRequest requestCompletionBlock]
  0x00000065790 -[MSIDSSOExtensionGetSsoCookiesRequest setRequestCompletionBlock:]


0x0000017e828 MSIDAccountIdentifier : NSObject /usr/lib/libobjc.A.dylib <NSCopying, MSIDJsonSerializable>
 @property  MSIDMaskedHashableLogParameter *maskedHomeAccountId
 @property  MSIDMaskedUsernameLogParameter *maskedDisplayableId
 @property  NSString *homeAccountId
 @property  NSString *displayableId
 @property  NSString *localAccountId
 @property  long long legacyAccountIdentifierType
 @property  NSString *uid
 @property  NSString *utid
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000065a68 +[MSIDAccountIdentifier legacyAccountIdentifierTypeAsString:]
  0x00000065a8c +[MSIDAccountIdentifier legacyAccountIdentifierTypeFromString:]
  0x00000065b04 +[MSIDAccountIdentifier homeAccountIdentifierFromUid:utid:]
  0x00000065bb4 +[MSIDAccountIdentifier isAccountIdValid:error:]

  // instance methods
  0x000000658f4 -[MSIDAccountIdentifier initWithDisplayableId:homeAccountId:]
  0x00000065ce8 -[MSIDAccountIdentifier copyWithZone:]
  0x00000065e68 -[MSIDAccountIdentifier isEqual:]
  0x00000065f90 -[MSIDAccountIdentifier isEqualToItem:]
  0x000000661b4 -[MSIDAccountIdentifier initWithJSONDictionary:error:]
  0x000000662fc -[MSIDAccountIdentifier jsonDictionary]
  0x00000066474 -[MSIDAccountIdentifier homeAccountId]
  0x0000006647c -[MSIDAccountIdentifier displayableId]
  0x00000066484 -[MSIDAccountIdentifier localAccountId]
  0x0000006648c -[MSIDAccountIdentifier setLocalAccountId:]
  0x00000066498 -[MSIDAccountIdentifier legacyAccountIdentifierType]
  0x000000664a0 -[MSIDAccountIdentifier setLegacyAccountIdentifierType:]
  0x000000664a8 -[MSIDAccountIdentifier uid]
  0x000000664b0 -[MSIDAccountIdentifier setUid:]
  0x000000664bc -[MSIDAccountIdentifier utid]
  0x000000664c4 -[MSIDAccountIdentifier setUtid:]
  0x000000664d0 -[MSIDAccountIdentifier maskedHomeAccountId]
  0x000000664d8 -[MSIDAccountIdentifier setMaskedHomeAccountId:]
  0x000000664e4 -[MSIDAccountIdentifier maskedDisplayableId]
  0x000000664ec -[MSIDAccountIdentifier setMaskedDisplayableId:]


0x0000017e878 MSIDSystemWebviewController : NSObject /usr/lib/libobjc.A.dylib <MSIDWebviewInteracting>
 @property  @? completionHandler
 @property  NSString *telemetryRequestId
 @property  MSIDTelemetryUIEvent *telemetryEvent
 @property  <MSIDWebviewInteracting> *session
 @property  <MSIDRequestContext> *context
 @property  BOOL useAuthenticationSession
 @property  BOOL allowSafariViewController
 @property  BOOL prefersEphemeralWebBrowserSession
 @property  NSURL *startURL
 @property  NSURL *redirectURL
 @property  NSViewController *parentController

  // instance methods
  0x00000066564 -[MSIDSystemWebviewController initWithStartURL:redirectURI:parentController:useAuthenticationSession:allowSafariViewController:ephemeralWebBrowserSession:context:]
  0x000000667f8 -[MSIDSystemWebviewController startWithCompletionHandler:]
  0x00000066cc4 -[MSIDSystemWebviewController cancel:]
  0x00000066de8 -[MSIDSystemWebviewController cancelProgrammatically]
  0x00000066f34 -[MSIDSystemWebviewController userCancel]
  0x00000067084 -[MSIDSystemWebviewController handleURLResponse:]
  0x000000672c4 -[MSIDSystemWebviewController dismiss]
  0x000000672f4 -[MSIDSystemWebviewController sessionWithAuthSessionAllowed:safariAllowed:]
  0x00000067478 -[MSIDSystemWebviewController notifyEndWebAuthWithURL:error:]
  0x00000067490 -[MSIDSystemWebviewController startURL]
  0x0000006749c -[MSIDSystemWebviewController redirectURL]
  0x000000674a8 -[MSIDSystemWebviewController parentController]
  0x000000674c0 -[MSIDSystemWebviewController setParentController:]
  0x000000674cc -[MSIDSystemWebviewController completionHandler]
  0x000000674d4 -[MSIDSystemWebviewController setCompletionHandler:]
  0x000000674dc -[MSIDSystemWebviewController telemetryRequestId]
  0x000000674e4 -[MSIDSystemWebviewController setTelemetryRequestId:]
  0x000000674f0 -[MSIDSystemWebviewController telemetryEvent]
  0x000000674f8 -[MSIDSystemWebviewController setTelemetryEvent:]
  0x00000067504 -[MSIDSystemWebviewController session]
  0x0000006750c -[MSIDSystemWebviewController setSession:]
  0x00000067518 -[MSIDSystemWebviewController context]
  0x00000067520 -[MSIDSystemWebviewController setContext:]
  0x0000006752c -[MSIDSystemWebviewController useAuthenticationSession]
  0x00000067534 -[MSIDSystemWebviewController setUseAuthenticationSession:]
  0x0000006753c -[MSIDSystemWebviewController allowSafariViewController]
  0x00000067544 -[MSIDSystemWebviewController setAllowSafariViewController:]
  0x0000006754c -[MSIDSystemWebviewController prefersEphemeralWebBrowserSession]
  0x00000067554 -[MSIDSystemWebviewController setPrefersEphemeralWebBrowserSession:]


0x0000017e8c8 MSIDBrokerOperationBrowserTokenRequest : MSIDBaseBrokerOperationRequest
 @property  NSURL *requestURL
 @property  NSString *bundleIdentifier
 @property  MSIDAADAuthority *authority
 @property  NSDictionary *headers
 @property  NSData *httpBody
 @property  BOOL useSSOCookieFallback
 @property  MSIDExternalSSOContext *ssoContext

  // class methods
  0x00000067a78 +[MSIDBrokerOperationBrowserTokenRequest logProtocolNames]
  0x00000067ad0 +[MSIDBrokerOperationBrowserTokenRequest protocolLogNameForRequestURL:]
  0x00000067d5c +[MSIDBrokerOperationBrowserTokenRequest operation]

  // instance methods
  0x000000675d0 -[MSIDBrokerOperationBrowserTokenRequest initWithRequest:headers:body:bundleIdentifier:requestValidator:useSSOCookieFallback:ssoContext:error:]
  0x00000067c58 -[MSIDBrokerOperationBrowserTokenRequest printRequestURLInfo:]
  0x00000067d6c -[MSIDBrokerOperationBrowserTokenRequest logInfo]
  0x00000067df8 -[MSIDBrokerOperationBrowserTokenRequest requestURL]
  0x00000067e08 -[MSIDBrokerOperationBrowserTokenRequest bundleIdentifier]
  0x00000067e18 -[MSIDBrokerOperationBrowserTokenRequest authority]
  0x00000067e28 -[MSIDBrokerOperationBrowserTokenRequest headers]
  0x00000067e38 -[MSIDBrokerOperationBrowserTokenRequest httpBody]
  0x00000067e48 -[MSIDBrokerOperationBrowserTokenRequest useSSOCookieFallback]
  0x00000067e58 -[MSIDBrokerOperationBrowserTokenRequest ssoContext]


0x0000017e918 MSIDBrokerOperationGetAccountsRequest : MSIDBrokerOperationRequest
 @property  NSString *clientId
 @property  NSString *familyId
 @property  BOOL returnOnlySignedInAccounts

  // class methods
  0x000000682dc +[MSIDBrokerOperationGetAccountsRequest load]
  0x0000006832c +[MSIDBrokerOperationGetAccountsRequest operation]

  // instance methods
  0x0000006833c -[MSIDBrokerOperationGetAccountsRequest initWithJSONDictionary:error:]
  0x00000068558 -[MSIDBrokerOperationGetAccountsRequest jsonDictionary]
  0x000000686f0 -[MSIDBrokerOperationGetAccountsRequest clientId]
  0x00000068700 -[MSIDBrokerOperationGetAccountsRequest setClientId:]
  0x00000068714 -[MSIDBrokerOperationGetAccountsRequest familyId]
  0x00000068724 -[MSIDBrokerOperationGetAccountsRequest setFamilyId:]
  0x00000068738 -[MSIDBrokerOperationGetAccountsRequest returnOnlySignedInAccounts]
  0x00000068748 -[MSIDBrokerOperationGetAccountsRequest setReturnOnlySignedInAccounts:]


0x0000017e968 MSIDLegacyTokenCacheItem : MSIDCredentialCacheItem <NSSecureCoding>
 @property  NSString *accessToken
 @property  NSString *refreshToken
 @property  NSString *idToken
 @property  NSString *oauthTokenType
 @property  MSIDIdTokenClaims *idTokenClaims
 @property  NSDictionary *additionalInfo

  // class methods
  0x00000068edc +[MSIDLegacyTokenCacheItem supportsSecureCoding]

  // instance methods
  0x00000068798 -[MSIDLegacyTokenCacheItem isEqual:]
  0x0000006880c -[MSIDLegacyTokenCacheItem isEqualToItem:]
  0x00000068d28 -[MSIDLegacyTokenCacheItem copyWithZone:]
  0x00000068ee4 -[MSIDLegacyTokenCacheItem initWithCoder:]
  0x00000069540 -[MSIDLegacyTokenCacheItem encodeWithCoder:]
  0x00000069a14 -[MSIDLegacyTokenCacheItem tokenWithType:]
  0x00000069ae8 -[MSIDLegacyTokenCacheItem idTokenClaims]
  0x00000069c98 -[MSIDLegacyTokenCacheItem isTombstone]
  0x00000069d10 -[MSIDLegacyTokenCacheItem accessToken]
  0x00000069d20 -[MSIDLegacyTokenCacheItem setAccessToken:]
  0x00000069d2c -[MSIDLegacyTokenCacheItem refreshToken]
  0x00000069d3c -[MSIDLegacyTokenCacheItem setRefreshToken:]
  0x00000069d48 -[MSIDLegacyTokenCacheItem idToken]
  0x00000069d58 -[MSIDLegacyTokenCacheItem setIdToken:]
  0x00000069d64 -[MSIDLegacyTokenCacheItem oauthTokenType]
  0x00000069d74 -[MSIDLegacyTokenCacheItem setOauthTokenType:]
  0x00000069d80 -[MSIDLegacyTokenCacheItem additionalInfo]
  0x00000069d90 -[MSIDLegacyTokenCacheItem setAdditionalInfo:]


0x0000017e9b8 MSIDSSOExtensionSilentTokenRequest : MSIDSilentTokenRequest <ASAuthorizationControllerDelegate>
 @property  ASAuthorizationController *authorizationController
 @property  @? requestCompletionBlock
 @property  <MSIDCacheAccessor> *tokenCache
 @property  MSIDAccountMetadataCacheAccessor *accountMetadataCache
 @property  MSIDSSOExtensionTokenRequestDelegate *extensionDelegate
 @property  ASAuthorizationSingleSignOnProvider *ssoProvider
 @property  long long providerType
 @property  MSIDIntuneEnrollmentIdsCache *enrollmentIdsCache
 @property  MSIDIntuneMAMResourcesCache *mamResourcesCache
 @property  MSIDSSOTokenResponseHandler *ssoTokenResponseHandler
 @property  MSIDBrokerOperationSilentTokenRequest *operationRequest
 @property  NSDate *requestSentDate
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000069e2c -[MSIDSSOExtensionSilentTokenRequest initWithRequestParameters:forceRefresh:oauthFactory:tokenResponseValidator:tokenCache:accountMetadataCache:extendedTokenCache:]
  0x0000006a490 -[MSIDSSOExtensionSilentTokenRequest executeRequestWithCompletion:]
  0x0000006ac1c -[MSIDSSOExtensionSilentTokenRequest executeRequestImplWithCompletionBlock:]
  0x0000006aee8 -[MSIDSSOExtensionSilentTokenRequest tokenCache]
  0x0000006aef8 -[MSIDSSOExtensionSilentTokenRequest metadataCache]
  0x0000006aefc -[MSIDSSOExtensionSilentTokenRequest setTokenCache:]
  0x0000006af10 -[MSIDSSOExtensionSilentTokenRequest authorizationController]
  0x0000006af20 -[MSIDSSOExtensionSilentTokenRequest setAuthorizationController:]
  0x0000006af34 -[MSIDSSOExtensionSilentTokenRequest requestCompletionBlock]
  0x0000006af44 -[MSIDSSOExtensionSilentTokenRequest setRequestCompletionBlock:]
  0x0000006af50 -[MSIDSSOExtensionSilentTokenRequest accountMetadataCache]
  0x0000006af60 -[MSIDSSOExtensionSilentTokenRequest setAccountMetadataCache:]
  0x0000006af74 -[MSIDSSOExtensionSilentTokenRequest extensionDelegate]
  0x0000006af84 -[MSIDSSOExtensionSilentTokenRequest setExtensionDelegate:]
  0x0000006af98 -[MSIDSSOExtensionSilentTokenRequest ssoProvider]
  0x0000006afa8 -[MSIDSSOExtensionSilentTokenRequest setSsoProvider:]
  0x0000006afbc -[MSIDSSOExtensionSilentTokenRequest providerType]
  0x0000006afcc -[MSIDSSOExtensionSilentTokenRequest enrollmentIdsCache]
  0x0000006afdc -[MSIDSSOExtensionSilentTokenRequest mamResourcesCache]
  0x0000006afec -[MSIDSSOExtensionSilentTokenRequest ssoTokenResponseHandler]
  0x0000006affc -[MSIDSSOExtensionSilentTokenRequest operationRequest]
  0x0000006b00c -[MSIDSSOExtensionSilentTokenRequest setOperationRequest:]
  0x0000006b020 -[MSIDSSOExtensionSilentTokenRequest requestSentDate]
  0x0000006b030 -[MSIDSSOExtensionSilentTokenRequest setRequestSentDate:]


0x0000017ea08 MSIDAADV2BrokerResponse : MSIDBrokerResponse
 @property  NSString *scope
 @property  NSDictionary *errorMetadata
 @property  NSString *oauthErrorCode
 @property  NSString *errorDescription
 @property  NSString *subError
 @property  NSDictionary *httpHeaders

  // instance methods
  0x0000006b138 -[MSIDAADV2BrokerResponse scope]
  0x0000006b1cc -[MSIDAADV2BrokerResponse initWithDictionary:error:]
  0x0000006b2f4 -[MSIDAADV2BrokerResponse initDerivedProperties]
  0x0000006b3d4 -[MSIDAADV2BrokerResponse errorCode]
  0x0000006b420 -[MSIDAADV2BrokerResponse errorDomain]
  0x0000006b46c -[MSIDAADV2BrokerResponse oauthErrorCode]
  0x0000006b4b8 -[MSIDAADV2BrokerResponse errorDescription]
  0x0000006b504 -[MSIDAADV2BrokerResponse subError]
  0x0000006b550 -[MSIDAADV2BrokerResponse httpHeaders]
  0x0000006b608 -[MSIDAADV2BrokerResponse errorMetadata]


0x0000017ea80 MSIDTelemetryAuthorityValidationEvent : MSIDTelemetryBaseEvent
  // class methods
  0x0000006b700 +[MSIDTelemetryAuthorityValidationEvent propertiesToAggregate]

  // instance methods
  0x0000006b62c -[MSIDTelemetryAuthorityValidationEvent setAuthorityValidationStatus:]
  0x0000006b640 -[MSIDTelemetryAuthorityValidationEvent setAuthority:]


0x0000017ead0 MSIDHelpers : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000006b89c +[MSIDHelpers msidIntegerValue:]
  0x0000006b8f8 +[MSIDHelpers normalizeUserId:]


0x0000017eaf8 MSIDThrottlingModelBase : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *thumbprintValue
 @property  long long thumbprintType
 @property  long long throttleDuration
 @property  <MSIDThumbprintCalculatable> *request
 @property  NSError *errorResponse
 @property  MSIDThrottlingCacheRecord *cacheRecord
 @property  <MSIDExtendedTokenCacheDataSource> *datasource
 @property  <MSIDRequestContext> *context

  // class methods
  0x0000006b96c +[MSIDThrottlingModelBase cacheService]
  0x0000006be38 +[MSIDThrottlingModelBase isApplicableForTheThrottleModel:]

  // instance methods
  0x0000006b978 -[MSIDThrottlingModelBase initWithRequest:cacheRecord:errorResponse:datasource:]
  0x0000006baa0 -[MSIDThrottlingModelBase cleanCacheRecordFromDB]
  0x0000006bbf8 -[MSIDThrottlingModelBase insertOrUpdateCacheRecordToDB:]
  0x0000006be30 -[MSIDThrottlingModelBase createDBCacheRecord]
  0x0000006be40 -[MSIDThrottlingModelBase shouldThrottleRequest]
  0x0000006be48 -[MSIDThrottlingModelBase updateServerTelemetry]
  0x0000006be4c -[MSIDThrottlingModelBase thumbprintValue]
  0x0000006be58 -[MSIDThrottlingModelBase setThumbprintValue:]
  0x0000006be60 -[MSIDThrottlingModelBase thumbprintType]
  0x0000006be68 -[MSIDThrottlingModelBase setThumbprintType:]
  0x0000006be70 -[MSIDThrottlingModelBase throttleDuration]
  0x0000006be78 -[MSIDThrottlingModelBase setThrottleDuration:]
  0x0000006be80 -[MSIDThrottlingModelBase request]
  0x0000006be88 -[MSIDThrottlingModelBase errorResponse]
  0x0000006be90 -[MSIDThrottlingModelBase cacheRecord]
  0x0000006be98 -[MSIDThrottlingModelBase datasource]
  0x0000006bea0 -[MSIDThrottlingModelBase context]


0x0000017eb48 MSIDBrokerOperationBrowserNativeMessageResponse : MSIDBrokerNativeAppOperationResponse
 @property  NSString *payload

  // class methods
  0x0000006bf08 +[MSIDBrokerOperationBrowserNativeMessageResponse load]
  0x0000006bf58 +[MSIDBrokerOperationBrowserNativeMessageResponse responseType]

  // instance methods
  0x0000006bf68 -[MSIDBrokerOperationBrowserNativeMessageResponse initWithJSONDictionary:error:]
  0x0000006c0ec -[MSIDBrokerOperationBrowserNativeMessageResponse jsonDictionary]
  0x0000006c208 -[MSIDBrokerOperationBrowserNativeMessageResponse payload]
  0x0000006c218 -[MSIDBrokerOperationBrowserNativeMessageResponse setPayload:]


0x0000017ebc0 MSIDLegacyTokenCacheQuery : MSIDLegacyTokenCacheKey
 @property  BOOL exactMatch

  // instance methods
  0x0000006c240 -[MSIDLegacyTokenCacheQuery account]
  0x0000006c2b4 -[MSIDLegacyTokenCacheQuery service]
  0x0000006c3b8 -[MSIDLegacyTokenCacheQuery exactMatch]


0x0000017ebe8 MSIDErrorConverter : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000006c448 +[MSIDErrorConverter initialize]
  0x0000006c4b0 +[MSIDErrorConverter setErrorConverter:]
  0x0000006c4c0 +[MSIDErrorConverter errorConverter]
  0x0000006c4cc +[MSIDErrorConverter defaultErrorConverter]


0x0000017ec38 MSIDSSOExtensionPasskeyCredentialRequest : MSIDSSOExtensionGetDataBaseRequest
 @property  @? requestCompletionBlock
 @property  NSUUID *correlationId

  // instance methods
  0x0000006c4d8 -[MSIDSSOExtensionPasskeyCredentialRequest initWithRequestParameters:correlationId:error:]
  0x0000006c888 -[MSIDSSOExtensionPasskeyCredentialRequest executeRequestWithCompletion:]
  0x0000006c9f0 -[MSIDSSOExtensionPasskeyCredentialRequest correlationId]
  0x0000006ca00 -[MSIDSSOExtensionPasskeyCredentialRequest requestCompletionBlock]
  0x0000006ca10 -[MSIDSSOExtensionPasskeyCredentialRequest setRequestCompletionBlock:]


0x0000017ec88 MSIDSSOExtensionRequestDelegate : NSObject /usr/lib/libobjc.A.dylib <ASAuthorizationControllerDelegate>
 @property  MSIDJsonSerializer *jsonSerializer
 @property  <MSIDRequestContext> *context
 @property  @? completionBlock
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000006ca5c -[MSIDSSOExtensionRequestDelegate init]
  0x0000006caec -[MSIDSSOExtensionRequestDelegate authorizationController:didCompleteWithAuthorization:]
  0x0000006caf0 -[MSIDSSOExtensionRequestDelegate authorizationController:didCompleteWithError:]
  0x0000006ce28 -[MSIDSSOExtensionRequestDelegate ssoCredentialFromCredential:error:]
  0x0000006cffc -[MSIDSSOExtensionRequestDelegate jsonPayloadFromSSOCredential:error:]
  0x0000006d044 -[MSIDSSOExtensionRequestDelegate context]
  0x0000006d04c -[MSIDSSOExtensionRequestDelegate setContext:]
  0x0000006d058 -[MSIDSSOExtensionRequestDelegate completionBlock]
  0x0000006d060 -[MSIDSSOExtensionRequestDelegate setCompletionBlock:]
  0x0000006d068 -[MSIDSSOExtensionRequestDelegate jsonSerializer]


0x0000017ecd8 MSIDLegacyTokenRequestProvider : NSObject /usr/lib/libobjc.A.dylib <MSIDTokenRequestProviding>
 @property  MSIDOauth2Factory *oauthFactory
 @property  MSIDLegacyTokenCacheAccessor *tokenCache
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000006d0ac -[MSIDLegacyTokenRequestProvider initWithOauthFactory:legacyAccessor:]
  0x0000006d17c -[MSIDLegacyTokenRequestProvider interactiveTokenRequestWithParameters:]
  0x0000006d248 -[MSIDLegacyTokenRequestProvider silentTokenRequestWithParameters:forceRefresh:]
  0x0000006d314 -[MSIDLegacyTokenRequestProvider brokerTokenRequestWithParameters:brokerKey:brokerApplicationToken:sdkCapabilities:error:]
  0x0000006d3cc -[MSIDLegacyTokenRequestProvider interactiveSSOExtensionTokenRequestWithParameters:]
  0x0000006d3d4 -[MSIDLegacyTokenRequestProvider silentSSOExtensionTokenRequestWithParameters:forceRefresh:]
  0x0000006d3dc -[MSIDLegacyTokenRequestProvider oauthFactory]
  0x0000006d3e4 -[MSIDLegacyTokenRequestProvider setOauthFactory:]
  0x0000006d3f0 -[MSIDLegacyTokenRequestProvider tokenCache]
  0x0000006d3f8 -[MSIDLegacyTokenRequestProvider setTokenCache:]


0x0000017ed28 MSIDAppMetadataCacheItem : NSObject /usr/lib/libobjc.A.dylib <NSCopying, MSIDJsonSerializable, MSIDKeyGenerator>
 @property  NSDictionary *json
 @property  NSString *clientId
 @property  NSString *environment
 @property  NSString *familyId
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000006d9bc -[MSIDAppMetadataCacheItem isEqual:]
  0x0000006da30 -[MSIDAppMetadataCacheItem isEqualToItem:]
  0x0000006dd50 -[MSIDAppMetadataCacheItem copyWithZone:]
  0x0000006de48 -[MSIDAppMetadataCacheItem initWithJSONDictionary:error:]
  0x0000006e008 -[MSIDAppMetadataCacheItem jsonDictionary]
  0x0000006e098 -[MSIDAppMetadataCacheItem matchesWithClientId:environment:environmentAliases:]
  0x0000006e158 -[MSIDAppMetadataCacheItem matchByEnvironment:environmentAliases:]
  0x0000006e228 -[MSIDAppMetadataCacheItem generateCacheKey]
  0x0000006e310 -[MSIDAppMetadataCacheItem clientId]
  0x0000006e31c -[MSIDAppMetadataCacheItem setClientId:]
  0x0000006e324 -[MSIDAppMetadataCacheItem environment]
  0x0000006e330 -[MSIDAppMetadataCacheItem setEnvironment:]
  0x0000006e338 -[MSIDAppMetadataCacheItem familyId]
  0x0000006e344 -[MSIDAppMetadataCacheItem setFamilyId:]
  0x0000006e34c -[MSIDAppMetadataCacheItem json]
  0x0000006e358 -[MSIDAppMetadataCacheItem setJson:]


0x0000017ed78 MSIDAADTokenResponse : MSIDTokenResponse
 @property  NSString *correlationId
 @property  long long extendedExpiresIn
 @property  long long extendedExpiresOn
 @property  long long refreshIn
 @property  long long refreshOn
 @property  MSIDClientInfo *clientInfo
 @property  NSString *familyId
 @property  NSString *suberror
 @property  NSString *additionalUserId
 @property  NSString *speInfo
 @property  NSDate *extendedExpiresOnDate
 @property  NSDate *refreshOnDate

  // instance methods
  0x0000006e4fc -[MSIDAADTokenResponse setAdditionalServerInfo:]
  0x0000006e684 -[MSIDAADTokenResponse extendedExpiresOnDate]
  0x0000006e700 -[MSIDAADTokenResponse refreshOnDate]
  0x0000006e77c -[MSIDAADTokenResponse accountIdentifier]
  0x0000006e7c0 -[MSIDAADTokenResponse initWithJSONDictionary:error:]
  0x0000006eaa0 -[MSIDAADTokenResponse jsonDictionary]
  0x0000006ee84 -[MSIDAADTokenResponse correlationId]
  0x0000006ee94 -[MSIDAADTokenResponse setCorrelationId:]
  0x0000006eea8 -[MSIDAADTokenResponse extendedExpiresIn]
  0x0000006eeb8 -[MSIDAADTokenResponse setExtendedExpiresIn:]
  0x0000006eec8 -[MSIDAADTokenResponse extendedExpiresOn]
  0x0000006eed8 -[MSIDAADTokenResponse setExtendedExpiresOn:]
  0x0000006eee8 -[MSIDAADTokenResponse refreshIn]
  0x0000006eef8 -[MSIDAADTokenResponse setRefreshIn:]
  0x0000006ef08 -[MSIDAADTokenResponse refreshOn]
  0x0000006ef18 -[MSIDAADTokenResponse setRefreshOn:]
  0x0000006ef28 -[MSIDAADTokenResponse clientInfo]
  0x0000006ef38 -[MSIDAADTokenResponse setClientInfo:]
  0x0000006ef4c -[MSIDAADTokenResponse familyId]
  0x0000006ef5c -[MSIDAADTokenResponse setFamilyId:]
  0x0000006ef70 -[MSIDAADTokenResponse suberror]
  0x0000006ef80 -[MSIDAADTokenResponse setSuberror:]
  0x0000006ef94 -[MSIDAADTokenResponse additionalUserId]
  0x0000006efa4 -[MSIDAADTokenResponse setAdditionalUserId:]
  0x0000006efb8 -[MSIDAADTokenResponse speInfo]
  0x0000006efc8 -[MSIDAADTokenResponse setSpeInfo:]


0x0000017edc8 MSIDSSOExtensionInteractiveTokenRequest : MSIDInteractiveTokenRequest <ASAuthorizationControllerPresentationContextProviding>
 @property  ASAuthorizationController *authorizationController
 @property  @? requestCompletionBlock
 @property  MSIDSSOExtensionTokenRequestDelegate *extensionDelegate
 @property  ASAuthorizationSingleSignOnProvider *ssoProvider
 @property  long long providerType
 @property  MSIDIntuneEnrollmentIdsCache *enrollmentIdsCache
 @property  MSIDIntuneMAMResourcesCache *mamResourcesCache
 @property  MSIDSSOTokenResponseHandler *ssoTokenResponseHandler
 @property  NSDate *requestSentDate
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000006f06c -[MSIDSSOExtensionInteractiveTokenRequest initWithRequestParameters:oauthFactory:tokenResponseValidator:tokenCache:accountMetadataCache:extendedTokenCache:]
  0x0000006f634 -[MSIDSSOExtensionInteractiveTokenRequest executeRequestWithCompletion:]
  0x0000006fd78 -[MSIDSSOExtensionInteractiveTokenRequest presentationAnchorForAuthorizationController:]
  0x0000006fd7c -[MSIDSSOExtensionInteractiveTokenRequest presentationAnchor]
  0x0000006ff58 -[MSIDSSOExtensionInteractiveTokenRequest dealloc]
  0x0000006ffb8 -[MSIDSSOExtensionInteractiveTokenRequest authorizationController]
  0x0000006ffc8 -[MSIDSSOExtensionInteractiveTokenRequest setAuthorizationController:]
  0x0000006ffdc -[MSIDSSOExtensionInteractiveTokenRequest requestCompletionBlock]
  0x0000006ffec -[MSIDSSOExtensionInteractiveTokenRequest setRequestCompletionBlock:]
  0x0000006fff8 -[MSIDSSOExtensionInteractiveTokenRequest extensionDelegate]
  0x00000070008 -[MSIDSSOExtensionInteractiveTokenRequest setExtensionDelegate:]
  0x0000007001c -[MSIDSSOExtensionInteractiveTokenRequest ssoProvider]
  0x0000007002c -[MSIDSSOExtensionInteractiveTokenRequest setSsoProvider:]
  0x00000070040 -[MSIDSSOExtensionInteractiveTokenRequest providerType]
  0x00000070050 -[MSIDSSOExtensionInteractiveTokenRequest enrollmentIdsCache]
  0x00000070060 -[MSIDSSOExtensionInteractiveTokenRequest mamResourcesCache]
  0x00000070070 -[MSIDSSOExtensionInteractiveTokenRequest ssoTokenResponseHandler]
  0x00000070080 -[MSIDSSOExtensionInteractiveTokenRequest requestSentDate]
  0x00000070090 -[MSIDSSOExtensionInteractiveTokenRequest setRequestSentDate:]


0x0000017ee18 MSIDPasskeyCredential : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable>
 @property  NSData *userHandle
 @property  NSData *credentialKeyId
 @property  NSString *userName
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000007015c -[MSIDPasskeyCredential initWithUserHandle:credentialKeyId:userName:]
  0x00000070258 -[MSIDPasskeyCredential initWithJSONDictionary:error:]
  0x00000070430 -[MSIDPasskeyCredential jsonDictionary]
  0x00000070528 -[MSIDPasskeyCredential userHandle]
  0x00000070530 -[MSIDPasskeyCredential setUserHandle:]
  0x0000007053c -[MSIDPasskeyCredential credentialKeyId]
  0x00000070544 -[MSIDPasskeyCredential setCredentialKeyId:]
  0x00000070550 -[MSIDPasskeyCredential userName]
  0x00000070558 -[MSIDPasskeyCredential setUserName:]


0x0000017ee68 MSIDAADV2IdTokenClaims : MSIDIdTokenClaims
 @property  NSString *issuer
 @property  NSString *objectId
 @property  NSString *tenantId
 @property  NSString *version
 @property  NSString *homeObjectId

  // instance methods
  0x00000071424 -[MSIDAADV2IdTokenClaims issuer]
  0x000000714b8 -[MSIDAADV2IdTokenClaims objectId]
  0x0000007154c -[MSIDAADV2IdTokenClaims tenantId]
  0x000000715e0 -[MSIDAADV2IdTokenClaims version]
  0x00000071674 -[MSIDAADV2IdTokenClaims homeObjectId]
  0x00000071708 -[MSIDAADV2IdTokenClaims initDerivedProperties]
  0x00000071a70 -[MSIDAADV2IdTokenClaims alternativeAccountId]
  0x00000071a8c -[MSIDAADV2IdTokenClaims realm]


0x0000017eeb8 MSIDAADTokenRequestServerTelemetry : NSObject /usr/lib/libobjc.A.dylib <MSIDHttpRequestServerTelemetryHandling>
 @property  MSIDLastRequestTelemetry *lastRequestTelemetry
 @property  MSIDCurrentRequestTelemetry *currentRequestTelemetry
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000071a90 -[MSIDAADTokenRequestServerTelemetry init]
  0x00000071b28 -[MSIDAADTokenRequestServerTelemetry handleError:context:]
  0x00000071c34 -[MSIDAADTokenRequestServerTelemetry handleError:errorString:context:]
  0x00000071d64 -[MSIDAADTokenRequestServerTelemetry setTelemetryToRequest:]
  0x00000071e70 -[MSIDAADTokenRequestServerTelemetry currentRequestTelemetry]
  0x00000071e78 -[MSIDAADTokenRequestServerTelemetry setCurrentRequestTelemetry:]
  0x00000071e84 -[MSIDAADTokenRequestServerTelemetry lastRequestTelemetry]
  0x00000071e8c -[MSIDAADTokenRequestServerTelemetry setLastRequestTelemetry:]


0x0000017ef08 MSIDAssymetricKeyPairWithCert : MSIDAssymetricKeyPair
 @property  ^{__SecCertificate=} certificateRef
 @property  NSData *certificateData
 @property  NSString *certificateSubject
 @property  NSString *certificateIssuer

  // instance methods
  0x00000071ec8 -[MSIDAssymetricKeyPairWithCert initWithPrivateKey:publicKey:certificate:certificateIssuer:privateKeyDict:]
  0x00000072034 -[MSIDAssymetricKeyPairWithCert dealloc]
  0x000000720b8 -[MSIDAssymetricKeyPairWithCert certificateRef]
  0x000000720c8 -[MSIDAssymetricKeyPairWithCert certificateData]
  0x000000720d8 -[MSIDAssymetricKeyPairWithCert certificateSubject]
  0x000000720e8 -[MSIDAssymetricKeyPairWithCert certificateIssuer]


0x0000017ef58 MSIDMacTokenCache : NSObject /usr/lib/libobjc.A.dylib <MSIDTokenCacheDataSource>
 @property  NSMutableDictionary *cache
 @property  NSObject<OS_dispatch_queue> *synchronizationQueue
 @property  <MSIDMacTokenCacheDelegate> *delegate
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000072278 +[MSIDMacTokenCache defaultCache]

  // instance methods
  0x0000007214c -[MSIDMacTokenCache init]
  0x000000722e4 -[MSIDMacTokenCache serialize]
  0x0000007263c -[MSIDMacTokenCache deserialize:error:]
  0x000000729fc -[MSIDMacTokenCache initializeCacheIfNecessary]
  0x00000072a94 -[MSIDMacTokenCache clear]
  0x00000072b60 -[MSIDMacTokenCache saveToken:key:serializer:context:error:]
  0x00000072c48 -[MSIDMacTokenCache tokenWithKey:serializer:context:error:]
  0x00000072e10 -[MSIDMacTokenCache tokensWithKey:serializer:context:error:]
  0x00000072ec4 -[MSIDMacTokenCache removeTokensWithKey:context:error:]
  0x00000072ec8 -[MSIDMacTokenCache removeAccountMetadataForKey:context:error:]
  0x00000072ecc -[MSIDMacTokenCache removeItemsWithKey:context:error:]
  0x000000730a4 -[MSIDMacTokenCache saveWipeInfoWithContext:error:]
  0x000000730ac -[MSIDMacTokenCache wipeInfo:error:]
  0x000000730b4 -[MSIDMacTokenCache addToItems:fromDictionary:key:]
  0x00000073184 -[MSIDMacTokenCache addToItems:forUserId:tokens:key:]
  0x0000007331c -[MSIDMacTokenCache validateCache:error:]
  0x0000007398c -[MSIDMacTokenCache removeItemsWithKeyImpl:context:error:]
  0x00000073bcc -[MSIDMacTokenCache setItemImpl:key:serializer:context:error:]
  0x00000074220 -[MSIDMacTokenCache itemsWithKeyImpl:serializer:context:error:]
  0x00000074628 -[MSIDMacTokenCache legacyKeyWithoutAccount:]
  0x000000746ec -[MSIDMacTokenCache clearWithContext:error:]
  0x000000747b4 -[MSIDMacTokenCache delegate]
  0x000000747cc -[MSIDMacTokenCache setDelegate:]
  0x000000747d8 -[MSIDMacTokenCache cache]
  0x000000747e0 -[MSIDMacTokenCache setCache:]
  0x000000747ec -[MSIDMacTokenCache synchronizationQueue]
  0x000000747f4 -[MSIDMacTokenCache setSynchronizationQueue:]


0x0000017efa8 MSIDKeyOperationUtil : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000074838 +[MSIDKeyOperationUtil sharedInstance]

  // instance methods
  0x000000748a4 -[MSIDKeyOperationUtil isKeyFromSecureEnclave:]
  0x00000074924 -[MSIDKeyOperationUtil isOperationSupportedByKey:algorithm:key:context:error:]
  0x00000074a08 -[MSIDKeyOperationUtil getJwtAlgorithmForKey:context:error:]
  0x00000074bb0 -[MSIDKeyOperationUtil getSignatureForDataWithKey:privateKey:signingAlgorithm:context:error:]
  0x00000074d1c -[MSIDKeyOperationUtil generateErrorWithMessage:underlyingError:context:error:]


0x0000017f020 MSIDCertAuthHandler : NSObject /usr/lib/libobjc.A.dylib <MSIDChallengeHandling>
  // class methods
  0x00000074dec +[MSIDCertAuthHandler resetHandler]
  0x00000074df0 +[MSIDCertAuthHandler handleChallenge:webview:context:completionHandler:]
  0x00000075374 +[MSIDCertAuthHandler respondCertAuthChallengeWithIdentity:context:completionHandler:]
  0x00000075490 +[MSIDCertAuthHandler promptUserForIdentity:host:webview:correlationId:completionHandler:]
  0x000000759e0 +[MSIDCertAuthHandler isIdentityValid:context:]
  0x00000075c88 +[MSIDCertAuthHandler isCertificatedValid:context:]
  0x00000075d54 +[MSIDCertAuthHandler dateFromCertificate:key:context:]


0x0000017f048 MSIDRefreshTokenGrantRequest : MSIDTokenRequest <MSIDThumbprintCalculatable>
 @property  NSMutableDictionary *thumbprintParameters
 @property  NSString *fullRequestThumbprint
 @property  NSString *strictRequestThumbprint
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x000000761f4 +[MSIDRefreshTokenGrantRequest fullRequestThumbprintExcludeParams]
  0x000000762e8 +[MSIDRefreshTokenGrantRequest strictRequestThumbprintIncludeParams]

  // instance methods
  0x00000075f04 -[MSIDRefreshTokenGrantRequest initWithEndpoint:authScheme:clientId:scope:refreshToken:redirectUri:extraParameters:ssoContext:context:]
  0x000000760ec -[MSIDRefreshTokenGrantRequest fullRequestThumbprint]
  0x00000076170 -[MSIDRefreshTokenGrantRequest strictRequestThumbprint]
  0x00000076404 -[MSIDRefreshTokenGrantRequest thumbprintParameters]
  0x00000076414 -[MSIDRefreshTokenGrantRequest setThumbprintParameters:]


0x0000017f098 MSIDAADAuthority : MSIDAuthority
 @property  MSIDAadAuthorityCache *authorityCache
 @property  MSIDAADTenant *tenant

  // class methods
  0x0000007643c +[MSIDAADAuthority load]
  0x00000076d20 +[MSIDAADAuthority isAuthorityFormatValid:context:error:]
  0x00000076f3c +[MSIDAADAuthority aadAuthorityWithEnvironment:rawTenant:context:error:]
  0x00000077208 +[MSIDAADAuthority realmFromURL:context:error:]
  0x000000772d4 +[MSIDAADAuthority normalizedAuthorityUrl:context:error:]
  0x00000077488 +[MSIDAADAuthority tenantFromAuthorityUrl:context:error:]

  // instance methods
  0x000000764f0 -[MSIDAADAuthority initWithURL:context:error:]
  0x0000007669c -[MSIDAADAuthority initWithURL:rawTenant:context:error:]
  0x00000076874 -[MSIDAADAuthority networkUrlWithContext:]
  0x000000768e4 -[MSIDAADAuthority cacheUrlWithContext:]
  0x000000769a0 -[MSIDAADAuthority cacheEnvironmentWithContext:]
  0x000000769e4 -[MSIDAADAuthority legacyAccessTokenLookupAuthorities]
  0x00000076a7c -[MSIDAADAuthority defaultCacheEnvironmentAliases]
  0x00000076af0 -[MSIDAADAuthority universalAuthorityURL]
  0x00000076bc4 -[MSIDAADAuthority legacyRefreshTokenLookupAliases]
  0x00000076fd4 -[MSIDAADAuthority enrollmentIdForHomeAccountId:legacyUserId:context:error:]
  0x0000007708c -[MSIDAADAuthority telemetryAuthorityType]
  0x0000007709c -[MSIDAADAuthority supportsBrokeredAuthentication]
  0x000000770a4 -[MSIDAADAuthority supportsMAMScenarios]
  0x000000770ac -[MSIDAADAuthority checkTokenEndpointForRTRefresh:]
  0x00000077164 -[MSIDAADAuthority copyWithZone:]
  0x000000772b8 -[MSIDAADAuthority resolver]
  0x000000775cc -[MSIDAADAuthority authorityWithUpdatedCloudHostInstanceName:error:]
  0x00000077680 -[MSIDAADAuthority tenant]
  0x00000077690 -[MSIDAADAuthority authorityCache]
  0x000000776a0 -[MSIDAADAuthority setAuthorityCache:]


0x0000017f0e8 MSIDInteractiveTokenRequestParameters : MSIDInteractiveRequestParameters
 @property  long long uiBehaviorType
 @property  NSString *loginHint
 @property  NSString *extraScopesToConsent
 @property  long long promptType
 @property  BOOL shouldValidateResultAccount
 @property  NSDictionary *extraAuthorizeURLQueryParameters
 @property  BOOL enablePkce
 @property  MSIDBrokerInvocationOptions *brokerInvocationOptions

  // instance methods
  0x000000776f4 -[MSIDInteractiveTokenRequestParameters initWithAuthority:authScheme:redirectUri:clientId:scopes:oidcScopes:extraScopesToConsent:correlationId:telemetryApiId:brokerOptions:requestType:intuneAppIdentifier:error:]
  0x00000077848 -[MSIDInteractiveTokenRequestParameters setLoginHint:]
  0x000000778b4 -[MSIDInteractiveTokenRequestParameters allAuthorizeRequestScopes]
  0x00000077958 -[MSIDInteractiveTokenRequestParameters allAuthorizeRequestExtraParameters]
  0x00000077960 -[MSIDInteractiveTokenRequestParameters allAuthorizeRequestExtraParametersWithMetadata:]
  0x00000077abc -[MSIDInteractiveTokenRequestParameters validateParametersWithError:]
  0x00000077bdc -[MSIDInteractiveTokenRequestParameters updateAppRequestMetadata:]
  0x00000077d20 -[MSIDInteractiveTokenRequestParameters uiBehaviorType]
  0x00000077d30 -[MSIDInteractiveTokenRequestParameters setUiBehaviorType:]
  0x00000077d40 -[MSIDInteractiveTokenRequestParameters loginHint]
  0x00000077d50 -[MSIDInteractiveTokenRequestParameters extraScopesToConsent]
  0x00000077d60 -[MSIDInteractiveTokenRequestParameters setExtraScopesToConsent:]
  0x00000077d74 -[MSIDInteractiveTokenRequestParameters promptType]
  0x00000077d84 -[MSIDInteractiveTokenRequestParameters setPromptType:]
  0x00000077d94 -[MSIDInteractiveTokenRequestParameters shouldValidateResultAccount]
  0x00000077da4 -[MSIDInteractiveTokenRequestParameters setShouldValidateResultAccount:]
  0x00000077db4 -[MSIDInteractiveTokenRequestParameters extraAuthorizeURLQueryParameters]
  0x00000077dc4 -[MSIDInteractiveTokenRequestParameters setExtraAuthorizeURLQueryParameters:]
  0x00000077dd8 -[MSIDInteractiveTokenRequestParameters enablePkce]
  0x00000077de8 -[MSIDInteractiveTokenRequestParameters setEnablePkce:]
  0x00000077df8 -[MSIDInteractiveTokenRequestParameters brokerInvocationOptions]
  0x00000077e08 -[MSIDInteractiveTokenRequestParameters setBrokerInvocationOptions:]


0x0000017f160 MSIDWebviewFactory : NSObject /usr/lib/libobjc.A.dylib
  // instance methods
  0x00000077e84 -[MSIDWebviewFactory webViewWithConfiguration:requestParameters:externalDecidePolicyForBrowserAction:context:]
  0x00000077f9c -[MSIDWebviewFactory embeddedWebviewFromConfiguration:customWebview:externalDecidePolicyForBrowserAction:context:]
  0x00000078164 -[MSIDWebviewFactory systemWebviewFromConfiguration:useAuthenticationSession:allowSafariViewController:context:]
  0x000000783b8 -[MSIDWebviewFactory authorizationParametersFromRequestParameters:pkce:requestState:]
  0x0000007875c -[MSIDWebviewFactory logoutParametersFromRequestParameters:requestState:]
  0x00000078888 -[MSIDWebviewFactory metadataFromRequestParameters:]
  0x00000078890 -[MSIDWebviewFactory oAuthResponseWithURL:requestState:ignoreInvalidState:context:error:]
  0x000000789b8 -[MSIDWebviewFactory generateStateValue]
  0x00000078a64 -[MSIDWebviewFactory getFinalRedirectUri]
  0x00000078b20 -[MSIDWebviewFactory authorizeWebRequestConfigurationWithRequestParameters:]
  0x00000078d7c -[MSIDWebviewFactory logoutWebRequestConfigurationWithRequestParameters:]
  0x00000078f50 -[MSIDWebviewFactory startURLWithEndpoint:authority:query:context:]


0x0000017f1b0 MSIDAADTenant : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSString *rawTenant
 @property  long long type

  // instance methods
  0x00000079084 -[MSIDAADTenant initWithRawTenant:context:error:]
  0x0000007922c -[MSIDAADTenant copyWithZone:]
  0x00000079290 -[MSIDAADTenant rawTenant]
  0x00000079298 -[MSIDAADTenant type]


0x0000017f1d8 MSIDHttpRequest : NSObject /usr/lib/libobjc.A.dylib <MSIDHttpRequestProtocol>
 @property  MSIDURLSessionManager *sessionManager
 @property  NSDictionary *parameters
 @property  NSDictionary *headers
 @property  NSURLRequest *urlRequest
 @property  <MSIDRequestSerialization> *requestSerializer
 @property  <MSIDResponseSerialization> *responseSerializer
 @property  <MSIDResponseSerialization> *errorResponseSerializer
 @property  <MSIDHttpRequestTelemetryHandling> *telemetry
 @property  <MSIDHttpRequestServerTelemetryHandling> *serverTelemetry
 @property  <MSIDHttpRequestErrorHandling> *errorHandler
 @property  <MSIDRequestContext> *context
 @property  MSIDExternalSSOContext *externalSSOContext
 @property  long long retryCounter
 @property  double retryInterval
 @property  double requestTimeoutInterval
 @property  NSDictionary *experimentBag
 @property  NSURLCache *cache
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000007a19c +[MSIDHttpRequest retryCountSetting]
  0x0000007a1a8 +[MSIDHttpRequest setRetryCountSetting:]
  0x0000007a1b4 +[MSIDHttpRequest setRetryIntervalSetting:]
  0x0000007a1c0 +[MSIDHttpRequest retryIntervalSetting]
  0x0000007a1cc +[MSIDHttpRequest setRequestTimeoutInterval:]
  0x0000007a1d8 +[MSIDHttpRequest requestTimeoutInterval]
  0x0000007a1e4 +[MSIDHttpRequest setExperimentBagSetting:]
  0x0000007a1f4 +[MSIDHttpRequest experimentBagSetting]

  // instance methods
  0x000000792ac -[MSIDHttpRequest init]
  0x00000079438 -[MSIDHttpRequest sendWithBlock:]
  0x0000007a200 -[MSIDHttpRequest cachedResponse]
  0x0000007a274 -[MSIDHttpRequest setCachedResponse:forRequest:]
  0x0000007a2e8 -[MSIDHttpRequest sessionManager]
  0x0000007a2f0 -[MSIDHttpRequest setSessionManager:]
  0x0000007a2fc -[MSIDHttpRequest parameters]
  0x0000007a304 -[MSIDHttpRequest setParameters:]
  0x0000007a310 -[MSIDHttpRequest headers]
  0x0000007a318 -[MSIDHttpRequest setHeaders:]
  0x0000007a324 -[MSIDHttpRequest urlRequest]
  0x0000007a32c -[MSIDHttpRequest setUrlRequest:]
  0x0000007a338 -[MSIDHttpRequest requestSerializer]
  0x0000007a340 -[MSIDHttpRequest setRequestSerializer:]
  0x0000007a34c -[MSIDHttpRequest responseSerializer]
  0x0000007a354 -[MSIDHttpRequest setResponseSerializer:]
  0x0000007a360 -[MSIDHttpRequest errorResponseSerializer]
  0x0000007a368 -[MSIDHttpRequest setErrorResponseSerializer:]
  0x0000007a374 -[MSIDHttpRequest telemetry]
  0x0000007a37c -[MSIDHttpRequest setTelemetry:]
  0x0000007a388 -[MSIDHttpRequest serverTelemetry]
  0x0000007a390 -[MSIDHttpRequest setServerTelemetry:]
  0x0000007a39c -[MSIDHttpRequest errorHandler]
  0x0000007a3a4 -[MSIDHttpRequest setErrorHandler:]
  0x0000007a3b0 -[MSIDHttpRequest context]
  0x0000007a3b8 -[MSIDHttpRequest setContext:]
  0x0000007a3c4 -[MSIDHttpRequest externalSSOContext]
  0x0000007a3cc -[MSIDHttpRequest setExternalSSOContext:]
  0x0000007a3d8 -[MSIDHttpRequest retryCounter]
  0x0000007a3e0 -[MSIDHttpRequest setRetryCounter:]
  0x0000007a3e8 -[MSIDHttpRequest retryInterval]
  0x0000007a3f0 -[MSIDHttpRequest setRetryInterval:]
  0x0000007a3f8 -[MSIDHttpRequest requestTimeoutInterval]
  0x0000007a400 -[MSIDHttpRequest setRequestTimeoutInterval:]
  0x0000007a408 -[MSIDHttpRequest experimentBag]
  0x0000007a410 -[MSIDHttpRequest setExperimentBag:]
  0x0000007a41c -[MSIDHttpRequest cache]
  0x0000007a424 -[MSIDHttpRequest setCache:]


0x0000017f228 MSIDRequestParameters : NSObject /usr/lib/libobjc.A.dylib <NSCopying, MSIDRequestContext>
 @property  MSIDAuthority *authority
 @property  MSIDAuthenticationScheme *authScheme
 @property  MSIDAuthority *providedAuthority
 @property  MSIDAuthority *cloudAuthority
 @property  NSString *redirectUri
 @property  NSString *clientId
 @property  NSString *target
 @property  NSString *oidcScope
 @property  MSIDAccountIdentifier *accountIdentifier
 @property  BOOL validateAuthority
 @property  NSString *nonce
 @property  NSString *clientSku
 @property  BOOL skipValidateResultAccount
 @property  NSDictionary *extraTokenRequestParameters
 @property  NSDictionary *extraURLQueryParameters
 @property  unsigned long tokenExpirationBuffer
 @property  BOOL extendedLifetimeEnabled
 @property  BOOL instanceAware
 @property  BOOL allowUsingLocalCachedRtWhenSsoExtFailed
 @property  BOOL clientBrokerKeyCapabilityNotSupported
 @property  NSString *intuneApplicationIdentifier
 @property  long long requestType
 @property  MSIDCurrentRequestTelemetry *currentRequestTelemetry
 @property  NSString *nestedAuthBrokerClientId
 @property  NSString *nestedAuthBrokerRedirectUri
 @property  NSUUID *correlationId
 @property  NSString *logComponent
 @property  NSString *telemetryRequestId
 @property  NSDictionary *appRequestMetadata
 @property  NSString *telemetryApiId
 @property  MSIDClaimsRequest *claimsRequest
 @property  NSArray *clientCapabilities
 @property  MSIDConfiguration *msidConfiguration
 @property  NSString *keychainAccessGroup
 @property  MSIDExternalSSOContext *ssoContext

  // instance methods
  0x000000a8f6c -[MSIDRequestParameters shouldUseBroker]
  0x0000007a4f0 -[MSIDRequestParameters init]
  0x0000007a56c -[MSIDRequestParameters initWithAuthority:authScheme:redirectUri:clientId:scopes:oidcScopes:correlationId:telemetryApiId:intuneAppIdentifier:requestType:error:]
  0x0000007a8d8 -[MSIDRequestParameters initDefaultSettings]
  0x0000007aaf8 -[MSIDRequestParameters setAccountIdentifier:]
  0x0000007ab5c -[MSIDRequestParameters tokenEndpoint]
  0x0000007ae10 -[MSIDRequestParameters setCloudAuthorityWithCloudHostName:]
  0x0000007afa4 -[MSIDRequestParameters setAuthority:]
  0x0000007afd0 -[MSIDRequestParameters setCloudAuthority:]
  0x0000007affc -[MSIDRequestParameters setClientId:]
  0x0000007b028 -[MSIDRequestParameters setRedirectUri:]
  0x0000007b054 -[MSIDRequestParameters setNestedAuthBrokerClientId:]
  0x0000007b080 -[MSIDRequestParameters setNestedAuthBrokerRedirectUri:]
  0x0000007b0ac -[MSIDRequestParameters setTarget:]
  0x0000007b0d8 -[MSIDRequestParameters allTokenRequestScopes]
  0x0000007b198 -[MSIDRequestParameters setAuthScheme:]
  0x0000007b1c4 -[MSIDRequestParameters updateMSIDConfiguration]
  0x0000007b388 -[MSIDRequestParameters msidConfiguration]
  0x0000007b3b8 -[MSIDRequestParameters updateAppRequestMetadata:]
  0x0000007b58c -[MSIDRequestParameters isNestedAuthProtocol]
  0x0000007b61c -[MSIDRequestParameters reverseNestedAuthParametersIfNeeded]
  0x0000007b7a8 -[MSIDRequestParameters validateParametersWithError:]
  0x0000007b8dc -[MSIDRequestParameters copyWithZone:]
  0x0000007bbd0 -[MSIDRequestParameters ccsHintHeaderWithUpn:]
  0x0000007bc44 -[MSIDRequestParameters authority]
  0x0000007bc4c -[MSIDRequestParameters authScheme]
  0x0000007bc54 -[MSIDRequestParameters providedAuthority]
  0x0000007bc5c -[MSIDRequestParameters setProvidedAuthority:]
  0x0000007bc68 -[MSIDRequestParameters cloudAuthority]
  0x0000007bc70 -[MSIDRequestParameters redirectUri]
  0x0000007bc78 -[MSIDRequestParameters clientId]
  0x0000007bc80 -[MSIDRequestParameters target]
  0x0000007bc88 -[MSIDRequestParameters oidcScope]
  0x0000007bc90 -[MSIDRequestParameters setOidcScope:]
  0x0000007bc9c -[MSIDRequestParameters accountIdentifier]
  0x0000007bca4 -[MSIDRequestParameters validateAuthority]
  0x0000007bcac -[MSIDRequestParameters setValidateAuthority:]
  0x0000007bcb4 -[MSIDRequestParameters nonce]
  0x0000007bcbc -[MSIDRequestParameters setNonce:]
  0x0000007bcc8 -[MSIDRequestParameters clientSku]
  0x0000007bcd0 -[MSIDRequestParameters setClientSku:]
  0x0000007bcdc -[MSIDRequestParameters skipValidateResultAccount]
  0x0000007bce4 -[MSIDRequestParameters setSkipValidateResultAccount:]
  0x0000007bcec -[MSIDRequestParameters extraTokenRequestParameters]
  0x0000007bcf4 -[MSIDRequestParameters setExtraTokenRequestParameters:]
  0x0000007bd00 -[MSIDRequestParameters extraURLQueryParameters]
  0x0000007bd08 -[MSIDRequestParameters setExtraURLQueryParameters:]
  0x0000007bd14 -[MSIDRequestParameters tokenExpirationBuffer]
  0x0000007bd1c -[MSIDRequestParameters setTokenExpirationBuffer:]
  0x0000007bd24 -[MSIDRequestParameters extendedLifetimeEnabled]
  0x0000007bd2c -[MSIDRequestParameters setExtendedLifetimeEnabled:]
  0x0000007bd34 -[MSIDRequestParameters instanceAware]
  0x0000007bd3c -[MSIDRequestParameters setInstanceAware:]
  0x0000007bd44 -[MSIDRequestParameters allowUsingLocalCachedRtWhenSsoExtFailed]
  0x0000007bd4c -[MSIDRequestParameters setAllowUsingLocalCachedRtWhenSsoExtFailed:]
  0x0000007bd54 -[MSIDRequestParameters clientBrokerKeyCapabilityNotSupported]
  0x0000007bd5c -[MSIDRequestParameters setClientBrokerKeyCapabilityNotSupported:]
  0x0000007bd64 -[MSIDRequestParameters intuneApplicationIdentifier]
  0x0000007bd6c -[MSIDRequestParameters setIntuneApplicationIdentifier:]
  0x0000007bd78 -[MSIDRequestParameters requestType]
  0x0000007bd80 -[MSIDRequestParameters setRequestType:]
  0x0000007bd88 -[MSIDRequestParameters currentRequestTelemetry]
  0x0000007bd90 -[MSIDRequestParameters setCurrentRequestTelemetry:]
  0x0000007bd9c -[MSIDRequestParameters nestedAuthBrokerClientId]
  0x0000007bda4 -[MSIDRequestParameters nestedAuthBrokerRedirectUri]
  0x0000007bdac -[MSIDRequestParameters correlationId]
  0x0000007bdb4 -[MSIDRequestParameters setCorrelationId:]
  0x0000007bdc0 -[MSIDRequestParameters logComponent]
  0x0000007bdc8 -[MSIDRequestParameters setLogComponent:]
  0x0000007bdd4 -[MSIDRequestParameters telemetryRequestId]
  0x0000007bddc -[MSIDRequestParameters setTelemetryRequestId:]
  0x0000007bde8 -[MSIDRequestParameters appRequestMetadata]
  0x0000007bdf0 -[MSIDRequestParameters setAppRequestMetadata:]
  0x0000007bdfc -[MSIDRequestParameters telemetryApiId]
  0x0000007be04 -[MSIDRequestParameters setTelemetryApiId:]
  0x0000007be10 -[MSIDRequestParameters claimsRequest]
  0x0000007be18 -[MSIDRequestParameters setClaimsRequest:]
  0x0000007be24 -[MSIDRequestParameters clientCapabilities]
  0x0000007be2c -[MSIDRequestParameters setClientCapabilities:]
  0x0000007be38 -[MSIDRequestParameters setMsidConfiguration:]
  0x0000007be44 -[MSIDRequestParameters keychainAccessGroup]
  0x0000007be4c -[MSIDRequestParameters setKeychainAccessGroup:]
  0x0000007be58 -[MSIDRequestParameters ssoContext]
  0x0000007be60 -[MSIDRequestParameters setSsoContext:]


0x0000017f278 MSIDMacKeychainTokenCache : MSIDMacACLKeychainAccessor <MSIDExtendedTokenCacheDataSource>
 @property  NSString *keychainGroup
 @property  NSDictionary *defaultCacheQuery
 @property  NSString *appIdentifier
 @property  MSIDMacCredentialStorageItem *appStorageItem
 @property  MSIDMacCredentialStorageItem *sharedStorageItem
 @property  MSIDCacheItemJsonSerializer *serializer
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000007cb0c +[MSIDMacKeychainTokenCache defaultKeychainGroup]
  0x0000007cb18 +[MSIDMacKeychainTokenCache setDefaultKeychainGroup:]
  0x0000007cd1c +[MSIDMacKeychainTokenCache defaultKeychainCache]

  // instance methods
  0x0000007cd88 -[MSIDMacKeychainTokenCache shouldUseLoginKeychain]
  0x0000007cdd4 -[MSIDMacKeychainTokenCache init]
  0x0000007cde8 -[MSIDMacKeychainTokenCache initWithGroup:trustedApplications:error:]
  0x0000007d440 -[MSIDMacKeychainTokenCache saveAccount:key:serializer:context:error:]
  0x0000007d560 -[MSIDMacKeychainTokenCache accountWithKey:serializer:context:error:]
  0x0000007d62c -[MSIDMacKeychainTokenCache accountsWithKey:serializer:context:error:]
  0x0000007d6ec -[MSIDMacKeychainTokenCache removeAccountsWithKey:context:error:]
  0x0000007d700 -[MSIDMacKeychainTokenCache jsonObjectsWithKey:serializer:context:error:]
  0x0000007d720 -[MSIDMacKeychainTokenCache saveJsonObject:serializer:key:context:error:]
  0x0000007d740 -[MSIDMacKeychainTokenCache saveToken:key:serializer:context:error:]
  0x0000007d860 -[MSIDMacKeychainTokenCache tokenWithKey:serializer:context:error:]
  0x0000007d9b0 -[MSIDMacKeychainTokenCache tokensWithKey:serializer:context:error:]
  0x0000007dc20 -[MSIDMacKeychainTokenCache filterTokenItemsFromKeychainItems:serializer:context:]
  0x0000007dd78 -[MSIDMacKeychainTokenCache getAllItemsWithKey:context:serializer:error:]
  0x0000007deb8 -[MSIDMacKeychainTokenCache removeAllMatchingTokens:context:serializer:isShared:error:]
  0x0000007dfdc -[MSIDMacKeychainTokenCache removeTokensWithKey:context:error:]
  0x0000007e220 -[MSIDMacKeychainTokenCache syncStorageItem:serializer:context:error:]
  0x0000007e29c -[MSIDMacKeychainTokenCache saveStorageItem:isShared:serializer:context:error:]
  0x0000007e56c -[MSIDMacKeychainTokenCache removeStorageItem:context:error:]
  0x0000007e64c -[MSIDMacKeychainTokenCache queryStorageItem:serializer:context:error:]
  0x0000007ea28 -[MSIDMacKeychainTokenCache removeItemsWithKey:context:inBucket:error:]
  0x0000007ec64 -[MSIDMacKeychainTokenCache primaryAttributesForItem:context:error:]
  0x0000007edd4 -[MSIDMacKeychainTokenCache saveAppMetadata:key:serializer:context:error:]
  0x0000007eee4 -[MSIDMacKeychainTokenCache appMetadataEntriesWithKey:serializer:context:error:]
  0x0000007f018 -[MSIDMacKeychainTokenCache removeMetadataItemsWithKey:context:error:]
  0x0000007f02c -[MSIDMacKeychainTokenCache saveAccountMetadata:key:serializer:context:error:]
  0x0000007f130 -[MSIDMacKeychainTokenCache accountMetadataWithKey:serializer:context:error:]
  0x0000007f2e4 -[MSIDMacKeychainTokenCache accountsMetadataWithKey:serializer:context:error:]
  0x0000007f418 -[MSIDMacKeychainTokenCache removeAccountMetadataForKey:context:error:]
  0x0000007f42c -[MSIDMacKeychainTokenCache saveWipeInfoWithContext:error:]
  0x0000007f450 -[MSIDMacKeychainTokenCache wipeInfo:error:]
  0x0000007f474 -[MSIDMacKeychainTokenCache clearWithContext:error:]
  0x0000007f538 -[MSIDMacKeychainTokenCache createUnimplementedError:context:]
  0x0000007f55c -[MSIDMacKeychainTokenCache keychainGroupLoggingName]
  0x0000007f5f8 -[MSIDMacKeychainTokenCache updateLastModifiedForAccount:context:]
  0x0000007f6d4 -[MSIDMacKeychainTokenCache updateLastModifiedForCredential:context:]
  0x0000007f7b0 -[MSIDMacKeychainTokenCache checkIfRecentlyModifiedItem:time:app:]
  0x0000007f904 -[MSIDMacKeychainTokenCache keychainGroup]
  0x0000007f914 -[MSIDMacKeychainTokenCache setKeychainGroup:]
  0x0000007f920 -[MSIDMacKeychainTokenCache defaultCacheQuery]
  0x0000007f930 -[MSIDMacKeychainTokenCache setDefaultCacheQuery:]
  0x0000007f93c -[MSIDMacKeychainTokenCache appIdentifier]
  0x0000007f94c -[MSIDMacKeychainTokenCache setAppIdentifier:]
  0x0000007f958 -[MSIDMacKeychainTokenCache appStorageItem]
  0x0000007f968 -[MSIDMacKeychainTokenCache setAppStorageItem:]
  0x0000007f974 -[MSIDMacKeychainTokenCache sharedStorageItem]
  0x0000007f984 -[MSIDMacKeychainTokenCache setSharedStorageItem:]
  0x0000007f990 -[MSIDMacKeychainTokenCache serializer]
  0x0000007f9a0 -[MSIDMacKeychainTokenCache setSerializer:]


0x0000017f2c8 MSIDAADJsonResponsePreprocessor : MSIDJsonResponsePreprocessor
  // instance methods
  0x0000007fa3c -[MSIDAADJsonResponsePreprocessor responseObjectForResponse:data:context:error:]


0x0000017f318 MSIDOIDCSignoutRequest : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDInteractiveRequestParameters *requestParameters
 @property  MSIDOauth2Factory *oauthFactory

  // instance methods
  0x0000007fe40 -[MSIDOIDCSignoutRequest initWithRequestParameters:oauthFactory:]
  0x0000007ff10 -[MSIDOIDCSignoutRequest executeRequestWithCompletion:]
  0x000000802cc -[MSIDOIDCSignoutRequest executeRequestWithCompletionImpl:]
  0x000000807b4 -[MSIDOIDCSignoutRequest requestParameters]
  0x000000807bc -[MSIDOIDCSignoutRequest setRequestParameters:]
  0x000000807c8 -[MSIDOIDCSignoutRequest oauthFactory]
  0x000000807d0 -[MSIDOIDCSignoutRequest setOauthFactory:]


0x0000017f368 MSIDCredentialInfo : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable>
 @property  NSString *name
 @property  NSString *value
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000008080c -[MSIDCredentialInfo initWithJSONDictionary:error:]
  0x00000080ab8 -[MSIDCredentialInfo jsonDictionary]
  0x00000080bd0 -[MSIDCredentialInfo name]
  0x00000080bd8 -[MSIDCredentialInfo setName:]
  0x00000080be4 -[MSIDCredentialInfo value]
  0x00000080bec -[MSIDCredentialInfo setValue:]


0x0000017f3b8 MSIDBrokerOperationTokenRequest : MSIDBrokerOperationRequest
 @property  MSIDConfiguration *configuration
 @property  long long providerType
 @property  NSString *oidcScope
 @property  NSDictionary *extraQueryParameters
 @property  BOOL instanceAware
 @property  NSDictionary *enrollmentIds
 @property  NSDictionary *mamResources
 @property  NSArray *clientCapabilities
 @property  MSIDClaimsRequest *claimsRequest
 @property  NSDate *requestSentDate
 @property  NSString *nonce
 @property  NSString *accountHomeTenantId
 @property  NSString *clientSku
 @property  BOOL skipValidateResultAccount

  // class methods
  0x00000080c28 +[MSIDBrokerOperationTokenRequest fillRequest:withParameters:providerType:enrollmentIds:mamResources:requestSentDate:]

  // instance methods
  0x00000080eb0 -[MSIDBrokerOperationTokenRequest initWithJSONDictionary:error:]
  0x00000081390 -[MSIDBrokerOperationTokenRequest jsonDictionary]
  0x000000818f8 -[MSIDBrokerOperationTokenRequest configuration]
  0x00000081908 -[MSIDBrokerOperationTokenRequest setConfiguration:]
  0x0000008191c -[MSIDBrokerOperationTokenRequest providerType]
  0x0000008192c -[MSIDBrokerOperationTokenRequest setProviderType:]
  0x0000008193c -[MSIDBrokerOperationTokenRequest oidcScope]
  0x0000008194c -[MSIDBrokerOperationTokenRequest setOidcScope:]
  0x00000081960 -[MSIDBrokerOperationTokenRequest extraQueryParameters]
  0x00000081970 -[MSIDBrokerOperationTokenRequest setExtraQueryParameters:]
  0x00000081984 -[MSIDBrokerOperationTokenRequest instanceAware]
  0x00000081994 -[MSIDBrokerOperationTokenRequest setInstanceAware:]
  0x000000819a4 -[MSIDBrokerOperationTokenRequest enrollmentIds]
  0x000000819b4 -[MSIDBrokerOperationTokenRequest setEnrollmentIds:]
  0x000000819c8 -[MSIDBrokerOperationTokenRequest mamResources]
  0x000000819d8 -[MSIDBrokerOperationTokenRequest setMamResources:]
  0x000000819ec -[MSIDBrokerOperationTokenRequest clientCapabilities]
  0x000000819fc -[MSIDBrokerOperationTokenRequest setClientCapabilities:]
  0x00000081a10 -[MSIDBrokerOperationTokenRequest claimsRequest]
  0x00000081a20 -[MSIDBrokerOperationTokenRequest setClaimsRequest:]
  0x00000081a34 -[MSIDBrokerOperationTokenRequest requestSentDate]
  0x00000081a44 -[MSIDBrokerOperationTokenRequest setRequestSentDate:]
  0x00000081a58 -[MSIDBrokerOperationTokenRequest nonce]
  0x00000081a68 -[MSIDBrokerOperationTokenRequest setNonce:]
  0x00000081a7c -[MSIDBrokerOperationTokenRequest accountHomeTenantId]
  0x00000081a8c -[MSIDBrokerOperationTokenRequest setAccountHomeTenantId:]
  0x00000081aa0 -[MSIDBrokerOperationTokenRequest clientSku]
  0x00000081ab0 -[MSIDBrokerOperationTokenRequest setClientSku:]
  0x00000081ac4 -[MSIDBrokerOperationTokenRequest skipValidateResultAccount]
  0x00000081ad4 -[MSIDBrokerOperationTokenRequest setSkipValidateResultAccount:]


0x0000017f430 MSIDTokenResponseValidator : NSObject /usr/lib/libobjc.A.dylib
  // instance methods
  0x00000081bd8 -[MSIDTokenResponseValidator validateTokenResponse:oauthFactory:configuration:requestAccount:correlationID:error:]
  0x00000081e1c -[MSIDTokenResponseValidator createTokenResultFromResponse:oauthFactory:configuration:requestAccount:correlationID:error:]
  0x00000082178 -[MSIDTokenResponseValidator validateTokenResult:configuration:oidcScope:correlationID:error:]
  0x00000082180 -[MSIDTokenResponseValidator validateAccount:tokenResult:correlationID:error:]
  0x00000082188 -[MSIDTokenResponseValidator validateAndSaveBrokerResponse:oidcScope:requestAuthority:instanceAware:oauthFactory:tokenCache:accountMetadataCache:correlationID:saveSSOStateOnly:authScheme:error:]
  0x00000082a30 -[MSIDTokenResponseValidator validateAndSaveTokenResponse:oauthFactory:tokenCache:accountMetadataCache:requestParameters:saveSSOStateOnly:error:]
  0x00000082eac -[MSIDTokenResponseValidator saveTokenResponseToCache:configuration:oauthFactory:tokenCache:saveSSOStateOnly:context:error:]
  0x000000831d4 -[MSIDTokenResponseValidator updateAccountMetadataForHomeAccountId:clientId:instanceAware:state:requestAuthority:resultingAuthority:accountMetadataCache:context:]


0x0000017f480 MSIDLegacyBrokerTokenRequest : MSIDBrokerTokenRequest
  // instance methods
  0x000000834cc -[MSIDLegacyBrokerTokenRequest protocolPayloadContentsWithError:]
  0x00000083860 -[MSIDLegacyBrokerTokenRequest protocolResumeDictionaryContents]


0x0000017f4a8 MSIDAssymetricKeyLoginKeychainGenerator : MSIDAssymetricKeyKeychainGenerator
 @property  ^{__SecAccess=} accessRef

  // instance methods
  0x00000083948 -[MSIDAssymetricKeyLoginKeychainGenerator initWithKeychainGroup:accessRef:error:]
  0x000000839b8 -[MSIDAssymetricKeyLoginKeychainGenerator additionalPlatformKeychainAttributes]
  0x00000083a4c -[MSIDAssymetricKeyLoginKeychainGenerator accessRef]
  0x00000083a5c -[MSIDAssymetricKeyLoginKeychainGenerator setAccessRef:]


0x0000017f4f8 MSIDBrokerOperationGetDeviceInfoRequest : MSIDBrokerOperationRequest
  // class methods
  0x00000083c90 +[MSIDBrokerOperationGetDeviceInfoRequest load]
  0x00000083ce0 +[MSIDBrokerOperationGetDeviceInfoRequest operation]

  // instance methods
  0x00000083cf0 -[MSIDBrokerOperationGetDeviceInfoRequest initWithJSONDictionary:error:]
  0x00000083d50 -[MSIDBrokerOperationGetDeviceInfoRequest jsonDictionary]


0x0000017f570 MSIDAadAuthorityCacheRecord : MSIDAuthorityCacheRecord
 @property  NSString *networkHost
 @property  NSString *cacheHost
 @property  NSArray *aliases

  // instance methods
  0x00000083dd8 -[MSIDAadAuthorityCacheRecord networkHost]
  0x00000083de8 -[MSIDAadAuthorityCacheRecord setNetworkHost:]
  0x00000083dfc -[MSIDAadAuthorityCacheRecord cacheHost]
  0x00000083e0c -[MSIDAadAuthorityCacheRecord setCacheHost:]
  0x00000083e20 -[MSIDAadAuthorityCacheRecord aliases]
  0x00000083e30 -[MSIDAadAuthorityCacheRecord setAliases:]


0x0000017f5c0 MSIDB2CTokenResponse : MSIDAADV2TokenResponse
  // class methods
  0x00000083e98 +[MSIDB2CTokenResponse load]
  0x00000083f70 +[MSIDB2CTokenResponse providerType]

  // instance methods
  0x00000083f14 -[MSIDB2CTokenResponse tokenClaimsFromRawIdToken:error:]


0x0000017f5e8 MSIDThrottlingService : NSObject /usr/lib/libobjc.A.dylib
 @property  <MSIDRequestContext> *context
 @property  NSString *accessGroup
 @property  <MSIDExtendedTokenCacheDataSource> *datasource

  // class methods
  0x00000084370 +[MSIDThrottlingService updateLastRefreshTimeDatasource:context:error:]
  0x000000843f8 +[MSIDThrottlingService isThrottlingEnabled]

  // instance methods
  0x00000083f78 -[MSIDThrottlingService initWithDataSource:context:]
  0x00000084000 -[MSIDThrottlingService shouldThrottleRequest:resultBlock:]
  0x000000841e4 -[MSIDThrottlingService updateThrottlingService:tokenRequest:]
  0x00000084400 -[MSIDThrottlingService context]
  0x00000084408 -[MSIDThrottlingService accessGroup]
  0x00000084410 -[MSIDThrottlingService datasource]


0x0000017f638 MSIDKeyedArchiverSerializer : NSObject /usr/lib/libobjc.A.dylib <MSIDCacheItemSerializing>
 @property  NSMutableDictionary *defaultEncodeClassMap
 @property  NSMutableDictionary *defaultDecodeClassMap
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000084454 -[MSIDKeyedArchiverSerializer init]
  0x000000845e4 -[MSIDKeyedArchiverSerializer serialize:]
  0x000000847e0 -[MSIDKeyedArchiverSerializer deserialize:className:]
  0x00000084a48 -[MSIDKeyedArchiverSerializer serializeCredentialCacheItem:]
  0x00000084b40 -[MSIDKeyedArchiverSerializer deserializeCredentialCacheItem:]
  0x00000084bdc -[MSIDKeyedArchiverSerializer serializeCredentialStorageItem:]
  0x00000084c78 -[MSIDKeyedArchiverSerializer deserializeCredentialStorageItem:]
  0x00000084d14 -[MSIDKeyedArchiverSerializer addEncodeClassMapping:]
  0x00000084d24 -[MSIDKeyedArchiverSerializer addDecodeClassMapping:]
  0x00000084d34 -[MSIDKeyedArchiverSerializer defaultEncodeClassMap]
  0x00000084d3c -[MSIDKeyedArchiverSerializer setDefaultEncodeClassMap:]
  0x00000084d48 -[MSIDKeyedArchiverSerializer defaultDecodeClassMap]
  0x00000084d50 -[MSIDKeyedArchiverSerializer setDefaultDecodeClassMap:]


0x0000017f688 MSIDWorkplaceJoinChallenge : NSObject /usr/lib/libobjc.A.dylib
 @property  NSArray *certAuthorities

  // instance methods
  0x00000084d8c -[MSIDWorkplaceJoinChallenge initWithURLChallenge:]
  0x00000084e58 -[MSIDWorkplaceJoinChallenge certAuthorities]


0x0000017f6d8 MSIDThrottlingMetaDataCache : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000084e6c +[MSIDThrottlingMetaDataCache getLastRefreshTimeWithDatasource:context:error:]
  0x00000084ee4 +[MSIDThrottlingMetaDataCache updateLastRefreshTimeWithDatasource:context:error:]
  0x00000084ff8 +[MSIDThrottlingMetaDataCache getThrottlingMetadataWithDatasource:context:error:]
  0x00000085138 +[MSIDThrottlingMetaDataCache throttlingMetadataCacheKey]


0x0000017f728 MSIDAADAuthorizationCodeRequest : MSIDHttpRequest
  // instance methods
  0x000000851c8 -[MSIDAADAuthorizationCodeRequest initWithEndpoint:clientId:redirectUri:scope:loginHint:ssoContext:context:]


0x0000017f778 MSIDBrowserNativeMessageGetCookiesRequest : MSIDBrowserNativeMessageRequest
 @property  NSString *uri

  // class methods
  0x000000854a8 +[MSIDBrowserNativeMessageGetCookiesRequest load]
  0x000000854f8 +[MSIDBrowserNativeMessageGetCookiesRequest operation]

  // instance methods
  0x00000085504 -[MSIDBrowserNativeMessageGetCookiesRequest initWithJSONDictionary:error:]
  0x0000008561c -[MSIDBrowserNativeMessageGetCookiesRequest jsonDictionary]
  0x000000856b4 -[MSIDBrowserNativeMessageGetCookiesRequest uri]
  0x000000856c4 -[MSIDBrowserNativeMessageGetCookiesRequest setUri:]


0x0000017f7f0 MSIDOpenIdProviderMetadata : NSObject /usr/lib/libobjc.A.dylib
 @property  NSURL *authorizationEndpoint
 @property  NSURL *tokenEndpoint
 @property  NSURL *issuer
 @property  NSURL *endSessionEndpoint

  // instance methods
  0x000000856ec -[MSIDOpenIdProviderMetadata authorizationEndpoint]
  0x000000856f4 -[MSIDOpenIdProviderMetadata setAuthorizationEndpoint:]
  0x00000085700 -[MSIDOpenIdProviderMetadata tokenEndpoint]
  0x00000085708 -[MSIDOpenIdProviderMetadata setTokenEndpoint:]
  0x00000085714 -[MSIDOpenIdProviderMetadata issuer]
  0x0000008571c -[MSIDOpenIdProviderMetadata setIssuer:]
  0x00000085728 -[MSIDOpenIdProviderMetadata endSessionEndpoint]
  0x00000085730 -[MSIDOpenIdProviderMetadata setEndSessionEndpoint:]


0x0000017f840 MSIDJWTHelper : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000085bf0 +[MSIDJWTHelper createSignedJWTforHeader:payload:signingKey:]
  0x00000085d80 +[MSIDJWTHelper sign:data:]
  0x00000085e74 +[MSIDJWTHelper JSONFromDictionary:]


0x0000017f868 MSIDLegacyTokenCacheKey : MSIDCacheKey <NSCopying, NSSecureCoding>
 @property  NSURL *authority
 @property  NSString *clientId
 @property  NSString *resource
 @property  NSString *legacyUserId
 @property  NSString *applicationIdentifier

  // class methods
  0x000000868a8 +[MSIDLegacyTokenCacheKey supportsSecureCoding]

  // instance methods
  0x000000860e8 -[MSIDLegacyTokenCacheKey getAttributeName:]
  0x0000008614c -[MSIDLegacyTokenCacheKey serviceWithAuthority:resource:clientId:appKey:]
  0x00000086400 -[MSIDLegacyTokenCacheKey initWithAccount:service:generic:type:]
  0x0000008647c -[MSIDLegacyTokenCacheKey initWithEnvironment:realm:clientId:resource:legacyUserId:]
  0x000000865f8 -[MSIDLegacyTokenCacheKey initWithAuthority:clientId:resource:legacyUserId:]
  0x00000086740 -[MSIDLegacyTokenCacheKey account]
  0x000000867b4 -[MSIDLegacyTokenCacheKey service]
  0x00000086898 -[MSIDLegacyTokenCacheKey generic]
  0x000000868b0 -[MSIDLegacyTokenCacheKey initWithCoder:]
  0x00000086b60 -[MSIDLegacyTokenCacheKey encodeWithCoder:]
  0x00000086d04 -[MSIDLegacyTokenCacheKey isEqual:]
  0x00000086d7c -[MSIDLegacyTokenCacheKey isEqualToTokenCacheKey:]
  0x00000087240 -[MSIDLegacyTokenCacheKey copyWithZone:]
  0x00000087470 -[MSIDLegacyTokenCacheKey adalAccountWithUserId:]
  0x000000874c8 -[MSIDLegacyTokenCacheKey setServiceKeyComponents]
  0x0000008766c -[MSIDLegacyTokenCacheKey authority]
  0x0000008767c -[MSIDLegacyTokenCacheKey setAuthority:]
  0x00000087690 -[MSIDLegacyTokenCacheKey clientId]
  0x000000876a0 -[MSIDLegacyTokenCacheKey setClientId:]
  0x000000876b4 -[MSIDLegacyTokenCacheKey resource]
  0x000000876c4 -[MSIDLegacyTokenCacheKey setResource:]
  0x000000876d8 -[MSIDLegacyTokenCacheKey legacyUserId]
  0x000000876e8 -[MSIDLegacyTokenCacheKey setLegacyUserId:]
  0x000000876fc -[MSIDLegacyTokenCacheKey applicationIdentifier]
  0x0000008770c -[MSIDLegacyTokenCacheKey setApplicationIdentifier:]


0x0000017f8b8 MSIDDevicePopManager : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDCacheConfig *cacheConfig
 @property  <MSIDAssymetricKeyGenerating> *keyGeneratorFactory
 @property  MSIDAssymetricKeyLookupAttributes *keyPairAttributes
 @property  MSIDAssymetricKeyPair *keyPair

  // instance methods
  0x0000008779c -[MSIDDevicePopManager initWithCacheConfig:keyPairAttributes:]
  0x000000878b8 -[MSIDDevicePopManager keyPair]
  0x00000087a40 -[MSIDDevicePopManager buildPayloadDict:host:httpMethod:nonce:path:publicKeyDict:]
  0x00000087cc0 -[MSIDDevicePopManager createSignedAccessToken:httpMethod:requestUrl:nonce:error:]
  0x00000088440 -[MSIDDevicePopManager logAndFillError:error:]
  0x00000088544 -[MSIDDevicePopManager setKeyPair:]
  0x00000088550 -[MSIDDevicePopManager cacheConfig]
  0x00000088558 -[MSIDDevicePopManager setCacheConfig:]
  0x00000088564 -[MSIDDevicePopManager keyGeneratorFactory]
  0x0000008856c -[MSIDDevicePopManager setKeyGeneratorFactory:]
  0x00000088578 -[MSIDDevicePopManager keyPairAttributes]
  0x00000088580 -[MSIDDevicePopManager setKeyPairAttributes:]


0x0000017f908 MSIDWPJKeyPairWithCert : NSObject /usr/lib/libobjc.A.dylib
 @property  ^{__SecCertificate=} certificateRef
 @property  NSData *certificateData
 @property  NSString *certificateSubject
 @property  NSString *certificateIssuer
 @property  ^{__SecKey=} privateKeyRef
 @property  long long keyChainVersion

  // instance methods
  0x000000885d4 -[MSIDWPJKeyPairWithCert initWithPrivateKey:certificate:certificateIssuer:]
  0x000000887d4 -[MSIDWPJKeyPairWithCert dealloc]
  0x00000088860 -[MSIDWPJKeyPairWithCert privateKeyRef]
  0x00000088868 -[MSIDWPJKeyPairWithCert setPrivateKeyRef:]
  0x00000088870 -[MSIDWPJKeyPairWithCert certificateRef]
  0x00000088878 -[MSIDWPJKeyPairWithCert setCertificateRef:]
  0x00000088880 -[MSIDWPJKeyPairWithCert certificateData]
  0x00000088888 -[MSIDWPJKeyPairWithCert setCertificateData:]
  0x00000088894 -[MSIDWPJKeyPairWithCert certificateSubject]
  0x0000008889c -[MSIDWPJKeyPairWithCert setCertificateSubject:]
  0x000000888a8 -[MSIDWPJKeyPairWithCert certificateIssuer]
  0x000000888b0 -[MSIDWPJKeyPairWithCert setCertificateIssuer:]
  0x000000888bc -[MSIDWPJKeyPairWithCert keyChainVersion]
  0x000000888c4 -[MSIDWPJKeyPairWithCert setKeyChainVersion:]


0x0000017f980 MSIDMainThreadUtil : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000088908 +[MSIDMainThreadUtil executeOnMainThreadIfNeeded:]


0x0000017f9d0 MSIDAADEndpointProvider : NSObject /usr/lib/libobjc.A.dylib <MSIDAADEndpointProviding>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000088964 -[MSIDAADEndpointProvider oauth2AuthorizeEndpointWithUrl:]
  0x00000088a08 -[MSIDAADEndpointProvider oauth2TokenEndpointWithUrl:]
  0x00000088aac -[MSIDAADEndpointProvider oauth2IssuerWithUrl:]
  0x00000088b6c -[MSIDAADEndpointProvider oauth2jwksEndpointWithUrl:]
  0x00000088c10 -[MSIDAADEndpointProvider drsDiscoveryEndpointWithDomain:adfsType:]
  0x00000088d08 -[MSIDAADEndpointProvider webFingerDiscoveryEndpointWithIssuer:]
  0x00000088da0 -[MSIDAADEndpointProvider openIdConfigurationEndpointWithUrl:]
  0x00000088e5c -[MSIDAADEndpointProvider aadAuthorityDiscoveryEndpointWithHost:]
  0x00000088f14 -[MSIDAADEndpointProvider aadApiVersionWithDelimiter]


0x0000017f9f8 MSIDBrokerOperationGetPasskeyAssertionResponse : MSIDBrokerNativeAppOperationResponse
 @property  MSIDPasskeyAssertion *passkeyAssertion

  // class methods
  0x00000089018 +[MSIDBrokerOperationGetPasskeyAssertionResponse load]
  0x00000089068 +[MSIDBrokerOperationGetPasskeyAssertionResponse responseType]

  // instance methods
  0x00000089078 -[MSIDBrokerOperationGetPasskeyAssertionResponse initWithJSONDictionary:error:]
  0x00000089248 -[MSIDBrokerOperationGetPasskeyAssertionResponse jsonDictionary]
  0x000000893d0 -[MSIDBrokerOperationGetPasskeyAssertionResponse passkeyAssertion]
  0x000000893e0 -[MSIDBrokerOperationGetPasskeyAssertionResponse setPasskeyAssertion:]


0x0000017fa48 MSIDBaseToken : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  long long credentialType
 @property  NSString *storageEnvironment
 @property  NSString *environment
 @property  NSString *realm
 @property  NSString *clientId
 @property  NSDictionary *additionalServerInfo
 @property  MSIDAccountIdentifier *accountIdentifier
 @property  NSString *speInfo

  // instance methods
  0x00000089408 -[MSIDBaseToken copyWithZone:]
  0x0000008950c -[MSIDBaseToken isEqual:]
  0x000000896b4 -[MSIDBaseToken isEqualToItem:]
  0x00000089a7c -[MSIDBaseToken credentialType]
  0x00000089a84 -[MSIDBaseToken supportsCredentialType:]
  0x00000089aac -[MSIDBaseToken initWithTokenCacheItem:]
  0x00000089dd8 -[MSIDBaseToken tokenCacheItem]
  0x0000008a000 -[MSIDBaseToken storageEnvironment]
  0x0000008a00c -[MSIDBaseToken setStorageEnvironment:]
  0x0000008a014 -[MSIDBaseToken environment]
  0x0000008a020 -[MSIDBaseToken setEnvironment:]
  0x0000008a028 -[MSIDBaseToken realm]
  0x0000008a034 -[MSIDBaseToken setRealm:]
  0x0000008a03c -[MSIDBaseToken clientId]
  0x0000008a048 -[MSIDBaseToken setClientId:]
  0x0000008a050 -[MSIDBaseToken additionalServerInfo]
  0x0000008a05c -[MSIDBaseToken setAdditionalServerInfo:]
  0x0000008a064 -[MSIDBaseToken accountIdentifier]
  0x0000008a070 -[MSIDBaseToken setAccountIdentifier:]
  0x0000008a078 -[MSIDBaseToken speInfo]
  0x0000008a084 -[MSIDBaseToken setSpeInfo:]


0x0000017fa98 MSIDADFSAuthority : MSIDAuthority
  // class methods
  0x0000008a0f8 +[MSIDADFSAuthority load]
  0x0000008a290 +[MSIDADFSAuthority isAuthorityFormatValid:context:error:]
  0x0000008a498 +[MSIDADFSAuthority normalizedAuthorityUrl:context:error:]

  // instance methods
  0x0000008a174 -[MSIDADFSAuthority initWithURL:context:error:]
  0x0000008a464 -[MSIDADFSAuthority telemetryAuthorityType]
  0x0000008a474 -[MSIDADFSAuthority supportsBrokeredAuthentication]
  0x0000008a47c -[MSIDADFSAuthority resolver]


0x0000017fae8 MSIDBrowserNativeMessageSignOutRequest : MSIDBrowserNativeMessageRequest
 @property  MSIDAccountIdentifier *accountId

  // class methods
  0x0000008a64c +[MSIDBrowserNativeMessageSignOutRequest load]
  0x0000008a650 +[MSIDBrowserNativeMessageSignOutRequest operation]

  // instance methods
  0x0000008a65c -[MSIDBrowserNativeMessageSignOutRequest initWithJSONDictionary:error:]
  0x0000008a794 -[MSIDBrowserNativeMessageSignOutRequest jsonDictionary]
  0x0000008a82c -[MSIDBrowserNativeMessageSignOutRequest accountId]
  0x0000008a83c -[MSIDBrowserNativeMessageSignOutRequest setAccountId:]


0x0000017fb60 MSIDAADV2TokenResponse : MSIDAADTokenResponse
  // class methods
  0x0000008a864 +[MSIDAADV2TokenResponse load]
  0x0000008a944 +[MSIDAADV2TokenResponse providerType]

  // instance methods
  0x0000008a8e0 -[MSIDAADV2TokenResponse tokenClaimsFromRawIdToken:error:]
  0x0000008a93c -[MSIDAADV2TokenResponse accountType]


0x0000017fb88 MSIDLegacySilentTokenRequest : MSIDSilentTokenRequest
 @property  MSIDLegacyTokenCacheAccessor *legacyAccessor

  // instance methods
  0x0000008a94c -[MSIDLegacySilentTokenRequest initWithRequestParameters:forceRefresh:oauthFactory:tokenResponseValidator:tokenCache:]
  0x0000008aa28 -[MSIDLegacySilentTokenRequest accessTokenWithError:]
  0x0000008aa30 -[MSIDLegacySilentTokenRequest resultWithAccessToken:refreshToken:error:]
  0x0000008aa38 -[MSIDLegacySilentTokenRequest familyRefreshTokenWithError:]
  0x0000008aa40 -[MSIDLegacySilentTokenRequest appRefreshTokenWithError:]
  0x0000008aa48 -[MSIDLegacySilentTokenRequest updateFamilyIdCacheWithServerError:cacheError:]
  0x0000008aa50 -[MSIDLegacySilentTokenRequest shouldRemoveRefreshToken:]
  0x0000008aa9c -[MSIDLegacySilentTokenRequest tokenCache]
  0x0000008aaa0 -[MSIDLegacySilentTokenRequest metadataCache]
  0x0000008aaa8 -[MSIDLegacySilentTokenRequest legacyAccessor]
  0x0000008aab8 -[MSIDLegacySilentTokenRequest setLegacyAccessor:]


0x0000017fc00 MSIDWebResponseBrokerInstallOperation : MSIDWebResponseBaseOperation
 @property  NSURL *appInstallLink

  // instance methods
  0x0000008aae0 -[MSIDWebResponseBrokerInstallOperation initWithResponse:error:]
  0x0000008ab60 -[MSIDWebResponseBrokerInstallOperation invokeWithInteractiveTokenRequestParameters:tokenRequestProvider:completion:]
  0x0000008ac70 -[MSIDWebResponseBrokerInstallOperation appInstallLink]
  0x0000008ac80 -[MSIDWebResponseBrokerInstallOperation setAppInstallLink:]


0x0000017fc28 MSIDTelemetryCacheEvent : MSIDTelemetryBaseEvent
  // class methods
  0x0000008b10c +[MSIDTelemetryCacheEvent propertiesToAggregate]

  // instance methods
  0x0000008aca8 -[MSIDTelemetryCacheEvent initWithName:requestId:correlationId:]
  0x0000008ad7c -[MSIDTelemetryCacheEvent setTokenType:]
  0x0000008adcc -[MSIDTelemetryCacheEvent setStatus:]
  0x0000008ade0 -[MSIDTelemetryCacheEvent setIsRT:]
  0x0000008adf4 -[MSIDTelemetryCacheEvent setIsMRRT:]
  0x0000008ae08 -[MSIDTelemetryCacheEvent setIsFRT:]
  0x0000008ae1c -[MSIDTelemetryCacheEvent setRTStatus:]
  0x0000008ae30 -[MSIDTelemetryCacheEvent setMRRTStatus:]
  0x0000008ae44 -[MSIDTelemetryCacheEvent setFRTStatus:]
  0x0000008ae58 -[MSIDTelemetryCacheEvent setSpeInfo:]
  0x0000008ae6c -[MSIDTelemetryCacheEvent setToken:]
  0x0000008b01c -[MSIDTelemetryCacheEvent setCacheWipeApp:]
  0x0000008b030 -[MSIDTelemetryCacheEvent setCacheWipeTime:]
  0x0000008b044 -[MSIDTelemetryCacheEvent setWipeData:]
  0x0000008b0f8 -[MSIDTelemetryCacheEvent setExternalCacheSeedingStatus:]


0x0000017fc78 MSIDURLFormObject : NSObject /usr/lib/libobjc.A.dylib
  // instance methods
  0x0000008b2ec -[MSIDURLFormObject init]
  0x0000008b340 -[MSIDURLFormObject initWithEncodedString:error:]
  0x0000008b4b0 -[MSIDURLFormObject initWithDictionary:error:]
  0x0000008b5d8 -[MSIDURLFormObject formDictionary]
  0x0000008b5e0 -[MSIDURLFormObject encode]


0x0000017fcc8 MSIDSSOExtensionGetDataBaseRequest : NSObject /usr/lib/libobjc.A.dylib
 @property  ASAuthorizationController *authorizationController
 @property  MSIDSSOExtensionOperationRequestDelegate *extensionDelegate
 @property  ASAuthorizationSingleSignOnProvider *ssoProvider
 @property  MSIDRequestParameters *requestParameters

  // class methods
  0x0000008b9d0 +[MSIDSSOExtensionGetDataBaseRequest canPerformRequest]

  // instance methods
  0x0000008b5f4 -[MSIDSSOExtensionGetDataBaseRequest initWithRequestParameters:error:]
  0x0000008b760 -[MSIDSSOExtensionGetDataBaseRequest executeBrokerOperationRequest:requiresUI:errorBlock:]
  0x0000008b914 -[MSIDSSOExtensionGetDataBaseRequest controllerWithRequest:]
  0x0000008ba14 -[MSIDSSOExtensionGetDataBaseRequest requestParameters]
  0x0000008ba1c -[MSIDSSOExtensionGetDataBaseRequest setRequestParameters:]
  0x0000008ba28 -[MSIDSSOExtensionGetDataBaseRequest authorizationController]
  0x0000008ba30 -[MSIDSSOExtensionGetDataBaseRequest setAuthorizationController:]
  0x0000008ba3c -[MSIDSSOExtensionGetDataBaseRequest extensionDelegate]
  0x0000008ba44 -[MSIDSSOExtensionGetDataBaseRequest setExtensionDelegate:]
  0x0000008ba50 -[MSIDSSOExtensionGetDataBaseRequest ssoProvider]
  0x0000008ba58 -[MSIDSSOExtensionGetDataBaseRequest setSsoProvider:]


0x0000017fd18 MSIDCacheKey : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSString *account
 @property  NSString *service
 @property  NSNumber *type
 @property  NSData *generic
 @property  NSString *appKey
 @property  BOOL isShared

  // class methods
  0x0000008bbe4 +[MSIDCacheKey familyClientId:]

  // instance methods
  0x0000008baac -[MSIDCacheKey initWithAccount:service:generic:type:]
  0x0000008bc4c -[MSIDCacheKey logDescription]
  0x0000008bca4 -[MSIDCacheKey piiLogDescription]
  0x0000008bce4 -[MSIDCacheKey copyWithZone:]
  0x0000008bdb0 -[MSIDCacheKey isEqual:]
  0x0000008be9c -[MSIDCacheKey isEqualToItem:]
  0x0000008c028 -[MSIDCacheKey appKeyHash]
  0x0000008c030 -[MSIDCacheKey account]
  0x0000008c03c -[MSIDCacheKey service]
  0x0000008c048 -[MSIDCacheKey type]
  0x0000008c054 -[MSIDCacheKey generic]
  0x0000008c060 -[MSIDCacheKey appKey]
  0x0000008c06c -[MSIDCacheKey setAppKey:]
  0x0000008c074 -[MSIDCacheKey isShared]


0x0000017fd68 MSIDTelemetryBaseEvent : NSObject /usr/lib/libobjc.A.dylib <MSIDTelemetryEventInterface>
 @property  NSDictionary *propertyMap
 @property  BOOL errorInEvent
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000008c608 +[MSIDTelemetryBaseEvent propertiesToAggregate]
  0x0000008c6d8 +[MSIDTelemetryBaseEvent defaultParameters]
  0x0000008c918 +[MSIDTelemetryBaseEvent rawDefaultParameters]

  // instance methods
  0x0000008c0d4 -[MSIDTelemetryBaseEvent initWithName:requestId:correlationId:]
  0x0000008c240 -[MSIDTelemetryBaseEvent initWithName:context:]
  0x0000008c2ec -[MSIDTelemetryBaseEvent setProperty:value:]
  0x0000008c3d0 -[MSIDTelemetryBaseEvent propertyWithName:]
  0x0000008c438 -[MSIDTelemetryBaseEvent deleteProperty:]
  0x0000008c484 -[MSIDTelemetryBaseEvent getProperties]
  0x0000008c48c -[MSIDTelemetryBaseEvent setStartTime:]
  0x0000008c4ec -[MSIDTelemetryBaseEvent setStopTime:]
  0x0000008c54c -[MSIDTelemetryBaseEvent setResponseTime:]
  0x0000008c5c8 -[MSIDTelemetryBaseEvent addDefaultProperties]
  0x0000008cba0 -[MSIDTelemetryBaseEvent propertyMap]
  0x0000008cbac -[MSIDTelemetryBaseEvent errorInEvent]
  0x0000008cbb8 -[MSIDTelemetryBaseEvent setErrorInEvent:]


0x0000017fde0 MSIDTokenResponseHandler : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDExternalAADCacheSeeder *externalCacheSeeder

  // instance methods
  0x0000008cbcc -[MSIDTokenResponseHandler handleTokenResponse:requestParameters:homeAccountId:tokenResponseValidator:oauthFactory:tokenCache:accountMetadataCache:validateAccount:saveSSOStateOnly:brokerAppVersion:error:completionBlock:]
  0x0000008d318 -[MSIDTokenResponseHandler externalCacheSeeder]
  0x0000008d320 -[MSIDTokenResponseHandler setExternalCacheSeeder:]


0x0000017fe08 MSIDCurrentRequestTelemetrySerializedItem : NSObject /usr/lib/libobjc.A.dylib
 @property  NSNumber *schemaVersion
 @property  NSArray *defaultFields
 @property  NSArray *platformFields

  // class methods
  0x0000008d338 +[MSIDCurrentRequestTelemetrySerializedItem telemetryStringSizeLimit]
  0x0000008d344 +[MSIDCurrentRequestTelemetrySerializedItem setTelemetryStringSizeLimit:]

  // instance methods
  0x0000008d350 -[MSIDCurrentRequestTelemetrySerializedItem initWithSchemaVersion:defaultFields:platformFields:]
  0x0000008d44c -[MSIDCurrentRequestTelemetrySerializedItem serialize]
  0x0000008d588 -[MSIDCurrentRequestTelemetrySerializedItem serializeFields:]
  0x0000008d5c4 -[MSIDCurrentRequestTelemetrySerializedItem schemaVersion]
  0x0000008d5cc -[MSIDCurrentRequestTelemetrySerializedItem setSchemaVersion:]
  0x0000008d5d8 -[MSIDCurrentRequestTelemetrySerializedItem defaultFields]
  0x0000008d5e0 -[MSIDCurrentRequestTelemetrySerializedItem setDefaultFields:]
  0x0000008d5ec -[MSIDCurrentRequestTelemetrySerializedItem platformFields]
  0x0000008d5f4 -[MSIDCurrentRequestTelemetrySerializedItem setPlatformFields:]


0x0000017fe80 MSIDAppExtensionUtil : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000008d63c +[MSIDAppExtensionUtil runningInCompliantExtension]
  0x0000008d648 +[MSIDAppExtensionUtil setRunningInCompliantExtension:]
  0x0000008d654 +[MSIDAppExtensionUtil isExecutingInAppExtension]
  0x0000008d768 +[MSIDAppExtensionUtil sharedApplication]
  0x0000008d7b8 +[MSIDAppExtensionUtil sharedApplicationOpenURL:]
  0x0000008d8d8 +[MSIDAppExtensionUtil sharedApplicationOpenURL:configuration:completionHandler:]


0x0000017fed0 MSIDBasicContext : NSObject /usr/lib/libobjc.A.dylib <MSIDRequestContext>
 @property  NSUUID *correlationId
 @property  NSString *logComponent
 @property  NSString *telemetryRequestId
 @property  NSDictionary *appRequestMetadata

  // instance methods
  0x0000008da98 -[MSIDBasicContext correlationId]
  0x0000008daa0 -[MSIDBasicContext setCorrelationId:]
  0x0000008daac -[MSIDBasicContext logComponent]
  0x0000008dab4 -[MSIDBasicContext setLogComponent:]
  0x0000008dac0 -[MSIDBasicContext telemetryRequestId]
  0x0000008dac8 -[MSIDBasicContext setTelemetryRequestId:]
  0x0000008dad4 -[MSIDBasicContext appRequestMetadata]
  0x0000008dadc -[MSIDBasicContext setAppRequestMetadata:]


0x0000017ff20 MSIDChallengeHandler : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000008db30 +[MSIDChallengeHandler handleChallenge:webview:context:completionHandler:]
  0x0000008dc8c +[MSIDChallengeHandler registerHandler:authMethod:]
  0x0000008dd8c +[MSIDChallengeHandler resetHandlers]


0x0000017ff70 MSIDSystemWebViewControllerFactory : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000008ded0 +[MSIDSystemWebViewControllerFactory availableWebViewTypeWithPreferredType:]
  0x0000008ded8 +[MSIDSystemWebViewControllerFactory authSessionWithParentController:startURL:callbackScheme:useEmpheralSession:context:]


0x0000017ff98 MSIDAccountMetadataCacheAccessor : NSObject /usr/lib/libobjc.A.dylib
 @property  BOOL skipMemoryCacheForAccountMetadata

  // instance methods
  0x0000008df74 -[MSIDAccountMetadataCacheAccessor initWithDataSource:]
  0x0000008e050 -[MSIDAccountMetadataCacheAccessor getAuthorityURL:homeAccountId:clientId:instanceAware:context:error:]
  0x0000008e204 -[MSIDAccountMetadataCacheAccessor updateAuthorityURL:forRequestURL:homeAccountId:clientId:instanceAware:context:error:]
  0x0000008e518 -[MSIDAccountMetadataCacheAccessor signInStateForHomeAccountId:clientId:context:error:]
  0x0000008e6ec -[MSIDAccountMetadataCacheAccessor updateSignInStateForHomeAccountId:clientId:state:context:error:]
  0x0000008e950 -[MSIDAccountMetadataCacheAccessor principalAccountIdForClientId:context:error:]
  0x0000008e9fc -[MSIDAccountMetadataCacheAccessor updatePrincipalAccountIdForClientId:principalAccountId:principalAccountEnvironment:context:error:]
  0x0000008ebb0 -[MSIDAccountMetadataCacheAccessor retrieveAccountMetadataCacheItemForClientId:context:error:]
  0x0000008ebc0 -[MSIDAccountMetadataCacheAccessor retrieveAccountMetadataCacheItemForClientId:skipCache:context:error:]
  0x0000008ed38 -[MSIDAccountMetadataCacheAccessor removeAccountMetadataForHomeAccountId:context:error:]
  0x0000008f1b8 -[MSIDAccountMetadataCacheAccessor allAccountMetadataCacheItemsWithContext:error:]
  0x0000008f1c0 -[MSIDAccountMetadataCacheAccessor skipMemoryCacheForAccountMetadata]
  0x0000008f1c8 -[MSIDAccountMetadataCacheAccessor setSkipMemoryCacheForAccountMetadata:]


0x00000180010 MSIDDefaultBrokerTokenRequest : MSIDBrokerTokenRequest
  // instance methods
  0x0000008f594 -[MSIDDefaultBrokerTokenRequest protocolPayloadContentsWithError:]
  0x0000008f940 -[MSIDDefaultBrokerTokenRequest protocolResumeDictionaryContents]


0x00000180038 MSIDBaseWebRequestConfiguration : NSObject /usr/lib/libobjc.A.dylib
 @property  NSURL *startURL
 @property  NSString *endRedirectUrl
 @property  NSDictionary *customHeaders
 @property  NSViewController *parentController
 @property  BOOL prefersEphemeralWebBrowserSession
 @property  NSString *state
 @property  MSIDExternalSSOContext *ssoContext
 @property  BOOL ignoreInvalidState

  // instance methods
  0x0000008fb00 -[MSIDBaseWebRequestConfiguration initWithStartURL:endRedirectUri:state:ignoreInvalidState:ssoContext:]
  0x0000008fc30 -[MSIDBaseWebRequestConfiguration initWithStartURL:endRedirectUri:state:ignoreInvalidState:]
  0x0000008fc38 -[MSIDBaseWebRequestConfiguration responseWithResultURL:factory:context:error:]
  0x0000008fc40 -[MSIDBaseWebRequestConfiguration startURL]
  0x0000008fc48 -[MSIDBaseWebRequestConfiguration setStartURL:]
  0x0000008fc54 -[MSIDBaseWebRequestConfiguration endRedirectUrl]
  0x0000008fc5c -[MSIDBaseWebRequestConfiguration setEndRedirectUrl:]
  0x0000008fc68 -[MSIDBaseWebRequestConfiguration customHeaders]
  0x0000008fc70 -[MSIDBaseWebRequestConfiguration setCustomHeaders:]
  0x0000008fc7c -[MSIDBaseWebRequestConfiguration parentController]
  0x0000008fc94 -[MSIDBaseWebRequestConfiguration setParentController:]
  0x0000008fca0 -[MSIDBaseWebRequestConfiguration prefersEphemeralWebBrowserSession]
  0x0000008fca8 -[MSIDBaseWebRequestConfiguration setPrefersEphemeralWebBrowserSession:]
  0x0000008fcb0 -[MSIDBaseWebRequestConfiguration state]
  0x0000008fcb8 -[MSIDBaseWebRequestConfiguration ssoContext]
  0x0000008fcc0 -[MSIDBaseWebRequestConfiguration ignoreInvalidState]


0x00000180088 MSIDMetadataCache : NSObject /usr/lib/libobjc.A.dylib
  // instance methods
  0x0000008fd24 -[MSIDMetadataCache initWithPersistentDataSource:]
  0x0000008fec0 -[MSIDMetadataCache saveAccountMetadataCacheItem:key:context:error:]
  0x0000009036c -[MSIDMetadataCache accountMetadataCacheItemWithKey:context:error:]
  0x0000009037c -[MSIDMetadataCache accountMetadataCacheItemWithKey:skipCache:context:error:]
  0x000000908bc -[MSIDMetadataCache allAccountMetadataCacheItemsWithContext:error:]
  0x00000090d78 -[MSIDMetadataCache removeAccountMetadataCacheItemForKey:context:error:]


0x00000180100 MSIDGeneralCacheItemTypeHelpers : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000009105c +[MSIDGeneralCacheItemTypeHelpers generalTypeAsString:]
  0x0000009107c +[MSIDGeneralCacheItemTypeHelpers generalTypeFromString:]


0x00000180128 MSIDBrokerCryptoProvider : NSObject /usr/lib/libobjc.A.dylib
 @property  NSData *encryptionKey

  // instance methods
  0x00000091228 -[MSIDBrokerCryptoProvider initWithEncryptionKey:]
  0x000000912cc -[MSIDBrokerCryptoProvider decryptBrokerResponse:correlationId:error:]
  0x000000915a0 -[MSIDBrokerCryptoProvider decryptData:protocolVersion:]
  0x00000091700 -[MSIDBrokerCryptoProvider encryptionKey]
  0x00000091708 -[MSIDBrokerCryptoProvider setEncryptionKey:]


0x00000180178 MSIDBrokerOperationTokenResponse : MSIDBrokerNativeAppOperationResponse
 @property  MSIDTokenResponse *tokenResponse
 @property  MSIDAuthority *authority
 @property  MSIDTokenResponse *additionalTokenResponse

  // class methods
  0x00000091720 +[MSIDBrokerOperationTokenResponse load]
  0x00000091770 +[MSIDBrokerOperationTokenResponse responseType]

  // instance methods
  0x00000091780 -[MSIDBrokerOperationTokenResponse initWithJSONDictionary:error:]
  0x00000091a00 -[MSIDBrokerOperationTokenResponse jsonDictionary]
  0x00000091d40 -[MSIDBrokerOperationTokenResponse tokenResponse]
  0x00000091d50 -[MSIDBrokerOperationTokenResponse setTokenResponse:]
  0x00000091d64 -[MSIDBrokerOperationTokenResponse authority]
  0x00000091d74 -[MSIDBrokerOperationTokenResponse setAuthority:]
  0x00000091d88 -[MSIDBrokerOperationTokenResponse additionalTokenResponse]
  0x00000091d98 -[MSIDBrokerOperationTokenResponse setAdditionalTokenResponse:]


0x000001801c8 MSIDBrokerOperationInteractiveTokenRequest : MSIDBrokerOperationTokenRequest
 @property  MSIDAccountIdentifier *accountIdentifier
 @property  long long promptType
 @property  NSString *extraScopesToConsent

  // class methods
  0x00000091e00 +[MSIDBrokerOperationInteractiveTokenRequest load]
  0x00000091e50 +[MSIDBrokerOperationInteractiveTokenRequest tokenRequestWithParameters:providerType:enrollmentIds:mamResources:requestSentDate:]
  0x00000092034 +[MSIDBrokerOperationInteractiveTokenRequest operation]

  // instance methods
  0x00000092044 -[MSIDBrokerOperationInteractiveTokenRequest initWithJSONDictionary:error:]
  0x00000092180 -[MSIDBrokerOperationInteractiveTokenRequest jsonDictionary]
  0x000000922d8 -[MSIDBrokerOperationInteractiveTokenRequest accountIdentifier]
  0x000000922e8 -[MSIDBrokerOperationInteractiveTokenRequest setAccountIdentifier:]
  0x000000922fc -[MSIDBrokerOperationInteractiveTokenRequest promptType]
  0x0000009230c -[MSIDBrokerOperationInteractiveTokenRequest setPromptType:]
  0x0000009231c -[MSIDBrokerOperationInteractiveTokenRequest extraScopesToConsent]
  0x0000009232c -[MSIDBrokerOperationInteractiveTokenRequest setExtraScopesToConsent:]


0x00000180218 MSIDAccessTokenWithAuthScheme : MSIDAccessToken
  // instance methods
  0x00000092380 -[MSIDAccessTokenWithAuthScheme credentialType]
  0x00000092388 -[MSIDAccessTokenWithAuthScheme tokenCacheItem]
  0x0000009245c -[MSIDAccessTokenWithAuthScheme copyWithZone:]
  0x0000009252c -[MSIDAccessTokenWithAuthScheme isEqual:]
  0x0000009267c -[MSIDAccessTokenWithAuthScheme isEqualToItem:]
  0x00000092844 -[MSIDAccessTokenWithAuthScheme initWithTokenCacheItem:]


0x00000180290 MSIDNegotiateHandler : NSObject /usr/lib/libobjc.A.dylib <MSIDChallengeHandling>
  // class methods
  0x00000092a40 +[MSIDNegotiateHandler load]
  0x00000092a5c +[MSIDNegotiateHandler resetHandler]
  0x00000092a60 +[MSIDNegotiateHandler handleChallenge:webview:context:completionHandler:]
  0x00000092ba0 +[MSIDNegotiateHandler hasValidKBRCredential:]


0x000001802b8 MSIDAadAuthorityCache : MSIDCache
  // class methods
  0x00000094560 +[MSIDAadAuthorityCache sharedInstance]

  // instance methods
  0x000000945cc -[MSIDAadAuthorityCache processMetadata:openIdConfigEndpoint:authority:context:completion:]
  0x00000094878 -[MSIDAadAuthorityCache processImpl:authority:openIdConfigEndpoint:context:error:]
  0x00000095340 -[MSIDAadAuthorityCache addInvalidRecord:oauthError:context:]
  0x00000095488 -[MSIDAadAuthorityCache networkUrlForAuthority:context:]
  0x000000955a8 -[MSIDAadAuthorityCache cacheUrlForAuthority:context:]
  0x000000956c8 -[MSIDAadAuthorityCache cacheEnvironmentForEnvironment:context:]
  0x000000957d4 -[MSIDAadAuthorityCache cacheAliasesForAuthority:]
  0x00000095800 -[MSIDAadAuthorityCache cacheAliasesForEnvironment:]
  0x0000009582c -[MSIDAadAuthorityCache networkUrlForAuthorityImpl:]
  0x00000095b98 -[MSIDAadAuthorityCache cacheUrlForAuthorityImpl:]
  0x00000095c70 -[MSIDAadAuthorityCache cacheEnvironmentForEnvironmentImpl:]
  0x00000095cc4 -[MSIDAadAuthorityCache cacheAliasesForAuthorityImpl:]
  0x00000095fb4 -[MSIDAadAuthorityCache cacheAliasesForEnvironmentImpl:]


0x00000180308 MSIDDefaultDispatcher : NSObject /usr/lib/libobjc.A.dylib <MSIDTelemetryDispatcher>
 @property  NSMutableDictionary *eventsToBeDispatched
 @property  <MSIDTelemetryEventsObserving> *observer
 @property  BOOL setTelemetryOnFailure
 @property  NSMutableSet *errorEvents
 @property  NSObject<OS_dispatch_queue> *synchronizationQueue
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x0000009619c -[MSIDDefaultDispatcher initWithObserver:]
  0x00000096314 -[MSIDDefaultDispatcher containsObserver:]
  0x00000096374 -[MSIDDefaultDispatcher flush:]
  0x00000096540 -[MSIDDefaultDispatcher receive:event:]
  0x00000096728 -[MSIDDefaultDispatcher dispatchEvents:]
  0x00000096894 -[MSIDDefaultDispatcher popEventsForRequestId:]
  0x00000096b1c -[MSIDDefaultDispatcher appendPrefixForEvent:]
  0x00000096cc8 -[MSIDDefaultDispatcher eventsToBeDispatched]
  0x00000096cd0 -[MSIDDefaultDispatcher setEventsToBeDispatched:]
  0x00000096cdc -[MSIDDefaultDispatcher observer]
  0x00000096ce4 -[MSIDDefaultDispatcher setObserver:]
  0x00000096cf0 -[MSIDDefaultDispatcher setTelemetryOnFailure]
  0x00000096cf8 -[MSIDDefaultDispatcher setSetTelemetryOnFailure:]
  0x00000096d00 -[MSIDDefaultDispatcher errorEvents]
  0x00000096d08 -[MSIDDefaultDispatcher setErrorEvents:]
  0x00000096d14 -[MSIDDefaultDispatcher synchronizationQueue]
  0x00000096d1c -[MSIDDefaultDispatcher setSynchronizationQueue:]


0x00000180358 MSIDUserInformation : NSObject /usr/lib/libobjc.A.dylib <NSSecureCoding>
 @property  NSString *rawIdToken

  // class methods
  0x00000096d70 +[MSIDUserInformation supportsSecureCoding]

  // instance methods
  0x00000096d78 -[MSIDUserInformation initWithRawIdToken:]
  0x00000096e1c -[MSIDUserInformation initWithCoder:]
  0x00000096ef0 -[MSIDUserInformation idTokenClaims]
  0x0000009702c -[MSIDUserInformation encodeWithCoder:]
  0x00000097044 -[MSIDUserInformation rawIdToken]


0x000001803d0 MSIDUrlResponseSerializer : MSIDHttpResponseSerializer
  // instance methods
  0x000000971b0 -[MSIDUrlResponseSerializer responseObjectForResponse:data:context:error:]


0x00000180420 MSIDWebOAuth2Response : MSIDWebviewResponse
  // class methods
  0x000000973f4 +[MSIDWebOAuth2Response verifyRequestState:responseURL:error:]

  // instance methods
  0x000000972b8 -[MSIDWebOAuth2Response initWithURL:requestState:ignoreInvalidState:context:error:]


0x00000180448 MSIDLegacyRefreshToken : MSIDRefreshToken <MSIDLegacyCredentialCacheCompatible>
 @property  NSString *idToken
 @property  MSIDIdTokenClaims *idTokenClaims
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000975c4 -[MSIDLegacyRefreshToken copyWithZone:]
  0x00000097690 -[MSIDLegacyRefreshToken isEqual:]
  0x000000977e0 -[MSIDLegacyRefreshToken isEqualToItem:]
  0x000000979a8 -[MSIDLegacyRefreshToken tokenCacheItem]
  0x00000097a28 -[MSIDLegacyRefreshToken initWithLegacyTokenCacheItem:]
  0x00000097c5c -[MSIDLegacyRefreshToken legacyTokenCacheItem]
  0x00000097e50 -[MSIDLegacyRefreshToken credentialType]
  0x00000097f80 -[MSIDLegacyRefreshToken idToken]
  0x00000097f90 -[MSIDLegacyRefreshToken setIdToken:]
  0x00000097f9c -[MSIDLegacyRefreshToken idTokenClaims]


0x00000180498 MSIDAADV1IdTokenClaims : MSIDIdTokenClaims
 @property  NSString *upn
 @property  NSString *identityProvider
 @property  NSString *objectId
 @property  NSString *tenantId
 @property  NSString *uniqueName

  // instance methods
  0x00000097fec -[MSIDAADV1IdTokenClaims upn]
  0x00000098080 -[MSIDAADV1IdTokenClaims identityProvider]
  0x00000098114 -[MSIDAADV1IdTokenClaims objectId]
  0x000000981a8 -[MSIDAADV1IdTokenClaims tenantId]
  0x0000009823c -[MSIDAADV1IdTokenClaims uniqueName]
  0x000000982d0 -[MSIDAADV1IdTokenClaims initDerivedProperties]
  0x000000987dc -[MSIDAADV1IdTokenClaims alternativeAccountId]
  0x000000987f8 -[MSIDAADV1IdTokenClaims realm]


0x000001804e8 MSIDWebOpenBrowserResponse : MSIDWebviewResponse
 @property  NSURL *browserURL

  // class methods
  0x000000987fc +[MSIDWebOpenBrowserResponse load]
  0x00000098a30 +[MSIDWebOpenBrowserResponse operation]

  // instance methods
  0x00000098838 -[MSIDWebOpenBrowserResponse initWithURL:context:error:]
  0x00000098a40 -[MSIDWebOpenBrowserResponse browserURL]


0x00000180538 MSIDTelemetryBrokerEvent : MSIDTelemetryBaseEvent
  // class methods
  0x00000098b38 +[MSIDTelemetryBrokerEvent propertiesToAggregate]

  // instance methods
  0x00000098a64 -[MSIDTelemetryBrokerEvent initWithName:requestId:correlationId:]
  0x00000098ae8 -[MSIDTelemetryBrokerEvent setBrokerAppVersion:]
  0x00000098afc -[MSIDTelemetryBrokerEvent setBrokerProtocolVersion:]
  0x00000098b10 -[MSIDTelemetryBrokerEvent setResultStatus:]
  0x00000098b24 -[MSIDTelemetryBrokerEvent setBrokerApp:]


0x00000180588 MSIDOAuth2EmbeddedWebviewController : MSIDWebviewUIController <MSIDWebviewInteracting, WKNavigationDelegate>
 @property  NSDictionary *customHeaders
 @property  MSIDBaseWebRequestConfiguration *configuration
 @property  NSString *telemetryRequestId
 @property  MSIDTelemetryUIEvent *telemetryEvent
 @property  @? completionHandler
 @property  BOOL runningNewImplementation
 @property  @? navigationResponseBlock
 @property  @? externalDecidePolicyForBrowserAction
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000098cc4 -[MSIDOAuth2EmbeddedWebviewController initWithStartURL:endURL:webview:customHeaders:platfromParams:context:]
  0x00000098f98 -[MSIDOAuth2EmbeddedWebviewController dealloc]
  0x000000990c0 -[MSIDOAuth2EmbeddedWebviewController startWithCompletionHandler:]
  0x00000099560 -[MSIDOAuth2EmbeddedWebviewController cancelProgrammatically]
  0x000000996f8 -[MSIDOAuth2EmbeddedWebviewController dismiss]
  0x000000996fc -[MSIDOAuth2EmbeddedWebviewController userCancel]
  0x00000099894 -[MSIDOAuth2EmbeddedWebviewController loadView:]
  0x00000099934 -[MSIDOAuth2EmbeddedWebviewController endWebAuthWithURL:error:]
  0x00000099c94 -[MSIDOAuth2EmbeddedWebviewController dispatchCompletionBlock:error:]
  0x00000099d58 -[MSIDOAuth2EmbeddedWebviewController startRequest:]
  0x00000099ee0 -[MSIDOAuth2EmbeddedWebviewController loadRequest:]
  0x00000099f38 -[MSIDOAuth2EmbeddedWebviewController webView:decidePolicyForNavigationAction:decisionHandler:]
  0x0000009a188 -[MSIDOAuth2EmbeddedWebviewController webView:didStartProvisionalNavigation:]
  0x0000009a220 -[MSIDOAuth2EmbeddedWebviewController webView:didFinishNavigation:]
  0x0000009a27c -[MSIDOAuth2EmbeddedWebviewController webView:didFailNavigation:withError:]
  0x0000009a284 -[MSIDOAuth2EmbeddedWebviewController webView:didFailProvisionalNavigation:withError:]
  0x0000009a28c -[MSIDOAuth2EmbeddedWebviewController webView:didReceiveAuthenticationChallenge:completionHandler:]
  0x0000009a43c -[MSIDOAuth2EmbeddedWebviewController webView:decidePolicyForNavigationResponse:decisionHandler:]
  0x0000009a528 -[MSIDOAuth2EmbeddedWebviewController completeWebAuthWithURL:]
  0x0000009a634 -[MSIDOAuth2EmbeddedWebviewController webAuthFailWithError:]
  0x0000009a7d4 -[MSIDOAuth2EmbeddedWebviewController decidePolicyForNavigationAction:webview:decisionHandler:]
  0x0000009ad28 -[MSIDOAuth2EmbeddedWebviewController webView:didReceiveServerRedirectForProvisionalNavigation:]
  0x0000009adec -[MSIDOAuth2EmbeddedWebviewController onStartLoadingIndicator:]
  0x0000009ae28 -[MSIDOAuth2EmbeddedWebviewController stopSpinner]
  0x0000009ae88 -[MSIDOAuth2EmbeddedWebviewController notifyFinishedNavigation:webView:]
  0x0000009b068 -[MSIDOAuth2EmbeddedWebviewController shouldSendNavigationNotification:]
  0x0000009b0e8 -[MSIDOAuth2EmbeddedWebviewController initWithConfiguration:context:]
  0x0000009b1d0 -[MSIDOAuth2EmbeddedWebviewController startURL]
  0x0000009b23c -[MSIDOAuth2EmbeddedWebviewController handleGetURLEvent:withReplyEvent:]
  0x0000009b7d4 -[MSIDOAuth2EmbeddedWebviewController stringByDecodingURLFormat:]
  0x0000009b82c -[MSIDOAuth2EmbeddedWebviewController getCorrelationIdFromErrorDescription:]
  0x0000009bae8 -[MSIDOAuth2EmbeddedWebviewController customHeaders]
  0x0000009baf8 -[MSIDOAuth2EmbeddedWebviewController setCustomHeaders:]
  0x0000009bb0c -[MSIDOAuth2EmbeddedWebviewController navigationResponseBlock]
  0x0000009bb1c -[MSIDOAuth2EmbeddedWebviewController setNavigationResponseBlock:]
  0x0000009bb28 -[MSIDOAuth2EmbeddedWebviewController externalDecidePolicyForBrowserAction]
  0x0000009bb38 -[MSIDOAuth2EmbeddedWebviewController setExternalDecidePolicyForBrowserAction:]
  0x0000009bb44 -[MSIDOAuth2EmbeddedWebviewController configuration]
  0x0000009bb54 -[MSIDOAuth2EmbeddedWebviewController setConfiguration:]
  0x0000009bb68 -[MSIDOAuth2EmbeddedWebviewController telemetryRequestId]
  0x0000009bb78 -[MSIDOAuth2EmbeddedWebviewController setTelemetryRequestId:]
  0x0000009bb8c -[MSIDOAuth2EmbeddedWebviewController telemetryEvent]
  0x0000009bb9c -[MSIDOAuth2EmbeddedWebviewController setTelemetryEvent:]
  0x0000009bbb0 -[MSIDOAuth2EmbeddedWebviewController completionHandler]
  0x0000009bbc0 -[MSIDOAuth2EmbeddedWebviewController setCompletionHandler:]
  0x0000009bbcc -[MSIDOAuth2EmbeddedWebviewController runningNewImplementation]
  0x0000009bbdc -[MSIDOAuth2EmbeddedWebviewController setRunningNewImplementation:]


0x00000180600 MSIDCIAMTokenResponse : MSIDAADV2TokenResponse
  // class methods
  0x0000009bcf4 +[MSIDCIAMTokenResponse load]
  0x0000009bdcc +[MSIDCIAMTokenResponse providerType]

  // instance methods
  0x0000009bd70 -[MSIDCIAMTokenResponse tokenClaimsFromRawIdToken:error:]


0x00000180650 MSIDThumbprintCalculator : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000009bdd4 +[MSIDThumbprintCalculator calculateThumbprint:filteringSet:shouldIncludeKeys:]
  0x0000009c00c +[MSIDThumbprintCalculator sortRequestParametersUsingFilteredSet:filteringSet:shouldIncludeKeys:]
  0x0000009c20c +[MSIDThumbprintCalculator hash:]


0x00000180678 MSIDAdfsAuthorityResolver : NSObject /usr/lib/libobjc.A.dylib <MSIDAuthorityResolving>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000009c2b4 +[MSIDAdfsAuthorityResolver initialize]
  0x0000009c31c +[MSIDAdfsAuthorityResolver cache]

  // instance methods
  0x0000009c328 -[MSIDAdfsAuthorityResolver resolveAuthority:userPrincipalName:validate:context:completionBlock:]
  0x0000009c9c8 -[MSIDAdfsAuthorityResolver sendDrsDiscoveryWithDomain:context:completionBlock:]
  0x0000009cc2c -[MSIDAdfsAuthorityResolver isRealmTrustedFromWebFingerPayload:authority:]
  0x0000009ce20 -[MSIDAdfsAuthorityResolver openIdConfigurationEndpointForAuthority:]
  0x0000009ce5c -[MSIDAdfsAuthorityResolver getDomain:]


0x000001806c8 MSIDDRSDiscoveryResponseSerializer : MSIDHttpResponseSerializer
  // instance methods
  0x0000009ced8 -[MSIDDRSDiscoveryResponseSerializer init]
  0x0000009cf70 -[MSIDDRSDiscoveryResponseSerializer responseObjectForResponse:data:context:error:]


0x00000180718 MSIDAccountMetadataCacheKey : MSIDCacheKey
  // instance methods
  0x0000009d11c -[MSIDAccountMetadataCacheKey initWithClientId:]


0x00000180768 MSIDTokenResult : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDAccessToken *accessToken
 @property  <MSIDRefreshableToken> *refreshToken
 @property  NSString *rawIdToken
 @property  MSIDAccount *account
 @property  BOOL extendedLifeTimeToken
 @property  MSIDAuthority *authority
 @property  NSUUID *correlationId
 @property  MSIDTokenResponse *tokenResponse
 @property  NSString *brokerAppVersion

  // instance methods
  0x0000009d1f0 -[MSIDTokenResult initWithAccessToken:refreshToken:idToken:account:authority:correlationId:tokenResponse:]
  0x0000009d414 -[MSIDTokenResult accessToken]
  0x0000009d41c -[MSIDTokenResult setAccessToken:]
  0x0000009d428 -[MSIDTokenResult refreshToken]
  0x0000009d430 -[MSIDTokenResult setRefreshToken:]
  0x0000009d43c -[MSIDTokenResult rawIdToken]
  0x0000009d444 -[MSIDTokenResult setRawIdToken:]
  0x0000009d450 -[MSIDTokenResult account]
  0x0000009d458 -[MSIDTokenResult setAccount:]
  0x0000009d464 -[MSIDTokenResult extendedLifeTimeToken]
  0x0000009d46c -[MSIDTokenResult setExtendedLifeTimeToken:]
  0x0000009d474 -[MSIDTokenResult authority]
  0x0000009d47c -[MSIDTokenResult setAuthority:]
  0x0000009d488 -[MSIDTokenResult correlationId]
  0x0000009d490 -[MSIDTokenResult setCorrelationId:]
  0x0000009d49c -[MSIDTokenResult tokenResponse]
  0x0000009d4a4 -[MSIDTokenResult setTokenResponse:]
  0x0000009d4b0 -[MSIDTokenResult brokerAppVersion]
  0x0000009d4b8 -[MSIDTokenResult setBrokerAppVersion:]


0x000001807b8 MSIDAccessToken : MSIDBaseToken
 @property  NSString *target
 @property  NSDate *expiresOn
 @property  NSDate *extendedExpiresOn
 @property  NSDate *refreshOn
 @property  NSDate *cachedAt
 @property  NSString *accessToken
 @property  NSString *resource
 @property  NSOrderedSet *scopes
 @property  NSString *enrollmentId
 @property  NSString *applicationIdentifier
 @property  NSString *kid
 @property  NSString *tokenType
 @property  NSString *redirectUri
 @property  NSString *requestedClaims

  // instance methods
  0x0000009d53c -[MSIDAccessToken copyWithZone:]
  0x0000009d748 -[MSIDAccessToken isEqual:]
  0x0000009da04 -[MSIDAccessToken isEqualToItem:]
  0x0000009dfa0 -[MSIDAccessToken initWithTokenCacheItem:]
  0x0000009e2f4 -[MSIDAccessToken tokenCacheItem]
  0x0000009e544 -[MSIDAccessToken credentialType]
  0x0000009e54c -[MSIDAccessToken refreshNeeded]
  0x0000009e664 -[MSIDAccessToken isExpiredWithExpiryBuffer:]
  0x0000009e764 -[MSIDAccessToken isExpired]
  0x0000009e76c -[MSIDAccessToken isExtendedLifetimeValid]
  0x0000009e824 -[MSIDAccessToken resource]
  0x0000009e834 -[MSIDAccessToken setResource:]
  0x0000009e848 -[MSIDAccessToken scopes]
  0x0000009e858 -[MSIDAccessToken setScopes:]
  0x0000009ea14 -[MSIDAccessToken expiresOn]
  0x0000009ea24 -[MSIDAccessToken setExpiresOn:]
  0x0000009ea30 -[MSIDAccessToken extendedExpiresOn]
  0x0000009ea40 -[MSIDAccessToken setExtendedExpiresOn:]
  0x0000009ea4c -[MSIDAccessToken refreshOn]
  0x0000009ea5c -[MSIDAccessToken setRefreshOn:]
  0x0000009ea68 -[MSIDAccessToken cachedAt]
  0x0000009ea78 -[MSIDAccessToken setCachedAt:]
  0x0000009ea84 -[MSIDAccessToken accessToken]
  0x0000009ea94 -[MSIDAccessToken setAccessToken:]
  0x0000009eaa0 -[MSIDAccessToken enrollmentId]
  0x0000009eab0 -[MSIDAccessToken setEnrollmentId:]
  0x0000009eabc -[MSIDAccessToken applicationIdentifier]
  0x0000009eacc -[MSIDAccessToken setApplicationIdentifier:]
  0x0000009ead8 -[MSIDAccessToken kid]
  0x0000009eae8 -[MSIDAccessToken setKid:]
  0x0000009eafc -[MSIDAccessToken tokenType]
  0x0000009eb0c -[MSIDAccessToken setTokenType:]
  0x0000009eb20 -[MSIDAccessToken redirectUri]
  0x0000009eb30 -[MSIDAccessToken setRedirectUri:]
  0x0000009eb3c -[MSIDAccessToken requestedClaims]
  0x0000009eb4c -[MSIDAccessToken setRequestedClaims:]
  0x0000009eb58 -[MSIDAccessToken target]
  0x0000009eb68 -[MSIDAccessToken setTarget:]


0x00000180830 MSIDSSOExtensionOperationRequestDelegate : MSIDSSOExtensionRequestDelegate
  // instance methods
  0x0000009ec7c -[MSIDSSOExtensionOperationRequestDelegate authorizationController:didCompleteWithAuthorization:]


0x00000180880 MSIDWebResponseOperationFactory : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000009eeec +[MSIDWebResponseOperationFactory registerOperationClass:forResponseClass:]
  0x0000009f014 +[MSIDWebResponseOperationFactory unregisterAll]
  0x0000009f064 +[MSIDWebResponseOperationFactory unRegisterforResponse:]
  0x0000009f100 +[MSIDWebResponseOperationFactory createOperationForResponse:error:]


0x000001808a8 MSIDDefaultAccountCacheKey : MSIDCacheKey <NSCopying>
 @property  NSString *homeAccountId
 @property  NSString *environment
 @property  NSString *username
 @property  NSString *realm
 @property  long long accountType

  // instance methods
  0x0000009f280 -[MSIDDefaultAccountCacheKey accountTypeNumber:]
  0x0000009f290 -[MSIDDefaultAccountCacheKey initWithHomeAccountId:environment:realm:type:]
  0x0000009f3c0 -[MSIDDefaultAccountCacheKey generic]
  0x0000009f440 -[MSIDDefaultAccountCacheKey type]
  0x0000009f468 -[MSIDDefaultAccountCacheKey account]
  0x0000009f568 -[MSIDDefaultAccountCacheKey service]
  0x0000009f5cc -[MSIDDefaultAccountCacheKey isShared]
  0x0000009f5d4 -[MSIDDefaultAccountCacheKey copyWithZone:]
  0x0000009f6b4 -[MSIDDefaultAccountCacheKey homeAccountId]
  0x0000009f6c4 -[MSIDDefaultAccountCacheKey setHomeAccountId:]
  0x0000009f6d8 -[MSIDDefaultAccountCacheKey environment]
  0x0000009f6e8 -[MSIDDefaultAccountCacheKey setEnvironment:]
  0x0000009f6fc -[MSIDDefaultAccountCacheKey username]
  0x0000009f70c -[MSIDDefaultAccountCacheKey setUsername:]
  0x0000009f720 -[MSIDDefaultAccountCacheKey realm]
  0x0000009f730 -[MSIDDefaultAccountCacheKey setRealm:]
  0x0000009f744 -[MSIDDefaultAccountCacheKey accountType]
  0x0000009f754 -[MSIDDefaultAccountCacheKey setAccountType:]


0x000001808f8 MSIDIdToken : MSIDBaseToken
 @property  NSString *rawIdToken

  // instance methods
  0x0000009f7cc -[MSIDIdToken copyWithZone:]
  0x0000009f870 -[MSIDIdToken isEqual:]
  0x0000009f990 -[MSIDIdToken isEqualToItem:]
  0x0000009fac4 -[MSIDIdToken initWithTokenCacheItem:]
  0x0000009fc20 -[MSIDIdToken tokenCacheItem]
  0x0000009fcd0 -[MSIDIdToken credentialType]
  0x0000009fda8 -[MSIDIdToken rawIdToken]
  0x0000009fdb8 -[MSIDIdToken setRawIdToken:]


0x00000180948 MSIDCIAMAuthority : MSIDAuthority
  // class methods
  0x0000009fdd8 +[MSIDCIAMAuthority load]
  0x000000a0280 +[MSIDCIAMAuthority isAuthorityFormatValid:context:error:]
  0x000000a0584 +[MSIDCIAMAuthority realmFromURL:context:error:]

  // instance methods
  0x0000009fe54 -[MSIDCIAMAuthority initWithURL:validateFormat:rawTenant:context:error:]
  0x0000009ffbc -[MSIDCIAMAuthority initWithURL:validateFormat:context:error:]
  0x000000a0270 -[MSIDCIAMAuthority initWithURL:context:error:]
  0x000000a04e8 -[MSIDCIAMAuthority supportsBrokeredAuthentication]
  0x000000a04f0 -[MSIDCIAMAuthority excludeFromAuthorityValidation]
  0x000000a04f8 -[MSIDCIAMAuthority copyWithZone:]
  0x000000a0558 -[MSIDCIAMAuthority resolver]
  0x000000a0574 -[MSIDCIAMAuthority telemetryAuthorityType]


0x000001809c0 MSIDPKeyAuthHandler : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x000000a0654 +[MSIDPKeyAuthHandler handleChallenge:context:customHeaders:externalSSOContext:completionHandler:]
  0x000000a0dc0 +[MSIDPKeyAuthHandler handleWwwAuthenticateHeader:requestUrl:externalSSOContext:context:completionHandler:]
  0x000000a0f80 +[MSIDPKeyAuthHandler parseAuthHeader:]


0x000001809e8 MSIDBrokerOperationSignoutFromDeviceRequest : MSIDBrokerOperationRemoveAccountRequest
 @property  MSIDAuthority *authority
 @property  NSString *redirectUri
 @property  long long providerType
 @property  BOOL signoutFromBrowser
 @property  BOOL clearSSOExtensionCookies
 @property  BOOL wipeAccount
 @property  BOOL wipeCacheForAllAccounts

  // class methods
  0x000000a1344 +[MSIDBrokerOperationSignoutFromDeviceRequest load]
  0x000000a1394 +[MSIDBrokerOperationSignoutFromDeviceRequest operation]

  // instance methods
  0x000000a13a4 -[MSIDBrokerOperationSignoutFromDeviceRequest initWithJSONDictionary:error:]
  0x000000a15d4 -[MSIDBrokerOperationSignoutFromDeviceRequest jsonDictionary]
  0x000000a1978 -[MSIDBrokerOperationSignoutFromDeviceRequest authority]
  0x000000a1988 -[MSIDBrokerOperationSignoutFromDeviceRequest setAuthority:]
  0x000000a1994 -[MSIDBrokerOperationSignoutFromDeviceRequest redirectUri]
  0x000000a19a4 -[MSIDBrokerOperationSignoutFromDeviceRequest setRedirectUri:]
  0x000000a19b0 -[MSIDBrokerOperationSignoutFromDeviceRequest providerType]
  0x000000a19c0 -[MSIDBrokerOperationSignoutFromDeviceRequest setProviderType:]
  0x000000a19d0 -[MSIDBrokerOperationSignoutFromDeviceRequest signoutFromBrowser]
  0x000000a19e0 -[MSIDBrokerOperationSignoutFromDeviceRequest setSignoutFromBrowser:]
  0x000000a19f0 -[MSIDBrokerOperationSignoutFromDeviceRequest clearSSOExtensionCookies]
  0x000000a1a00 -[MSIDBrokerOperationSignoutFromDeviceRequest setClearSSOExtensionCookies:]
  0x000000a1a10 -[MSIDBrokerOperationSignoutFromDeviceRequest wipeAccount]
  0x000000a1a20 -[MSIDBrokerOperationSignoutFromDeviceRequest setWipeAccount:]
  0x000000a1a30 -[MSIDBrokerOperationSignoutFromDeviceRequest wipeCacheForAllAccounts]
  0x000000a1a40 -[MSIDBrokerOperationSignoutFromDeviceRequest setWipeCacheForAllAccounts:]


0x00000180a38 MSIDClaimsRequest : NSObject /usr/lib/libobjc.A.dylib <NSCopying, MSIDJsonSerializable>
 @property  NSMutableDictionary *claimsRequestsDict
 @property  BOOL hasClaims
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000003d928 +[MSIDClaimsRequest claimsRequestFromCapabilities:claimsRequest:]

  // instance methods
  0x0000003d86c -[MSIDClaimsRequest requestCapabilities:]
  0x000000a1b70 -[MSIDClaimsRequest claimsRequestsDict]
  0x000000a1bb4 -[MSIDClaimsRequest count]
  0x000000a1bf0 -[MSIDClaimsRequest hasClaims]
  0x000000a1c30 -[MSIDClaimsRequest requestClaim:forTarget:error:]
  0x000000a1e20 -[MSIDClaimsRequest claimsRequestsForTarget:]
  0x000000a1f04 -[MSIDClaimsRequest removeClaimRequestWithName:target:error:]
  0x000000a210c -[MSIDClaimsRequest copyWithZone:]
  0x000000a2154 -[MSIDClaimsRequest initWithJSONDictionary:error:]
  0x000000a2524 -[MSIDClaimsRequest jsonDictionary]
  0x000000a27f8 -[MSIDClaimsRequest targetFromString:error:]
  0x000000a296c -[MSIDClaimsRequest stringFromTarget:]
  0x000000a29b0 -[MSIDClaimsRequest setClaimsRequestsDict:]


0x00000180a88 MSIDPasskeyAssertion : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable>
 @property  NSData *signature
 @property  NSData *authenticatorData
 @property  NSData *credentialId
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000a2a80 -[MSIDPasskeyAssertion initWithSignature:authenticatorData:credentialId:]
  0x000000a2b7c -[MSIDPasskeyAssertion initWithJSONDictionary:error:]
  0x000000a2d6c -[MSIDPasskeyAssertion jsonDictionary]
  0x000000a2e7c -[MSIDPasskeyAssertion signature]
  0x000000a2e84 -[MSIDPasskeyAssertion setSignature:]
  0x000000a2e90 -[MSIDPasskeyAssertion authenticatorData]
  0x000000a2e98 -[MSIDPasskeyAssertion setAuthenticatorData:]
  0x000000a2ea4 -[MSIDPasskeyAssertion credentialId]
  0x000000a2eac -[MSIDPasskeyAssertion setCredentialId:]


0x00000180ad8 MSIDMaskedHashableLogParameter : MSIDMaskedLogParameter
  // instance methods
  0x000000a2ef4 -[MSIDMaskedHashableLogParameter maskedDescription]
  0x000000a2fe0 -[MSIDMaskedHashableLogParameter isEUII]


0x00000180b28 MSIDThrottlingCacheRecord : NSObject /usr/lib/libobjc.A.dylib
 @property  NSDate *creationTime
 @property  NSDate *expirationTime
 @property  long long throttleType
 @property  NSError *cachedErrorResponse
 @property  unsigned long throttledCount

  // instance methods
  0x000000a2fe8 -[MSIDThrottlingCacheRecord initWithErrorResponse:throttleType:throttleDuration:]
  0x000000a30f0 -[MSIDThrottlingCacheRecord creationTime]
  0x000000a30f8 -[MSIDThrottlingCacheRecord expirationTime]
  0x000000a3100 -[MSIDThrottlingCacheRecord throttleType]
  0x000000a3108 -[MSIDThrottlingCacheRecord setThrottleType:]
  0x000000a3110 -[MSIDThrottlingCacheRecord cachedErrorResponse]
  0x000000a3118 -[MSIDThrottlingCacheRecord throttledCount]
  0x000000a3120 -[MSIDThrottlingCacheRecord setThrottledCount:]


0x00000180b78 MSIDASWebAuthenticationSessionHandler : NSObject /usr/lib/libobjc.A.dylib <ASWebAuthenticationPresentationContextProviding, MSIDWebviewInteracting>
 @property  NSViewController *parentController
 @property  NSURL *startURL
 @property  NSString *callbackURLScheme
 @property  ASWebAuthenticationSession *webAuthSession
 @property  BOOL useEmpheralSession
 @property  BOOL sessionDismissed
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000a3164 -[MSIDASWebAuthenticationSessionHandler initWithParentController:startURL:callbackScheme:useEmpheralSession:]
  0x000000a3264 -[MSIDASWebAuthenticationSessionHandler startWithCompletionHandler:]
  0x000000a35b0 -[MSIDASWebAuthenticationSessionHandler cancelProgrammatically]
  0x000000a35e0 -[MSIDASWebAuthenticationSessionHandler userCancel]
  0x000000a35e4 -[MSIDASWebAuthenticationSessionHandler dismiss]
  0x000000a360c -[MSIDASWebAuthenticationSessionHandler presentationAnchorForWebAuthenticationSession:]
  0x000000a3610 -[MSIDASWebAuthenticationSessionHandler presentationAnchor]
  0x000000a37d8 -[MSIDASWebAuthenticationSessionHandler parentController]
  0x000000a37f0 -[MSIDASWebAuthenticationSessionHandler setParentController:]
  0x000000a37fc -[MSIDASWebAuthenticationSessionHandler startURL]
  0x000000a3804 -[MSIDASWebAuthenticationSessionHandler setStartURL:]
  0x000000a3810 -[MSIDASWebAuthenticationSessionHandler callbackURLScheme]
  0x000000a3818 -[MSIDASWebAuthenticationSessionHandler setCallbackURLScheme:]
  0x000000a3824 -[MSIDASWebAuthenticationSessionHandler webAuthSession]
  0x000000a382c -[MSIDASWebAuthenticationSessionHandler setWebAuthSession:]
  0x000000a3838 -[MSIDASWebAuthenticationSessionHandler useEmpheralSession]
  0x000000a3840 -[MSIDASWebAuthenticationSessionHandler setUseEmpheralSession:]
  0x000000a3848 -[MSIDASWebAuthenticationSessionHandler sessionDismissed]
  0x000000a3850 -[MSIDASWebAuthenticationSessionHandler setSessionDismissed:]


0x00000180bc8 MSIDAccountMetadata : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable, NSCopying>
 @property  NSMutableDictionary *auhtorityMap
 @property  NSString *homeAccountId
 @property  NSString *clientId
 @property  long long signInState
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000a389c -[MSIDAccountMetadata initWithHomeAccountId:clientId:]
  0x000000a39b4 -[MSIDAccountMetadata setCachedURL:forRequestURL:instanceAware:error:]
  0x000000a3bc8 -[MSIDAccountMetadata cachedURL:instanceAware:]
  0x000000a3cc4 -[MSIDAccountMetadata updateSignInState:]
  0x000000a3d10 -[MSIDAccountMetadata initWithJSONDictionary:error:]
  0x000000a3f24 -[MSIDAccountMetadata jsonDictionary]
  0x000000a4040 -[MSIDAccountMetadata URLMapKey:]
  0x000000a405c -[MSIDAccountMetadata accountMetadataStateStringFromEnum:]
  0x000000a407c -[MSIDAccountMetadata accountMetadataStateEnumFromString:]
  0x000000a40fc -[MSIDAccountMetadata isEqual:]
  0x000000a4170 -[MSIDAccountMetadata isEqualToItem:]
  0x000000a4484 -[MSIDAccountMetadata copyWithZone:]
  0x000000a4554 -[MSIDAccountMetadata homeAccountId]
  0x000000a455c -[MSIDAccountMetadata clientId]
  0x000000a4564 -[MSIDAccountMetadata auhtorityMap]
  0x000000a456c -[MSIDAccountMetadata setAuhtorityMap:]
  0x000000a4578 -[MSIDAccountMetadata signInState]


0x00000180c18 MSIDInteractiveTokenRequest : MSIDInteractiveAuthorizationCodeRequest <MSIDInteractiveRequestControlling>
 @property  MSIDTokenResponseHandler *tokenResponseHandler
 @property  MSIDTokenResponseValidator *tokenResponseValidator
 @property  <MSIDCacheAccessor> *tokenCache
 @property  MSIDAccountMetadataCacheAccessor *accountMetadataCache
 @property  <MSIDExtendedTokenCacheDataSource> *extendedTokenCache
 @property  MSIDExternalAADCacheSeeder *externalCacheSeeder
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000a45bc -[MSIDInteractiveTokenRequest initWithRequestParameters:oauthFactory:tokenResponseValidator:tokenCache:accountMetadataCache:extendedTokenCache:]
  0x000000a4738 -[MSIDInteractiveTokenRequest executeRequestWithCompletion:]
  0x000000a48a8 -[MSIDInteractiveTokenRequest acquireTokenWithCodeResult:completion:]
  0x000000a4cbc -[MSIDInteractiveTokenRequest dealloc]
  0x000000a4d1c -[MSIDInteractiveTokenRequest externalCacheSeeder]
  0x000000a4d2c -[MSIDInteractiveTokenRequest setExternalCacheSeeder:]
  0x000000a4d40 -[MSIDInteractiveTokenRequest tokenResponseHandler]
  0x000000a4d50 -[MSIDInteractiveTokenRequest setTokenResponseHandler:]
  0x000000a4d64 -[MSIDInteractiveTokenRequest tokenResponseValidator]
  0x000000a4d74 -[MSIDInteractiveTokenRequest setTokenResponseValidator:]
  0x000000a4d88 -[MSIDInteractiveTokenRequest tokenCache]
  0x000000a4d98 -[MSIDInteractiveTokenRequest setTokenCache:]
  0x000000a4dac -[MSIDInteractiveTokenRequest accountMetadataCache]
  0x000000a4dbc -[MSIDInteractiveTokenRequest setAccountMetadataCache:]
  0x000000a4dd0 -[MSIDInteractiveTokenRequest extendedTokenCache]


0x00000180c68 MSIDSymmetricKey : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *symmetricKeyBase64

  // instance methods
  0x000000a4e70 -[MSIDSymmetricKey initWithSymmetricKeyBytes:]
  0x000000a4f38 -[MSIDSymmetricKey initWithSymmetricKeyBase64:]
  0x000000a4fc8 -[MSIDSymmetricKey createVerifySignature:dataToSign:]
  0x000000a513c -[MSIDSymmetricKey computeKDFInCounterMode:]
  0x000000a5314 -[MSIDSymmetricKey kdfCounterMode:keyDerivationKeyLength:fixedInput:fixedInputLength:]
  0x000000a53ec -[MSIDSymmetricKey updateDataInput:fixedInput:fixedInput_length:]
  0x000000a5448 -[MSIDSymmetricKey symmetricKeyBase64]
  0x000000a5454 -[MSIDSymmetricKey setSymmetricKeyBase64:]


0x00000180cb8 MSIDMaskedLogParameter : NSObject /usr/lib/libobjc.A.dylib
 @property  id parameterValue
 @property  NSString *maskedParameterValue
 @property  NSString *euiiMaskedParameterValue
 @property  BOOL isEUII

  // instance methods
  0x000000a5490 -[MSIDMaskedLogParameter initWithParameterValue:]
  0x000000a5498 -[MSIDMaskedLogParameter initWithParameterValue:isEUII:]
  0x000000a56a0 -[MSIDMaskedLogParameter maskedDescription]
  0x000000a5824 -[MSIDMaskedLogParameter EUIIMaskedDescription]
  0x000000a58b8 -[MSIDMaskedLogParameter parameterValue]
  0x000000a58c0 -[MSIDMaskedLogParameter setParameterValue:]
  0x000000a58cc -[MSIDMaskedLogParameter isEUII]
  0x000000a58d4 -[MSIDMaskedLogParameter setIsEUII:]
  0x000000a58dc -[MSIDMaskedLogParameter maskedParameterValue]
  0x000000a58e4 -[MSIDMaskedLogParameter setMaskedParameterValue:]
  0x000000a58f0 -[MSIDMaskedLogParameter euiiMaskedParameterValue]
  0x000000a58f8 -[MSIDMaskedLogParameter setEuiiMaskedParameterValue:]


0x00000180d08 MSIDAuthority : NSObject /usr/lib/libobjc.A.dylib <NSCopying, MSIDJsonSerializable>
 @property  MSIDOpenIdProviderMetadata *metadata
 @property  NSURL *openIdConfigurationEndpoint
 @property  NSURL *url
 @property  NSString *environment
 @property  NSString *realm
 @property  BOOL isDeveloperKnown
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x000000a5940 +[MSIDAuthority initialize]
  0x000000a59a8 +[MSIDAuthority openIdConfigurationCache]
  0x000000a6790 +[MSIDAuthority isAuthorityFormatValid:context:error:]
  0x000000a6d60 +[MSIDAuthority realmFromURL:context:error:]

  // instance methods
  0x000000a59b4 -[MSIDAuthority initWithURL:validateFormat:context:error:]
  0x000000a5bc4 -[MSIDAuthority initWithURL:context:error:]
  0x000000a5bd4 -[MSIDAuthority resolveAndValidate:userPrincipalName:context:completionBlock:]
  0x000000a602c -[MSIDAuthority networkUrlWithContext:]
  0x000000a6030 -[MSIDAuthority cacheUrlWithContext:]
  0x000000a6034 -[MSIDAuthority cacheEnvironmentWithContext:]
  0x000000a6078 -[MSIDAuthority legacyAccessTokenLookupAuthorities]
  0x000000a6104 -[MSIDAuthority universalAuthorityURL]
  0x000000a6108 -[MSIDAuthority legacyRefreshTokenLookupAliases]
  0x000000a6194 -[MSIDAuthority defaultCacheEnvironmentAliases]
  0x000000a6220 -[MSIDAuthority enrollmentIdForHomeAccountId:legacyUserId:context:error:]
  0x000000a6228 -[MSIDAuthority isKnown]
  0x000000a62e8 -[MSIDAuthority supportsBrokeredAuthentication]
  0x000000a62f0 -[MSIDAuthority excludeFromAuthorityValidation]
  0x000000a62f8 -[MSIDAuthority supportsClientIDAsScope]
  0x000000a6300 -[MSIDAuthority supportsMAMScenarios]
  0x000000a6308 -[MSIDAuthority checkTokenEndpointForRTRefresh:]
  0x000000a6310 -[MSIDAuthority telemetryAuthorityType]
  0x000000a631c -[MSIDAuthority loadOpenIdMetadataWithContext:completionBlock:]
  0x000000a6614 -[MSIDAuthority isSameEnvironmentAsAuthority:]
  0x000000a690c -[MSIDAuthority isEqual:]
  0x000000a6a24 -[MSIDAuthority isEqualToItem:]
  0x000000a6cc0 -[MSIDAuthority copyWithZone:]
  0x000000a6d68 -[MSIDAuthority resolver]
  0x000000a6d70 -[MSIDAuthority authorityWithUpdatedCloudHostInstanceName:error:]
  0x000000a6d78 -[MSIDAuthority initWithJSONDictionary:error:]
  0x000000a6eb4 -[MSIDAuthority jsonDictionary]
  0x000000a7010 -[MSIDAuthority url]
  0x000000a701c -[MSIDAuthority setUrl:]
  0x000000a7024 -[MSIDAuthority environment]
  0x000000a7030 -[MSIDAuthority realm]
  0x000000a703c -[MSIDAuthority openIdConfigurationEndpoint]
  0x000000a7048 -[MSIDAuthority setOpenIdConfigurationEndpoint:]
  0x000000a7050 -[MSIDAuthority metadata]
  0x000000a705c -[MSIDAuthority setMetadata:]
  0x000000a7064 -[MSIDAuthority isDeveloperKnown]
  0x000000a706c -[MSIDAuthority setIsDeveloperKnown:]


0x00000180d58 MSIDAccountMetadataCacheItem : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable, NSCopying, MSIDKeyGenerator>
 @property  NSString *clientId
 @property  MSIDAccountIdentifier *principalAccountId
 @property  NSString *principalAccountEnvironment
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000a70c8 -[MSIDAccountMetadataCacheItem initWithClientId:]
  0x000000a7230 -[MSIDAccountMetadataCacheItem accountMetadataForHomeAccountId:]
  0x000000a72e4 -[MSIDAccountMetadataCacheItem addAccountMetadata:forHomeAccountId:error:]
  0x000000a738c -[MSIDAccountMetadataCacheItem removeAccountMetadataForHomeAccountId:error:]
  0x000000a745c -[MSIDAccountMetadataCacheItem initWithJSONDictionary:error:]
  0x000000a78ac -[MSIDAccountMetadataCacheItem jsonDictionary]
  0x000000a7b38 -[MSIDAccountMetadataCacheItem copyWithZone:]
  0x000000a7d40 -[MSIDAccountMetadataCacheItem isEqual:]
  0x000000a7db4 -[MSIDAccountMetadataCacheItem isEqualToItem:]
  0x000000a7fe0 -[MSIDAccountMetadataCacheItem generateCacheKey]
  0x000000a803c -[MSIDAccountMetadataCacheItem clientId]
  0x000000a8044 -[MSIDAccountMetadataCacheItem principalAccountId]
  0x000000a804c -[MSIDAccountMetadataCacheItem setPrincipalAccountId:]
  0x000000a8058 -[MSIDAccountMetadataCacheItem principalAccountEnvironment]
  0x000000a8060 -[MSIDAccountMetadataCacheItem setPrincipalAccountEnvironment:]


0x00000180da8 MSIDAuthorizationCodeGrantRequest : MSIDTokenRequest
  // instance methods
  0x000000a80b4 -[MSIDAuthorizationCodeGrantRequest initWithEndpoint:authScheme:clientId:scope:redirectUri:code:claims:codeVerifier:extraParameters:ssoContext:context:]


0x00000180e20 MSIDAuthorizationCodeResult : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *authCode
 @property  NSString *pkceVerifier
 @property  NSString *accountIdentifier

  // instance methods
  0x000000a8290 -[MSIDAuthorizationCodeResult authCode]
  0x000000a8298 -[MSIDAuthorizationCodeResult setAuthCode:]
  0x000000a82a4 -[MSIDAuthorizationCodeResult pkceVerifier]
  0x000000a82ac -[MSIDAuthorizationCodeResult setPkceVerifier:]
  0x000000a82b8 -[MSIDAuthorizationCodeResult accountIdentifier]
  0x000000a82c0 -[MSIDAuthorizationCodeResult setAccountIdentifier:]


0x00000180e48 MSIDAADV1WebviewFactory : MSIDAADWebviewFactory
  // instance methods
  0x000000a8308 -[MSIDAADV1WebviewFactory authorizationParametersFromRequestParameters:pkce:requestState:]


0x00000180ec0 MSIDWebAuthNUtil : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x000000a841c +[MSIDWebAuthNUtil amIRunningInExtension]
  0x000000a8428 +[MSIDWebAuthNUtil setAmIRunningInExtension:]


0x00000180f10 MSIDLegacyTokenResponseValidator : MSIDTokenResponseValidator
  // instance methods
  0x000000a8434 -[MSIDLegacyTokenResponseValidator validateTokenResult:configuration:oidcScope:correlationID:error:]
  0x000000a8568 -[MSIDLegacyTokenResponseValidator createTokenResultFromResponse:oauthFactory:configuration:requestAccount:correlationID:error:]
  0x000000a86e4 -[MSIDLegacyTokenResponseValidator validateAccount:tokenResult:correlationID:error:]


0x00000180f38 MSIDAuthenticationScheme : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable, NSCopying>
 @property  long long authScheme
 @property  NSDictionary *schemeParameters
 @property  long long credentialType
 @property  NSString *tokenType
 @property  MSIDAccessToken *accessToken
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000a8d04 -[MSIDAuthenticationScheme init]
  0x000000a8d98 -[MSIDAuthenticationScheme initWithSchemeParameters:]
  0x000000a8e4c -[MSIDAuthenticationScheme authSchemeFromParameters:]
  0x000000a8e54 -[MSIDAuthenticationScheme credentialType]
  0x000000a8e5c -[MSIDAuthenticationScheme tokenType]
  0x000000a8e64 -[MSIDAuthenticationScheme accessToken]
  0x000000a8e80 -[MSIDAuthenticationScheme matchAccessTokenKeyThumbprint:]
  0x000000a8e88 -[MSIDAuthenticationScheme initWithJSONDictionary:error:]
  0x000000a8ed0 -[MSIDAuthenticationScheme jsonDictionary]
  0x000000a8eec -[MSIDAuthenticationScheme copyWithZone:]
  0x000000a8f50 -[MSIDAuthenticationScheme authScheme]
  0x000000a8f58 -[MSIDAuthenticationScheme schemeParameters]


0x00000180fb0 MSIDOauth2Factory : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDWebviewFactory *webviewFactory

  // class methods
  0x000000a8fd8 +[MSIDOauth2Factory providerType]

  // instance methods
  0x000000a9070 -[MSIDOauth2Factory tokenResponseFromJSON:context:error:]
  0x000000a90cc -[MSIDOauth2Factory verifyResponse:context:error:]
  0x000000a9428 -[MSIDOauth2Factory verifyToken:]
  0x000000a9448 -[MSIDOauth2Factory baseTokenFromResponse:configuration:]
  0x000000a94f0 -[MSIDOauth2Factory accessTokenFromResponse:configuration:]
  0x000000a95b0 -[MSIDOauth2Factory legacyAccessTokenFromResponse:configuration:]
  0x000000a9658 -[MSIDOauth2Factory legacyRefreshTokenFromResponse:configuration:]
  0x000000a9700 -[MSIDOauth2Factory refreshTokenFromResponse:configuration:]
  0x000000a97a8 -[MSIDOauth2Factory idTokenFromResponse:configuration:]
  0x000000a9850 -[MSIDOauth2Factory legacyTokenFromResponse:configuration:]
  0x000000a98f8 -[MSIDOauth2Factory accountFromResponse:configuration:]
  0x000000a99a0 -[MSIDOauth2Factory appMetadataFromResponse:configuration:]
  0x000000a9a48 -[MSIDOauth2Factory fillBaseToken:fromResponse:configuration:]
  0x000000a9bf0 -[MSIDOauth2Factory fillAccessToken:fromResponse:configuration:]
  0x000000a9eb8 -[MSIDOauth2Factory fillRefreshToken:fromResponse:configuration:]
  0x000000aa06c -[MSIDOauth2Factory fillIDToken:fromResponse:configuration:]
  0x000000aa1ac -[MSIDOauth2Factory fillLegacyToken:fromResponse:configuration:]
  0x000000aa32c -[MSIDOauth2Factory fillLegacyAccessToken:fromResponse:configuration:]
  0x000000aa484 -[MSIDOauth2Factory fillLegacyRefreshToken:fromResponse:configuration:]
  0x000000aa57c -[MSIDOauth2Factory fillAccount:fromResponse:configuration:]
  0x000000aa8a4 -[MSIDOauth2Factory fillAppMetadata:fromResponse:configuration:]
  0x000000aa97c -[MSIDOauth2Factory webviewFactory]
  0x000000aa9c0 -[MSIDOauth2Factory authorizationGrantRequestWithRequestParameters:codeVerifier:authCode:homeAccountId:]
  0x000000aabd8 -[MSIDOauth2Factory refreshTokenRequestWithRequestParameters:refreshToken:]
  0x000000aad74 -[MSIDOauth2Factory cacheAuthorityWithConfiguration:tokenResponse:]
  0x000000aad7c -[MSIDOauth2Factory accountIdentifierFromResponse:]
  0x000000aae50 -[MSIDOauth2Factory resultAuthorityWithConfiguration:tokenResponse:error:]


0x00000180fd8 MSIDSSOExtensionSignoutController : MSIDSignoutController
 @property  MSIDSSOExtensionSignoutRequest *currentSSORequest
 @property  id sceneNotificationObserver
 @property  BOOL shouldWipeAccount
 @property  BOOL shouldWipeCacheForAllAccounts

  // class methods
  0x000000ab2d0 +[MSIDSSOExtensionSignoutController canPerformRequest]

  // instance methods
  0x000000aaf20 -[MSIDSSOExtensionSignoutController initWithRequestParameters:shouldSignoutFromBrowser:shouldWipeAccount:shouldWipeCacheForAllAccounts:oauthFactory:error:]
  0x000000aafb4 -[MSIDSSOExtensionSignoutController executeRequestWithCompletion:]
  0x000000ab314 -[MSIDSSOExtensionSignoutController shouldWipeAccount]
  0x000000ab324 -[MSIDSSOExtensionSignoutController shouldWipeCacheForAllAccounts]
  0x000000ab334 -[MSIDSSOExtensionSignoutController currentSSORequest]
  0x000000ab344 -[MSIDSSOExtensionSignoutController setCurrentSSORequest:]
  0x000000ab358 -[MSIDSSOExtensionSignoutController sceneNotificationObserver]
  0x000000ab368 -[MSIDSSOExtensionSignoutController setSceneNotificationObserver:]


0x00000181028 MSIDDefaultSilentTokenRequest : MSIDSilentTokenRequest
 @property  MSIDDefaultTokenCacheAccessor *defaultAccessor
 @property  MSIDAccountMetadataCacheAccessor *accountMetadataAccessor
 @property  MSIDAppMetadataCacheItem *appMetadata

  // instance methods
  0x000000ab3bc -[MSIDDefaultSilentTokenRequest initWithRequestParameters:forceRefresh:oauthFactory:tokenResponseValidator:tokenCache:accountMetadataCache:]
  0x000000ab54c -[MSIDDefaultSilentTokenRequest accessTokenWithError:]
  0x000000ab788 -[MSIDDefaultSilentTokenRequest resultWithAccessToken:refreshToken:error:]
  0x000000abd40 -[MSIDDefaultSilentTokenRequest getIDToken:]
  0x000000abd4c -[MSIDDefaultSilentTokenRequest getIDTokenForTokenType:error:]
  0x000000abe50 -[MSIDDefaultSilentTokenRequest familyRefreshTokenWithError:]
  0x000000ac000 -[MSIDDefaultSilentTokenRequest appRefreshTokenWithError:]
  0x000000ac100 -[MSIDDefaultSilentTokenRequest updateFamilyIdCacheWithServerError:cacheError:]
  0x000000ac310 -[MSIDDefaultSilentTokenRequest shouldRemoveRefreshToken:]
  0x000000ac3b4 -[MSIDDefaultSilentTokenRequest tokenCache]
  0x000000ac3b8 -[MSIDDefaultSilentTokenRequest metadataCache]
  0x000000ac3bc -[MSIDDefaultSilentTokenRequest appMetadataWithError:]
  0x000000ac5bc -[MSIDDefaultSilentTokenRequest defaultAccessor]
  0x000000ac5cc -[MSIDDefaultSilentTokenRequest setDefaultAccessor:]
  0x000000ac5e0 -[MSIDDefaultSilentTokenRequest accountMetadataAccessor]
  0x000000ac5f0 -[MSIDDefaultSilentTokenRequest setAccountMetadataAccessor:]
  0x000000ac604 -[MSIDDefaultSilentTokenRequest appMetadata]
  0x000000ac614 -[MSIDDefaultSilentTokenRequest setAppMetadata:]


0x00000181078 MSIDV1IdToken : MSIDIdToken
  // instance methods
  0x000000ac67c -[MSIDV1IdToken tokenCacheItem]
  0x000000ac6fc -[MSIDV1IdToken credentialType]


0x000001810c8 MSIDDefaultTokenRequestProvider : NSObject /usr/lib/libobjc.A.dylib <MSIDTokenRequestProviding>
 @property  MSIDOauth2Factory *oauthFactory
 @property  MSIDDefaultTokenCacheAccessor *tokenCache
 @property  MSIDAccountMetadataCacheAccessor *accountMetadataCache
 @property  MSIDTokenResponseValidator *tokenResponseValidator
 @property  MSIDExternalAADCacheSeeder *externalCacheSeeder
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000ac704 -[MSIDDefaultTokenRequestProvider initWithOauthFactory:defaultAccessor:accountMetadataAccessor:tokenResponseValidator:]
  0x000000ac82c -[MSIDDefaultTokenRequestProvider interactiveTokenRequestWithParameters:]
  0x000000ac99c -[MSIDDefaultTokenRequestProvider silentTokenRequestWithParameters:forceRefresh:]
  0x000000acabc -[MSIDDefaultTokenRequestProvider brokerTokenRequestWithParameters:brokerKey:brokerApplicationToken:sdkCapabilities:error:]
  0x000000acb74 -[MSIDDefaultTokenRequestProvider interactiveSSOExtensionTokenRequestWithParameters:]
  0x000000accbc -[MSIDDefaultTokenRequestProvider silentSSOExtensionTokenRequestWithParameters:forceRefresh:]
  0x000000ace14 -[MSIDDefaultTokenRequestProvider externalCacheSeeder]
  0x000000ace1c -[MSIDDefaultTokenRequestProvider setExternalCacheSeeder:]
  0x000000ace28 -[MSIDDefaultTokenRequestProvider oauthFactory]
  0x000000ace30 -[MSIDDefaultTokenRequestProvider setOauthFactory:]
  0x000000ace3c -[MSIDDefaultTokenRequestProvider tokenCache]
  0x000000ace44 -[MSIDDefaultTokenRequestProvider setTokenCache:]
  0x000000ace50 -[MSIDDefaultTokenRequestProvider accountMetadataCache]
  0x000000ace58 -[MSIDDefaultTokenRequestProvider setAccountMetadataCache:]
  0x000000ace64 -[MSIDDefaultTokenRequestProvider tokenResponseValidator]
  0x000000ace6c -[MSIDDefaultTokenRequestProvider setTokenResponseValidator:]


0x00000181118 MSIDKeychainTokenCache : NSObject /usr/lib/libobjc.A.dylib <MSIDExtendedTokenCacheDataSource>
 @property  NSString *keychainGroup
 @property  NSDictionary *defaultKeychainQuery
 @property  NSDictionary *defaultWipeQuery
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x000000acecc +[MSIDKeychainTokenCache defaultKeychainGroup]
  0x000000aced8 +[MSIDKeychainTokenCache setDefaultKeychainGroup:]
  0x000000ad0dc +[MSIDKeychainTokenCache defaultKeychainCache]

  // instance methods
  0x000000ad148 -[MSIDKeychainTokenCache init]
  0x000000ad158 -[MSIDKeychainTokenCache initWithGroup:error:]
  0x000000ad68c -[MSIDKeychainTokenCache saveToken:key:serializer:context:error:]
  0x000000ada28 -[MSIDKeychainTokenCache tokenWithKey:serializer:context:error:]
  0x000000adbf0 -[MSIDKeychainTokenCache tokensWithKey:serializer:context:error:]
  0x000000add5c -[MSIDKeychainTokenCache saveAccount:key:serializer:context:error:]
  0x000000adfdc -[MSIDKeychainTokenCache accountWithKey:serializer:context:error:]
  0x000000ae0f4 -[MSIDKeychainTokenCache accountsWithKey:serializer:context:error:]
  0x000000ae1a4 -[MSIDKeychainTokenCache saveAppMetadata:key:serializer:context:error:]
  0x000000ae470 -[MSIDKeychainTokenCache appMetadataEntriesWithKey:serializer:context:error:]
  0x000000ae520 -[MSIDKeychainTokenCache jsonObjectsWithKey:serializer:context:error:]
  0x000000ae5d0 -[MSIDKeychainTokenCache saveJsonObject:serializer:key:context:error:]
  0x000000ae830 -[MSIDKeychainTokenCache saveAccountMetadata:key:serializer:context:error:]
  0x000000aea94 -[MSIDKeychainTokenCache accountMetadataWithKey:serializer:context:error:]
  0x000000aebc0 -[MSIDKeychainTokenCache accountsMetadataWithKey:serializer:context:error:]
  0x000000aec70 -[MSIDKeychainTokenCache removeTokensWithKey:context:error:]
  0x000000aecec -[MSIDKeychainTokenCache removeAccountsWithKey:context:error:]
  0x000000aecf0 -[MSIDKeychainTokenCache removeMetadataItemsWithKey:context:error:]
  0x000000aecf4 -[MSIDKeychainTokenCache removeAccountMetadataForKey:context:error:]
  0x000000aecf8 -[MSIDKeychainTokenCache removeItemsWithKey:context:error:]
  0x000000af288 -[MSIDKeychainTokenCache saveWipeInfoWithContext:error:]
  0x000000af9c0 -[MSIDKeychainTokenCache wipeInfo:error:]
  0x000000aff0c -[MSIDKeychainTokenCache keychainGroupLoggingName]
  0x000000aff88 -[MSIDKeychainTokenCache filterTokenItemsFromKeychainItems:serializer:context:]
  0x000000b02c4 -[MSIDKeychainTokenCache overrideTokenKey:]
  0x000000b02dc -[MSIDKeychainTokenCache extractAppKey:]
  0x000000b02e4 -[MSIDKeychainTokenCache deleteTombstoneWithService:account:context:]
  0x000000b04d8 -[MSIDKeychainTokenCache cacheItemsWithKey:serializer:cacheItemClass:context:error:]
  0x000000b07e8 -[MSIDKeychainTokenCache itemsWithKey:context:error:]
  0x000000b0db0 -[MSIDKeychainTokenCache saveData:key:context:error:]
  0x000000b16c4 -[MSIDKeychainTokenCache clearWithContext:error:]
  0x000000b1a18 -[MSIDKeychainTokenCache keychainGroup]
  0x000000b1a24 -[MSIDKeychainTokenCache setKeychainGroup:]
  0x000000b1a2c -[MSIDKeychainTokenCache defaultKeychainQuery]
  0x000000b1a38 -[MSIDKeychainTokenCache setDefaultKeychainQuery:]
  0x000000b1a40 -[MSIDKeychainTokenCache defaultWipeQuery]
  0x000000b1a4c -[MSIDKeychainTokenCache setDefaultWipeQuery:]


0x00000181190 MSIDWorkPlaceJoinUtil : MSIDWorkPlaceJoinUtilBase
  // class methods
  0x000000b1a90 +[MSIDWorkPlaceJoinUtil wpjKeyPairWithSSOContext:tenantId:context:]
  0x000000b1d9c +[MSIDWorkPlaceJoinUtil getRegistrationInformation:workplacejoinChallenge:]
  0x000000b1f1c +[MSIDWorkPlaceJoinUtil findWPJRegistrationInfoWithAuthorities:context:]
  0x000000b243c +[MSIDWorkPlaceJoinUtil copyWPJIdentityWithAuthorities:issuer:privateKeyDict:]
  0x000000b2760 +[MSIDWorkPlaceJoinUtil getWPJStringDataForIdentifier:context:error:]
  0x000000b2770 +[MSIDWorkPlaceJoinUtil getWPJStringDataFromV2ForTenantId:identifier:key:context:error:]


0x000001811b8 MSIDWebResponseBaseOperation : NSObject /usr/lib/libobjc.A.dylib
  // instance methods
  0x000000b2780 -[MSIDWebResponseBaseOperation initWithResponse:error:]
  0x000000b27e0 -[MSIDWebResponseBaseOperation invokeWithInteractiveTokenRequestParameters:tokenRequestProvider:completion:]
  0x000000b28f0 -[MSIDWebResponseBaseOperation doActionWithCorrelationId:error:]


0x00000181208 MSIDLegacyTokenCacheAccessor : NSObject /usr/lib/libobjc.A.dylib <MSIDCacheAccessor>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000b29e0 -[MSIDLegacyTokenCacheAccessor initWithDataSource:otherCacheAccessors:]
  0x000000b2acc -[MSIDLegacyTokenCacheAccessor saveTokensWithConfiguration:response:factory:context:error:]
  0x000000b2ca0 -[MSIDLegacyTokenCacheAccessor saveSSOStateWithConfiguration:response:factory:context:error:]
  0x000000b2fe0 -[MSIDLegacyTokenCacheAccessor getRefreshTokenWithAccount:familyId:configuration:context:error:]
  0x000000b3248 -[MSIDLegacyTokenCacheAccessor getPrimaryRefreshTokenWithAccount:familyId:configuration:context:error:]
  0x000000b34e0 -[MSIDLegacyTokenCacheAccessor getRefreshableTokenWithAccount:familyId:credentialType:configuration:context:error:]
  0x000000b36c8 -[MSIDLegacyTokenCacheAccessor clearWithContext:error:]
  0x000000b37a8 -[MSIDLegacyTokenCacheAccessor accountsWithAuthority:clientId:familyId:accountIdentifier:context:error:]
  0x000000b4154 -[MSIDLegacyTokenCacheAccessor getAccessTokenForAccount:configuration:context:error:]
  0x000000b4310 -[MSIDLegacyTokenCacheAccessor getSingleResourceTokenForAccount:configuration:context:error:]
  0x000000b44cc -[MSIDLegacyTokenCacheAccessor validateAndRemoveRefreshToken:context:error:]
  0x000000b44d0 -[MSIDLegacyTokenCacheAccessor validateAndRemovePrimaryRefreshToken:context:error:]
  0x000000b44d4 -[MSIDLegacyTokenCacheAccessor validateAndRemoveRefreshableToken:context:error:]
  0x000000b4c28 -[MSIDLegacyTokenCacheAccessor removeAccessToken:context:error:]
  0x000000b4d90 -[MSIDLegacyTokenCacheAccessor clearCacheForAccount:authority:clientId:familyId:context:error:]
  0x000000b5530 -[MSIDLegacyTokenCacheAccessor getLegacyRefreshableTokenForAccountImpl:familyId:credentialType:configuration:context:error:]
  0x000000b57b4 -[MSIDLegacyTokenCacheAccessor saveAccessTokenWithConfiguration:response:factory:context:error:]
  0x000000b5934 -[MSIDLegacyTokenCacheAccessor saveRefreshToken:configuration:context:error:]
  0x000000b5c20 -[MSIDLegacyTokenCacheAccessor saveRefreshTokenWithConfiguration:response:factory:context:error:]
  0x000000b5d54 -[MSIDLegacyTokenCacheAccessor saveLegacySingleResourceTokenWithConfiguration:response:factory:context:error:]
  0x000000b5ed4 -[MSIDLegacyTokenCacheAccessor saveToken:context:error:]
  0x000000b62d0 -[MSIDLegacyTokenCacheAccessor allTokensWithContext:error:]
  0x000000b64f4 -[MSIDLegacyTokenCacheAccessor removeTokenEnvironment:realm:clientId:target:userId:credentialType:appKey:applicationIdentifier:context:error:]
  0x000000b6810 -[MSIDLegacyTokenCacheAccessor getTokenByLegacyUserId:type:environment:lookupAliases:clientId:resource:appIdentifier:context:error:]


0x00000181258 MSIDKeychainUtil : NSObject /usr/lib/libobjc.A.dylib
 @property  BOOL isAppEntitled
 @property  NSString *applicationBundleIdentifier
 @property  NSString *teamId

  // class methods
  0x000000b6ec4 +[MSIDKeychainUtil sharedInstance]

  // instance methods
  0x000000b6e00 -[MSIDKeychainUtil init]
  0x000000b6f8c -[MSIDKeychainUtil getTeamId]
  0x000000b72d8 -[MSIDKeychainUtil getApplicationBundleIdentifier]
  0x000000b7448 -[MSIDKeychainUtil accessGroup:]
  0x000000b74f8 -[MSIDKeychainUtil teamIdFromSigningInformation:]
  0x000000b750c -[MSIDKeychainUtil appIdPrefixFromSigningInformation:]
  0x000000b7658 -[MSIDKeychainUtil isAppEntitled]
  0x000000b78c0 -[MSIDKeychainUtil teamId]
  0x000000b78cc -[MSIDKeychainUtil setTeamId:]
  0x000000b78d4 -[MSIDKeychainUtil applicationBundleIdentifier]
  0x000000b78e0 -[MSIDKeychainUtil setApplicationBundleIdentifier:]


0x000001812d0 MSIDAADRequestConfigurator : NSObject /usr/lib/libobjc.A.dylib <MSIDHttpRequestConfiguratorProtocol>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000b7918 -[MSIDAADRequestConfigurator configure:]


0x000001812f8 MSIDAADAuthorityMetadataResponseSerializer : MSIDHttpResponseSerializer
  // instance methods
  0x000000b7d20 -[MSIDAADAuthorityMetadataResponseSerializer init]
  0x000000b7db8 -[MSIDAADAuthorityMetadataResponseSerializer responseObjectForResponse:data:context:error:]


0x00000181348 MSIDAuthorizeWebRequestConfiguration : MSIDBaseWebRequestConfiguration
 @property  MSIDPkce *pkce

  // instance methods
  0x000000b8148 -[MSIDAuthorizeWebRequestConfiguration initWithStartURL:endRedirectUri:pkce:state:ignoreInvalidState:ssoContext:]
  0x000000b822c -[MSIDAuthorizeWebRequestConfiguration responseWithResultURL:factory:context:error:]
  0x000000b82f0 -[MSIDAuthorizeWebRequestConfiguration pkce]


0x00000181398 MSIDAADAuthorizationCodeGrantRequest : MSIDAuthorizationCodeGrantRequest
  // instance methods
  0x000000b8314 -[MSIDAADAuthorizationCodeGrantRequest initWithEndpoint:authScheme:clientId:enrollmentId:scope:redirectUri:code:claims:codeVerifier:extraParameters:ssoContext:context:]


0x000001813e8 MSIDBrokerOperationResponse : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable>
 @property  NSString *operation
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000b84ac -[MSIDBrokerOperationResponse initWithJSONDictionary:error:]
  0x000000b85b4 -[MSIDBrokerOperationResponse jsonDictionary]
  0x000000b86e0 -[MSIDBrokerOperationResponse operation]
  0x000000b86e8 -[MSIDBrokerOperationResponse setOperation:]


0x00000181460 MSIDHttpResponseSerializer : NSObject /usr/lib/libobjc.A.dylib <MSIDResponseSerialization>
 @property  <MSIDResponseSerialization> *preprocessor
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000b8700 -[MSIDHttpResponseSerializer responseObjectForResponse:data:context:error:]
  0x000000b87e0 -[MSIDHttpResponseSerializer preprocessor]
  0x000000b87e8 -[MSIDHttpResponseSerializer setPreprocessor:]


0x000001814b0 MSIDWPJKeyPairWithCertMock : MSIDWPJKeyPairWithCert
  // instance methods
  0x000000b8800 -[MSIDWPJKeyPairWithCertMock setPrivateKey:]
  0x000000b882c -[MSIDWPJKeyPairWithCertMock setCertIssuer:]


0x00000181500 MSIDExternalSSOContextMock : MSIDExternalSSOContext
 @property  MSIDWPJKeyPairWithCert *mockedKeyPair
 @property  unsigned long wpjCertWithContextCalledCount
 @property  NSURL *mockedTokenEndpointURL

  // instance methods
  0x000000b8844 -[MSIDExternalSSOContextMock wpjKeyPairWithCertWithContext:]
  0x000000b8874 -[MSIDExternalSSOContextMock tokenEndpointURL]
  0x000000b8878 -[MSIDExternalSSOContextMock mockedKeyPair]
  0x000000b8888 -[MSIDExternalSSOContextMock setMockedKeyPair:]
  0x000000b889c -[MSIDExternalSSOContextMock wpjCertWithContextCalledCount]
  0x000000b88ac -[MSIDExternalSSOContextMock setWpjCertWithContextCalledCount:]
  0x000000b88bc -[MSIDExternalSSOContextMock mockedTokenEndpointURL]
  0x000000b88cc -[MSIDExternalSSOContextMock setMockedTokenEndpointURL:]


0x00000181550 MSIDSignoutWebRequestConfiguration : MSIDBaseWebRequestConfiguration
  // instance methods
  0x000000b8920 -[MSIDSignoutWebRequestConfiguration responseWithResultURL:factory:context:error:]


0x00000181578 MSIDB2CIdTokenClaims : MSIDAADV2IdTokenClaims
 @property  NSString *tfp

  // instance methods
  0x000000b8ad0 -[MSIDB2CIdTokenClaims tfp]
  0x000000b8b64 -[MSIDB2CIdTokenClaims initDerivedProperties]
  0x000000b8e50 -[MSIDB2CIdTokenClaims alternativeAccountId]
  0x000000b8e58 -[MSIDB2CIdTokenClaims realm]


0x000001815f0 MSIDAccountTypeHelpers : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x000000b8e5c +[MSIDAccountTypeHelpers accountTypeAsString:]
  0x000000b8e84 +[MSIDAccountTypeHelpers accountTypeFromString:]


0x00000181618 MSIDBrokerResponse : MSIDURLFormObject
 @property  MSIDTokenResponse *tokenResponse
 @property  MSIDAuthority *msidAuthority
 @property  MSIDDeviceInfo *deviceInfo
 @property  NSString *authority
 @property  NSString *clientId
 @property  NSString *redirectUri
 @property  NSString *nestedAuthBrokerClientId
 @property  NSString *applicationToken
 @property  NSString *brokerAppVer
 @property  NSString *validAuthority
 @property  NSString *correlationId
 @property  NSString *errorCode
 @property  NSString *errorDomain
 @property  NSString *target
 @property  BOOL ignoreAccessTokenCache

  // instance methods
  0x000000b8f58 -[MSIDBrokerResponse authority]
  0x000000b8ff8 -[MSIDBrokerResponse clientId]
  0x000000b9098 -[MSIDBrokerResponse redirectUri]
  0x000000b9138 -[MSIDBrokerResponse nestedAuthBrokerClientId]
  0x000000b91d8 -[MSIDBrokerResponse brokerAppVer]
  0x000000b926c -[MSIDBrokerResponse validAuthority]
  0x000000b9300 -[MSIDBrokerResponse correlationId]
  0x000000b93a0 -[MSIDBrokerResponse errorCode]
  0x000000b9434 -[MSIDBrokerResponse errorDomain]
  0x000000b94c8 -[MSIDBrokerResponse applicationToken]
  0x000000b955c -[MSIDBrokerResponse initWithDictionary:error:]
  0x000000b9614 -[MSIDBrokerResponse initDerivedProperties]
  0x000000b96f4 -[MSIDBrokerResponse target]
  0x000000b9710 -[MSIDBrokerResponse ignoreAccessTokenCache]
  0x000000b9750 -[MSIDBrokerResponse tokenResponse]
  0x000000b9760 -[MSIDBrokerResponse setTokenResponse:]
  0x000000b976c -[MSIDBrokerResponse msidAuthority]
  0x000000b977c -[MSIDBrokerResponse setMsidAuthority:]
  0x000000b9788 -[MSIDBrokerResponse deviceInfo]
  0x000000b9798 -[MSIDBrokerResponse setDeviceInfo:]


0x00000181668 MSIDMacLegacyCachePersistenceHandler : MSIDMacACLKeychainAccessor <MSIDMacTokenCacheDelegate>
 @property  NSDictionary *keychainAttributes
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000b9860 -[MSIDMacLegacyCachePersistenceHandler initWithTrustedApplications:accessLabel:attributes:error:]
  0x000000b99b8 -[MSIDMacLegacyCachePersistenceHandler willAccessCache:]
  0x000000b99bc -[MSIDMacLegacyCachePersistenceHandler didAccessCache:]
  0x000000b99c0 -[MSIDMacLegacyCachePersistenceHandler willWriteCache:]
  0x000000b99c4 -[MSIDMacLegacyCachePersistenceHandler didWriteCache:]
  0x000000b9b30 -[MSIDMacLegacyCachePersistenceHandler readAndDeserializeWithCache:]
  0x000000b9d4c -[MSIDMacLegacyCachePersistenceHandler keychainQuery]
  0x000000b9e00 -[MSIDMacLegacyCachePersistenceHandler keychainAttributes]
  0x000000b9e10 -[MSIDMacLegacyCachePersistenceHandler setKeychainAttributes:]


0x000001816b8 MSIDThrottlingModel429 : MSIDThrottlingModelBase
  // class methods
  0x000000b9ff4 +[MSIDThrottlingModel429 isApplicableForTheThrottleModel:]

  // instance methods
  0x000000b9e38 -[MSIDThrottlingModel429 initWithRequest:cacheRecord:errorResponse:datasource:]
  0x000000ba238 -[MSIDThrottlingModel429 shouldThrottleRequest]
  0x000000ba39c -[MSIDThrottlingModel429 createDBCacheRecord]
  0x000000ba610 -[MSIDThrottlingModel429 updateServerTelemetry]


0x00000181708 MSIDOpenIdConfigurationInfoRequest : MSIDHttpRequest
  // instance methods
  0x000000ba614 -[MSIDOpenIdConfigurationInfoRequest initWithEndpoint:context:]


0x00000181758 MSIDBrokerOperationGetSsoCookiesRequest : MSIDBrokerOperationRequest
 @property  NSString *ssoUrl
 @property  MSIDAccountIdentifier *accountIdentifier
 @property  NSString *headerTypes

  // class methods
  0x000000ba7b4 +[MSIDBrokerOperationGetSsoCookiesRequest load]
  0x000000ba804 +[MSIDBrokerOperationGetSsoCookiesRequest operation]

  // instance methods
  0x000000ba814 -[MSIDBrokerOperationGetSsoCookiesRequest initWithJSONDictionary:error:]
  0x000000baa98 -[MSIDBrokerOperationGetSsoCookiesRequest jsonDictionary]
  0x000000bacdc -[MSIDBrokerOperationGetSsoCookiesRequest ssoUrl]
  0x000000bacec -[MSIDBrokerOperationGetSsoCookiesRequest setSsoUrl:]
  0x000000bad00 -[MSIDBrokerOperationGetSsoCookiesRequest accountIdentifier]
  0x000000bad10 -[MSIDBrokerOperationGetSsoCookiesRequest setAccountIdentifier:]
  0x000000bad24 -[MSIDBrokerOperationGetSsoCookiesRequest headerTypes]
  0x000000bad34 -[MSIDBrokerOperationGetSsoCookiesRequest setHeaderTypes:]


0x000001817a8 MSIDAADV1AuthorizationCodeRequest : MSIDAADAuthorizationCodeRequest
  // instance methods
  0x000000bad9c -[MSIDAADV1AuthorizationCodeRequest initWithEndpoint:clientId:redirectUri:scope:loginHint:resource:ssoContext:context:]


0x000001817f8 MSIDSSOExtensionGetAccountsRequest : NSObject /usr/lib/libobjc.A.dylib
 @property  ASAuthorizationController *authorizationController
 @property  @? requestCompletionBlock
 @property  MSIDSSOExtensionOperationRequestDelegate *extensionDelegate
 @property  ASAuthorizationSingleSignOnProvider *ssoProvider
 @property  MSIDRequestParameters *requestParameters
 @property  BOOL returnOnlySignedInAccounts
 @property  NSDate *requestSentDate
 @property  MSIDLastRequestTelemetry *lastRequestTelemetry

  // class methods
  0x000000bb674 +[MSIDSSOExtensionGetAccountsRequest canPerformRequest]

  // instance methods
  0x000000baeb4 -[MSIDSSOExtensionGetAccountsRequest initWithRequestParameters:returnOnlySignedInAccounts:error:]
  0x000000bb370 -[MSIDSSOExtensionGetAccountsRequest executeRequestWithCompletion:]
  0x000000bb5b8 -[MSIDSSOExtensionGetAccountsRequest controllerWithRequest:]
  0x000000bb6b8 -[MSIDSSOExtensionGetAccountsRequest requestParameters]
  0x000000bb6c0 -[MSIDSSOExtensionGetAccountsRequest setRequestParameters:]
  0x000000bb6cc -[MSIDSSOExtensionGetAccountsRequest authorizationController]
  0x000000bb6d4 -[MSIDSSOExtensionGetAccountsRequest setAuthorizationController:]
  0x000000bb6e0 -[MSIDSSOExtensionGetAccountsRequest requestCompletionBlock]
  0x000000bb6e8 -[MSIDSSOExtensionGetAccountsRequest setRequestCompletionBlock:]
  0x000000bb6f0 -[MSIDSSOExtensionGetAccountsRequest extensionDelegate]
  0x000000bb6f8 -[MSIDSSOExtensionGetAccountsRequest setExtensionDelegate:]
  0x000000bb704 -[MSIDSSOExtensionGetAccountsRequest ssoProvider]
  0x000000bb70c -[MSIDSSOExtensionGetAccountsRequest setSsoProvider:]
  0x000000bb718 -[MSIDSSOExtensionGetAccountsRequest returnOnlySignedInAccounts]
  0x000000bb720 -[MSIDSSOExtensionGetAccountsRequest setReturnOnlySignedInAccounts:]
  0x000000bb728 -[MSIDSSOExtensionGetAccountsRequest requestSentDate]
  0x000000bb730 -[MSIDSSOExtensionGetAccountsRequest setRequestSentDate:]
  0x000000bb73c -[MSIDSSOExtensionGetAccountsRequest lastRequestTelemetry]
  0x000000bb744 -[MSIDSSOExtensionGetAccountsRequest setLastRequestTelemetry:]


0x00000181848 MSIDBrokerOperationSilentTokenRequest : MSIDBrokerOperationTokenRequest <MSIDThumbprintCalculatable>
 @property  MSIDAccountIdentifier *accountIdentifier
 @property  NSString *fullRequestThumbprint
 @property  NSString *strictRequestThumbprint
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x000000bb7bc +[MSIDBrokerOperationSilentTokenRequest load]
  0x000000bb80c +[MSIDBrokerOperationSilentTokenRequest tokenRequestWithParameters:providerType:enrollmentIds:mamResources:requestSentDate:]
  0x000000bb900 +[MSIDBrokerOperationSilentTokenRequest operation]
  0x000000bbcb4 +[MSIDBrokerOperationSilentTokenRequest fullRequestThumbprintExcludeParams]
  0x000000bbe20 +[MSIDBrokerOperationSilentTokenRequest strictRequestThumbprintIncludeParams]

  // instance methods
  0x000000bb910 -[MSIDBrokerOperationSilentTokenRequest initWithJSONDictionary:error:]
  0x000000bbaac -[MSIDBrokerOperationSilentTokenRequest jsonDictionary]
  0x000000bbbac -[MSIDBrokerOperationSilentTokenRequest fullRequestThumbprint]
  0x000000bbc30 -[MSIDBrokerOperationSilentTokenRequest strictRequestThumbprint]
  0x000000bbf38 -[MSIDBrokerOperationSilentTokenRequest accountIdentifier]
  0x000000bbf48 -[MSIDBrokerOperationSilentTokenRequest setAccountIdentifier:]


0x00000181898 MSIDIntuneMAMResourcesCache : NSObject /usr/lib/libobjc.A.dylib
 @property  <MSIDIntuneCacheDataSource> *dataSource

  // class methods
  0x000000bc014 +[MSIDIntuneMAMResourcesCache setSharedCache:]
  0x000000bc080 +[MSIDIntuneMAMResourcesCache sharedCache]

  // instance methods
  0x000000bbf70 -[MSIDIntuneMAMResourcesCache initWithDataSource:]
  0x000000bc130 -[MSIDIntuneMAMResourcesCache resourceForAuthority:context:error:]
  0x000000bc36c -[MSIDIntuneMAMResourcesCache setResourcesJsonDictionary:context:error:]
  0x000000bc3f8 -[MSIDIntuneMAMResourcesCache resourcesJsonDictionaryWithContext:error:]
  0x000000bc4ac -[MSIDIntuneMAMResourcesCache clear]
  0x000000bc4e4 -[MSIDIntuneMAMResourcesCache isValid:context:error:]
  0x000000bc994 -[MSIDIntuneMAMResourcesCache dataSource]
  0x000000bc99c -[MSIDIntuneMAMResourcesCache setDataSource:]


0x000001818e8 MSIDAppMetadataCacheKey : MSIDCacheKey <NSCopying>
 @property  NSString *clientId
 @property  NSString *environment
 @property  NSString *familyId
 @property  long long generalType

  // instance methods
  0x000000bc9b4 -[MSIDAppMetadataCacheKey serviceWithType:clientId:]
  0x000000bca70 -[MSIDAppMetadataCacheKey generalTypeNumber:]
  0x000000bca80 -[MSIDAppMetadataCacheKey initWithClientId:environment:familyId:generalType:]
  0x000000bcba4 -[MSIDAppMetadataCacheKey generic]
  0x000000bcbec -[MSIDAppMetadataCacheKey type]
  0x000000bcc14 -[MSIDAppMetadataCacheKey account]
  0x000000bcc18 -[MSIDAppMetadataCacheKey service]
  0x000000bcc80 -[MSIDAppMetadataCacheKey copyWithZone:]
  0x000000bcd3c -[MSIDAppMetadataCacheKey clientId]
  0x000000bcd4c -[MSIDAppMetadataCacheKey setClientId:]
  0x000000bcd60 -[MSIDAppMetadataCacheKey environment]
  0x000000bcd70 -[MSIDAppMetadataCacheKey setEnvironment:]
  0x000000bcd84 -[MSIDAppMetadataCacheKey familyId]
  0x000000bcd94 -[MSIDAppMetadataCacheKey setFamilyId:]
  0x000000bcda8 -[MSIDAppMetadataCacheKey generalType]
  0x000000bcdb8 -[MSIDAppMetadataCacheKey setGeneralType:]


0x00000181938 MSIDAADV2Oauth2Factory : MSIDAADOauth2Factory
  // class methods
  0x000000bce1c +[MSIDAADV2Oauth2Factory providerType]

  // instance methods
  0x000000bce24 -[MSIDAADV2Oauth2Factory checkResponseClass:context:error:]
  0x000000bcf50 -[MSIDAADV2Oauth2Factory tokenResponseFromJSON:context:error:]
  0x000000bcfac -[MSIDAADV2Oauth2Factory tokenResponseFromJSON:refreshToken:context:error:]
  0x000000bd024 -[MSIDAADV2Oauth2Factory verifyResponse:context:error:]
  0x000000bd26c -[MSIDAADV2Oauth2Factory fillAccessToken:fromResponse:configuration:]
  0x000000bd3d4 -[MSIDAADV2Oauth2Factory webviewFactory]
  0x000000bd424 -[MSIDAADV2Oauth2Factory authorizationGrantRequestWithRequestParameters:codeVerifier:authCode:homeAccountId:]
  0x000000bd950 -[MSIDAADV2Oauth2Factory refreshTokenRequestWithRequestParameters:refreshToken:]
  0x000000bddd8 -[MSIDAADV2Oauth2Factory resultAuthorityWithConfiguration:tokenResponse:error:]


0x000001819b0 MSIDSSOExtensionSilentTokenRequestController : MSIDSilentController
  // class methods
  0x000000be2a4 +[MSIDSSOExtensionSilentTokenRequestController canPerformRequest]

  // instance methods
  0x000000bdf24 -[MSIDSSOExtensionSilentTokenRequestController acquireToken:]


0x00000181a00 MSIDDefaultErrorConverter : NSObject /usr/lib/libobjc.A.dylib <MSIDErrorConverting>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000be2e8 -[MSIDDefaultErrorConverter errorWithDomain:code:errorDescription:oauthError:subError:underlyingError:correlationId:userInfo:]
  0x000000be4ec -[MSIDDefaultErrorConverter oauthErrorKey]
  0x000000be4fc -[MSIDDefaultErrorConverter subErrorKey]


0x00000181a28 MSIDThrottlingMetaData : MSIDJsonObject
 @property  NSString *lastRefreshTime

  // instance methods
  0x000000be50c -[MSIDThrottlingMetaData initWithJSONDictionary:error:]
  0x000000be5dc -[MSIDThrottlingMetaData jsonDictionary]
  0x000000be63c -[MSIDThrottlingMetaData lastRefreshTime]
  0x000000be64c -[MSIDThrottlingMetaData setLastRefreshTime:]


0x00000181a78 MSIDBrokerOperationPasskeyCredentialRequest : MSIDBrokerOperationRequest
  // class methods
  0x000000be674 +[MSIDBrokerOperationPasskeyCredentialRequest load]
  0x000000be6c4 +[MSIDBrokerOperationPasskeyCredentialRequest operation]

  // instance methods
  0x000000be6d4 -[MSIDBrokerOperationPasskeyCredentialRequest initWithJSONDictionary:error:]
  0x000000be734 -[MSIDBrokerOperationPasskeyCredentialRequest jsonDictionary]


0x00000181af0 MSIDIntuneApplicationStateManager : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x000000be79c +[MSIDIntuneApplicationStateManager isAppCapableForMAMCA]
  0x000000be7a4 +[MSIDIntuneApplicationStateManager intuneApplicationIdentifierForAuthority:appIdentifier:]


0x00000181b18 MSIDTelemetryHttpEvent : MSIDTelemetryBaseEvent
  // class methods
  0x000000bec08 +[MSIDTelemetryHttpEvent propertiesToAggregate]

  // instance methods
  0x000000be810 -[MSIDTelemetryHttpEvent initWithName:requestId:correlationId:]
  0x000000be8e4 -[MSIDTelemetryHttpEvent setHttpMethod:]
  0x000000be8f8 -[MSIDTelemetryHttpEvent setHttpPath:]
  0x000000be90c -[MSIDTelemetryHttpEvent setHttpRequestIdHeader:]
  0x000000be920 -[MSIDTelemetryHttpEvent setHttpResponseCode:]
  0x000000be934 -[MSIDTelemetryHttpEvent setHttpErrorCode:]
  0x000000be984 -[MSIDTelemetryHttpEvent setOAuthErrorCodeFromResponseData:]
  0x000000bea68 -[MSIDTelemetryHttpEvent setHttpResponseMethod:]
  0x000000bea7c -[MSIDTelemetryHttpEvent setHttpRequestQueryParams:]
  0x000000beb48 -[MSIDTelemetryHttpEvent setHttpUserAgent:]
  0x000000beb5c -[MSIDTelemetryHttpEvent setHttpErrorDomain:]
  0x000000beb70 -[MSIDTelemetryHttpEvent setClientTelemetry:]


0x00000181b68 MSIDWebOpenBrowserResponseOperation : MSIDWebResponseBaseOperation
 @property  NSURL *browserURL

  // instance methods
  0x000000bede8 -[MSIDWebOpenBrowserResponseOperation initWithResponse:error:]
  0x000000bf010 -[MSIDWebOpenBrowserResponseOperation doActionWithCorrelationId:error:]
  0x000000bf0ec -[MSIDWebOpenBrowserResponseOperation browserURL]
  0x000000bf0fc -[MSIDWebOpenBrowserResponseOperation setBrowserURL:]


0x00000181bb8 MSIDBrowserNativeMessageGetCookiesResponse : MSIDBrokerNativeAppOperationResponse
 @property  MSIDBrokerOperationGetSsoCookiesResponse *cookiesResponse

  // instance methods
  0x000000bf124 -[MSIDBrowserNativeMessageGetCookiesResponse initWithCookiesResponse:]
  0x000000bf284 -[MSIDBrowserNativeMessageGetCookiesResponse initWithJSONDictionary:error:]
  0x000000bf324 -[MSIDBrowserNativeMessageGetCookiesResponse jsonDictionary]
  0x000000bf6a8 -[MSIDBrowserNativeMessageGetCookiesResponse cookiesResponse]
  0x000000bf6b8 -[MSIDBrowserNativeMessageGetCookiesResponse setCookiesResponse:]


0x00000181c30 MSIDURLSessionDelegate : NSObject /usr/lib/libobjc.A.dylib <NSURLSessionDelegate, NSURLSessionTaskDelegate>
 @property  @? sessionDidReceiveAuthenticationChallengeBlock
 @property  @? taskDidReceiveAuthenticationChallengeBlock
 @property  @? taskWillPerformHTTPRedirectionBlock
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000bfb50 -[MSIDURLSessionDelegate URLSession:didReceiveChallenge:completionHandler:]
  0x000000bfd4c -[MSIDURLSessionDelegate URLSession:task:didReceiveChallenge:completionHandler:]
  0x000000bff28 -[MSIDURLSessionDelegate URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:]
  0x000000c00f8 -[MSIDURLSessionDelegate sessionDidReceiveAuthenticationChallengeBlock]
  0x000000c0100 -[MSIDURLSessionDelegate setSessionDidReceiveAuthenticationChallengeBlock:]
  0x000000c0108 -[MSIDURLSessionDelegate taskDidReceiveAuthenticationChallengeBlock]
  0x000000c0110 -[MSIDURLSessionDelegate setTaskDidReceiveAuthenticationChallengeBlock:]
  0x000000c0118 -[MSIDURLSessionDelegate taskWillPerformHTTPRedirectionBlock]
  0x000000c0120 -[MSIDURLSessionDelegate setTaskWillPerformHTTPRedirectionBlock:]


0x00000181c58 MSIDAuthenticationSchemePop : MSIDAuthenticationScheme
 @property  NSString *kid
 @property  NSString *req_cnf

  // class methods
  0x000000c0164 +[MSIDAuthenticationSchemePop load]

  // instance methods
  0x000000c01b8 -[MSIDAuthenticationSchemePop initWithSchemeParameters:]
  0x000000c063c -[MSIDAuthenticationSchemePop authSchemeFromParameters:]
  0x000000c0740 -[MSIDAuthenticationSchemePop accessToken]
  0x000000c07c8 -[MSIDAuthenticationSchemePop credentialType]
  0x000000c07d0 -[MSIDAuthenticationSchemePop tokenType]
  0x000000c07e4 -[MSIDAuthenticationSchemePop matchAccessTokenKeyThumbprint:]
  0x000000c08bc -[MSIDAuthenticationSchemePop initWithJSONDictionary:error:]
  0x000000c0af0 -[MSIDAuthenticationSchemePop jsonDictionary]
  0x000000c0cfc -[MSIDAuthenticationSchemePop copyWithZone:]
  0x000000c0dc4 -[MSIDAuthenticationSchemePop kid]
  0x000000c0dd4 -[MSIDAuthenticationSchemePop setKid:]
  0x000000c0de8 -[MSIDAuthenticationSchemePop req_cnf]
  0x000000c0df8 -[MSIDAuthenticationSchemePop setReq_cnf:]


0x00000181ca8 MSIDPkeyAuthHelper : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x000000c0e4c +[MSIDPkeyAuthHelper createDeviceAuthResponse:challengeData:externalSSOContext:context:]
  0x000000c1498 +[MSIDPkeyAuthHelper getOrgUnitFromIssuer:]
  0x000000c1658 +[MSIDPkeyAuthHelper isValidIssuer:keychainCertIssuer:]
  0x000000c1894 +[MSIDPkeyAuthHelper createDeviceAuthResponse:nonce:identity:serverSupportedAlgs:]
  0x000000c1db0 +[MSIDPkeyAuthHelper saveTelemetryForAdfsPkeyAuthChallengeForUrl:code:context:]


0x00000181cf8 MSIDAppMetadataCacheQuery : MSIDAppMetadataCacheKey
 @property  BOOL exactMatch
 @property  NSArray *environmentAliases

  // instance methods
  0x000000c1ecc -[MSIDAppMetadataCacheQuery type]
  0x000000c1f54 -[MSIDAppMetadataCacheQuery service]
  0x000000c2008 -[MSIDAppMetadataCacheQuery exactMatch]
  0x000000c2068 -[MSIDAppMetadataCacheQuery environmentAliases]
  0x000000c2078 -[MSIDAppMetadataCacheQuery setEnvironmentAliases:]


0x00000181d48 MSIDRequestPerformanceInfo : NSObject /usr/lib/libobjc.A.dylib <NSSecureCoding>
 @property  NSMutableArray *totalNumbers
 @property  NSMutableArray *ipcRequestNumbers
 @property  NSMutableArray *ipcResponseNumbers

  // class methods
  0x000000c22dc +[MSIDRequestPerformanceInfo supportsSecureCoding]

  // instance methods
  0x000000c20a0 -[MSIDRequestPerformanceInfo encodeWithCoder:]
  0x000000c2164 -[MSIDRequestPerformanceInfo initWithCoder:]
  0x000000c22e4 -[MSIDRequestPerformanceInfo totalNumbers]
  0x000000c22ec -[MSIDRequestPerformanceInfo setTotalNumbers:]
  0x000000c22f8 -[MSIDRequestPerformanceInfo ipcRequestNumbers]
  0x000000c2300 -[MSIDRequestPerformanceInfo setIpcRequestNumbers:]
  0x000000c230c -[MSIDRequestPerformanceInfo ipcResponseNumbers]
  0x000000c2314 -[MSIDRequestPerformanceInfo setIpcResponseNumbers:]


0x00000181d98 MSIDRequestTelemetryErrorInfo : NSObject /usr/lib/libobjc.A.dylib <NSSecureCoding>
 @property  long long apiId
 @property  NSUUID *correlationId
 @property  NSString *error

  // class methods
  0x000000c25b4 +[MSIDRequestTelemetryErrorInfo supportsSecureCoding]

  // instance methods
  0x000000c235c -[MSIDRequestTelemetryErrorInfo encodeWithCoder:]
  0x000000c2424 -[MSIDRequestTelemetryErrorInfo initWithCoder:]
  0x000000c25bc -[MSIDRequestTelemetryErrorInfo apiId]
  0x000000c25c4 -[MSIDRequestTelemetryErrorInfo setApiId:]
  0x000000c25cc -[MSIDRequestTelemetryErrorInfo correlationId]
  0x000000c25d4 -[MSIDRequestTelemetryErrorInfo setCorrelationId:]
  0x000000c25e0 -[MSIDRequestTelemetryErrorInfo error]
  0x000000c25e8 -[MSIDRequestTelemetryErrorInfo setError:]


0x00000181de8 MSIDLastRequestTelemetry : NSObject /usr/lib/libobjc.A.dylib <MSIDTelemetryStringSerializable, NSSecureCoding>
 @property  NSMutableArray *errorsInfo
 @property  long long schemaVersion
 @property  long long silentSuccessfulCount
 @property  NSMutableDictionary *perfTelemetry
 @property  NSMutableArray *platformFields
 @property  NSObject<OS_dispatch_queue> *synchronizationQueue
 @property  MSIDLastRequestTelemetrySerializedItem *telemetrySerializedItem
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x000000c2624 +[MSIDLastRequestTelemetry telemetryStringSizeLimit]
  0x000000c2630 +[MSIDLastRequestTelemetry updateTelemetryStringSizeLimit:]
  0x000000c263c +[MSIDLastRequestTelemetry updateMaxErrorCountToArchive:]
  0x000000c2934 +[MSIDLastRequestTelemetry sharedInstance]
  0x000000c32c8 +[MSIDLastRequestTelemetry supportsSecureCoding]

  // instance methods
  0x000000c2648 -[MSIDLastRequestTelemetry initInternal]
  0x000000c2708 -[MSIDLastRequestTelemetry initFromDisk]
  0x000000c29e4 -[MSIDLastRequestTelemetry updateWithApiId:errorString:context:]
  0x000000c2aac -[MSIDLastRequestTelemetry increaseSilentSuccessfulCount]
  0x000000c2b64 -[MSIDLastRequestTelemetry trackSSOExtensionPerformanceWithType:totalPerfNumber:ipcRequestPerfNumber:ipcResponsePerfNumber:]
  0x000000c2c94 -[MSIDLastRequestTelemetry trackSSOExtensionPerformanceWithTypeImpl:totalPerfNumber:ipcRequestPerfNumber:ipcResponsePerfNumber:]
  0x000000c2f3c -[MSIDLastRequestTelemetry telemetryString]
  0x000000c30a8 -[MSIDLastRequestTelemetry encodeWithCoder:]
  0x000000c312c -[MSIDLastRequestTelemetry initWithCoder:]
  0x000000c32d0 -[MSIDLastRequestTelemetry serializeLastTelemetryString]
  0x000000c3340 -[MSIDLastRequestTelemetry createSerializedItem]
  0x000000c34e4 -[MSIDLastRequestTelemetry serializedPerfTelemetry]
  0x000000c3604 -[MSIDLastRequestTelemetry serializedAverageForType:]
  0x000000c3840 -[MSIDLastRequestTelemetry addErrorInfo:]
  0x000000c3970 -[MSIDLastRequestTelemetry resetTelemetry]
  0x000000c3b28 -[MSIDLastRequestTelemetry saveTelemetryToDisk]
  0x000000c3c64 -[MSIDLastRequestTelemetry initFromDecodedObjectWithSchemaVersion:silentSuccessfulCount:errorsInfo:perfTelemetry:]
  0x000000c3db8 -[MSIDLastRequestTelemetry filePathToSavedTelemetry]
  0x000000c3e04 -[MSIDLastRequestTelemetry errorsInfo]
  0x000000c3f54 -[MSIDLastRequestTelemetry silentSuccessfulCount]
  0x000000c4054 -[MSIDLastRequestTelemetry initializeDispatchQueue]
  0x000000c4108 -[MSIDLastRequestTelemetry initTelemetryFromDiskWithQueue:]
  0x000000c4308 -[MSIDLastRequestTelemetry schemaVersion]
  0x000000c4310 -[MSIDLastRequestTelemetry setSchemaVersion:]
  0x000000c4318 -[MSIDLastRequestTelemetry setSilentSuccessfulCount:]
  0x000000c4320 -[MSIDLastRequestTelemetry setErrorsInfo:]
  0x000000c432c -[MSIDLastRequestTelemetry platformFields]
  0x000000c4334 -[MSIDLastRequestTelemetry setPlatformFields:]
  0x000000c4340 -[MSIDLastRequestTelemetry perfTelemetry]
  0x000000c4348 -[MSIDLastRequestTelemetry setPerfTelemetry:]
  0x000000c4354 -[MSIDLastRequestTelemetry synchronizationQueue]
  0x000000c435c -[MSIDLastRequestTelemetry setSynchronizationQueue:]
  0x000000c4368 -[MSIDLastRequestTelemetry telemetrySerializedItem]
  0x000000c4370 -[MSIDLastRequestTelemetry setTelemetrySerializedItem:]


0x00000181e38 MSIDJsonSerializer : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializing>
 @property  BOOL normalizeJSON
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000c43d0 -[MSIDJsonSerializer init]
  0x000000c443c -[MSIDJsonSerializer toJsonData:context:error:]
  0x000000c44a0 -[MSIDJsonSerializer fromJsonData:ofType:context:error:]
  0x000000c4674 -[MSIDJsonSerializer toJsonString:context:error:]
  0x000000c46d0 -[MSIDJsonSerializer fromJsonString:ofType:context:error:]
  0x000000c4794 -[MSIDJsonSerializer serializeToJsonString:error:]
  0x000000c47f0 -[MSIDJsonSerializer serializeToJsonData:error:]
  0x000000c496c -[MSIDJsonSerializer deserializeFromJSONString:error:]
  0x000000c49d4 -[MSIDJsonSerializer deserializeJSON:error:]
  0x000000c4b04 -[MSIDJsonSerializer normalizeJSON]
  0x000000c4b0c -[MSIDJsonSerializer setNormalizeJSON:]


0x00000181e88 MSIDBrokerOperationGetAccountsResponse : MSIDBrokerNativeAppOperationResponse
 @property  NSArray *accounts

  // class methods
  0x000000c4b14 +[MSIDBrokerOperationGetAccountsResponse load]
  0x000000c4b64 +[MSIDBrokerOperationGetAccountsResponse responseType]

  // instance methods
  0x000000c4b74 -[MSIDBrokerOperationGetAccountsResponse initWithJSONDictionary:error:]
  0x000000c4fc4 -[MSIDBrokerOperationGetAccountsResponse jsonDictionary]
  0x000000c5270 -[MSIDBrokerOperationGetAccountsResponse accounts]
  0x000000c5280 -[MSIDBrokerOperationGetAccountsResponse setAccounts:]


0x00000181f00 MSIDTelemetryPiiOiiRules : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x000000c52a8 +[MSIDTelemetryPiiOiiRules initialize]
  0x000000c5450 +[MSIDTelemetryPiiOiiRules isPii:]
  0x000000c5468 +[MSIDTelemetryPiiOiiRules isOii:]
  0x000000c5480 +[MSIDTelemetryPiiOiiRules isPiiOrOii:]


0x00000181f28 MSIDWebViewPlatformParams : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDExternalSSOContext *externalSSOContext
 @property  {CGRect={CGPoint=dd}{CGSize=dd}} customWindowRect
 @property  BOOL customWindowRectIsSet

  // instance methods
  0x000000c54dc -[MSIDWebViewPlatformParams initWithCoustomWindowRect:]
  0x000000c5570 -[MSIDWebViewPlatformParams initWithExternalSSOContext:]
  0x000000c5618 -[MSIDWebViewPlatformParams initWithExternalSSOContext:customWindowRect:]
  0x000000c56ec -[MSIDWebViewPlatformParams externalSSOContext]
  0x000000c56f4 -[MSIDWebViewPlatformParams customWindowRect]
  0x000000c5700 -[MSIDWebViewPlatformParams customWindowRectIsSet]


0x00000181f78 MSIDLegacyAccessToken : MSIDAccessToken <MSIDLegacyCredentialCacheCompatible>
 @property  NSString *idToken
 @property  NSString *accessTokenType
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000c5714 -[MSIDLegacyAccessToken copyWithZone:]
  0x000000c57dc -[MSIDLegacyAccessToken isEqual:]
  0x000000c592c -[MSIDLegacyAccessToken isEqualToItem:]
  0x000000c5af4 -[MSIDLegacyAccessToken tokenCacheItem]
  0x000000c5b74 -[MSIDLegacyAccessToken initWithLegacyTokenCacheItem:]
  0x000000c5d04 -[MSIDLegacyAccessToken legacyTokenCacheItem]
  0x000000c5fec -[MSIDLegacyAccessToken credentialType]
  0x000000c60ec -[MSIDLegacyAccessToken idToken]
  0x000000c60fc -[MSIDLegacyAccessToken setIdToken:]
  0x000000c6108 -[MSIDLegacyAccessToken accessTokenType]
  0x000000c6118 -[MSIDLegacyAccessToken setAccessTokenType:]


0x00000181fc8 MSIDRegistrationInformation : MSIDWPJKeyPairWithCert
 @property  ^{__SecIdentity=} securityIdentity

  // instance methods
  0x000000c6164 -[MSIDRegistrationInformation initWithIdentity:privateKey:certificate:certificateIssuer:]
  0x000000c6210 -[MSIDRegistrationInformation dealloc]
  0x000000c6294 -[MSIDRegistrationInformation isWorkPlaceJoined]
  0x000000c62b0 -[MSIDRegistrationInformation securityIdentity]


0x00000182018 MSIDAADWebviewFactory : MSIDWebviewFactory
  // instance methods
  0x000000c62c0 -[MSIDAADWebviewFactory authorizationParametersFromRequestParameters:pkce:requestState:]
  0x000000c644c -[MSIDAADWebviewFactory metadataFromRequestParameters:]
  0x000000c660c -[MSIDAADWebviewFactory embeddedWebviewFromConfiguration:customWebview:externalDecidePolicyForBrowserAction:context:]
  0x000000c67d4 -[MSIDAADWebviewFactory oAuthResponseWithURL:requestState:ignoreInvalidState:context:error:]


0x00000182068 MSIDPkce : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSString *codeVerifier
 @property  NSString *codeChallenge
 @property  NSString *codeChallengeMethod

  // class methods
  0x000000c69c0 +[MSIDPkce createCodeVerifier]
  0x000000c69d0 +[MSIDPkce createChallangeFromCodeVerifier:]

  // instance methods
  0x000000c68f0 -[MSIDPkce init]
  0x000000c6a3c -[MSIDPkce codeChallengeMethod]
  0x000000c6a48 -[MSIDPkce copyWithZone:]
  0x000000c6abc -[MSIDPkce codeVerifier]
  0x000000c6ac8 -[MSIDPkce codeChallenge]


0x000001820b8 MSIDAADOAuthEmbeddedWebviewController : MSIDOAuth2EmbeddedWebviewController
  // instance methods
  0x000000c6b04 -[MSIDAADOAuthEmbeddedWebviewController initWithStartURL:endURL:webview:customHeaders:platfromParams:context:]
  0x000000c6c80 -[MSIDAADOAuthEmbeddedWebviewController decidePolicyAADForNavigationAction:decisionHandler:]
  0x000000c6fc8 -[MSIDAADOAuthEmbeddedWebviewController decidePolicyForNavigationAction:webview:decisionHandler:]


0x00000182108 MSIDTokenRequest : MSIDHttpRequest
  // instance methods
  0x000000c70a0 -[MSIDTokenRequest initWithEndpoint:authScheme:clientId:scope:ssoContext:context:]


0x00000182158 MSIDWebviewSession : NSObject /usr/lib/libobjc.A.dylib
 @property  NSObject<MSIDWebviewInteracting> *webviewController
 @property  MSIDWebviewFactory *factory
 @property  MSIDBaseWebRequestConfiguration *webViewConfiguration

  // instance methods
  0x000000c79cc -[MSIDWebviewSession initWithWebviewController:factory:configuration:]
  0x000000c7ac8 -[MSIDWebviewSession webviewController]
  0x000000c7ad0 -[MSIDWebviewSession setWebviewController:]
  0x000000c7adc -[MSIDWebviewSession factory]
  0x000000c7ae4 -[MSIDWebviewSession setFactory:]
  0x000000c7af0 -[MSIDWebviewSession webViewConfiguration]
  0x000000c7af8 -[MSIDWebviewSession setWebViewConfiguration:]


0x000001821d0 MSIDWPJChallengeHandler : NSObject /usr/lib/libobjc.A.dylib <MSIDChallengeHandling>
  // class methods
  0x000000c7b40 +[MSIDWPJChallengeHandler resetHandler]
  0x000000c7b44 +[MSIDWPJChallengeHandler handleChallenge:webview:context:completionHandler:]
  0x000000c7c1c +[MSIDWPJChallengeHandler shouldHandleChallenge:]
  0x000000c7c88 +[MSIDWPJChallengeHandler isWPJChallenge:]
  0x000000c7e14 +[MSIDWPJChallengeHandler handleWPJChallenge:context:completionHandler:]


0x000001821f8 MSIDMacACLKeychainAccessor : NSObject /usr/lib/libobjc.A.dylib
 @property  id accessControlForSharedItems
 @property  id accessControlForNonSharedItems

  // class methods
  0x000000c83c4 +[MSIDMacACLKeychainAccessor setSynchronizationQueue:]
  0x000000c8558 +[MSIDMacACLKeychainAccessor synchronizationQueue]

  // instance methods
  0x000000c816c -[MSIDMacACLKeychainAccessor initWithTrustedApplications:accessLabel:error:]
  0x000000c85dc -[MSIDMacACLKeychainAccessor trustedAppListWithCurrentApp:]
  0x000000c887c -[MSIDMacACLKeychainAccessor accessCreateWithChangeACL:accessLabel:error:]
  0x000000c89f4 -[MSIDMacACLKeychainAccessor accessSetACLTrustedApplications:aclAuthorizationTag:trustedApplications:context:error:]
  0x000000c8d1c -[MSIDMacACLKeychainAccessor createError:domain:errorCode:error:context:]
  0x000000c8e78 -[MSIDMacACLKeychainAccessor saveData:attributes:context:error:]
  0x000000c9398 -[MSIDMacACLKeychainAccessor removeItemWithAttributes:context:error:]
  0x000000c9718 -[MSIDMacACLKeychainAccessor getDataWithAttributes:context:error:]
  0x000000c9bc0 -[MSIDMacACLKeychainAccessor clearWithAttributes:context:error:]
  0x000000ca00c -[MSIDMacACLKeychainAccessor accessControlForSharedItems]
  0x000000ca018 -[MSIDMacACLKeychainAccessor setAccessControlForSharedItems:]
  0x000000ca020 -[MSIDMacACLKeychainAccessor accessControlForNonSharedItems]
  0x000000ca02c -[MSIDMacACLKeychainAccessor setAccessControlForNonSharedItems:]


0x00000182248 MSIDThrottlingModelNonRecoverableServerError : MSIDThrottlingModelBase
  // class methods
  0x000000ca220 +[MSIDThrottlingModelNonRecoverableServerError isApplicableForTheThrottleModel:]

  // instance methods
  0x000000ca064 -[MSIDThrottlingModelNonRecoverableServerError initWithRequest:cacheRecord:errorResponse:datasource:]
  0x000000ca348 -[MSIDThrottlingModelNonRecoverableServerError shouldThrottleRequest]
  0x000000ca628 -[MSIDThrottlingModelNonRecoverableServerError createDBCacheRecord]
  0x000000ca69c -[MSIDThrottlingModelNonRecoverableServerError updateServerTelemetry]


0x000001822c0 MSIDNotifications : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x000000ca6a0 +[MSIDNotifications setWebAuthDidFailNotificationName:]
  0x000000ca6b0 +[MSIDNotifications webAuthDidFailNotificationName]
  0x000000ca6bc +[MSIDNotifications setWebAuthDidCompleteNotificationName:]
  0x000000ca6cc +[MSIDNotifications webAuthDidCompleteNotificationName]
  0x000000ca6d8 +[MSIDNotifications setWebAuthDidStartLoadNotificationName:]
  0x000000ca6e8 +[MSIDNotifications webAuthDidStartLoadNotificationName]
  0x000000ca6f4 +[MSIDNotifications setWebAuthDidFinishLoadNotificationName:]
  0x000000ca704 +[MSIDNotifications webAuthDidFinishLoadNotificationName]
  0x000000ca710 +[MSIDNotifications setWebAuthWillSwitchToBrokerAppNotificationName:]
  0x000000ca720 +[MSIDNotifications webAuthWillSwitchToBrokerAppNotificationName]
  0x000000ca72c +[MSIDNotifications setWebAuthDidReceiveResponseFromBrokerNotificationName:]
  0x000000ca73c +[MSIDNotifications webAuthDidReceiveResponseFromBrokerNotificationName]
  0x000000ca748 +[MSIDNotifications notifyWebAuthDidStartLoad:userInfo:]
  0x000000ca810 +[MSIDNotifications notifyWebAuthDidFinishLoad:userInfo:]
  0x000000ca8d8 +[MSIDNotifications notifyWebAuthDidFailWithError:]
  0x000000ca9d8 +[MSIDNotifications notifyWebAuthDidCompleteWithURL:]
  0x000000caae4 +[MSIDNotifications notifyWebAuthWillSwitchToBroker]
  0x000000cab3c +[MSIDNotifications notifyWebAuthDidReceiveResponseFromBroker:]


0x000001822e8 MSIDTokenResponseSerializer : MSIDHttpResponseSerializer
 @property  MSIDOauth2Factory *oauth2Factory

  // instance methods
  0x000000cac24 -[MSIDTokenResponseSerializer initWithOauth2Factory:]
  0x000000cacf4 -[MSIDTokenResponseSerializer responseObjectForResponse:data:context:error:]
  0x000000caebc -[MSIDTokenResponseSerializer oauth2Factory]
  0x000000caecc -[MSIDTokenResponseSerializer setOauth2Factory:]


0x00000182338 MSIDPrtHeader : MSIDCredentialHeader
 @property  NSString *homeAccountId
 @property  NSString *displayableId

  // instance methods
  0x000000caef4 -[MSIDPrtHeader initWithJSONDictionary:error:]
  0x000000caff4 -[MSIDPrtHeader jsonDictionary]
  0x000000cb224 -[MSIDPrtHeader homeAccountId]
  0x000000cb234 -[MSIDPrtHeader setHomeAccountId:]
  0x000000cb248 -[MSIDPrtHeader displayableId]
  0x000000cb258 -[MSIDPrtHeader setDisplayableId:]


0x00000182388 MSIDWebOAuth2AuthCodeResponse : MSIDWebOAuth2Response
 @property  NSString *authorizationCode
 @property  NSError *oauthError

  // class methods
  0x000000cb4c0 +[MSIDWebOAuth2AuthCodeResponse oauthErrorFromParameters:]

  // instance methods
  0x000000cb2ac -[MSIDWebOAuth2AuthCodeResponse initWithURL:context:error:]
  0x000000cb708 -[MSIDWebOAuth2AuthCodeResponse authorizationCode]
  0x000000cb718 -[MSIDWebOAuth2AuthCodeResponse oauthError]


0x000001823d8 MSIDBrokerOperationGetPasskeyCredentialResponse : MSIDBrokerNativeAppOperationResponse
 @property  MSIDPasskeyCredential *passkeyCredential

  // class methods
  0x000000cb768 +[MSIDBrokerOperationGetPasskeyCredentialResponse load]
  0x000000cb7b8 +[MSIDBrokerOperationGetPasskeyCredentialResponse responseType]

  // instance methods
  0x000000cb7c8 -[MSIDBrokerOperationGetPasskeyCredentialResponse initWithJSONDictionary:error:]
  0x000000cb998 -[MSIDBrokerOperationGetPasskeyCredentialResponse jsonDictionary]
  0x000000cbb20 -[MSIDBrokerOperationGetPasskeyCredentialResponse passkeyCredential]
  0x000000cbb30 -[MSIDBrokerOperationGetPasskeyCredentialResponse setPasskeyCredential:]


0x00000182428 MSIDLastRequestTelemetrySerializedItem : MSIDCurrentRequestTelemetrySerializedItem
 @property  NSArray *errorsInfo
 @property  NSMutableArray *unserializedErrors

  // class methods
  0x000000cbb58 +[MSIDLastRequestTelemetrySerializedItem telemetryStringSizeLimit]
  0x000000cbb64 +[MSIDLastRequestTelemetrySerializedItem setTelemetryStringSizeLimit:]

  // instance methods
  0x000000cbb70 -[MSIDLastRequestTelemetrySerializedItem initWithSchemaVersion:defaultFields:errorInfo:platformFields:]
  0x000000cbc3c -[MSIDLastRequestTelemetrySerializedItem serialize]
  0x000000cbe34 -[MSIDLastRequestTelemetrySerializedItem serializeErrorsInfoWithCurrentStringSize:]
  0x000000cc3a4 -[MSIDLastRequestTelemetrySerializedItem getUnserializedTelemetry]
  0x000000cc3a8 -[MSIDLastRequestTelemetrySerializedItem addRemainingErrorsToUnserializedTelemetry:]
  0x000000cc494 -[MSIDLastRequestTelemetrySerializedItem errorsInfo]
  0x000000cc4a4 -[MSIDLastRequestTelemetrySerializedItem setErrorsInfo:]
  0x000000cc4b8 -[MSIDLastRequestTelemetrySerializedItem unserializedErrors]
  0x000000cc4c8 -[MSIDLastRequestTelemetrySerializedItem setUnserializedErrors:]


0x00000182478 MSIDCacheConfig : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *keychainGroup
 @property  ^{__SecAccess=} accessRef

  // instance methods
  0x000000cc51c -[MSIDCacheConfig initWithKeychainGroup:]
  0x000000cc5c0 -[MSIDCacheConfig initWithKeychainGroup:accessRef:]
  0x000000cc66c -[MSIDCacheConfig keychainGroup]
  0x000000cc674 -[MSIDCacheConfig accessRef]


0x000001824c8 MSIDCredentialCollectionController : NSObject /usr/lib/libobjc.A.dylib
 @property  NSView *customView
 @property  NSTextField *usernameField
 @property  NSSecureTextField *passwordField
 @property  NSTextField *usernameLabel
 @property  NSTextField *passwordLabel

  // instance methods
  0x000000cc99c -[MSIDCredentialCollectionController init]
  0x000000ccc88 -[MSIDCredentialCollectionController customView]
  0x000000ccc94 -[MSIDCredentialCollectionController setCustomView:]
  0x000000ccc9c -[MSIDCredentialCollectionController usernameField]
  0x000000ccca8 -[MSIDCredentialCollectionController setUsernameField:]
  0x000000cccb0 -[MSIDCredentialCollectionController passwordField]
  0x000000cccbc -[MSIDCredentialCollectionController setPasswordField:]
  0x000000cccc4 -[MSIDCredentialCollectionController usernameLabel]
  0x000000cccd0 -[MSIDCredentialCollectionController setUsernameLabel:]
  0x000000cccd8 -[MSIDCredentialCollectionController passwordLabel]
  0x000000ccce4 -[MSIDCredentialCollectionController setPasswordLabel:]


0x00000182518 MSIDDefaultBrokerResponseHandler : MSIDBrokerResponseHandler
  // instance methods
  0x000000ccd40 -[MSIDDefaultBrokerResponseHandler initWithOauthFactory:tokenResponseValidator:]
  0x000000cceac -[MSIDDefaultBrokerResponseHandler brokerResponseFromEncryptedQueryParams:oidcScope:correlationId:authScheme:redirectUri:error:]
  0x000000cd4fc -[MSIDDefaultBrokerResponseHandler cacheAccessorWithKeychainGroup:error:]
  0x000000cd570 -[MSIDDefaultBrokerResponseHandler accountMetadataCacheWithKeychainGroup:error:]
  0x000000cd654 -[MSIDDefaultBrokerResponseHandler resultFromBrokerErrorResponse:tokenResult:decryptedResponse:]
  0x000000cdc40 -[MSIDDefaultBrokerResponseHandler canHandleBrokerResponse:hasCompletionBlock:]


0x00000182568 MSIDAccountCacheItem : NSObject /usr/lib/libobjc.A.dylib <NSCopying, MSIDJsonSerializable, MSIDKeyGenerator>
 @property  NSDictionary *json
 @property  long long accountType
 @property  NSString *homeAccountId
 @property  NSString *environment
 @property  NSString *localAccountId
 @property  NSString *username
 @property  NSString *givenName
 @property  NSString *middleName
 @property  NSString *familyName
 @property  NSString *name
 @property  NSString *realm
 @property  MSIDClientInfo *clientInfo
 @property  NSString *alternativeAccountId
 @property  NSDate *lastModificationTime
 @property  NSString *lastModificationApp
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000097058 -[MSIDAccountCacheItem matchesWithHomeAccountId:environment:environmentAliases:]
  0x000000cde38 -[MSIDAccountCacheItem isEqual:]
  0x000000cdeac -[MSIDAccountCacheItem isEqualToItem:]
  0x000000ce8f4 -[MSIDAccountCacheItem copyWithZone:]
  0x000000cec58 -[MSIDAccountCacheItem initWithJSONDictionary:error:]
  0x000000cf0d4 -[MSIDAccountCacheItem jsonDictionary]
  0x000000cf2d4 -[MSIDAccountCacheItem generateCacheKey]
  0x000000cf3b4 -[MSIDAccountCacheItem accountType]
  0x000000cf3bc -[MSIDAccountCacheItem setAccountType:]
  0x000000cf3c4 -[MSIDAccountCacheItem homeAccountId]
  0x000000cf3d0 -[MSIDAccountCacheItem setHomeAccountId:]
  0x000000cf3d8 -[MSIDAccountCacheItem environment]
  0x000000cf3e4 -[MSIDAccountCacheItem setEnvironment:]
  0x000000cf3ec -[MSIDAccountCacheItem localAccountId]
  0x000000cf3f8 -[MSIDAccountCacheItem setLocalAccountId:]
  0x000000cf400 -[MSIDAccountCacheItem username]
  0x000000cf40c -[MSIDAccountCacheItem setUsername:]
  0x000000cf414 -[MSIDAccountCacheItem givenName]
  0x000000cf420 -[MSIDAccountCacheItem setGivenName:]
  0x000000cf428 -[MSIDAccountCacheItem middleName]
  0x000000cf434 -[MSIDAccountCacheItem setMiddleName:]
  0x000000cf43c -[MSIDAccountCacheItem familyName]
  0x000000cf448 -[MSIDAccountCacheItem setFamilyName:]
  0x000000cf450 -[MSIDAccountCacheItem name]
  0x000000cf45c -[MSIDAccountCacheItem setName:]
  0x000000cf464 -[MSIDAccountCacheItem realm]
  0x000000cf470 -[MSIDAccountCacheItem setRealm:]
  0x000000cf478 -[MSIDAccountCacheItem clientInfo]
  0x000000cf484 -[MSIDAccountCacheItem setClientInfo:]
  0x000000cf48c -[MSIDAccountCacheItem alternativeAccountId]
  0x000000cf498 -[MSIDAccountCacheItem setAlternativeAccountId:]
  0x000000cf4a0 -[MSIDAccountCacheItem lastModificationTime]
  0x000000cf4ac -[MSIDAccountCacheItem setLastModificationTime:]
  0x000000cf4b4 -[MSIDAccountCacheItem lastModificationApp]
  0x000000cf4c0 -[MSIDAccountCacheItem setLastModificationApp:]
  0x000000cf4c8 -[MSIDAccountCacheItem json]
  0x000000cf4d4 -[MSIDAccountCacheItem setJson:]


0x000001825b8 MSIDAADV1RefreshTokenGrantRequest : MSIDAADRefreshTokenGrantRequest
 @property  NSMutableDictionary *thumbprintParameters

  // instance methods
  0x000000cf59c -[MSIDAADV1RefreshTokenGrantRequest initWithEndpoint:authScheme:clientId:scope:refreshToken:redirectUri:resource:extraParameters:ssoContext:context:]
  0x000000cf72c -[MSIDAADV1RefreshTokenGrantRequest fullRequestThumbprint]
  0x000000cf7b0 -[MSIDAADV1RefreshTokenGrantRequest strictRequestThumbprint]
  0x000000cf834 -[MSIDAADV1RefreshTokenGrantRequest thumbprintParameters]
  0x000000cf844 -[MSIDAADV1RefreshTokenGrantRequest setThumbprintParameters:]


0x00000182608 MSIDHttpRequestTelemetry : NSObject /usr/lib/libobjc.A.dylib <MSIDHttpRequestTelemetryHandling>
 @property  MSIDTelemetry *telemetry
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000cf86c -[MSIDHttpRequestTelemetry init]
  0x000000cf904 -[MSIDHttpRequestTelemetry sendRequestEventWithId:]
  0x000000cf960 -[MSIDHttpRequestTelemetry responseReceivedEventWithContext:urlRequest:httpResponse:data:error:]
  0x000000cfd84 -[MSIDHttpRequestTelemetry telemetry]
  0x000000cfd8c -[MSIDHttpRequestTelemetry setTelemetry:]


0x00000182658 MSIDTelemetryUIEvent : MSIDTelemetryBaseEvent
  // class methods
  0x000000cfeb8 +[MSIDTelemetryUIEvent propertiesToAggregate]

  // instance methods
  0x000000cfda4 -[MSIDTelemetryUIEvent initWithName:requestId:correlationId:]
  0x000000cfe60 -[MSIDTelemetryUIEvent setLoginHint:]
  0x000000cfe74 -[MSIDTelemetryUIEvent setNtlm:]
  0x000000cfe88 -[MSIDTelemetryUIEvent setIsCancelled:]


0x000001826a8 MSIDUrlResponse : NSObject /usr/lib/libobjc.A.dylib
 @property  NSHTTPURLResponse *response
 @property  NSData *body

  // instance methods
  0x000000d0060 -[MSIDUrlResponse initWithResponse:body:]
  0x000000d0130 -[MSIDUrlResponse response]
  0x000000d0138 -[MSIDUrlResponse body]


0x000001826f8 MSIDExternalAADCacheSeeder : NSObject /usr/lib/libobjc.A.dylib
 @property  MSIDLegacyTokenCacheAccessor *externalLegacyAccessor
 @property  MSIDDefaultTokenCacheAccessor *defaultAccessor
 @property  MSIDTelemetry *telemetry

  // instance methods
  0x000000d0170 -[MSIDExternalAADCacheSeeder initWithDefaultAccessor:externalLegacyAccessor:]
  0x000000d0264 -[MSIDExternalAADCacheSeeder seedTokenResponse:factory:requestParameters:completionBlock:]
  0x000000d0fe8 -[MSIDExternalAADCacheSeeder seedExternalCacheWithIdToken:tokenResponse:factory:configuration:providedAuthority:context:completionBlock:]
  0x000000d155c -[MSIDExternalAADCacheSeeder externalLegacyAccessor]
  0x000000d1564 -[MSIDExternalAADCacheSeeder setExternalLegacyAccessor:]
  0x000000d1570 -[MSIDExternalAADCacheSeeder defaultAccessor]
  0x000000d1578 -[MSIDExternalAADCacheSeeder setDefaultAccessor:]
  0x000000d1584 -[MSIDExternalAADCacheSeeder telemetry]
  0x000000d158c -[MSIDExternalAADCacheSeeder setTelemetry:]


0x00000182748 MSIDThrottlingModelFactory : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x000000d15d4 +[MSIDThrottlingModelFactory throttlingModelForIncomingRequest:datasource:context:]
  0x000000d18e0 +[MSIDThrottlingModelFactory throttlingModelForResponseWithRequest:datasource:errorResponse:context:]
  0x000000d1a18 +[MSIDThrottlingModelFactory generateModelFromErrorResponse:request:throttleType:cacheRecord:datasource:]
  0x000000d1adc +[MSIDThrottlingModelFactory processErrorResponseToGetThrottleType:]
  0x000000d1c38 +[MSIDThrottlingModelFactory validateInput:]
  0x000000d1cb0 +[MSIDThrottlingModelFactory getDBRecordWithStrictThumbprint:fullThumbprint:error:]


0x00000182798 MSIDSSOExtensionPasskeyAssertionRequest : MSIDSSOExtensionGetDataBaseRequest
 @property  @? requestCompletionBlock
 @property  NSData *clientDataHash
 @property  NSString *relyingPartyId
 @property  NSData *keyId
 @property  NSUUID *correlationId

  // instance methods
  0x000000d1e2c -[MSIDSSOExtensionPasskeyAssertionRequest initWithRequestParameters:clientDataHash:relyingPartyId:keyId:correlationId:error:]
  0x000000d2270 -[MSIDSSOExtensionPasskeyAssertionRequest executeRequestWithCompletion:]
  0x000000d2450 -[MSIDSSOExtensionPasskeyAssertionRequest clientDataHash]
  0x000000d2460 -[MSIDSSOExtensionPasskeyAssertionRequest relyingPartyId]
  0x000000d2470 -[MSIDSSOExtensionPasskeyAssertionRequest setRelyingPartyId:]
  0x000000d2484 -[MSIDSSOExtensionPasskeyAssertionRequest keyId]
  0x000000d2494 -[MSIDSSOExtensionPasskeyAssertionRequest correlationId]
  0x000000d24a4 -[MSIDSSOExtensionPasskeyAssertionRequest requestCompletionBlock]
  0x000000d24b4 -[MSIDSSOExtensionPasskeyAssertionRequest setRequestCompletionBlock:]


0x000001827e8 MSIDURLSessionManager : NSObject /usr/lib/libobjc.A.dylib
 @property  NSURLSessionConfiguration *configuration
 @property  NSURLSession *session

  // class methods
  0x000000d26bc +[MSIDURLSessionManager defaultManager]
  0x000000d2850 +[MSIDURLSessionManager setDefaultManager:]
  0x000000d2860 +[MSIDURLSessionManager timeoutIntervalForResource]
  0x000000d286c +[MSIDURLSessionManager setTimeoutIntervalForResource:]

  // instance methods
  0x000000d253c -[MSIDURLSessionManager initWithConfiguration:delegate:delegateQueue:]
  0x000000d2648 -[MSIDURLSessionManager dealloc]
  0x000000d2878 -[MSIDURLSessionManager configuration]
  0x000000d2880 -[MSIDURLSessionManager session]


0x00000182838 MSIDBrowserNativeMessageGetTokenRequest : MSIDBrowserNativeMessageRequest
 @property  MSIDAccountIdentifier *accountId
 @property  NSString *clientId
 @property  MSIDAADAuthority *authority
 @property  NSString *scopes
 @property  NSString *redirectUri
 @property  long long prompt
 @property  BOOL isSts
 @property  NSString *nonce
 @property  NSString *state
 @property  NSString *loginHint
 @property  BOOL instanceAware
 @property  NSDictionary *extraParameters

  // class methods
  0x000000d28b8 +[MSIDBrowserNativeMessageGetTokenRequest load]
  0x000000d28bc +[MSIDBrowserNativeMessageGetTokenRequest operation]

  // instance methods
  0x000000d28c8 -[MSIDBrowserNativeMessageGetTokenRequest initWithJSONDictionary:error:]
  0x000000d2ef8 -[MSIDBrowserNativeMessageGetTokenRequest jsonDictionary]
  0x000000d2f90 -[MSIDBrowserNativeMessageGetTokenRequest accountId]
  0x000000d2fa0 -[MSIDBrowserNativeMessageGetTokenRequest setAccountId:]
  0x000000d2fb4 -[MSIDBrowserNativeMessageGetTokenRequest clientId]
  0x000000d2fc4 -[MSIDBrowserNativeMessageGetTokenRequest setClientId:]
  0x000000d2fd8 -[MSIDBrowserNativeMessageGetTokenRequest authority]
  0x000000d2fe8 -[MSIDBrowserNativeMessageGetTokenRequest setAuthority:]
  0x000000d2ffc -[MSIDBrowserNativeMessageGetTokenRequest scopes]
  0x000000d300c -[MSIDBrowserNativeMessageGetTokenRequest setScopes:]
  0x000000d3020 -[MSIDBrowserNativeMessageGetTokenRequest redirectUri]
  0x000000d3030 -[MSIDBrowserNativeMessageGetTokenRequest setRedirectUri:]
  0x000000d3044 -[MSIDBrowserNativeMessageGetTokenRequest prompt]
  0x000000d3054 -[MSIDBrowserNativeMessageGetTokenRequest setPrompt:]
  0x000000d3064 -[MSIDBrowserNativeMessageGetTokenRequest isSts]
  0x000000d3074 -[MSIDBrowserNativeMessageGetTokenRequest setIsSts:]
  0x000000d3084 -[MSIDBrowserNativeMessageGetTokenRequest nonce]
  0x000000d3094 -[MSIDBrowserNativeMessageGetTokenRequest setNonce:]
  0x000000d30a8 -[MSIDBrowserNativeMessageGetTokenRequest state]
  0x000000d30b8 -[MSIDBrowserNativeMessageGetTokenRequest setState:]
  0x000000d30cc -[MSIDBrowserNativeMessageGetTokenRequest loginHint]
  0x000000d30dc -[MSIDBrowserNativeMessageGetTokenRequest setLoginHint:]
  0x000000d30f0 -[MSIDBrowserNativeMessageGetTokenRequest instanceAware]
  0x000000d3100 -[MSIDBrowserNativeMessageGetTokenRequest setInstanceAware:]
  0x000000d3110 -[MSIDBrowserNativeMessageGetTokenRequest extraParameters]
  0x000000d3120 -[MSIDBrowserNativeMessageGetTokenRequest setExtraParameters:]


0x00000182888 MSIDIndividualClaimRequestAdditionalInfo : NSObject /usr/lib/libobjc.A.dylib <MSIDJsonSerializable>
 @property  NSNumber *essential
 @property  id value
 @property  NSArray *values
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x000000d330c -[MSIDIndividualClaimRequestAdditionalInfo initWithJSONDictionary:error:]
  0x000000d35e0 -[MSIDIndividualClaimRequestAdditionalInfo jsonDictionary]
  0x000000d3704 -[MSIDIndividualClaimRequestAdditionalInfo essential]
  0x000000d370c -[MSIDIndividualClaimRequestAdditionalInfo setEssential:]
  0x000000d3718 -[MSIDIndividualClaimRequestAdditionalInfo value]
  0x000000d3720 -[MSIDIndividualClaimRequestAdditionalInfo setValue:]
  0x000000d372c -[MSIDIndividualClaimRequestAdditionalInfo values]
  0x000000d3734 -[MSIDIndividualClaimRequestAdditionalInfo setValues:]


0x00000182900 MSIDWPJMetadata : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *certificateThumbprint
 @property  NSString *cloudHost
 @property  NSString *deviceID
 @property  NSString *tenantIdentifier
 @property  NSString *upn

  // instance methods
  0x000000d377c -[MSIDWPJMetadata serializeWithFormat:]
  0x000000d393c -[MSIDWPJMetadata certificateThumbprint]
  0x000000d3944 -[MSIDWPJMetadata setCertificateThumbprint:]
  0x000000d3950 -[MSIDWPJMetadata cloudHost]
  0x000000d3958 -[MSIDWPJMetadata setCloudHost:]
  0x000000d3964 -[MSIDWPJMetadata deviceID]
  0x000000d396c -[MSIDWPJMetadata setDeviceID:]
  0x000000d3978 -[MSIDWPJMetadata tenantIdentifier]
  0x000000d3980 -[MSIDWPJMetadata setTenantIdentifier:]
  0x000000d398c -[MSIDWPJMetadata upn]
  0x000000d3994 -[MSIDWPJMetadata setUpn:]


0x0000015b410 NSError(MSIDServerTelemetryError)
	// instance methods
	0x00400057ad8 -[NSError(MSIDServerTelemetryError) msidErrorWithFilteringOptions:]
	0x00400057c68 -[NSError(MSIDServerTelemetryError) msidErrorConverter]
	0x00400057ca8 -[NSError(MSIDServerTelemetryError) msidOauthError]
	0x00400057d34 -[NSError(MSIDServerTelemetryError) msidSubError]
	0x00400057dc0 -[NSError(MSIDServerTelemetryError) msidGetStatusCodeUserInfoFromUnderlyingErrorCode]
	0x004000568c0 -[NSError(MSIDServerTelemetryError) msidGetRetryDateFromError]
	0x0040005691c -[NSError(MSIDServerTelemetryError) msidIsMSIDError]
	0x00400056960 -[NSError(MSIDServerTelemetryError) msidGetHTTPHeaderValue:]
	0x00400056a34 -[NSError(MSIDServerTelemetryError) msidGetUserInfoValueWithMSIDKey:orMSALKey:]
	0x0040002ce18 -[NSError(MSIDServerTelemetryError) msidServerTelemetryErrorString]

0x0000015bd80 NSData(MSIDExtensions)
	// class methods
	0x00400030f14 +[NSData(MSIDExtensions) msidDataFromBase64UrlEncodedString:]

	// instance methods
	0x00400067ef8 -[NSData(MSIDExtensions) msidSignHashWithPrivateKey:]
	0x004000681e0 -[NSData(MSIDExtensions) msidSetAttributeOnSigner:attributeKey:attributeValue:]
	0x004000357a0 -[NSData(MSIDExtensions) msidAES128DecryptedDataWithKey:keySize:]
	0x00400030e64 -[NSData(MSIDExtensions) msidSHA256]
	0x00400030ef4 -[NSData(MSIDExtensions) msidHexString]
	0x00400030f04 -[NSData(MSIDExtensions) msidBase64UrlEncodedString]
	0x0040003106c -[NSData(MSIDExtensions) msidDecryptedDataWithAlgorithm:privateKey:]

0x0000015d6b0 NSJSONSerialization(MSIDExtensions)
	// class methods
	0x0040003c700 +[NSJSONSerialization(MSIDExtensions) msidNormalizedDictionaryFromJsonData:error:]

0x0000015e5c8 NSKeyedArchiver(MSIDExtensions)
	// class methods
	0x00400041a7c +[NSKeyedArchiver(MSIDExtensions) msidEncodeObject:usingBlock:]
	0x00400041b34 +[NSKeyedArchiver(MSIDExtensions) msidArchivedDataWithRootObject:requiringSecureCoding:error:]

0x00000160dc8 NSString(MSIDExtensions)
	// class methods
	0x004000543b4 +[NSString(MSIDExtensions) msidIsStringNilOrBlank:]
	0x00400054750 +[NSString(MSIDExtensions) msidRandomUrlSafeStringOfByteSize:]
	0x00400054800 +[NSString(MSIDExtensions) msidHexStringFromData:]
	0x004000548b0 +[NSString(MSIDExtensions) msidBase64UrlEncodedStringFromData:]
	0x0040005498c +[NSString(MSIDExtensions) msidURLEncodedStringFromDictionary:]
	0x00400054994 +[NSString(MSIDExtensions) msidWWWFormURLEncodedStringFromDictionary:]
	0x0040005499c +[NSString(MSIDExtensions) msidEncodeStringFromDictionary:formEncode:]
	0x00400055138 +[NSString(MSIDExtensions) msidStringFromOrderedSet:]
	0x00400055254 +[NSString(MSIDExtensions) msidScopeFromResource:]

	// instance methods
	0x004000bf6e0 -[NSString(MSIDExtensions) msidParsedClientTelemetry]
	0x0040005426c -[NSString(MSIDExtensions) msidBase64UrlEncode]
	0x004000542b4 -[NSString(MSIDExtensions) msidBase64UrlDecode]
	0x004000544b0 -[NSString(MSIDExtensions) msidTrimmedString]
	0x00400054508 -[NSString(MSIDExtensions) msidNormalizedString]
	0x0040005454c -[NSString(MSIDExtensions) msidURLDecode]
	0x00400054578 -[NSString(MSIDExtensions) msidWWWFormURLDecode]
	0x004000545cc -[NSString(MSIDExtensions) msidURLEncode]
	0x00400054678 -[NSString(MSIDExtensions) msidWWWFormURLEncode]
	0x004000546cc -[NSString(MSIDExtensions) msidTokenHash]
	0x00400054cf0 -[NSString(MSIDExtensions) msidIsEquivalentWithAnyAlias:]
	0x00400055028 -[NSString(MSIDExtensions) msidHexData]
	0x004000551b8 -[NSString(MSIDExtensions) msidData]
	0x004000551c0 -[NSString(MSIDExtensions) msidScopeSet]
	0x004000551d0 -[NSString(MSIDExtensions) msidJson]
	0x00400055264 -[NSString(MSIDExtensions) msidSecretLoggingHash]
	0x00400055300 -[NSString(MSIDExtensions) msidDomainSuffix]
	0x00400055364 -[NSString(MSIDExtensions) msidSanitizedDomainName]

0x000001620d0 NSBundle(MSIDExtensions)
	// class methods
	0x0040005f940 +[NSBundle(MSIDExtensions) msidAppVersion]

0x000001649e8 NSURL(MSIDAADUtils)
	// class methods
	0x0040006d5d4 +[NSURL(MSIDAADUtils) msidAADURLWithEnvironment:tenant:]
	0x0040006d6bc +[NSURL(MSIDAADUtils) msidAADURLWithEnvironment:]

	// instance methods
	0x004000705a0 -[NSURL(MSIDAADUtils) msidFragmentParameters]
	0x00400070624 -[NSURL(MSIDAADUtils) msidQueryParameters]
	0x004000706a8 -[NSURL(MSIDAADUtils) msidIsEquivalentAuthority:]
	0x00400070784 -[NSURL(MSIDAADUtils) msidIsEquivalentAuthorityHost:]
	0x00400070994 -[NSURL(MSIDAADUtils) msidHostWithPortIfNecessary]
	0x00400070a7c -[NSURL(MSIDAADUtils) msidURLForHost:context:error:]
	0x00400070f54 -[NSURL(MSIDAADUtils) msidURLWithQueryParameters:]
	0x00400071200 -[NSURL(MSIDAADUtils) msidPIINullifiedURL]
	0x0040006d434 -[NSURL(MSIDAADUtils) msidAADTenant]
	0x0040006d4e8 -[NSURL(MSIDAADUtils) msidAADAuthorityWithCloudInstanceHostname:]
	0x0040006d6c8 -[NSURL(MSIDAADUtils) msidContainsPathComponent:]
	0x0040006d7f4 -[NSURL(MSIDAADUtils) msidContainsPathComponents:]
	0x0040006d948 -[NSURL(MSIDAADUtils) msidContainsCaseInsensitivePath:]

0x000001684a8 NSDate(MSIDExtensions)
	// class methods
	0x00400085964 +[NSDate(MSIDExtensions) msidDateFromTimeStamp:]
	0x004000859a8 +[NSDate(MSIDExtensions) msidDateFromRetryHeader:]

	// instance methods
	0x00400085784 -[NSDate(MSIDExtensions) msidToString]
	0x00400085858 -[NSDate(MSIDExtensions) msidDateToTimestamp]
	0x0040008589c -[NSDate(MSIDExtensions) msidDateToFractionalTimestamp:]
	0x004000858e4 -[NSDate(MSIDExtensions) msidIsDateBetween:dateAfter:]

0x00000168578 ASAuthorizationController(MSIDExtensions)
	// instance methods
	0x00400085fe4 -[ASAuthorizationController(MSIDExtensions) msidPerformRequests]

0x0000016a1a8 NSDictionary(MSIDQueryItems)
	// class methods
	0x004000c77a8 +[NSDictionary(MSIDQueryItems) msidSecretRequestKeys]
	0x00400093098 +[NSDictionary(MSIDQueryItems) msidDictionaryFromURLEncodedString:]
	0x004000930a0 +[NSDictionary(MSIDQueryItems) msidDictionaryFromWWWFormURLEncodedString:]
	0x004000930a8 +[NSDictionary(MSIDQueryItems) msidDictionaryFromURLEncodedString:isFormEncoded:]
	0x00400093898 +[NSDictionary(MSIDQueryItems) msidDictionaryFromJSONString:]
	0x0040008f1dc +[NSDictionary(MSIDQueryItems) msidDictionaryFromQueryItems:]

	// instance methods
	0x004000c7800 -[NSDictionary(MSIDQueryItems) msidMaskedRequestDictionary]
	0x00400093438 -[NSDictionary(MSIDQueryItems) msidURLEncode]
	0x00400093448 -[NSDictionary(MSIDQueryItems) msidWWWFormURLEncode]
	0x00400093458 -[NSDictionary(MSIDQueryItems) msidDictionaryByRemovingFields:]
	0x004000934a0 -[NSDictionary(MSIDQueryItems) msidAssertType:ofKey:required:error:]
	0x0040009356c -[NSDictionary(MSIDQueryItems) msidAssertTypeIsOneOf:ofKey:required:error:]
	0x0040009357c -[NSDictionary(MSIDQueryItems) msidAssertTypeIsOneOf:ofKey:required:context:errorCode:error:]
	0x00400093a94 -[NSDictionary(MSIDQueryItems) msidJSONSerializeWithContext:]
	0x00400093c14 -[NSDictionary(MSIDQueryItems) msidDictionaryWithoutNulls]
	0x00400093d90 -[NSDictionary(MSIDQueryItems) msidNormalizedJSONDictionary]
	0x004000940cc -[NSDictionary(MSIDQueryItems) msidStringObjectForKey:]
	0x00400094134 -[NSDictionary(MSIDQueryItems) msidIntegerObjectForKey:]
	0x00400094238 -[NSDictionary(MSIDQueryItems) msidBoolObjectForKey:]
	0x0040009433c -[NSDictionary(MSIDQueryItems) msidObjectForKey:ofClass:]
	0x0040009439c -[NSDictionary(MSIDQueryItems) mutableDeepCopy]
	0x00400091220 -[NSDictionary(MSIDQueryItems) initWithJSONDictionary:error:]
	0x00400091224 -[NSDictionary(MSIDQueryItems) jsonDictionary]
	0x0040008f33c -[NSDictionary(MSIDQueryItems) msidQueryItems]

0x0000016c8e0 NSMutableDictionary(MSIDExtensions)
	// instance methods
	0x004000a29c8 -[NSMutableDictionary(MSIDExtensions) msidSetObjectIfNotNil:forKey:]
	0x004000a29f8 -[NSMutableDictionary(MSIDExtensions) msidSetNonEmptyString:forKey:]

0x0000016f450 NSKeyedUnarchiver(MSIDExtensions)
	// class methods
	0x004000b97f8 +[NSKeyedUnarchiver(MSIDExtensions) msidCreateForReadingFromData:error:]
	0x004000b9854 +[NSKeyedUnarchiver(MSIDExtensions) msidUnarchivedObjectOfClasses:fromData:error:]

0x00000171a58 NSOrderedSet(MSIDExtensions)
	// class methods
	0x004000c72c8 +[NSOrderedSet(MSIDExtensions) msidOrderedSetFromString:]
	0x004000c72d0 +[NSOrderedSet(MSIDExtensions) msidOrderedSetFromString:normalize:]

	// instance methods
	0x004000c72b8 -[NSOrderedSet(MSIDExtensions) msidToString]
	0x004000c74a8 -[NSOrderedSet(MSIDExtensions) normalizedScopeSet]
	0x004000c75f4 -[NSOrderedSet(MSIDExtensions) msidMinusOrderedSet:normalize:]

0x000001724b0 ASAuthorizationSingleSignOnProvider(MSIDExtensions)
	// class methods
	0x004000cc688 +[ASAuthorizationSingleSignOnProvider(MSIDExtensions) msidSharedProvider]
	0x004000cc94c +[ASAuthorizationSingleSignOnProvider(MSIDExtensions) setRequiresUI:forRequest:]

	// instance methods
	0x004000cc6ec -[ASAuthorizationSingleSignOnProvider(MSIDExtensions) createSSORequestWithOperationRequest:requestParameters:requiresUI:error:]

0x00000000000 01 00 0140 /System/Library/Frameworks/AuthenticationServices.framework/Versions/A/AuthenticationServices: ASAuthorizationController 
0x00000000000 01 00 0140 /System/Library/Frameworks/AuthenticationServices.framework/Versions/A/AuthenticationServices: ASAuthorizationSingleSignOnCredential 
0x00000000000 01 00 0140 /System/Library/Frameworks/AuthenticationServices.framework/Versions/A/AuthenticationServices: ASAuthorizationSingleSignOnProvider 
0x00000000000 01 00 0140 /System/Library/Frameworks/AuthenticationServices.framework/Versions/A/AuthenticationServices: ASWebAuthenticationSession 
0x00000000000 01 00 0b00 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSAlert 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSAppleEventManager 
0x00000000000 01 00 0b00 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSApplication 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSArray 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSBundle 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSCachedURLResponse 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSCharacterSet 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSCompoundPredicate 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSConstantArray 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSConstantDictionary 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSConstantDoubleNumber 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSConstantIntegerNumber 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSData 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSDate 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSDateFormatter 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSDictionary 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSError 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSException 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSFileManager 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSHTTPURLResponse 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSJSONSerialization 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSKeyedArchiver 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSKeyedUnarchiver 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSLocale 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSLock 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableArray 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableData 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableDictionary 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableOrderedSet 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableSet 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSMutableString 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSMutableURLRequest 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSNotificationCenter 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSNull 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSNumber 
0x00000000000 01 00 0900 /usr/lib/libobjc.A.dylib: NSObject 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSOperationQueue 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSOrderedSet 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSPredicate 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSProcessInfo 
0x00000000000 01 00 0b00 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSProgressIndicator 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSRegularExpression 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSScanner 
0x00000000000 01 00 0b00 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSScreen 
0x00000000000 01 00 0b00 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSSecureTextField 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSSet 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSString 
0x00000000000 01 00 0b00 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSTextField 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSThread 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSTimeZone 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSTimer 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSURL 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSURLCache 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSURLComponents 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSURLCredential 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSURLQueryItem 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSURLSession 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSURLSessionConfiguration 
0x00000000000 01 00 0800 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSUUID 
0x00000000000 01 00 0c00 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSUserDefaults 
0x00000000000 01 00 0b00 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSView 
0x00000000000 01 00 0b00 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSWindow 
0x00000000000 01 00 0b00 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSWindowController 
0x00000000000 01 00 0b00 /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit: NSWorkspace 
0x00000000000 01 00 0300 /System/Library/Frameworks/SecurityInterface.framework/Versions/A/SecurityInterface: SFChooseIdentityPanel 
0x00000000000 01 00 0500 /System/Library/Frameworks/WebKit.framework/Versions/A/WebKit: WKWebView 
0x00000000000 01 00 0500 /System/Library/Frameworks/WebKit.framework/Versions/A/WebKit: WKWebViewConfiguration 
