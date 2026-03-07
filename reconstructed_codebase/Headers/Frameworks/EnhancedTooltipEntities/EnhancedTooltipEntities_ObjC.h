@protocol NSXMLParserDelegate <NSObject>
@optional
  // instance methods
 -[NSXMLParserDelegate parserDidStartDocument:]
 -[NSXMLParserDelegate parserDidEndDocument:]
 -[NSXMLParserDelegate parser:foundNotationDeclarationWithName:publicID:systemID:]
 -[NSXMLParserDelegate parser:foundUnparsedEntityDeclarationWithName:publicID:systemID:notationName:]
 -[NSXMLParserDelegate parser:foundAttributeDeclarationWithName:forElement:type:defaultValue:]
 -[NSXMLParserDelegate parser:foundElementDeclarationWithName:model:]
 -[NSXMLParserDelegate parser:foundInternalEntityDeclarationWithName:value:]
 -[NSXMLParserDelegate parser:foundExternalEntityDeclarationWithName:publicID:systemID:]
 -[NSXMLParserDelegate parser:didStartElement:namespaceURI:qualifiedName:attributes:]
 -[NSXMLParserDelegate parser:didEndElement:namespaceURI:qualifiedName:]
 -[NSXMLParserDelegate parser:didStartMappingPrefix:toURI:]
 -[NSXMLParserDelegate parser:didEndMappingPrefix:]
 -[NSXMLParserDelegate parser:foundCharacters:]
 -[NSXMLParserDelegate parser:foundIgnorableWhitespace:]
 -[NSXMLParserDelegate parser:foundProcessingInstructionWithTarget:data:]
 -[NSXMLParserDelegate parser:foundComment:]
 -[NSXMLParserDelegate parser:foundCDATA:]
 -[NSXMLParserDelegate parser:resolveExternalEntityName:systemID:]
 -[NSXMLParserDelegate parser:parseErrorOccurred:]
 -[NSXMLParserDelegate parser:validationErrorOccurred:]

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

0x000000107f8 _TtC23EnhancedTooltipEntities21EnhancedTooltipParser : NSObject /usr/lib/libobjc.A.dylib <NSXMLParserDelegate>
  // instance methods
  0x00000002e20 -[_TtC23EnhancedTooltipEntities21EnhancedTooltipParser parser:parseErrorOccurred:]
  0x00000002e74 -[_TtC23EnhancedTooltipEntities21EnhancedTooltipParser parser:didStartElement:namespaceURI:qualifiedName:attributes:]
  0x00000002f74 -[_TtC23EnhancedTooltipEntities21EnhancedTooltipParser parser:didEndElement:namespaceURI:qualifiedName:]
  0x00000003038 -[_TtC23EnhancedTooltipEntities21EnhancedTooltipParser parser:foundCharacters:]
  0x00000003194 -[_TtC23EnhancedTooltipEntities21EnhancedTooltipParser init]


0x00000011090 _TtC23EnhancedTooltipEntities33EnhancedTooltipDataRepositoryBase : Swift._SwiftObject /usr/lib/swift/libswiftCore.dylib

0x00000011170 _TtC23EnhancedTooltipEntities29EnhancedTooltipDataRepository : EnhancedTooltipEntities.EnhancedTooltipDataRepositoryBase

0x00000000000 01 00 0200 /usr/lib/libobjc.A.dylib: NSObject 
0x00000000000 01 00 0100 /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation: NSXMLParser 
0x00000000000 01 00 0500 /usr/lib/swift/libswiftCore.dylib: _TtCs12_SwiftObject 
