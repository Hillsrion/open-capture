import XCTest
@testable import AppCoreShared

class KeywordTests: XCTestCase {
    
    func testKeywordHierarchy() {
        let library = KeywordLibrary()
        
        // 1. Add root
        let people = library.addKeyword(name: "People")
        XCTAssertEqual(library.rootKeywords.count, 1)
        
        // 2. Add children
        let family = library.addKeyword(name: "Family", parent: people)
        let friends = library.addKeyword(name: "Friends", parent: people)
        
        XCTAssertEqual(library.children(of: people).count, 2)
        XCTAssertEqual(family.parentID, people.id)
        
        // 3. Nested child
        let brother = library.addKeyword(name: "Brother", parent: family)
        XCTAssertEqual(library.children(of: family).count, 1)
        XCTAssertEqual(brother.parentID, family.id)
    }
    
    func testKeywordLookup() {
        let library = KeywordLibrary()
        let nature = library.addKeyword(name: "Nature")
        
        let found = library.keyword(withID: nature.id)
        XCTAssertNotNil(found)
        XCTAssertEqual(found?.name, "Nature")
        
        XCTAssertNil(library.keyword(withID: "non-existent"))
    }
}
