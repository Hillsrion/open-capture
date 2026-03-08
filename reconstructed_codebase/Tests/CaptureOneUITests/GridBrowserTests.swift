import XCTest
import SwiftUI
import AppCoreShared
@testable import CaptureOneUI

class GridBrowserTests: XCTestCase {
    
    func testZoomStorePersistence() {
        let store = ImageBrowserZoomLevelStore.shared
        store.setSize(200.0)
        XCTAssertEqual(store.thumbnailSize, 200.0)
        
        let newStore = ImageBrowserZoomLevelStore()
        XCTAssertEqual(newStore.thumbnailSize, 200.0)
    }
    
    func testBrowserInteractorSelection() {
        let interactor = ImageBrowserInteractor()
        let images = (1...10).map { i in
            let img = ImageBase(imageUUID: "uuid-\(i)", path: "/path/\(i).jpg", context: nil)
            let v = VariantBase(variantUUID: "variant-\(i)", image: img, context: nil)
            img.variants = [v]
            return img
        }
        
        interactor.updateDataSource(with: images)
        
        // Single Select
        interactor.select(variant: images[0].primaryVariant!, isMultiSelect: false, isRangeSelect: false)
        XCTAssertEqual(interactor.selectedVariants.count, 1)
        XCTAssertEqual(interactor.primaryVariantUUID, "variant-1")
        
        // Multi Select (Cmd)
        interactor.select(variant: images[1].primaryVariant!, isMultiSelect: true, isRangeSelect: false)
        XCTAssertEqual(interactor.selectedVariants.count, 2)
        XCTAssertTrue(interactor.selectedVariants.contains("variant-2"))
        
        // Range Select (Shift) from 1 to 5
        interactor.select(variant: images[4].primaryVariant!, isMultiSelect: false, isRangeSelect: true)
        // Should contain 1, 2, 3, 4, 5
        XCTAssertEqual(interactor.selectedVariants.count, 5)
        XCTAssertTrue(interactor.selectedVariants.contains("variant-3"))
    }
}
