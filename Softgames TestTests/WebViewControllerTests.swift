

import XCTest
import WebKit
@testable import Softgames_Test


class WebViewControllerTests: XCTestCase {
    var sut: WebViewController!
    
    override func setUpWithError() throws {
        sut = WebViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    
    // MARK: - Tests
    func testBundle() {
        let testBundle = Bundle(for: WebViewControllerTests.self)
        let filePath = testBundle.path(forResource: "Form", ofType: "html")
        XCTAssertNotNil(filePath)
    }
    
    
    func testAgeCalculation() {
      let webView = sut.webView
      sut.loadViewIfNeeded()

      var age = Helper.calcAge("03/17/1979")
      webView?.evaluateJavaScript("updateAgeField('\(age)')") { value, error in
          guard let res = value as? Int else {
              XCTFail("Could not fetch html")
              return
          }

          age = res
      }

      XCTAssertEqual(age, 43)
    }
}
