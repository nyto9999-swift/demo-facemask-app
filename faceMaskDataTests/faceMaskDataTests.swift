import XCTest
import CoreData
import Kanna
@testable import faceMaskData

class faceMaskDataTests: XCTestCase {
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FaceMasks")
    
    //facemask
    func test_facemaskOperation_can_finish() {
        let fo = FaceMaskOperation()
        while fo.isFinished {
            XCTAssertTrue(fo.isFinished)
        }
    }
    
    func test_download_facemask_successfully() {
        let exp = expectation(description: "face mask was downloaded")
        let url = URL(string: urlStringType.FaceMask.rawValue)!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            XCTAssertNotNil(data)
            exp.fulfill()
        }.resume()
        
        wait(for: [exp], timeout: 3)
    }
    
    func test_local_has_facemask() {
        let count = try? context.count(for: request)
        let hasData = count == nil ? false : true
        XCTAssertNotNil(hasData)
        XCTAssertGreaterThan(count!, 0)
    }
    
    func test_local_can_delete() {
        
    }
    
    //sentence
    func test_sentenceOperation_can_finish() {
        let so = DailySentenceOperation()
        while so.isFinished {
            XCTAssertTrue(so.isFinished)
        }
    }
    
    func test_download_sentence_successfully() {
        let exp = expectation(description: "sentence was downloaded")
        let url = URL(string: urlStringType.DailySentence.rawValue)!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            XCTAssertNotNil(data)
            exp.fulfill()
        }.resume()
        
        wait(for: [exp], timeout: 3)
    }
    
    func test_can_scrape_sentence() {
        var sentence:String?
        var author:String?
        
        let exp = expectation(description: "sentence was scraped")
        let url = URL(string: urlStringType.DailySentence.rawValue)!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            do {
                let contents = String(data: data! as Data, encoding: .utf8)!
                let parsedHTML = try Kanna.HTML(html: contents, encoding: String.Encoding.utf8)
                
                sentence = parsedHTML.xpath("/html/body/div[1]/article/div/div/div[2]/p[2]")
                    .first?
                    .text?
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                author = parsedHTML.xpath("/html/body/div[1]/article/div/div/div[2]/h1")
                    .first?
                    .text?
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
            }
            catch { print("error") }
            
            XCTAssertNotNil(sentence)
            XCTAssertNotNil(author)
            exp.fulfill()
        }.resume()
        
        wait(for: [exp], timeout: 3)
    }
}
