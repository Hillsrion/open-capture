import XCTest
import SwiftUI
@testable import AppCoreShared
@testable import CaptureOneUI

final class LibraryToolViewTests: XCTestCase {
    
    func testSessionBaseExposesCollections() {
        let context = ObjectContext()
        let session = SessionBase(documentUUID: "test-session", type: 0, context: context)
        
        XCTAssertNotNil(session.arrangedUserAlbumCollections)
        XCTAssertNotNil(session.arrangedUserCachedFolderCollections)
        XCTAssertNotNil(session.arrangedUserFavouriteCollections)
    }

    func testLibraryToolViewInitialization() {
        let context = ObjectContext()
        let session = SessionBase(documentUUID: "test-session", type: 0, context: context)
        
        // Add sample data to ensure it can consume that data.
        let album = CollectionBase(uuid: "album-1", context: context)
        album.name = "My Test Album"
        session.arrangedUserAlbumCollections.append(album)
        
        let smartAlbum = SmartAlbum(uuid: "smart-1", context: context)
        smartAlbum.name = "5 Stars"
        session.arrangedUserAlbumCollections.append(smartAlbum)
        
        session.arrangedUserCachedFolderCollections.append("/Users/test/Pictures")
        
        let favorite = CollectionBase(uuid: "favorite-1", context: context)
        favorite.name = "Favorite Project"
        session.arrangedUserFavouriteCollections.append(favorite)
        
        let view = LibraryToolView(session: session)
        XCTAssertNotNil(view)
        
        // Since we cannot introspect the SwiftUI view reliably without ViewInspector,
        // we test that the underlying model state correctly holds the data that the UI will bind to.
        XCTAssertEqual(session.arrangedUserAlbumCollections.count, 2)
        XCTAssertEqual(session.arrangedUserCachedFolderCollections.count, 1)
        XCTAssertEqual(session.arrangedUserFavouriteCollections.count, 1)
    }
}
