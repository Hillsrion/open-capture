 protocol SwiftProtobuf._CustomJSONCodable // 3 requirements
 protocol SwiftProtobuf.Decoder // 59 requirements
 protocol SwiftProtobuf.Enum // 5 requirements
 protocol SwiftProtobuf.ExtensibleMessage // 4 requirements
 protocol SwiftProtobuf.AnyExtensionField // 7 requirements
 protocol SwiftProtobuf.ExtensionField // 8 requirements
 protocol SwiftProtobuf.ExtensionMap // 2 requirements
 protocol SwiftProtobuf.FieldType // 8 requirements
 protocol SwiftProtobuf.MapKeyType // 2 requirements
 protocol SwiftProtobuf.MapValueType // 1 requirements
 protocol SwiftProtobuf.ProtobufWrapper // 7 requirements
 protocol SwiftProtobuf.Message // 11 requirements
 protocol SwiftProtobuf._MessageImplementationBase // 3 requirements
 protocol SwiftProtobuf.AnyMessageExtension // 4 requirements
 protocol SwiftProtobuf.ProtobufAPIVersion_2 // 0 requirements
 protocol SwiftProtobuf.ProtobufAPIVersionCheck // 2 requirements
 protocol SwiftProtobuf._ProtoNameProviding // 1 requirements
 protocol SwiftProtobuf.SelectiveVisitor // 1 requirements
 protocol SwiftProtobuf.Visitor // 56 requirements

 struct SwiftProtobuf.Google_Protobuf_Any {

	// Properties
	var unknownFields : UnknownStorage
	var _storage : AnyMessageStorage
 }

 class SwiftProtobuf.AnyMessageStorage : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var _typeURL : String
	var state : InternalState

	// Swift methods
	0x7494  func AnyMessageStorage._value.getter // getter 
	0x7944  func AnyMessageStorage.isA<A>(_:) // method 
	0x7a34  func AnyMessageStorage.unpackTo<A>(target:extensions:options:) // method 
	0x7f24  func AnyMessageStorage.preTraverse() // method 
 }

 enum SwiftProtobuf.InternalState {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	case binary : Áã
	case message : Message
WARNING: couldn't find address 0x0 (0x0) in binary!
	case contentJSON : Ÿã
 }

 enum SwiftProtobuf.AnyUnpackError {

	// Properties
	case typeMismatch  
	case malformedWellKnownTypeJSON  
	case malformedAnyField  
 }

 struct SwiftProtobuf.Google_Protobuf_Api {

	// Properties
	var name : String
	var methods : Google_Protobuf_Method
	var options : Google_Protobuf_Option
	var version : String
	var mixins : Google_Protobuf_Mixin
	var syntax : Google_Protobuf_Syntax
	var unknownFields : UnknownStorage
	var _sourceContext : Google_Protobuf_SourceContext
 }

 struct SwiftProtobuf.Google_Protobuf_Method {

	// Properties
	var name : String
	var requestTypeURL : String
	var requestStreaming : Bool
	var responseTypeURL : String
	var responseStreaming : Bool
	var options : Google_Protobuf_Option
	var syntax : Google_Protobuf_Syntax
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_Mixin {

	// Properties
	var name : String
	var root : String
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.BinaryDecoder {

	// Properties
	var p : UnsafeRawPointer
	var available : Int
	var fieldStartP : UnsafeRawPointer
	var fieldEndP : UnsafeRawPointer?
	var consumed : Bool
	var fieldWireFormat : WireFormat
	var fieldNumber : Int
	var extensions : ExtensionMap
	var groupFieldNumber : Int?
	var options : BinaryDecodingOptions
	var recursionBudget : Int
WARNING: couldn't find address 0x0 (0x0) in binary!
	var unknownData : Èä
WARNING: couldn't find address 0x0 (0x0) in binary!
	var unknownOverride : Èä
 }

 enum SwiftProtobuf.BinaryDecodingError {

	// Properties
	case trailingGarbage  
	case truncated  
	case invalidUTF8  
	case malformedProtobuf  
	case missingRequiredFields  
	case internalExtensionError  
	case messageDepthLimit  
 }

 struct SwiftProtobuf.BinaryDecodingOptions {

	// Properties
	var messageDepthLimit : Int
	var discardUnknownFields : Bool
 }

 enum SwiftProtobuf.BinaryDelimited { }

 enum SwiftProtobuf.Error {

	// Properties
	case unknownStreamError  
	case truncated  
 }

 struct SwiftProtobuf.BinaryEncoder {

	// Properties
	var pointer : UnsafeMutableRawPointer
 }

 enum SwiftProtobuf.BinaryEncodingError {

	// Properties
	case anyTranscodeFailure  
	case missingRequiredFields  
 }

 struct SwiftProtobuf.BinaryEncodingSizeVisitor {

	// Properties
	var serializedSize : Int
 }

 struct SwiftProtobuf.BinaryEncodingMessageSetSizeVisitor {

	// Properties
	var serializedSize : Int
 }

 struct SwiftProtobuf.BinaryEncodingVisitor {

	// Properties
	var encoder : BinaryEncoder
 }

 struct SwiftProtobuf.BinaryEncodingMessageSetVisitor {

	// Properties
	var encoder : BinaryEncoder
 }

 struct SwiftProtobuf.Google_Protobuf_FileDescriptorSet {

	// Properties
	var file : Google_Protobuf_FileDescriptorProto
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_FileDescriptorProto {

	// Properties
	var dependency : [String]
WARNING: couldn't find address 0x0 (0x0) in binary!
	var publicDependency :  empty-list 
WARNING: couldn't find address 0x0 (0x0) in binary!
	var weakDependency :  empty-list 
	var messageType : Google_Protobuf_DescriptorProto
	var enumType : Google_Protobuf_EnumDescriptorProto
	var service : Google_Protobuf_ServiceDescriptorProto
	var extension : Google_Protobuf_FieldDescriptorProto
	var unknownFields : UnknownStorage
	var _name : String?
	var _package : String?
	var _options : Google_Protobuf_FileOptions
	var _sourceCodeInfo : Google_Protobuf_SourceCodeInfo
	var _syntax : String?
 }

 struct SwiftProtobuf.Google_Protobuf_DescriptorProto {

	// Properties
	var field : Google_Protobuf_FieldDescriptorProto
	var extension : Google_Protobuf_FieldDescriptorProto
	var nestedType : Google_Protobuf_DescriptorProto
	var enumType : Google_Protobuf_EnumDescriptorProto
	var extensionRange : ExtensionRange
	var oneofDecl : Google_Protobuf_OneofDescriptorProto
	var reservedRange : ReservedRange
	var reservedName : [String]
	var unknownFields : UnknownStorage
	var _name : String?
	var _options : Google_Protobuf_MessageOptions
 }

 struct SwiftProtobuf.ExtensionRange {

	// Properties
	var unknownFields : UnknownStorage
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _start : ìç
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _end : ìç
	var _options : Google_Protobuf_ExtensionRangeOptions
 }

 struct SwiftProtobuf.ReservedRange {

	// Properties
	var unknownFields : UnknownStorage
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _start : ìç
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _end : ìç
 }

 struct SwiftProtobuf.Google_Protobuf_ExtensionRangeOptions {

	// Properties
	var uninterpretedOption : Google_Protobuf_UninterpretedOption
	var unknownFields : UnknownStorage
	var _protobuf_extensionFieldValues : ExtensionFieldValueSet
 }

 struct SwiftProtobuf.Google_Protobuf_FieldDescriptorProto {

	// Properties
	var unknownFields : UnknownStorage
	var _storage : _StorageClass
 }

 enum SwiftProtobuf.TypeEnum {

	// Properties
	case double  
	case float  
	case int64  
	case uint64  
	case int32  
	case fixed64  
	case fixed32  
	case bool  
	case string  
	case group  
	case message  
	case bytes  
	case uint32  
	case enum  
	case sfixed32  
	case sfixed64  
	case sint32  
	case sint64  
 }

 enum SwiftProtobuf.Label {

	// Properties
	case optional  
	case required  
	case repeated  
 }

 struct SwiftProtobuf.Google_Protobuf_OneofDescriptorProto {

	// Properties
	var unknownFields : UnknownStorage
	var _name : String?
	var _options : Google_Protobuf_OneofOptions
 }

 struct SwiftProtobuf.Google_Protobuf_EnumDescriptorProto {

	// Properties
	var value : Google_Protobuf_EnumValueDescriptorProto
	var reservedRange : EnumReservedRange
	var reservedName : [String]
	var unknownFields : UnknownStorage
	var _name : String?
	var _options : Google_Protobuf_EnumOptions
 }

 struct SwiftProtobuf.EnumReservedRange {

	// Properties
	var unknownFields : UnknownStorage
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _start : ìç
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _end : ìç
 }

 struct SwiftProtobuf.Google_Protobuf_EnumValueDescriptorProto {

	// Properties
	var unknownFields : UnknownStorage
	var _name : String?
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _number : ìç
	var _options : Google_Protobuf_EnumValueOptions
 }

 struct SwiftProtobuf.Google_Protobuf_ServiceDescriptorProto {

	// Properties
	var method : Google_Protobuf_MethodDescriptorProto
	var unknownFields : UnknownStorage
	var _name : String?
	var _options : Google_Protobuf_ServiceOptions
 }

 struct SwiftProtobuf.Google_Protobuf_MethodDescriptorProto {

	// Properties
	var unknownFields : UnknownStorage
	var _name : String?
	var _inputType : String?
	var _outputType : String?
	var _options : Google_Protobuf_MethodOptions
	var _clientStreaming : Bool?
	var _serverStreaming : Bool?
 }

 struct SwiftProtobuf.Google_Protobuf_FileOptions {

	// Properties
	var unknownFields : UnknownStorage
	var _protobuf_extensionFieldValues : ExtensionFieldValueSet
	var _storage : _StorageClass
 }

 enum SwiftProtobuf.OptimizeMode {

	// Properties
	case speed  
	case codeSize  
	case liteRuntime  
 }

 struct SwiftProtobuf.Google_Protobuf_MessageOptions {

	// Properties
	var uninterpretedOption : Google_Protobuf_UninterpretedOption
	var unknownFields : UnknownStorage
	var _protobuf_extensionFieldValues : ExtensionFieldValueSet
	var _messageSetWireFormat : Bool?
	var _noStandardDescriptorAccessor : Bool?
	var _deprecated : Bool?
	var _mapEntry : Bool?
 }

 struct SwiftProtobuf.Google_Protobuf_FieldOptions {

	// Properties
	var uninterpretedOption : Google_Protobuf_UninterpretedOption
	var unknownFields : UnknownStorage
	var _protobuf_extensionFieldValues : ExtensionFieldValueSet
	var _ctype : CType
	var _packed : Bool?
	var _jstype : JSType
	var _lazy : Bool?
	var _deprecated : Bool?
	var _weak : Bool?
 }

 enum SwiftProtobuf.CType {

	// Properties
	case string  
	case cord  
	case stringPiece  
 }

 enum SwiftProtobuf.JSType {

	// Properties
	case jsNormal  
	case jsString  
	case jsNumber  
 }

 struct SwiftProtobuf.Google_Protobuf_OneofOptions {

	// Properties
	var uninterpretedOption : Google_Protobuf_UninterpretedOption
	var unknownFields : UnknownStorage
	var _protobuf_extensionFieldValues : ExtensionFieldValueSet
 }

 struct SwiftProtobuf.Google_Protobuf_EnumOptions {

	// Properties
	var uninterpretedOption : Google_Protobuf_UninterpretedOption
	var unknownFields : UnknownStorage
	var _protobuf_extensionFieldValues : ExtensionFieldValueSet
	var _allowAlias : Bool?
	var _deprecated : Bool?
 }

 struct SwiftProtobuf.Google_Protobuf_EnumValueOptions {

	// Properties
	var uninterpretedOption : Google_Protobuf_UninterpretedOption
	var unknownFields : UnknownStorage
	var _protobuf_extensionFieldValues : ExtensionFieldValueSet
	var _deprecated : Bool?
 }

 struct SwiftProtobuf.Google_Protobuf_ServiceOptions {

	// Properties
	var uninterpretedOption : Google_Protobuf_UninterpretedOption
	var unknownFields : UnknownStorage
	var _protobuf_extensionFieldValues : ExtensionFieldValueSet
	var _deprecated : Bool?
 }

 struct SwiftProtobuf.Google_Protobuf_MethodOptions {

	// Properties
	var uninterpretedOption : Google_Protobuf_UninterpretedOption
	var unknownFields : UnknownStorage
	var _protobuf_extensionFieldValues : ExtensionFieldValueSet
	var _deprecated : Bool?
	var _idempotencyLevel : IdempotencyLevel
 }

 enum SwiftProtobuf.IdempotencyLevel {

	// Properties
	case idempotencyUnknown  
	case noSideEffects  
	case idempotent  
 }

 struct SwiftProtobuf.Google_Protobuf_UninterpretedOption {

	// Properties
	var name : NamePart
	var unknownFields : UnknownStorage
	var _identifierValue : String?
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _positiveIntValue : ’ç
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _negativeIntValue : eç
	var _doubleValue : Double?
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _stringValue : Èä
	var _aggregateValue : String?
 }

 struct SwiftProtobuf.NamePart {

	// Properties
	var unknownFields : UnknownStorage
	var _namePart : String?
	var _isExtension : Bool?
 }

 struct SwiftProtobuf.Google_Protobuf_SourceCodeInfo {

	// Properties
	var location : Location
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Location {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var path :  empty-list 
WARNING: couldn't find address 0x0 (0x0) in binary!
	var span :  empty-list 
	var leadingDetachedComments : [String]
	var unknownFields : UnknownStorage
	var _leadingComments : String?
	var _trailingComments : String?
 }

 struct SwiftProtobuf.Google_Protobuf_GeneratedCodeInfo {

	// Properties
	var annotation : Annotation
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Annotation {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var path :  empty-list 
	var unknownFields : UnknownStorage
	var _sourceFile : String?
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _begin : ìç
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _end : ìç
 }

 class SwiftProtobuf._StorageClass : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var _name : String?
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _number : ìç
	var _label : Label
	var _type : TypeEnum
	var _typeName : String?
	var _extendee : String?
	var _defaultValue : String?
WARNING: couldn't find address 0x0 (0x0) in binary!
	var _oneofIndex : ìç
	var _jsonName : String?
	var _options : Google_Protobuf_FieldOptions
	var _proto3Optional : Bool?

	// Swift methods
 }

 class SwiftProtobuf._StorageClass : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var _javaPackage : String?
	var _javaOuterClassname : String?
	var _javaMultipleFiles : Bool?
	var _javaGenerateEqualsAndHash : Bool?
	var _javaStringCheckUtf8 : Bool?
	var _optimizeFor : OptimizeMode
	var _goPackage : String?
	var _ccGenericServices : Bool?
	var _javaGenericServices : Bool?
	var _pyGenericServices : Bool?
	var _phpGenericServices : Bool?
	var _deprecated : Bool?
	var _ccEnableArenas : Bool?
	var _objcClassPrefix : String?
	var _csharpNamespace : String?
	var _swiftPrefix : String?
	var _phpClassPrefix : String?
	var _phpNamespace : String?
	var _phpMetadataNamespace : String?
	var _rubyPackage : String?
	var _uninterpretedOption : Google_Protobuf_UninterpretedOption

	// Swift methods
 }

 class SwiftProtobuf.DoubleParser : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var work :  empty-list 

	// Swift methods
	0x6a080  func DoubleParser.utf8ToDouble(bytes:) // method 
 }

 struct SwiftProtobuf.Google_Protobuf_Duration {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var seconds : ˝â
WARNING: couldn't find address 0x0 (0x0) in binary!
	var nanos : œâ
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_Empty {

	// Properties
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.OptionalExtensionField: ExtensionField,  AnyExtensionField {

	// Properties
	var value : FieldType
	var protobufExtension : AnyMessageExtension
 }

 struct SwiftProtobuf.RepeatedExtensionField: ExtensionField,  AnyExtensionField {

	// Properties
	var value : FieldType
	var protobufExtension : AnyMessageExtension
 }

 struct SwiftProtobuf.PackedExtensionField: ExtensionField,  AnyExtensionField {

	// Properties
	var value : FieldType
	var protobufExtension : AnyMessageExtension
 }

 struct SwiftProtobuf.OptionalEnumExtensionField: ExtensionField,  AnyExtensionField {

	// Properties
	var value : A
	var protobufExtension : AnyMessageExtension
 }

 struct SwiftProtobuf.RepeatedEnumExtensionField: ExtensionField,  AnyExtensionField {

	// Properties
	var value : [A]
	var protobufExtension : AnyMessageExtension
 }

 struct SwiftProtobuf.PackedEnumExtensionField: ExtensionField,  AnyExtensionField {

	// Properties
	var value : [A]
	var protobufExtension : AnyMessageExtension
 }

 struct SwiftProtobuf.OptionalMessageExtensionField: ExtensionField,  AnyExtensionField {

	// Properties
	var value : A
	var protobufExtension : AnyMessageExtension
 }

 struct SwiftProtobuf.RepeatedMessageExtensionField: ExtensionField,  AnyExtensionField {

	// Properties
	var value : [A]
	var protobufExtension : AnyMessageExtension
 }

 struct SwiftProtobuf.OptionalGroupExtensionField: ExtensionField,  AnyExtensionField {

	// Properties
	var value : A
	var protobufExtension : AnyMessageExtension
 }

 struct SwiftProtobuf.RepeatedGroupExtensionField: ExtensionField,  AnyExtensionField {

	// Properties
	var value : [A]
	var protobufExtension : AnyMessageExtension
 }

 struct SwiftProtobuf.ExtensionFieldValueSet {

	// Properties
	var values : AnyExtensionField
 }

 struct SwiftProtobuf.Google_Protobuf_FieldMask {

	// Properties
	var paths : [String]
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.ProtobufFloat: FieldType,  MapValueType { }

 struct SwiftProtobuf.ProtobufDouble: FieldType,  MapValueType { }

 struct SwiftProtobuf.ProtobufInt32: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufInt64: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufUInt32: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufUInt64: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufSInt32: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufSInt64: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufFixed32: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufFixed64: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufSFixed32: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufSFixed64: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufBool: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufString: FieldType,  MapKeyType,  MapValueType { }

 struct SwiftProtobuf.ProtobufBytes: FieldType,  MapValueType { }

 struct SwiftProtobuf.HashVisitor {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var hasher : ÈÉ
 }

 enum SwiftProtobuf.Internal { }

 struct SwiftProtobuf.JSONDecoder {

	// Properties
	var scanner : JSONScanner
	var messageType : Message
	var fieldCount : Int
	var isMapKey : Bool
	var fieldNameMap : _NameMap
 }

 enum SwiftProtobuf.JSONDecodingError {

	// Properties
	case unknownField : String
	case failure  
	case malformedNumber  
	case numberRange  
	case malformedMap  
	case malformedBool  
	case malformedString  
	case invalidUTF8  
	case missingFieldNames  
	case schemaMismatch  
	case unrecognizedEnumValue  
	case illegalNull  
	case unquotedMapKey  
	case leadingZero  
	case truncated  
	case malformedDuration  
	case malformedTimestamp  
	case malformedFieldMask  
	case trailingGarbage  
	case conflictingOneOf  
	case messageDepthLimit  
 }

 struct SwiftProtobuf.JSONDecodingOptions {

	// Properties
	var messageDepthLimit : Int
	var ignoreUnknownFields : Bool
 }

 struct SwiftProtobuf.JSONEncoder {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var data :  empty-list 
WARNING: couldn't find address 0x0 (0x0) in binary!
	var separator : ùÉ
 }

 enum SwiftProtobuf.JSONEncodingError {

	// Properties
	case anyTranscodeFailure  
	case timestampRange  
	case durationRange  
	case fieldMaskConversion  
	case missingFieldNames  
	case missingValue  
 }

 struct SwiftProtobuf.JSONEncodingOptions {

	// Properties
	var alwaysPrintEnumsAsInts : Bool
	var preserveProtoFieldNames : Bool
 }

 struct SwiftProtobuf.JSONEncodingVisitor {

	// Properties
	var encoder : JSONEncoder
	var nameMap : _NameMap
	var extensions : ExtensionFieldValueSet
	let options : JSONEncodingOptions
 }

 struct SwiftProtobuf.JSONMapEncodingVisitor {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var separator : ÕÇ
	var encoder : JSONEncoder
	let options : JSONEncodingOptions
 }

 struct SwiftProtobuf.JSONScanner {

	// Properties
	let source : UnsafeRawBufferPointer
	var index : Int
	var numberParser : DoubleParser
	var options : JSONDecodingOptions
	var extensions : ExtensionMap
	var recursionLimit : Int
	var recursionBudget : Int
 }

 class SwiftProtobuf.MessageExtension {
 class SwiftProtobuf.InternPool : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var interned : [UnsafeRawBufferPointer]

	// Swift methods
	0xa0920  func InternPool.intern(utf8:) // method 
	0xa0afc  func InternPool.intern(utf8Ptr:) // method 
 }

 struct SwiftProtobuf._NameMap {

	// Properties
	var internPool : InternPool
	var numberToNameMap : Names
	var protoToNumberMap : Name
	var jsonToNumberMap : Name
 }

 enum SwiftProtobuf.NameDescription {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	case same : WÅ
WARNING: couldn't find address 0x0 (0x0) in binary!
	case standard : WÅ
WARNING: couldn't find address 0x0 (0x0) in binary!
	case unique : IÅ
WARNING: couldn't find address 0x0 (0x0) in binary!
	case aliased : 3Å
 }

 struct SwiftProtobuf.Name {

	// Properties
	var utf8Buffer : UnsafeRawBufferPointer
	var nameString : NameString
 }

 struct SwiftProtobuf.Names {

	// Properties
	var json : Name
	var proto : Name
 }

 enum SwiftProtobuf.NameString {

	// Properties
	case string : String
WARNING: couldn't find address 0x0 (0x0) in binary!
	case staticString : ©Ä
 }

 struct SwiftProtobuf._ProtobufMap { }

 struct SwiftProtobuf._ProtobufMessageMap { }

 struct SwiftProtobuf._ProtobufEnumMap { }

 struct SwiftProtobuf.SimpleExtensionMap {

	// Properties
	var fields : AnyMessageExtension
 }

 struct SwiftProtobuf.Google_Protobuf_SourceContext {

	// Properties
	var fileName : String
	var unknownFields : UnknownStorage
 }

 enum SwiftProtobuf.Google_Protobuf_NullValue {

	// Properties
	case UNRECOGNIZED : Int
	case nullValue  
 }

 struct SwiftProtobuf.Google_Protobuf_Struct {

	// Properties
	var fields : Google_Protobuf_Value
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_Value {

	// Properties
	var kind : OneOf_Kind
	var unknownFields : UnknownStorage
 }

 enum SwiftProtobuf.OneOf_Kind {

	// Properties
	case nullValue : Google_Protobuf_NullValue
	case numberValue : Double
	case stringValue : String
	case boolValue : Bool
	case structValue : Google_Protobuf_Struct
	case listValue : Google_Protobuf_ListValue
 }

 struct SwiftProtobuf.Google_Protobuf_ListValue {

	// Properties
	var values : Google_Protobuf_Value
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.TextFormatDecoder {

	// Properties
	var scanner : TextFormatScanner
	var fieldCount : Int
WARNING: couldn't find address 0x0 (0x0) in binary!
	var terminator : ùÉ
	var fieldNameMap : _NameMap
	var messageType : Message
 }

 enum SwiftProtobuf.TextFormatDecodingError {

	// Properties
	case malformedText  
	case malformedNumber  
	case trailingGarbage  
	case truncated  
	case invalidUTF8  
	case schemaMismatch  
	case missingFieldNames  
	case unknownField  
	case unrecognizedEnumValue  
	case conflictingOneOf  
	case internalExtensionError  
 }

 struct SwiftProtobuf.TextFormatEncoder {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var data :  empty-list 
WARNING: couldn't find address 0x0 (0x0) in binary!
	var indentString :  empty-list 
 }

 struct SwiftProtobuf.TextFormatEncodingOptions {

	// Properties
	var printUnknownFields : Bool
 }

 struct SwiftProtobuf.TextFormatEncodingVisitor {

	// Properties
	var encoder : TextFormatEncoder
	var nameMap : _NameMap
WARNING: couldn't find address 0x0 (0x0) in binary!
	var nameResolver : Int
	var extensions : ExtensionFieldValueSet
	let options : TextFormatEncodingOptions
 }

 struct SwiftProtobuf.TextFormatScanner {

	// Properties
	var extensions : ExtensionMap
	var p : UnsafeRawPointer
	var end : UnsafeRawPointer
	var doubleParser : DoubleParser
 }

 struct SwiftProtobuf.Google_Protobuf_Timestamp {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var seconds : ˝â
WARNING: couldn't find address 0x0 (0x0) in binary!
	var nanos : œâ
	var unknownFields : UnknownStorage
 }

 enum SwiftProtobuf.Google_Protobuf_Syntax {

	// Properties
	case UNRECOGNIZED : Int
	case proto2  
	case proto3  
 }

 struct SwiftProtobuf.Google_Protobuf_Type {

	// Properties
	var name : String
	var fields : Google_Protobuf_Field
	var oneofs : [String]
	var options : Google_Protobuf_Option
	var syntax : Google_Protobuf_Syntax
	var unknownFields : UnknownStorage
	var _sourceContext : Google_Protobuf_SourceContext
 }

 struct SwiftProtobuf.Google_Protobuf_Field {

	// Properties
	var kind : Kind
	var cardinality : Cardinality
WARNING: couldn't find address 0x0 (0x0) in binary!
	var number : œâ
	var name : String
	var typeURL : String
WARNING: couldn't find address 0x0 (0x0) in binary!
	var oneofIndex : œâ
	var packed : Bool
	var options : Google_Protobuf_Option
	var jsonName : String
	var defaultValue : String
	var unknownFields : UnknownStorage
 }

 enum SwiftProtobuf.Kind {

	// Properties
	case UNRECOGNIZED : Int
	case typeUnknown  
	case typeDouble  
	case typeFloat  
	case typeInt64  
	case typeUint64  
	case typeInt32  
	case typeFixed64  
	case typeFixed32  
	case typeBool  
	case typeString  
	case typeGroup  
	case typeMessage  
	case typeBytes  
	case typeUint32  
	case typeEnum  
	case typeSfixed32  
	case typeSfixed64  
	case typeSint32  
	case typeSint64  
 }

 enum SwiftProtobuf.Cardinality {

	// Properties
	case UNRECOGNIZED : Int
	case unknown  
	case optional  
	case required  
	case repeated  
 }

 struct SwiftProtobuf.Google_Protobuf_Enum {

	// Properties
	var name : String
	var enumvalue : Google_Protobuf_EnumValue
	var options : Google_Protobuf_Option
	var syntax : Google_Protobuf_Syntax
	var unknownFields : UnknownStorage
	var _sourceContext : Google_Protobuf_SourceContext
 }

 struct SwiftProtobuf.Google_Protobuf_EnumValue {

	// Properties
	var name : String
WARNING: couldn't find address 0x0 (0x0) in binary!
	var number : œâ
	var options : Google_Protobuf_Option
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_Option {

	// Properties
	var name : String
	var unknownFields : UnknownStorage
	var _value : Google_Protobuf_Any
 }

 struct SwiftProtobuf.UnknownStorage {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var data : Áã
 }

 struct SwiftProtobuf.Version { }

 enum SwiftProtobuf.WireFormat {

	// Properties
	case varint  
	case fixed64  
	case lengthDelimited  
	case startGroup  
	case endGroup  
	case fixed32  
 }

 struct SwiftProtobuf.Google_Protobuf_DoubleValue {

	// Properties
	var value : Double
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_FloatValue {

	// Properties
	var value : Float
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_Int64Value {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var value : ˝â
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_UInt64Value {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var value : …á
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_Int32Value {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var value : œâ
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_UInt32Value {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var value : µá
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_BoolValue {

	// Properties
	var value : Bool
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_StringValue {

	// Properties
	var value : String
	var unknownFields : UnknownStorage
 }

 struct SwiftProtobuf.Google_Protobuf_BytesValue {

	// Properties
WARNING: couldn't find address 0x0 (0x0) in binary!
	var value : Áã
	var unknownFields : UnknownStorage
 }


