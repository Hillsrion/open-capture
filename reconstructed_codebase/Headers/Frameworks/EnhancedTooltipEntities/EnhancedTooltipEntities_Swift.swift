 protocol EnhancedTooltipEntities.EnhancedTooltipDataRepositoryProtocol // 2 requirements

 class EnhancedTooltipEntities.EnhancedTooltipParser : NSObject /usr/lib/libobjc.A.dylib {

	// Properties
	var tooltips : EnhancedTooltipData
	var currentElementStack : [String]
	var currentFieldId : Id
	var tooltipId : String?
	var tooltipContent : String?
	var tooltipValue : String?
	var tooltipLocalizeContent : Bool
	var tooltipLocalizeValue : Bool
	var tooltip : EnhancedTooltipData

	// ObjC -> Swift bridged methods
WARNING: couldn't find offset 0x968 in binary!
WARNING: couldn't find offset 0x968 in binary!
WARNING: couldn't find address 0x959000061c8 (0x159000061c8) in binary!
	0x0  @objc EnhancedTooltipParser.(null) <stripped>
WARNING: couldn't find offset 0x935 in binary!
WARNING: couldn't find offset 0x935 in binary!
WARNING: couldn't find address 0x97c00006198 (0x17c00006198) in binary!
	0x0  @objc EnhancedTooltipParser.(null) <stripped>
WARNING: couldn't find offset 0x974 in binary!
WARNING: couldn't find offset 0x974 in binary!
WARNING: couldn't find address 0x97800006168 (0x17800006168) in binary!
	0x0  @objc EnhancedTooltipParser.(null) <stripped>
WARNING: couldn't find address 0x474f525029232840 (0x25029232840) in binary!
	0x7546465636e  @objc EnhancedTooltipParser.(null) <stripped>
WARNING: couldn't find address 0x7469746e45706974 (0x46e45706974) in binary!
	0x53a5443454a  @objc EnhancedTooltipParser.(null) <stripped>
WARNING: couldn't find address 0x6f6f546465636e61 (0x46465636e61) in binary!
	0x0  @objc EnhancedTooltipParser.(null) <stripped>

	// Swift methods
	0x2b34  func <stripped> // modifyCoroutine 
	0x2ba4  func <stripped> // modifyCoroutine 
	0x2c18  func <stripped> // modifyCoroutine 
	0x2c5c  func EnhancedTooltipParser.parse(data:) // method 
	0x2dd4  func EnhancedTooltipParser.parser(_:parseErrorOccurred:) // method 
	0x2e6c  func EnhancedTooltipParser.parser(_:didStartElement:namespaceURI:qualifiedName:attributes:) // method 
	0x2f68  func EnhancedTooltipParser.parser(_:didEndElement:namespaceURI:qualifiedName:) // method 
	0x302c  func EnhancedTooltipParser.parser(_:foundCharacters:) // method 
 }

 class EnhancedTooltipEntities.EnhancedTooltipDataRepositoryBase : _SwiftObject /usr/lib/swift/libswiftCore.dylib {

	// Properties
	var tooltips : EnhancedTooltipData

	// Swift methods
	0x4484  class func EnhancedTooltipDataRepositoryBase.__allocating_init() // init 
	0x44e8  class func EnhancedTooltipDataRepositoryBase.__allocating_init(tooltips:) // init 
	0x457c  func EnhancedTooltipDataRepositoryBase.add(tooltips:) // method 
	0x4794  func EnhancedTooltipDataRepositoryBase.tooltipData(for:) // method 
	0x4878  func EnhancedTooltipDataRepositoryBase.tooltipDataList.getter // getter 
	0x493c  func EnhancedTooltipDataRepositoryBase.numberOfSteps(for:) // method 
 }

 class EnhancedTooltipEntities.EnhancedTooltipDataRepository : EnhancedTooltipDataRepositoryBase { }

 struct EnhancedTooltipEntities.EnhancedTooltipData {

	// Properties
	let id : String
	var fields : Id
 }

 struct EnhancedTooltipEntities.Field {

	// Properties
	let id : Id
	let value : String?
	let content : String?
	let localize_value : Bool
	let localize_content : Bool
 }

 enum EnhancedTooltipEntities.Id {

	// Properties
	case title  
	case description  
	case coverImage  
	case tutorialUrl  
	case helpUrl  
	case autoAdvance  
	case nextTourStep  
	case nextButtonLabel  
	case previousTourStep  
	case previousButtonLabel  
 }

 enum EnhancedTooltipEntities.Attribute {

	// Properties
	case id  
	case value  
	case localizeValue  
	case localizeContent  
 }


