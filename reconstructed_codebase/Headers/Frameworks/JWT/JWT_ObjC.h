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

@protocol JWTAlgorithm <NSObject>
 @property  NSString *name

  // instance methods
 -[JWTAlgorithm signHash:key:error:]
 -[JWTAlgorithm verifyHash:signature:key:error:]
 -[JWTAlgorithm encodePayload:withSecret:]
 -[JWTAlgorithm verifySignedInput:withSignature:verificationKey:]
 -[JWTAlgorithm name]

@optional
  // instance methods
 -[JWTAlgorithm encodePayloadData:withSecret:]
 -[JWTAlgorithm verifySignedInput:withSignature:verificationKeyData:]

@end

@protocol JWTAsymmetricKeysAlgorithm <JWTAlgorithm>
 @property  NSString *keyExtractorType
 @property  <JWTCryptoKeyProtocol> *signKey
 @property  <JWTCryptoKeyProtocol> *verifyKey

@optional
  // instance methods
 -[JWTAsymmetricKeysAlgorithm keyExtractorType]
 -[JWTAsymmetricKeysAlgorithm setKeyExtractorType:]
 -[JWTAsymmetricKeysAlgorithm signKey]
 -[JWTAsymmetricKeysAlgorithm setSignKey:]
 -[JWTAsymmetricKeysAlgorithm verifyKey]
 -[JWTAsymmetricKeysAlgorithm setVerifyKey:]

@end

@protocol NSCopying
  // instance methods
 -[NSCopying copyWithZone:]

@end

@protocol JWTRSAlgorithm <JWTAsymmetricKeysAlgorithm, NSCopying>
 @property  NSString *privateKeyCertificatePassphrase

  // instance methods
 -[JWTRSAlgorithm privateKeyCertificatePassphrase]
 -[JWTRSAlgorithm setPrivateKeyCertificatePassphrase:]

@end

@protocol JWTAlgorithmDataHolderProtocol <NSObject, NSCopying>
 @property  NSData *internalSecretData
 @property  <JWTAlgorithm> *internalAlgorithm
 @property  <JWTStringCoder__Protocol> *internalStringCoder

  // instance methods
 -[JWTAlgorithmDataHolderProtocol internalSecretData]
 -[JWTAlgorithmDataHolderProtocol setInternalSecretData:]
 -[JWTAlgorithmDataHolderProtocol internalAlgorithm]
 -[JWTAlgorithmDataHolderProtocol setInternalAlgorithm:]
 -[JWTAlgorithmDataHolderProtocol internalStringCoder]
 -[JWTAlgorithmDataHolderProtocol setInternalStringCoder:]

@end

@protocol JWTAlgorithmDataHolderCreateProtocol <NSObject>
  // class methods
 +[JWTAlgorithmDataHolderCreateProtocol createWithAlgorithm256]
 +[JWTAlgorithmDataHolderCreateProtocol createWithAlgorithm384]
 +[JWTAlgorithmDataHolderCreateProtocol createWithAlgorithm512]

@end

@protocol JWTStringCoder__Protocol <NSObject>
  // instance methods
 -[JWTStringCoder__Protocol stringWithData:]
 -[JWTStringCoder__Protocol dataWithString:]

@end

@protocol JWTCodingResultTypeSuccessEncodedProtocol <NSObject>
 @property  NSString *encoded
 @property  NSString *token

  // instance methods
 -[JWTCodingResultTypeSuccessEncodedProtocol initWithEncoded:]
 -[JWTCodingResultTypeSuccessEncodedProtocol initWithToken:]
 -[JWTCodingResultTypeSuccessEncodedProtocol encoded]
 -[JWTCodingResultTypeSuccessEncodedProtocol token]

@end

@protocol JWTMutableCodingResultTypeSuccessEncodedProtocol <JWTCodingResultTypeSuccessEncodedProtocol>
 @property  NSString *encoded
 @property  NSString *token

  // instance methods
 -[JWTMutableCodingResultTypeSuccessEncodedProtocol encoded]
 -[JWTMutableCodingResultTypeSuccessEncodedProtocol setEncoded:]
 -[JWTMutableCodingResultTypeSuccessEncodedProtocol token]
 -[JWTMutableCodingResultTypeSuccessEncodedProtocol setToken:]

@end

@protocol JWTCodingResultTypeSuccessDecodedProtocol <NSObject>
 @property  NSDictionary *headers
 @property  NSDictionary *payload
 @property  NSDictionary *headerAndPayloadDictionary
 @property  JWTClaimsSet *claimsSet

  // instance methods
 -[JWTCodingResultTypeSuccessDecodedProtocol initWithHeadersAndPayload:]
 -[JWTCodingResultTypeSuccessDecodedProtocol initWithHeaders:withPayload:]
 -[JWTCodingResultTypeSuccessDecodedProtocol initWithClaimsSet:]
 -[JWTCodingResultTypeSuccessDecodedProtocol headers]
 -[JWTCodingResultTypeSuccessDecodedProtocol payload]
 -[JWTCodingResultTypeSuccessDecodedProtocol headerAndPayloadDictionary]
 -[JWTCodingResultTypeSuccessDecodedProtocol claimsSet]

@end

@protocol JWTMutableCodingResultTypeSuccessDecodedProtocol <JWTCodingResultTypeSuccessDecodedProtocol>
 @property  NSDictionary *headers
 @property  NSDictionary *payload
 @property  JWTClaimsSet *claimsSet

  // instance methods
 -[JWTMutableCodingResultTypeSuccessDecodedProtocol headers]
 -[JWTMutableCodingResultTypeSuccessDecodedProtocol setHeaders:]
 -[JWTMutableCodingResultTypeSuccessDecodedProtocol payload]
 -[JWTMutableCodingResultTypeSuccessDecodedProtocol setPayload:]
 -[JWTMutableCodingResultTypeSuccessDecodedProtocol claimsSet]
 -[JWTMutableCodingResultTypeSuccessDecodedProtocol setClaimsSet:]

@end

@protocol JWTCodingResultTypeErrorProtocol <NSObject>
 @property  NSError *error

  // instance methods
 -[JWTCodingResultTypeErrorProtocol initWithError:]
 -[JWTCodingResultTypeErrorProtocol error]

@end

@protocol JWTMutableCodingResultTypeErrorProtocol <JWTCodingResultTypeErrorProtocol>
 @property  NSError *error

  // instance methods
 -[JWTMutableCodingResultTypeErrorProtocol error]
 -[JWTMutableCodingResultTypeErrorProtocol setError:]

@end

@protocol JWTCryptoKey__Generator__Protocol
  // instance methods
 -[JWTCryptoKey__Generator__Protocol initWithData:parameters:error:]
 -[JWTCryptoKey__Generator__Protocol initWithBase64String:parameters:error:]
 -[JWTCryptoKey__Generator__Protocol initWithPemEncoded:parameters:error:]
 -[JWTCryptoKey__Generator__Protocol initWithPemAtURL:parameters:error:]

@end

@protocol JWTCryptoKey__Raw__Generator__Protocol
  // instance methods
 -[JWTCryptoKey__Raw__Generator__Protocol initWithSecKeyRef:]

@end

@protocol JWTCryptoKeyProtocol <NSObject>
 @property  NSString *tag
 @property  ^{__SecKey=} key
 @property  NSData *rawKey

  // instance methods
 -[JWTCryptoKeyProtocol tag]
 -[JWTCryptoKeyProtocol key]
 -[JWTCryptoKeyProtocol rawKey]

@end

@protocol JWTCryptoKeyExtractorProtocol <NSObject>
@optional
  // instance methods
 -[JWTCryptoKeyExtractorProtocol keyFromString:parameters:error:]
 -[JWTCryptoKeyExtractorProtocol keyFromData:parameters:error:]

@end

0x0000002dfd8 PodsDummy_JWT : NSObject /usr/lib/libobjc.A.dylib

0x0000002e028 JWTAlgorithmAsymmetricFamilyErrorDescription : JWTAlgorithmErrorDescription
  // class methods
  0x0000000207c +[JWTAlgorithmAsymmetricFamilyErrorDescription errorDomain]
  0x00000002088 +[JWTAlgorithmAsymmetricFamilyErrorDescription defaultErrorCode]
  0x00000002090 +[JWTAlgorithmAsymmetricFamilyErrorDescription externalErrorCode]
  0x00000002098 +[JWTAlgorithmAsymmetricFamilyErrorDescription codesAndUserDescriptions]
  0x000000021f4 +[JWTAlgorithmAsymmetricFamilyErrorDescription codesAndDescriptions]


0x0000002e050 JWTAlgorithmAsymmetricBase : NSObject /usr/lib/libobjc.A.dylib <JWTRSAlgorithm>
 @property  NSString *privateKeyCertificatePassphrase
 @property  NSString *keyExtractorType
 @property  <JWTCryptoKeyProtocol> *signKey
 @property  <JWTCryptoKeyProtocol> *verifyKey
 @property  NSString *name
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription
 @property  NSNumber *algorithmType
 @property  NSNumber *algorithmNumber
 @property  <JWTCryptoKeyExtractorProtocol> *keyExtractor
 @property  @? setAlgorithmType
 @property  @? setAlgorithmNumber

  // class methods
  0x000000034c8 +[JWTAlgorithmAsymmetricBase withRS]
  0x000000034e4 +[JWTAlgorithmAsymmetricBase withES]
  0x00000003500 +[JWTAlgorithmAsymmetricBase withPS]

  // instance methods
  0x0000000351c -[JWTAlgorithmAsymmetricBase with256]
  0x00000003568 -[JWTAlgorithmAsymmetricBase with384]
  0x000000035b4 -[JWTAlgorithmAsymmetricBase with512]
  0x000000026fc -[JWTAlgorithmAsymmetricBase name]
  0x00000002708 -[JWTAlgorithmAsymmetricBase signHash:key:error:]
  0x00000002710 -[JWTAlgorithmAsymmetricBase verifyHash:signature:key:error:]
  0x00000002718 -[JWTAlgorithmAsymmetricBase encodePayload:withSecret:]
  0x00000002720 -[JWTAlgorithmAsymmetricBase verifySignedInput:withSignature:verificationKey:]
  0x00000002728 -[JWTAlgorithmAsymmetricBase copyWithZone:]
  0x000000026ec -[JWTAlgorithmAsymmetricBase verifyData:signature:key:error:]
  0x000000026f4 -[JWTAlgorithmAsymmetricBase signData:key:error:]
  0x00000002350 -[JWTAlgorithmAsymmetricBase setupFluent]
  0x00000002548 -[JWTAlgorithmAsymmetricBase init]
  0x00000002598 -[JWTAlgorithmAsymmetricBase keyExtractor]
  0x000000025ec -[JWTAlgorithmAsymmetricBase keyExtractorType]
  0x000000025f4 -[JWTAlgorithmAsymmetricBase setKeyExtractorType:]
  0x000000025fc -[JWTAlgorithmAsymmetricBase signKey]
  0x00000002604 -[JWTAlgorithmAsymmetricBase setSignKey:]
  0x00000002610 -[JWTAlgorithmAsymmetricBase verifyKey]
  0x00000002618 -[JWTAlgorithmAsymmetricBase setVerifyKey:]
  0x00000002624 -[JWTAlgorithmAsymmetricBase privateKeyCertificatePassphrase]
  0x0000000262c -[JWTAlgorithmAsymmetricBase setPrivateKeyCertificatePassphrase:]
  0x00000002634 -[JWTAlgorithmAsymmetricBase algorithmType]
  0x0000000263c -[JWTAlgorithmAsymmetricBase setAlgorithmType:]
  0x00000002644 -[JWTAlgorithmAsymmetricBase algorithmNumber]
  0x0000000264c -[JWTAlgorithmAsymmetricBase setAlgorithmNumber:]
  0x00000002654 -[JWTAlgorithmAsymmetricBase setAlgorithmType]
  0x0000000265c -[JWTAlgorithmAsymmetricBase setSetAlgorithmType:]
  0x00000002664 -[JWTAlgorithmAsymmetricBase setAlgorithmNumber]
  0x0000000266c -[JWTAlgorithmAsymmetricBase setSetAlgorithmNumber:]


0x0000002e0c8 JWTAlgorithmAsymmetricBase__Prior10 : JWTAlgorithmAsymmetricBase

0x0000002e118 JWTAlgorithmAsymmetricBase__After10 : JWTAlgorithmAsymmetricBase
 @property  ^{__CFString=} algorithm

  // instance methods
  0x00000002ae8 -[JWTAlgorithmAsymmetricBase__After10 verifyKeyExtractorParameters]
  0x00000002c44 -[JWTAlgorithmAsymmetricBase__After10 signKeyExtractorParameters]
  0x00000002d18 -[JWTAlgorithmAsymmetricBase__After10 removeKeyItem:error:]
  0x00000002da4 -[JWTAlgorithmAsymmetricBase__After10 signHash:key:error:]
  0x00000002f84 -[JWTAlgorithmAsymmetricBase__After10 verifyHash:signature:key:error:]
  0x0000000318c -[JWTAlgorithmAsymmetricBase__After10 encodePayload:withSecret:]
  0x0000000322c -[JWTAlgorithmAsymmetricBase__After10 encodePayloadData:withSecret:]
  0x00000003234 -[JWTAlgorithmAsymmetricBase__After10 verifySignedInput:withSignature:verificationKey:]
  0x000000032d4 -[JWTAlgorithmAsymmetricBase__After10 verifySignedInput:withSignature:verificationKeyData:]
  0x000000029b8 -[JWTAlgorithmAsymmetricBase__After10 signData:key:error:]
  0x00000002a3c -[JWTAlgorithmAsymmetricBase__After10 verifyData:signature:key:error:]
  0x0000000293c -[JWTAlgorithmAsymmetricBase__After10 chooseAlgorithmByType:number:]
  0x00000002948 -[JWTAlgorithmAsymmetricBase__After10 algorithm]


0x0000002e168 JWTAlgorithmAsymmetricBase__FamilyMember : JWTAlgorithmAsymmetricBase__After10
  // instance methods
  0x00000003394 -[JWTAlgorithmAsymmetricBase__FamilyMember stringForAlgorithmNumber:]
  0x000000033b4 -[JWTAlgorithmAsymmetricBase__FamilyMember stringForAlgorithmType:]
  0x000000033d4 -[JWTAlgorithmAsymmetricBase__FamilyMember name]


0x0000002e1b8 JWTAlgorithmAsymmetricBase__FamilyMember__RS : JWTAlgorithmAsymmetricBase__FamilyMember
  // instance methods
  0x00000003498 -[JWTAlgorithmAsymmetricBase__FamilyMember__RS algorithmType]


0x0000002e208 JWTAlgorithmAsymmetricBase__FamilyMember__ES : JWTAlgorithmAsymmetricBase__FamilyMember
  // instance methods
  0x000000034a8 -[JWTAlgorithmAsymmetricBase__FamilyMember__ES algorithmType]


0x0000002e258 JWTAlgorithmAsymmetricBase__FamilyMember__PS : JWTAlgorithmAsymmetricBase__FamilyMember
  // instance methods
  0x000000034b8 -[JWTAlgorithmAsymmetricBase__FamilyMember__PS algorithmType]


0x0000002e280 JWTAlgorithmBaseDataHolder : NSObject /usr/lib/libobjc.A.dylib <JWTAlgorithmDataHolderProtocol>
 @property  @? secret
 @property  @? secretData
 @property  @? algorithm
 @property  @? algorithmName
 @property  @? stringCoder
 @property  @? secret
 @property  @? secretData
 @property  @? algorithm
 @property  @? algorithmName
 @property  @? stringCoder
 @property  NSString *internalSecret
 @property  NSString *internalAlgorithmName
 @property  NSData *internalSecretData
 @property  <JWTAlgorithm> *internalAlgorithm
 @property  <JWTStringCoder__Protocol> *internalStringCoder
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000004178 -[JWTAlgorithmBaseDataHolder initWithAlgorithmName:]
  0x0000000407c -[JWTAlgorithmBaseDataHolder secretData:]
  0x000000040a0 -[JWTAlgorithmBaseDataHolder secret:]
  0x000000040e4 -[JWTAlgorithmBaseDataHolder algorithm:]
  0x00000004108 -[JWTAlgorithmBaseDataHolder algorithmName:]
  0x00000004154 -[JWTAlgorithmBaseDataHolder stringCoder:]
  0x00000003c14 -[JWTAlgorithmBaseDataHolder debugInformation]
  0x000000037cc -[JWTAlgorithmBaseDataHolder setupFluent]
  0x00000003600 -[JWTAlgorithmBaseDataHolder dataFromString:]
  0x000000036d0 -[JWTAlgorithmBaseDataHolder stringFromData:]
  0x00000003dc8 -[JWTAlgorithmBaseDataHolder internalStringCoder]
  0x00000003df4 -[JWTAlgorithmBaseDataHolder internalAlgorithmName]
  0x00000003e38 -[JWTAlgorithmBaseDataHolder internalSecret]
  0x00000003e88 -[JWTAlgorithmBaseDataHolder init]
  0x00000003ed8 -[JWTAlgorithmBaseDataHolder copyWithZone:]
  0x00000003f84 -[JWTAlgorithmBaseDataHolder internalAlgorithm]
  0x00000003f8c -[JWTAlgorithmBaseDataHolder setInternalAlgorithm:]
  0x00000003f98 -[JWTAlgorithmBaseDataHolder internalSecretData]
  0x00000003fa0 -[JWTAlgorithmBaseDataHolder setInternalSecretData:]
  0x00000003fa8 -[JWTAlgorithmBaseDataHolder setInternalStringCoder:]
  0x00000003fb4 -[JWTAlgorithmBaseDataHolder secret]
  0x00000003fbc -[JWTAlgorithmBaseDataHolder setSecret:]
  0x00000003fc4 -[JWTAlgorithmBaseDataHolder secretData]
  0x00000003fcc -[JWTAlgorithmBaseDataHolder setSecretData:]
  0x00000003fd4 -[JWTAlgorithmBaseDataHolder algorithm]
  0x00000003fdc -[JWTAlgorithmBaseDataHolder setAlgorithm:]
  0x00000003fe4 -[JWTAlgorithmBaseDataHolder algorithmName]
  0x00000003fec -[JWTAlgorithmBaseDataHolder setAlgorithmName:]
  0x00000003ff4 -[JWTAlgorithmBaseDataHolder stringCoder]
  0x00000003ffc -[JWTAlgorithmBaseDataHolder setStringCoder:]


0x0000002e2d0 JWTAlgorithmNoneDataHolder : JWTAlgorithmBaseDataHolder
  // instance methods
  0x000000041f8 -[JWTAlgorithmNoneDataHolder init]


0x0000002e348 JWTAlgorithmHSFamilyDataHolder : JWTAlgorithmBaseDataHolder <JWTAlgorithmDataHolderCreateProtocol>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000004284 +[JWTAlgorithmHSFamilyDataHolder createWithAlgorithm256]
  0x000000042a8 +[JWTAlgorithmHSFamilyDataHolder createWithAlgorithm384]
  0x000000042cc +[JWTAlgorithmHSFamilyDataHolder createWithAlgorithm512]


0x0000002e370 JWTAlgorithmRSFamilyDataHolder : JWTAlgorithmBaseDataHolder <JWTAlgorithmDataHolderCreateProtocol>
 @property  @? privateKeyCertificatePassphrase
 @property  @? keyExtractorType
 @property  @? signKey
 @property  @? verifyKey
 @property  NSString *internalPrivateKeyCertificatePassphrase
 @property  NSString *internalKeyExtractorType
 @property  <JWTCryptoKeyProtocol> *internalSignKey
 @property  <JWTCryptoKeyProtocol> *internalVerifyKey
 @property  @? privateKeyCertificatePassphrase
 @property  @? keyExtractorType
 @property  @? signKey
 @property  @? verifyKey
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000004578 +[JWTAlgorithmRSFamilyDataHolder createWithAlgorithm256]
  0x0000000459c +[JWTAlgorithmRSFamilyDataHolder createWithAlgorithm384]
  0x000000045c0 +[JWTAlgorithmRSFamilyDataHolder createWithAlgorithm512]

  // instance methods
  0x00000004d00 -[JWTAlgorithmRSFamilyDataHolder privateKeyCertificatePassphrase:]
  0x00000004d24 -[JWTAlgorithmRSFamilyDataHolder keyExtractorType:]
  0x00000004d48 -[JWTAlgorithmRSFamilyDataHolder signKey:]
  0x00000004d6c -[JWTAlgorithmRSFamilyDataHolder verifyKey:]
  0x000000049a0 -[JWTAlgorithmRSFamilyDataHolder setupFluent]
  0x000000042f0 -[JWTAlgorithmRSFamilyDataHolder debugInformation]
  0x000000044d0 -[JWTAlgorithmRSFamilyDataHolder init]
  0x000000045e4 -[JWTAlgorithmRSFamilyDataHolder internalAlgorithm]
  0x00000004708 -[JWTAlgorithmRSFamilyDataHolder copyWithZone:]
  0x000000047f8 -[JWTAlgorithmRSFamilyDataHolder internalPrivateKeyCertificatePassphrase]
  0x00000004808 -[JWTAlgorithmRSFamilyDataHolder setInternalPrivateKeyCertificatePassphrase:]
  0x00000004814 -[JWTAlgorithmRSFamilyDataHolder internalKeyExtractorType]
  0x00000004824 -[JWTAlgorithmRSFamilyDataHolder setInternalKeyExtractorType:]
  0x00000004830 -[JWTAlgorithmRSFamilyDataHolder internalSignKey]
  0x00000004840 -[JWTAlgorithmRSFamilyDataHolder setInternalSignKey:]
  0x00000004854 -[JWTAlgorithmRSFamilyDataHolder internalVerifyKey]
  0x00000004864 -[JWTAlgorithmRSFamilyDataHolder setInternalVerifyKey:]
  0x00000004878 -[JWTAlgorithmRSFamilyDataHolder privateKeyCertificatePassphrase]
  0x00000004888 -[JWTAlgorithmRSFamilyDataHolder setPrivateKeyCertificatePassphrase:]
  0x00000004894 -[JWTAlgorithmRSFamilyDataHolder keyExtractorType]
  0x000000048a4 -[JWTAlgorithmRSFamilyDataHolder setKeyExtractorType:]
  0x000000048b0 -[JWTAlgorithmRSFamilyDataHolder signKey]
  0x000000048c0 -[JWTAlgorithmRSFamilyDataHolder setSignKey:]
  0x000000048cc -[JWTAlgorithmRSFamilyDataHolder verifyKey]
  0x000000048dc -[JWTAlgorithmRSFamilyDataHolder setVerifyKey:]


0x0000002e3c0 JWTAlgorithmDataHolderChain : NSObject /usr/lib/libobjc.A.dylib
 @property  NSArray *holders

  // class methods
  0x00000005174 +[JWTAlgorithmDataHolderChain chainWithHolders:]
  0x000000051d8 +[JWTAlgorithmDataHolderChain chainWithHolder:]

  // instance methods
  0x000000052f0 -[JWTAlgorithmDataHolderChain firstHolderByAlgorithm:]
  0x00000005480 -[JWTAlgorithmDataHolderChain firstHolderBySecretData:]
  0x000000055c0 -[JWTAlgorithmDataHolderChain singleAlgorithm:withManySecretData:]
  0x00000005768 -[JWTAlgorithmDataHolderChain singleSecretData:withManyAlgorithms:]
  0x000000058e8 -[JWTAlgorithmDataHolderChain chainByPopulatingAlgorithm:withManySecretData:]
  0x00000005980 -[JWTAlgorithmDataHolderChain chainByPopulatingSecretData:withManyAlgorithms:]
  0x00000004d90 -[JWTAlgorithmDataHolderChain holders]
  0x00000004dcc -[JWTAlgorithmDataHolderChain initWithHolders:]
  0x00000004e98 -[JWTAlgorithmDataHolderChain initWithHolder:]
  0x00000004f64 -[JWTAlgorithmDataHolderChain chainByAppendingChain:]
  0x00000005020 -[JWTAlgorithmDataHolderChain chainByAppendingHolders:]
  0x000000050a0 -[JWTAlgorithmDataHolderChain chainByAppendingHolder:]
  0x000000052d8 -[JWTAlgorithmDataHolderChain setHolders:]


0x0000002e410 JWTAlgorithmErrorDescription : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x000000060c8 +[JWTAlgorithmErrorDescription errorDomain]
  0x000000060d0 +[JWTAlgorithmErrorDescription defaultErrorCode]
  0x000000060d8 +[JWTAlgorithmErrorDescription externalCodeForInternalError]
  0x000000060e0 +[JWTAlgorithmErrorDescription codesAndUserDescriptions]
  0x000000060e8 +[JWTAlgorithmErrorDescription codesAndDescriptions]
  0x00000005a18 +[JWTAlgorithmErrorDescription currentErrorDescriptionKey]
  0x00000005a24 +[JWTAlgorithmErrorDescription externalErrorDescriptionKey]
  0x00000005a30 +[JWTAlgorithmErrorDescription userDescriptionForCode:]
  0x00000005b34 +[JWTAlgorithmErrorDescription errorDescriptionForCode:]
  0x00000005c38 +[JWTAlgorithmErrorDescription errorWithCode:userDescription:errorDescription:]
  0x00000005d7c +[JWTAlgorithmErrorDescription errorWithCode:userDescription:errorDescription:externalErrorDescription:]
  0x00000005f04 +[JWTAlgorithmErrorDescription errorWithCode:]
  0x00000005f88 +[JWTAlgorithmErrorDescription errorWithExternalError:]


0x0000002e488 JWTAlgorithmESBase : NSObject /usr/lib/libobjc.A.dylib <JWTAsymmetricKeysAlgorithm>
 @property  NSString *keyExtractorType
 @property  <JWTCryptoKeyProtocol> *signKey
 @property  <JWTCryptoKeyProtocol> *verifyKey
 @property  NSString *name
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000006168 -[JWTAlgorithmESBase name]
  0x00000006174 -[JWTAlgorithmESBase signHash:key:error:]
  0x0000000617c -[JWTAlgorithmESBase verifyHash:signature:key:error:]
  0x00000006184 -[JWTAlgorithmESBase encodePayload:withSecret:]
  0x0000000618c -[JWTAlgorithmESBase verifySignedInput:withSignature:verificationKey:]
  0x00000006164 -[JWTAlgorithmESBase importKey]
  0x000000060f0 -[JWTAlgorithmESBase keyExtractorType]
  0x000000060f8 -[JWTAlgorithmESBase setKeyExtractorType:]
  0x00000006100 -[JWTAlgorithmESBase signKey]
  0x00000006108 -[JWTAlgorithmESBase setSignKey:]
  0x00000006114 -[JWTAlgorithmESBase verifyKey]
  0x0000000611c -[JWTAlgorithmESBase setVerifyKey:]


0x0000002e4d8 JWTAlgorithmFactory : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000006194 +[JWTAlgorithmFactory checkIfSecurityAPIAvailable]
  0x000000061f4 +[JWTAlgorithmFactory algorithms]
  0x0000000653c +[JWTAlgorithmFactory algorithmByName:]


0x0000002e528 JWTAlgorithmHSBase : NSObject /usr/lib/libobjc.A.dylib <JWTAlgorithm>
 @property  unsigned long ccSHANumberDigestLength
 @property  unsigned int ccHmacAlgSHANumber
 @property  NSString *name
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000006b7c +[JWTAlgorithmHSBase algorithm256]
  0x00000006b98 +[JWTAlgorithmHSBase algorithm384]
  0x00000006bb4 +[JWTAlgorithmHSBase algorithm512]

  // instance methods
  0x000000066bc -[JWTAlgorithmHSBase ccSHANumberDigestLength]
  0x000000066f4 -[JWTAlgorithmHSBase ccHmacAlgSHANumber]
  0x0000000672c -[JWTAlgorithmHSBase signHash:key:error:]
  0x00000006830 -[JWTAlgorithmHSBase verifyHash:signature:key:error:]
  0x000000068b4 -[JWTAlgorithmHSBase name]
  0x000000068c0 -[JWTAlgorithmHSBase encodePayload:withSecret:]
  0x0000000695c -[JWTAlgorithmHSBase encodePayloadData:withSecret:]
  0x00000006964 -[JWTAlgorithmHSBase verifySignedInput:withSignature:verificationKey:]
  0x000000069f4 -[JWTAlgorithmHSBase verifySignedInput:withSignature:verificationKeyData:]


0x0000002e578 JWTAlgorithmHSFamilyMember : JWTAlgorithmHSBase

0x0000002e5c8 JWTAlgorithmHS256 : JWTAlgorithmHSBase
  // instance methods
  0x00000006ab8 -[JWTAlgorithmHS256 ccSHANumberDigestLength]
  0x00000006ac0 -[JWTAlgorithmHS256 ccHmacAlgSHANumber]
  0x00000006ac8 -[JWTAlgorithmHS256 name]


0x0000002e618 JWTAlgorithmHS384 : JWTAlgorithmHSBase
  // instance methods
  0x00000006ad4 -[JWTAlgorithmHS384 ccSHANumberDigestLength]
  0x00000006adc -[JWTAlgorithmHS384 ccHmacAlgSHANumber]
  0x00000006ae4 -[JWTAlgorithmHS384 name]


0x0000002e668 JWTAlgorithmHS512 : JWTAlgorithmHSBase
  // instance methods
  0x00000006af0 -[JWTAlgorithmHS512 ccSHANumberDigestLength]
  0x00000006af8 -[JWTAlgorithmHS512 ccHmacAlgSHANumber]
  0x00000006b00 -[JWTAlgorithmHS512 name]


0x0000002e6b8 JWTAlgorithmHSFamilyMemberMutable : JWTAlgorithmHSFamilyMember
 @property  unsigned long ccSHANumberDigestLength
 @property  unsigned int ccHmacAlgSHANumber
 @property  NSString *name

  // instance methods
  0x00000006b0c -[JWTAlgorithmHSFamilyMemberMutable ccSHANumberDigestLength]
  0x00000006b1c -[JWTAlgorithmHSFamilyMemberMutable ccHmacAlgSHANumber]
  0x00000006b2c -[JWTAlgorithmHSFamilyMemberMutable setCcSHANumberDigestLength:]
  0x00000006b3c -[JWTAlgorithmHSFamilyMemberMutable setCcHmacAlgSHANumber:]
  0x00000006b4c -[JWTAlgorithmHSFamilyMemberMutable name]
  0x00000006b5c -[JWTAlgorithmHSFamilyMemberMutable setName:]


0x0000002e708 JWTAlgorithmNone : NSObject /usr/lib/libobjc.A.dylib <JWTAlgorithm>
 @property  NSString *name
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000006bd0 -[JWTAlgorithmNone name]
  0x00000006bdc -[JWTAlgorithmNone signHash:key:error:]
  0x00000006be8 -[JWTAlgorithmNone verifyHash:signature:key:error:]
  0x00000006c7c -[JWTAlgorithmNone encodePayload:withSecret:]
  0x00000006d10 -[JWTAlgorithmNone encodePayloadData:withSecret:]
  0x00000006d18 -[JWTAlgorithmNone verifySignedInput:withSignature:verificationKey:]
  0x00000006da8 -[JWTAlgorithmNone verifySignedInput:withSignature:verificationKeyData:]


0x0000002e758 JWTAlgorithmRSFamilyErrorDescription : JWTAlgorithmErrorDescription
  // class methods
  0x00000006e64 +[JWTAlgorithmRSFamilyErrorDescription errorDomain]
  0x00000006e70 +[JWTAlgorithmRSFamilyErrorDescription defaultErrorCode]
  0x00000006e78 +[JWTAlgorithmRSFamilyErrorDescription externalErrorCode]
  0x00000006e80 +[JWTAlgorithmRSFamilyErrorDescription codesAndUserDescriptions]
  0x0000000700c +[JWTAlgorithmRSFamilyErrorDescription codesAndDescriptions]


0x0000002e7a8 JWTAlgorithmRSBase : NSObject /usr/lib/libobjc.A.dylib <JWTRSAlgorithm>
 @property  <JWTCryptoKeyExtractorProtocol> *keyExtractor
 @property  unsigned long ccSHANumberDigestLength
 @property  unsigned int secPaddingPKCS1SHANumber
 @property  NSString *privateKeyCertificatePassphrase
 @property  NSString *keyExtractorType
 @property  <JWTCryptoKeyProtocol> *signKey
 @property  <JWTCryptoKeyProtocol> *verifyKey
 @property  NSString *name
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x00000008354 +[JWTAlgorithmRSBase algorithm256]
  0x00000008370 +[JWTAlgorithmRSBase algorithm384]
  0x0000000838c +[JWTAlgorithmRSBase algorithm512]
  0x000000083a8 +[JWTAlgorithmRSBase mutableAlgorithm]

  // instance methods
  0x00000007198 -[JWTAlgorithmRSBase copyWithZone:]
  0x00000007298 -[JWTAlgorithmRSBase keyExtractor]
  0x000000072ec -[JWTAlgorithmRSBase ccSHANumberDigestLength]
  0x00000007324 -[JWTAlgorithmRSBase secPaddingPKCS1SHANumber]
  0x0000000735c -[JWTAlgorithmRSBase CC_SHANumberWithData:withLength:withHashBytes:]
  0x00000007364 -[JWTAlgorithmRSBase name]
  0x00000007370 -[JWTAlgorithmRSBase verifyKeyExtractorParameters]
  0x00000007444 -[JWTAlgorithmRSBase signKeyExtractorParameters]
  0x00000007518 -[JWTAlgorithmRSBase removeKeyItem:error:]
  0x000000075a4 -[JWTAlgorithmRSBase signHash:key:error:]
  0x00000007784 -[JWTAlgorithmRSBase verifyHash:signature:key:error:]
  0x0000000798c -[JWTAlgorithmRSBase encodePayload:withSecret:]
  0x00000007a2c -[JWTAlgorithmRSBase encodePayloadData:withSecret:]
  0x00000007a34 -[JWTAlgorithmRSBase verifySignedInput:withSignature:verificationKey:]
  0x00000007ad4 -[JWTAlgorithmRSBase verifySignedInput:withSignature:verificationKeyData:]
  0x00000007b94 -[JWTAlgorithmRSBase verifyData:signature:key:error:]
  0x00000007b9c -[JWTAlgorithmRSBase signData:key:error:]
  0x00000007ba4 -[JWTAlgorithmRSBase privateKeyCertificatePassphrase]
  0x00000007bac -[JWTAlgorithmRSBase setPrivateKeyCertificatePassphrase:]
  0x00000007bb4 -[JWTAlgorithmRSBase keyExtractorType]
  0x00000007bbc -[JWTAlgorithmRSBase setKeyExtractorType:]
  0x00000007bc4 -[JWTAlgorithmRSBase signKey]
  0x00000007bcc -[JWTAlgorithmRSBase setSignKey:]
  0x00000007bd8 -[JWTAlgorithmRSBase verifyKey]
  0x00000007be0 -[JWTAlgorithmRSBase setVerifyKey:]


0x0000002e7f8 JWTAlgorithmRSBaseMac : JWTAlgorithmRSBase
  // instance methods
  0x00000007c34 -[JWTAlgorithmRSBaseMac checkKeyConsistency:]
  0x00000007c6c -[JWTAlgorithmRSBaseMac executeTransform:withInput:withDigestType:withDigestLength:withFalseResult:]
  0x00000007de0 -[JWTAlgorithmRSBaseMac verifyData:signature:key:error:]
  0x00000008000 -[JWTAlgorithmRSBaseMac signData:key:error:]


0x0000002e848 JWTAlgorithmRSFamilyMember : JWTAlgorithmRSBaseMac
  // instance methods
  0x00000008170 -[JWTAlgorithmRSFamilyMember secPaddingPKCS1SHANumber]


0x0000002e898 JWTAlgorithmRS256 : JWTAlgorithmRSFamilyMember
  // instance methods
  0x00000008178 -[JWTAlgorithmRS256 ccSHANumberDigestLength]
  0x00000008180 -[JWTAlgorithmRS256 CC_SHANumberWithData:withLength:withHashBytes:]
  0x00000008190 -[JWTAlgorithmRS256 name]


0x0000002e8e8 JWTAlgorithmRS384 : JWTAlgorithmRSFamilyMember
  // instance methods
  0x0000000819c -[JWTAlgorithmRS384 ccSHANumberDigestLength]
  0x000000081a4 -[JWTAlgorithmRS384 CC_SHANumberWithData:withLength:withHashBytes:]
  0x000000081b4 -[JWTAlgorithmRS384 name]


0x0000002e938 JWTAlgorithmRS512 : JWTAlgorithmRSFamilyMember
  // instance methods
  0x000000081c0 -[JWTAlgorithmRS512 ccSHANumberDigestLength]
  0x000000081c8 -[JWTAlgorithmRS512 CC_SHANumberWithData:withLength:withHashBytes:]
  0x000000081d8 -[JWTAlgorithmRS512 name]


0x0000002e960 JWTAlgorithmRSFamilyMemberMutable : JWTAlgorithmRSFamilyMember
 @property  unsigned long ccSHANumberDigestLength
 @property  unsigned int secPaddingPKCS1SHANumber
 @property  @? ccShaNumberWithData
 @property  NSString *name

  // instance methods
  0x000000081e4 -[JWTAlgorithmRSFamilyMemberMutable ccSHANumberDigestLength]
  0x000000081f4 -[JWTAlgorithmRSFamilyMemberMutable secPaddingPKCS1SHANumber]
  0x00000008204 -[JWTAlgorithmRSFamilyMemberMutable CC_SHANumberWithData:withLength:withHashBytes:]
  0x000000082bc -[JWTAlgorithmRSFamilyMemberMutable setCcSHANumberDigestLength:]
  0x000000082cc -[JWTAlgorithmRSFamilyMemberMutable setSecPaddingPKCS1SHANumber:]
  0x000000082dc -[JWTAlgorithmRSFamilyMemberMutable name]
  0x000000082ec -[JWTAlgorithmRSFamilyMemberMutable setName:]
  0x000000082f8 -[JWTAlgorithmRSFamilyMemberMutable ccShaNumberWithData]
  0x00000008308 -[JWTAlgorithmRSFamilyMemberMutable setCcShaNumberWithData:]


0x0000002e9d8 JWTBase64Coder : NSObject /usr/lib/libobjc.A.dylib <JWTStringCoder__Protocol>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription
 @property  BOOL isBase64String

  // class methods
  0x0000000840c +[JWTBase64Coder withBase64String]
  0x00000008438 +[JWTBase64Coder withPlainString]
  0x00000008464 +[JWTBase64Coder base64UrlEncodedStringWithData:]
  0x000000084d8 +[JWTBase64Coder dataWithBase64UrlEncodedString:]

  // instance methods
  0x0000000857c -[JWTBase64Coder stringWithData:]
  0x000000085d4 -[JWTBase64Coder dataWithString:]
  0x0000000856c -[JWTBase64Coder isBase64String]
  0x00000008574 -[JWTBase64Coder setIsBase64String:]


0x0000002ea28 JWTStringCoder__For__Encoding : NSObject /usr/lib/libobjc.A.dylib <JWTStringCoder__Protocol>
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription
 @property  unsigned long stringEncoding

  // class methods
  0x000000086a4 +[JWTStringCoder__For__Encoding utf8Encoding]

  // instance methods
  0x000000086e0 -[JWTStringCoder__For__Encoding stringWithData:]
  0x0000000874c -[JWTStringCoder__For__Encoding dataWithString:]
  0x000000086d0 -[JWTStringCoder__For__Encoding stringEncoding]
  0x000000086d8 -[JWTStringCoder__For__Encoding setStringEncoding:]


0x0000002eac8 JWTClaimIssuer : JWTClaim
  // class methods
  0x000000087a0 +[JWTClaimIssuer name]
  0x000000087ac +[JWTClaimIssuer verifyValue:withTrustedValue:]


0x0000002eb18 JWTClaimSubject : JWTClaim
  // class methods
  0x000000087b4 +[JWTClaimSubject name]
  0x000000087c0 +[JWTClaimSubject verifyValue:withTrustedValue:]


0x0000002eb68 JWTClaimAudience : JWTClaim
  // class methods
  0x000000087c8 +[JWTClaimAudience name]
  0x000000087d4 +[JWTClaimAudience verifyValue:withTrustedValue:]


0x0000002ebb8 JWTClaimExpirationTime : JWTClaim
  // class methods
  0x000000087dc +[JWTClaimExpirationTime name]
  0x000000087e8 +[JWTClaimExpirationTime verifyValue:withTrustedValue:]


0x0000002ec08 JWTClaimNotBefore : JWTClaim
  // class methods
  0x00000008808 +[JWTClaimNotBefore name]
  0x00000008814 +[JWTClaimNotBefore verifyValue:withTrustedValue:]


0x0000002ec58 JWTClaimIssuedAt : JWTClaim
  // class methods
  0x00000008834 +[JWTClaimIssuedAt name]
  0x00000008840 +[JWTClaimIssuedAt verifyValue:withTrustedValue:]


0x0000002eca8 JWTClaimJWTID : JWTClaim
  // class methods
  0x00000008860 +[JWTClaimJWTID name]
  0x0000000886c +[JWTClaimJWTID verifyValue:withTrustedValue:]


0x0000002ecf8 JWTClaimType : JWTClaim
  // class methods
  0x00000008874 +[JWTClaimType name]
  0x00000008880 +[JWTClaimType verifyValue:withTrustedValue:]


0x0000002ed48 JWTClaimScope : JWTClaim
  // class methods
  0x00000008888 +[JWTClaimScope name]
  0x00000008894 +[JWTClaimScope verifyValue:withTrustedValue:]


0x0000002eaa0 JWTClaim : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000000889c +[JWTClaim name]
  0x000000088a8 +[JWTClaim claimsAndNames]
  0x00000008b88 +[JWTClaim claimByName:]
  0x00000008bf4 +[JWTClaim verifyValue:withTrustedValue:]

  // instance methods
  0x00000008bfc -[JWTClaim verifyValue:withTrustedValue:]


0x0000002ed98 JWTClaimsSet : NSObject /usr/lib/libobjc.A.dylib <NSCopying>
 @property  NSString *issuer
 @property  NSString *subject
 @property  NSString *audience
 @property  NSDate *expirationDate
 @property  NSDate *notBeforeDate
 @property  NSDate *issuedAt
 @property  NSString *identifier
 @property  NSString *type
 @property  NSString *scope

  // instance methods
  0x00000008c68 -[JWTClaimsSet copyWithZone:]
  0x00000008e04 -[JWTClaimsSet issuer]
  0x00000008e0c -[JWTClaimsSet setIssuer:]
  0x00000008e14 -[JWTClaimsSet subject]
  0x00000008e1c -[JWTClaimsSet setSubject:]
  0x00000008e24 -[JWTClaimsSet audience]
  0x00000008e2c -[JWTClaimsSet setAudience:]
  0x00000008e34 -[JWTClaimsSet expirationDate]
  0x00000008e3c -[JWTClaimsSet setExpirationDate:]
  0x00000008e44 -[JWTClaimsSet notBeforeDate]
  0x00000008e4c -[JWTClaimsSet setNotBeforeDate:]
  0x00000008e54 -[JWTClaimsSet issuedAt]
  0x00000008e5c -[JWTClaimsSet setIssuedAt:]
  0x00000008e64 -[JWTClaimsSet identifier]
  0x00000008e6c -[JWTClaimsSet setIdentifier:]
  0x00000008e74 -[JWTClaimsSet type]
  0x00000008e7c -[JWTClaimsSet setType:]
  0x00000008e84 -[JWTClaimsSet scope]
  0x00000008e8c -[JWTClaimsSet setScope:]


0x0000002ede8 JWTClaimsSetSerializer : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000008f18 +[JWTClaimsSetSerializer claimsSetKeys]
  0x00000008fd4 +[JWTClaimsSetSerializer dictionaryWithClaimsSet:]
  0x00000009214 +[JWTClaimsSetSerializer claimsSetWithDictionary:]
  0x00000009488 +[JWTClaimsSetSerializer dictionary:setObjectIfNotNil:forKey:]
  0x000000094a0 +[JWTClaimsSetSerializer dictionary:setDateIfNotNil:forKey:]


0x0000002ee38 JWTClaimsSetVerifier : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000009534 +[JWTClaimsSetVerifier verifyDictionary:withTrustedDictionary:byKey:]
  0x00000009610 +[JWTClaimsSetVerifier verifyClaimsSetDictionary:withTrustedClaimsSetDictionary:]
  0x00000009788 +[JWTClaimsSetVerifier verifyClaimsSet:withTrustedClaimsSet:]
  0x00000009918 +[JWTClaimsSetVerifier verifyClaimsSetDictionary:withTrustedClaimsSet:]


0x0000002ee88 JWT : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x0000000d5f8 +[JWT encodePayload:]
  0x0000000d604 +[JWT encodeClaimsSet:]
  0x0000000d610 +[JWT decodeMessage:]
  0x0000000add0 +[JWT encodeWithHolders:]
  0x0000000addc +[JWT encodeWithChain:]
  0x0000000ade8 +[JWT decodeWithHolders:]
  0x0000000adf4 +[JWT decodeWithChain:]
  0x0000000a008 +[JWT encodeSegment:withError:]
  0x0000000a0f4 +[JWT encodeSegment:]
  0x0000000a120 +[JWT encodeClaimsSet:withSecret:]
  0x0000000a1d0 +[JWT encodeClaimsSet:withSecret:algorithm:]
  0x0000000a278 +[JWT encodePayload:withSecret:]
  0x0000000a328 +[JWT encodePayload:withSecret:algorithm:]
  0x0000000a334 +[JWT encodePayload:withSecret:withHeaders:algorithm:]
  0x0000000a360 +[JWT encodePayload:withSecret:withHeaders:algorithm:withError:]
  0x0000000a6b4 +[JWT decodeMessage:withSecret:withTrustedClaimsSet:withError:withForcedAlgorithmByName:]
  0x0000000a6bc +[JWT decodeMessage:withSecret:withTrustedClaimsSet:withError:withForcedOption:]
  0x0000000a6d0 +[JWT decodeMessage:withSecret:withTrustedClaimsSet:withError:withForcedAlgorithmByName:withForcedOption:]
  0x0000000a6f0 +[JWT decodeMessage:withSecret:withTrustedClaimsSet:withError:withForcedAlgorithmByName:withForcedOption:withAlgorithmWhiteList:]
  0x0000000a834 +[JWT decodeMessage:withSecret:withError:withForcedOption:]
  0x0000000a848 +[JWT decodeMessage:withSecret:withError:withForcedAlgorithmByName:]
  0x0000000a850 +[JWT decodeMessage:withSecret:withError:withForcedAlgorithmByName:skipVerification:]
  0x0000000a858 +[JWT decodeMessage:withSecret:withError:withForcedAlgorithmByName:skipVerification:whitelist:]
  0x0000000ad94 +[JWT decodeMessage:withSecret:withError:]
  0x0000000ada4 +[JWT decodeMessage:withSecret:]


0x0000002eed8 JWTCodingResultComponents : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000009994 +[JWTCodingResultComponents Headers]
  0x000000099a0 +[JWTCodingResultComponents Payload]


0x0000002ef00 JWTCodingResultTypeSuccess : NSObject /usr/lib/libobjc.A.dylib <JWTMutableCodingResultTypeSuccessEncodedProtocol, JWTMutableCodingResultTypeSuccessDecodedProtocol, JWTCodingResultTypeSuccessEncodedProtocol, JWTCodingResultTypeSuccessDecodedProtocol>
 @property  NSString *encoded
 @property  NSString *token
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription
 @property  NSDictionary *headers
 @property  NSDictionary *payload
 @property  JWTClaimsSet *claimsSet
 @property  NSDictionary *headerAndPayloadDictionary

  // instance methods
  0x000000099ac -[JWTCodingResultTypeSuccess headerAndPayloadDictionary]
  0x00000009af8 -[JWTCodingResultTypeSuccess initWithEncoded:]
  0x00000009b64 -[JWTCodingResultTypeSuccess initWithToken:]
  0x00000009bd0 -[JWTCodingResultTypeSuccess initWithHeaders:withPayload:]
  0x00000009c68 -[JWTCodingResultTypeSuccess initWithHeadersAndPayload:]
  0x00000009d40 -[JWTCodingResultTypeSuccess initWithClaimsSet:]
  0x00000009dac -[JWTCodingResultTypeSuccess encoded]
  0x00000009db4 -[JWTCodingResultTypeSuccess setEncoded:]
  0x00000009dbc -[JWTCodingResultTypeSuccess headers]
  0x00000009dc4 -[JWTCodingResultTypeSuccess setHeaders:]
  0x00000009dcc -[JWTCodingResultTypeSuccess payload]
  0x00000009dd4 -[JWTCodingResultTypeSuccess setPayload:]
  0x00000009ddc -[JWTCodingResultTypeSuccess claimsSet]
  0x00000009de4 -[JWTCodingResultTypeSuccess setClaimsSet:]
  0x00000009dec -[JWTCodingResultTypeSuccess token]
  0x00000009df4 -[JWTCodingResultTypeSuccess setToken:]


0x0000002ef50 JWTCodingResultTypeError : NSObject /usr/lib/libobjc.A.dylib <JWTMutableCodingResultTypeErrorProtocol, JWTCodingResultTypeErrorProtocol>
 @property  NSError *error
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // instance methods
  0x00000009e50 -[JWTCodingResultTypeError initWithError:]
  0x00000009ebc -[JWTCodingResultTypeError error]
  0x00000009ec4 -[JWTCodingResultTypeError setError:]


0x0000002efa0 JWTCodingResultType : NSObject /usr/lib/libobjc.A.dylib
 @property  JWTCodingResultTypeSuccess *successResult
 @property  JWTCodingResultTypeError *errorResult

  // instance methods
  0x00000009ed8 -[JWTCodingResultType initWithSuccessResult:]
  0x00000009f44 -[JWTCodingResultType initWithErrorResult:]
  0x00000009fb0 -[JWTCodingResultType successResult]
  0x00000009fb8 -[JWTCodingResultType setSuccessResult:]
  0x00000009fc4 -[JWTCodingResultType errorResult]
  0x00000009fcc -[JWTCodingResultType setErrorResult:]


0x0000002f040 JWTCodingBuilder : NSObject /usr/lib/libobjc.A.dylib
 @property  @? chain
 @property  @? constructChain
 @property  @? modifyChain
 @property  @? options
 @property  @? addHolder
 @property  JWTAlgorithmDataHolderChain *internalChain
 @property  NSNumber *internalOptions
 @property  @? chain
 @property  @? constructChain
 @property  @? modifyChain
 @property  @? options
 @property  @? addHolder
 @property  @? constructHolder

  // class methods
  0x0000000b524 +[JWTCodingBuilder createWithHolders:]
  0x0000000b59c +[JWTCodingBuilder createWithChain:]
  0x0000000b5e4 +[JWTCodingBuilder createWithEmptyChain]

  // instance methods
  0x0000000b6e0 -[JWTCodingBuilder and]
  0x0000000b6e4 -[JWTCodingBuilder with]
  0x0000000ae00 -[JWTCodingBuilder chain:]
  0x0000000ae24 -[JWTCodingBuilder options:]
  0x0000000ae48 -[JWTCodingBuilder addHolder:]
  0x0000000aec8 -[JWTCodingBuilder setupFluent]
  0x0000000b46c -[JWTCodingBuilder internalChain]
  0x0000000b4b0 -[JWTCodingBuilder initWithChain:]
  0x0000000b5ec -[JWTCodingBuilder setInternalChain:]
  0x0000000b5f8 -[JWTCodingBuilder internalOptions]
  0x0000000b600 -[JWTCodingBuilder setInternalOptions:]
  0x0000000b608 -[JWTCodingBuilder chain]
  0x0000000b610 -[JWTCodingBuilder setChain:]
  0x0000000b618 -[JWTCodingBuilder constructChain]
  0x0000000b620 -[JWTCodingBuilder setConstructChain:]
  0x0000000b628 -[JWTCodingBuilder modifyChain]
  0x0000000b630 -[JWTCodingBuilder setModifyChain:]
  0x0000000b638 -[JWTCodingBuilder options]
  0x0000000b640 -[JWTCodingBuilder setOptions:]
  0x0000000b648 -[JWTCodingBuilder addHolder]
  0x0000000b650 -[JWTCodingBuilder setAddHolder:]
  0x0000000b658 -[JWTCodingBuilder constructHolder]
  0x0000000b660 -[JWTCodingBuilder setConstructHolder:]


0x0000002eff0 JWTEncodingBuilder : JWTCodingBuilder
 @property  JWTCodingResultType *encode
 @property  @? payload
 @property  @? headers
 @property  @? claimsSet
 @property  NSDictionary *internalPayload
 @property  NSDictionary *internalHeaders
 @property  JWTClaimsSet *internalClaimsSet
 @property  NSDictionary *internalMixingClaimsPayload
 @property  @? payload
 @property  @? headers
 @property  @? claimsSet

  // class methods
  0x0000000ba7c +[JWTEncodingBuilder encodePayload:]
  0x0000000bb04 +[JWTEncodingBuilder encodeClaimsSet:]

  // instance methods
  0x0000000bcec -[JWTEncodingBuilder encode]
  0x0000000c014 -[JWTEncodingBuilder encodeWithAlgorithm:withHeaders:withPayload:withSecretData:withError:]
  0x0000000c4dc -[JWTEncodingBuilder encodeSegment:withError:]
  0x0000000c5c8 -[JWTEncodingBuilder result]
  0x0000000b754 -[JWTEncodingBuilder setupFluent]
  0x0000000b6e8 -[JWTEncodingBuilder payload:]
  0x0000000b70c -[JWTEncodingBuilder headers:]
  0x0000000b730 -[JWTEncodingBuilder claimsSet:]
  0x0000000b9f4 -[JWTEncodingBuilder internalMixingClaimsPayload]
  0x0000000bb8c -[JWTEncodingBuilder internalPayload]
  0x0000000bb9c -[JWTEncodingBuilder setInternalPayload:]
  0x0000000bba8 -[JWTEncodingBuilder internalHeaders]
  0x0000000bbb8 -[JWTEncodingBuilder setInternalHeaders:]
  0x0000000bbc4 -[JWTEncodingBuilder internalClaimsSet]
  0x0000000bbd4 -[JWTEncodingBuilder setInternalClaimsSet:]
  0x0000000bbe8 -[JWTEncodingBuilder setInternalMixingClaimsPayload:]
  0x0000000bbf4 -[JWTEncodingBuilder payload]
  0x0000000bc04 -[JWTEncodingBuilder setPayload:]
  0x0000000bc10 -[JWTEncodingBuilder headers]
  0x0000000bc20 -[JWTEncodingBuilder setHeaders:]
  0x0000000bc2c -[JWTEncodingBuilder claimsSet]
  0x0000000bc3c -[JWTEncodingBuilder setClaimsSet:]


0x0000002f018 JWTDecodingBuilder : JWTCodingBuilder
 @property  JWTCodingResultType *decode
 @property  @? message
 @property  @? claimsSet
 @property  NSString *internalMessage
 @property  JWTClaimsSet *internalClaimsSet
 @property  @? message
 @property  @? claimsSet

  // class methods
  0x0000000c804 +[JWTDecodingBuilder decodeMessage:]

  // instance methods
  0x0000000c96c -[JWTDecodingBuilder decode]
  0x0000000cf60 -[JWTDecodingBuilder decodeMessage:secretData:algorithm:options:error:]
  0x0000000d5f4 -[JWTDecodingBuilder result]
  0x0000000c614 -[JWTDecodingBuilder setupFluent]
  0x0000000c5cc -[JWTDecodingBuilder message:]
  0x0000000c5f0 -[JWTDecodingBuilder claimsSet:]
  0x0000000c88c -[JWTDecodingBuilder internalMessage]
  0x0000000c89c -[JWTDecodingBuilder setInternalMessage:]
  0x0000000c8a8 -[JWTDecodingBuilder internalClaimsSet]
  0x0000000c8b8 -[JWTDecodingBuilder setInternalClaimsSet:]
  0x0000000c8cc -[JWTDecodingBuilder message]
  0x0000000c8dc -[JWTDecodingBuilder setMessage:]
  0x0000000c8e8 -[JWTDecodingBuilder claimsSet]
  0x0000000c8f8 -[JWTDecodingBuilder setClaimsSet:]


0x0000002f0e0 JWTBuilder : NSObject /usr/lib/libobjc.A.dylib
 @property  @? message
 @property  @? payload
 @property  @? headers
 @property  @? claimsSet
 @property  @? secret
 @property  @? secretData
 @property  @? privateKeyCertificatePassphrase
 @property  @? algorithm
 @property  @? algorithmName
 @property  @? options
 @property  @? whitelist
 @property  NSString *jwtMessage
 @property  NSDictionary *jwtPayload
 @property  NSDictionary *jwtHeaders
 @property  JWTClaimsSet *jwtClaimsSet
 @property  NSArray *jwtDataHolders
 @property  NSString *jwtSecret
 @property  NSData *jwtSecretData
 @property  NSString *jwtPrivateKeyCertificatePassphrase
 @property  NSError *jwtError
 @property  <JWTAlgorithm> *jwtAlgorithm
 @property  NSString *jwtAlgorithmName
 @property  NSNumber *jwtOptions
 @property  NSSet *algorithmWhitelist
 @property  @? message
 @property  @? payload
 @property  @? headers
 @property  @? claimsSet
 @property  @? secret
 @property  @? secretData
 @property  @? privateKeyCertificatePassphrase
 @property  @? algorithm
 @property  @? algorithmName
 @property  @? options
 @property  @? whitelist
 @property  @? addDataHolder
 @property  @? constructDataHolder
 @property  NSString *encode
 @property  NSDictionary *decode

  // class methods
  0x0000000e24c +[JWTBuilder encodePayload:]
  0x0000000e2d0 +[JWTBuilder encodeClaimsSet:]
  0x0000000e354 +[JWTBuilder decodeMessage:]

  // instance methods
  0x0000000d61c -[JWTBuilder message:]
  0x0000000d640 -[JWTBuilder payload:]
  0x0000000d664 -[JWTBuilder headers:]
  0x0000000d688 -[JWTBuilder claimSet:]
  0x0000000d6ac -[JWTBuilder secret:]
  0x0000000d6d0 -[JWTBuilder secretData:]
  0x0000000d6f4 -[JWTBuilder privateKeyCertificatePassphrase:]
  0x0000000d718 -[JWTBuilder algorithm:]
  0x0000000d73c -[JWTBuilder algorithmName:]
  0x0000000d760 -[JWTBuilder options:]
  0x0000000d784 -[JWTBuilder whitelist:]
  0x0000000d7e0 -[JWTBuilder addDataHolder:]
  0x0000000d7e4 -[JWTBuilder jwtAlgorithm]
  0x0000000d834 -[JWTBuilder jwtPayload]
  0x0000000d86c -[JWTBuilder setupFluent]
  0x0000000e3d8 -[JWTBuilder init]
  0x0000000e428 -[JWTBuilder encode]
  0x0000000e450 -[JWTBuilder decode]
  0x0000000e478 -[JWTBuilder encodeHelper]
  0x0000000e990 -[JWTBuilder encodeSegment:withError:]
  0x0000000ea7c -[JWTBuilder decodeHelper]
  0x0000000ecbc -[JWTBuilder decodeMessage:withSecret:withSecretData:withError:withForcedAlgorithmByName:skipVerification:]
  0x0000000f1f8 -[JWTBuilder decodeMessage:withSecret:withSecretData:withError:withForcedAlgorithmByName:skipVerification:whitelist:]
  0x0000000f4f4 -[JWTBuilder jwtMessage]
  0x0000000f4fc -[JWTBuilder setJwtMessage:]
  0x0000000f504 -[JWTBuilder setJwtPayload:]
  0x0000000f50c -[JWTBuilder jwtHeaders]
  0x0000000f514 -[JWTBuilder setJwtHeaders:]
  0x0000000f51c -[JWTBuilder jwtClaimsSet]
  0x0000000f524 -[JWTBuilder setJwtClaimsSet:]
  0x0000000f52c -[JWTBuilder jwtDataHolders]
  0x0000000f534 -[JWTBuilder setJwtDataHolders:]
  0x0000000f53c -[JWTBuilder jwtSecret]
  0x0000000f544 -[JWTBuilder setJwtSecret:]
  0x0000000f54c -[JWTBuilder jwtSecretData]
  0x0000000f554 -[JWTBuilder setJwtSecretData:]
  0x0000000f55c -[JWTBuilder jwtPrivateKeyCertificatePassphrase]
  0x0000000f564 -[JWTBuilder setJwtPrivateKeyCertificatePassphrase:]
  0x0000000f56c -[JWTBuilder jwtError]
  0x0000000f574 -[JWTBuilder setJwtError:]
  0x0000000f57c -[JWTBuilder setJwtAlgorithm:]
  0x0000000f588 -[JWTBuilder jwtAlgorithmName]
  0x0000000f590 -[JWTBuilder setJwtAlgorithmName:]
  0x0000000f598 -[JWTBuilder jwtOptions]
  0x0000000f5a0 -[JWTBuilder setJwtOptions:]
  0x0000000f5a8 -[JWTBuilder algorithmWhitelist]
  0x0000000f5b0 -[JWTBuilder setAlgorithmWhitelist:]
  0x0000000f5b8 -[JWTBuilder message]
  0x0000000f5c0 -[JWTBuilder setMessage:]
  0x0000000f5c8 -[JWTBuilder payload]
  0x0000000f5d0 -[JWTBuilder setPayload:]
  0x0000000f5d8 -[JWTBuilder headers]
  0x0000000f5e0 -[JWTBuilder setHeaders:]
  0x0000000f5e8 -[JWTBuilder claimsSet]
  0x0000000f5f0 -[JWTBuilder setClaimsSet:]
  0x0000000f5f8 -[JWTBuilder secret]
  0x0000000f600 -[JWTBuilder setSecret:]
  0x0000000f608 -[JWTBuilder secretData]
  0x0000000f610 -[JWTBuilder setSecretData:]
  0x0000000f618 -[JWTBuilder privateKeyCertificatePassphrase]
  0x0000000f620 -[JWTBuilder setPrivateKeyCertificatePassphrase:]
  0x0000000f628 -[JWTBuilder algorithm]
  0x0000000f630 -[JWTBuilder setAlgorithm:]
  0x0000000f638 -[JWTBuilder algorithmName]
  0x0000000f640 -[JWTBuilder setAlgorithmName:]
  0x0000000f648 -[JWTBuilder options]
  0x0000000f650 -[JWTBuilder setOptions:]
  0x0000000f658 -[JWTBuilder whitelist]
  0x0000000f660 -[JWTBuilder setWhitelist:]
  0x0000000f668 -[JWTBuilder addDataHolder]
  0x0000000f670 -[JWTBuilder setAddDataHolder:]
  0x0000000f678 -[JWTBuilder constructDataHolder]
  0x0000000f680 -[JWTBuilder setConstructDataHolder:]


0x0000002f158 JWTCryptoKeyBuilder : NSObject /usr/lib/libobjc.A.dylib
 @property  BOOL public
 @property  NSString *keyType
 @property  BOOL withKeyTypeRSA
 @property  BOOL withKeyTypeEC

  // class methods
  0x0000000f7d8 +[JWTCryptoKeyBuilder keyTypeRSA]
  0x0000000f7e4 +[JWTCryptoKeyBuilder keyTypeEC]

  // instance methods
  0x0000000f7f0 -[JWTCryptoKeyBuilder keyTypeRSA]
  0x0000000f838 -[JWTCryptoKeyBuilder keyTypeEC]
  0x0000000f880 -[JWTCryptoKeyBuilder withKeyTypeRSA]
  0x0000000f8f0 -[JWTCryptoKeyBuilder withKeyTypeEC]
  0x0000000f960 -[JWTCryptoKeyBuilder keyType]
  0x0000000f968 -[JWTCryptoKeyBuilder setKeyType:]
  0x0000000f970 -[JWTCryptoKeyBuilder public]
  0x0000000f978 -[JWTCryptoKeyBuilder setPublic:]


0x0000002f180 JWTCryptoKey : NSObject /usr/lib/libobjc.A.dylib <JWTCryptoKey__Generator__Protocol, JWTCryptoKey__Raw__Generator__Protocol, JWTCryptoKeyProtocol>
 @property  NSString *tag
 @property  ^{__SecKey=} key
 @property  NSData *rawKey
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000000fa14 +[JWTCryptoKey parametersKeyBuilder]
  0x0000000f980 +[JWTCryptoKey generateUniqueTag]

  // instance methods
  0x0000000ff94 -[JWTCryptoKey externalRepresentationForCoder:error:]
  0x0000000fe7c -[JWTCryptoKey cleanup]
  0x0000000feb4 -[JWTCryptoKey checkedWithError:]
  0x0000000fb3c -[JWTCryptoKey initWithSecKeyRef:]
  0x0000000fba8 -[JWTCryptoKey initWithData:parameters:error:]
  0x0000000fbdc -[JWTCryptoKey initWithBase64String:parameters:error:]
  0x0000000fc68 -[JWTCryptoKey initWithPemEncoded:parameters:error:]
  0x0000000fda0 -[JWTCryptoKey initWithPemAtURL:parameters:error:]
  0x0000000fa1c -[JWTCryptoKey extractedBuilderWithParameters:]
  0x0000000fad4 -[JWTCryptoKey extractedSecKeyTypeWithParameters:]
  0x0000001005c -[JWTCryptoKey dealloc]
  0x000000100a0 -[JWTCryptoKey tag]
  0x000000100a8 -[JWTCryptoKey setTag:]
  0x000000100b0 -[JWTCryptoKey key]
  0x000000100b8 -[JWTCryptoKey setKey:]
  0x000000100c0 -[JWTCryptoKey rawKey]
  0x000000100c8 -[JWTCryptoKey setRawKey:]


0x0000002f1d0 JWTCryptoKeyPublic : JWTCryptoKey <JWTCryptoKey__Generator__Protocol, JWTCryptoKey__Raw__Generator__Protocol>
  // instance methods
  0x00000010100 -[JWTCryptoKeyPublic initWithData:parameters:error:]
  0x00000010370 -[JWTCryptoKeyPublic initWithCertificateData:parameters:error:]
  0x000000103f4 -[JWTCryptoKeyPublic initWithCertificateBase64String:parameters:error:]


0x0000002f220 JWTCryptoKeyPrivate : JWTCryptoKey <JWTCryptoKey__Generator__Protocol, JWTCryptoKey__Raw__Generator__Protocol>
  // instance methods
  0x00000010480 -[JWTCryptoKeyPrivate initWithData:parameters:error:]
  0x00000010670 -[JWTCryptoKeyPrivate initWithP12AtURL:withPassphrase:parameters:error:]
  0x00000010718 -[JWTCryptoKeyPrivate initWithP12Data:withPassphrase:parameters:error:]


0x0000002f270 JWTCryptoKeyExtractor : NSObject /usr/lib/libobjc.A.dylib <JWTCryptoKeyExtractorProtocol>
 @property  @? keyBuilder
 @property  JWTCryptoKeyBuilder *internalKeyBuilder
 @property  @? keyBuilder
 @property  NSString *type
 @property  unsigned long hash
 @property  Class superclass
 @property  NSString *description
 @property  NSString *debugDescription

  // class methods
  0x0000001109c +[JWTCryptoKeyExtractor publicKeyWithCertificate]
  0x000000110b8 +[JWTCryptoKeyExtractor privateKeyInP12]
  0x000000110d4 +[JWTCryptoKeyExtractor publicKeyWithPEMBase64]
  0x000000110f0 +[JWTCryptoKeyExtractor privateKeyWithPEMBase64]
  0x0000001110c +[JWTCryptoKeyExtractor availableExtractors]
  0x0000001120c +[JWTCryptoKeyExtractor typesAndExtractors]
  0x000000112e8 +[JWTCryptoKeyExtractor createWithType:]
  0x00000010934 +[JWTCryptoKeyExtractor type]
  0x00000010938 +[JWTCryptoKeyExtractor parametersKeyCertificatePassphrase]

  // instance methods
  0x00000010c98 -[JWTCryptoKeyExtractor configuredByKeyBuilder:]
  0x00000010850 -[JWTCryptoKeyExtractor enhancedParameters:]
  0x00000010920 -[JWTCryptoKeyExtractor type]
  0x00000010940 -[JWTCryptoKeyExtractor init]
  0x00000010990 -[JWTCryptoKeyExtractor setupFluent]
  0x00000010a9c -[JWTCryptoKeyExtractor keyFromData:parameters:error:]
  0x00000010b70 -[JWTCryptoKeyExtractor keyFromString:parameters:error:]
  0x00000010c44 -[JWTCryptoKeyExtractor internalKeyBuilder]
  0x00000010c4c -[JWTCryptoKeyExtractor setInternalKeyBuilder:]
  0x00000010c58 -[JWTCryptoKeyExtractor keyBuilder]
  0x00000010c60 -[JWTCryptoKeyExtractor setKeyBuilder:]


0x0000002f2e8 JWTCryptoKeyExtractor_Public_Pem_Certificate : JWTCryptoKeyExtractor
  // instance methods
  0x00000010cbc -[JWTCryptoKeyExtractor_Public_Pem_Certificate keyFromData:parameters:error:]


0x0000002f338 JWTCryptoKeyExtractor_Private_P12 : JWTCryptoKeyExtractor
  // instance methods
  0x00000010d40 -[JWTCryptoKeyExtractor_Private_P12 keyFromData:parameters:error:]


0x0000002f388 JWTCryptoKeyExtractor_Public_Pem_Key : JWTCryptoKeyExtractor
  // instance methods
  0x00000010e6c -[JWTCryptoKeyExtractor_Public_Pem_Key keyFromData:parameters:error:]
  0x00000010f00 -[JWTCryptoKeyExtractor_Public_Pem_Key keyFromString:parameters:error:]


0x0000002f3d8 JWTCryptoKeyExtractor_Private_Pem_Key : JWTCryptoKeyExtractor
  // instance methods
  0x00000010f84 -[JWTCryptoKeyExtractor_Private_Pem_Key keyFromData:parameters:error:]
  0x00000011018 -[JWTCryptoKeyExtractor_Private_Pem_Key keyFromString:parameters:error:]


0x0000002f400 JWTMemoryLayout : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *type
 @property  long long size

  // class methods
  0x00000011354 +[JWTMemoryLayout typeUInt8]
  0x0000001135c +[JWTMemoryLayout typeCUnsignedChar]
  0x000000113cc +[JWTMemoryLayout createWithType:]
  0x00000011414 +[JWTMemoryLayout sizesAndTypes]

  // instance methods
  0x00000011360 -[JWTMemoryLayout initWithType:]
  0x00000011508 -[JWTMemoryLayout size]
  0x00000011590 -[JWTMemoryLayout type]
  0x00000011598 -[JWTMemoryLayout setType:]


0x0000002f478 JWTCryptoSecurityKeysTypes : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x000000115ac +[JWTCryptoSecurityKeysTypes RSA]
  0x000000115bc +[JWTCryptoSecurityKeysTypes EC]


0x0000002f4a0 JWTCryptoSecurity : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000012da8 +[JWTCryptoSecurity componentsFromFile:]
  0x00000012e14 +[JWTCryptoSecurity componentsFromFileContent:]
  0x00000012588 +[JWTCryptoSecurity externalRepresentationForKey:error:]
  0x0000001246c +[JWTCryptoSecurity securityErrorWithOSStatus:]
  0x00000011ca0 +[JWTCryptoSecurity publicHeaderStrippingMessagesAndCodes]
  0x00000011e18 +[JWTCryptoSecurity stringForPublicHeaderStrippingErrorCode:]
  0x00000011eb4 +[JWTCryptoSecurity publicHeaderStrippingErrorForCode:parameters:]
  0x00000011ff8 +[JWTCryptoSecurity publicHeaderStrippingErrorForCode:]
  0x00000012000 +[JWTCryptoSecurity dataByRemovingPublicKeyHeader:error:]
  0x00000012364 +[JWTCryptoSecurity dataByExtractingKeyFromANS1:error:]
  0x00000011a7c +[JWTCryptoSecurity extractIdentityAndTrustFromPKCS12:password:identity:trust:]
  0x00000011a84 +[JWTCryptoSecurity extractIdentityAndTrustFromPKCS12:password:identity:trust:error:]
  0x00000011bd0 +[JWTCryptoSecurity publicKeyFromCertificate:]
  0x000000115cc +[JWTCryptoSecurity addKeyWithData:asPublic:tag:type:error:]
  0x00000011798 +[JWTCryptoSecurity addKeyWithData:asPublic:tag:error:]
  0x00000011840 +[JWTCryptoSecurity keyByTag:error:]
  0x00000011848 +[JWTCryptoSecurity removeKeyByTag:error:]
  0x00000011934 +[JWTCryptoSecurity dictionaryByCombiningDictionaries:]
  0x00000011a64 +[JWTCryptoSecurity keyTypeRSA]
  0x00000011a70 +[JWTCryptoSecurity keyTypeEC]


0x0000002f4f0 JWTCryptoSecurityComponent : NSObject /usr/lib/libobjc.A.dylib
 @property  NSString *content
 @property  NSString *type

  // instance methods
  0x00000012608 -[JWTCryptoSecurityComponent initWithContent:type:]
  0x000000126c4 -[JWTCryptoSecurityComponent content]
  0x000000126cc -[JWTCryptoSecurityComponent setContent:]
  0x000000126d4 -[JWTCryptoSecurityComponent type]
  0x000000126dc -[JWTCryptoSecurityComponent setType:]


0x0000002f568 JWTCryptoSecurityComponents : NSObject /usr/lib/libobjc.A.dylib
 @property  NSArray *components

  // class methods
  0x00000012934 +[JWTCryptoSecurityComponents determineTypeByPemHeaderType:]
  0x00000012a3c +[JWTCryptoSecurityComponents pemEntryRegularExpression]
  0x00000012a6c +[JWTCryptoSecurityComponents componentFromTextResult:inContent:]
  0x00000012bdc +[JWTCryptoSecurityComponents parsedComponentsInContent:]
  0x00000012714 +[JWTCryptoSecurityComponents Certificate]
  0x0000001275c +[JWTCryptoSecurityComponents PrivateKey]
  0x00000012768 +[JWTCryptoSecurityComponents PublicKey]
  0x00000012774 +[JWTCryptoSecurityComponents Key]
  0x000000127bc +[JWTCryptoSecurityComponents components:ofType:]

  // instance methods
  0x00000012848 -[JWTCryptoSecurityComponents initWithComponents:]
  0x00000012898 -[JWTCryptoSecurityComponents componentsOfType:]
  0x00000012918 -[JWTCryptoSecurityComponents components]
  0x00000012920 -[JWTCryptoSecurityComponents setComponents:]


0x0000002f5b8 JWTErrorDescription : NSObject /usr/lib/libobjc.A.dylib
  // class methods
  0x00000012e20 +[JWTErrorDescription userDescriptionsAndCodes]
  0x00000013218 +[JWTErrorDescription errorDescriptionsAndCodes]
  0x00000013610 +[JWTErrorDescription userDescriptionForCode:]
  0x000000136ac +[JWTErrorDescription errorDescriptionForCode:]
  0x00000013748 +[JWTErrorDescription errorWithCode:]
  0x000000137cc +[JWTErrorDescription errorWithCode:withUserDescription:withErrorDescription:]


0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSArray 
0x00000000000 01 00 0400 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSCharacterSet 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSData 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSDate 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSDictionary 
0x00000000000 01 00 0400 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSError 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSException 
0x00000000000 01 00 0400 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSJSONSerialization 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSMutableDictionary 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSNull 
0x00000000000 01 00 0400 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSNumber 
0x00000000000 01 00 0500 /usr/lib/libobjc.A.dylib: NSObject 
0x00000000000 01 00 0400 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSPredicate 
0x00000000000 01 00 0400 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSProcessInfo 
0x00000000000 01 00 0400 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSRegularExpression 
0x00000000000 01 00 0700 /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation: NSSet 
0x00000000000 01 00 0400 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSString 
0x00000000000 01 00 0400 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSUUID 
