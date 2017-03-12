//
//  DatabaseManager.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 06/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import Foundation
import FMDB

class DatabaseManager: NSObject {
    static let shared: DatabaseManager = DatabaseManager()
    
    let databaseFileName = "quotes.db"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    //quote table fields
    let quoteId = "_id"
    let quoteAuthorName = "author_name"
    let quoteCategoryName = "category_name"
    let quoteText = "qte"
    let quoteFav = "fav"
    
    //author table fields
    let authorId = "_id_author"
    let authorName = "name"
    let authorFileName = "file_name"
    
    //category table fields
    let categoryId = "_id_cat"
    let categoryName = "name"
    let categoryFileName = "file_name"
    
    // MARK: - Constructors
    
    override init() {
        super.init()
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String)
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    // MARK: - Open
    
    func openDatabase() -> Bool {
        let fileManager = FileManager.default
        
        let templatePath = Bundle.main.path(forResource: "quotes", ofType: "db")!
        
        if database == nil {
            if !FileManager.default.fileExists(atPath: pathToDatabase) {
                do {
                    try fileManager.copyItem(at: URL(fileURLWithPath: templatePath), to: URL(fileURLWithPath: pathToDatabase))
                } catch {
                    print("Error while copying db!")
                }
            }
            
            database = FMDatabase(path: pathToDatabase)
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Quotes
    
    func getAllQuotes(lastQuoteIndex: Int, completion: @escaping ([Quote]) -> ()) {
        var quotes: [Quote]! = []
        
        if openDatabase() {
            let query = "select * from quote where \(quoteId) > \(lastQuoteIndex) order by \(quoteId) LIMIT 20;"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let quote = Quote()
                    quote.id = Int(results.int(forColumn: quoteId))
                    quote.author_name = results.string(forColumn: quoteAuthorName)
                    quote.category_name = results.string(forColumn: quoteCategoryName)
                    quote.text = results.string(forColumn: quoteText)
                    quote.favorite = Int(results.int(forColumn: quoteFav))
                    
                    quotes.append(quote)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        completion(quotes)
    }
    
    
    func getQuotesByCategory(category: String, completion: ([Quote]) -> Void) {
        var quotes: [Quote]! = []
        
        if openDatabase() {
            let query = "select \(quoteId), \(quoteAuthorName), \(quoteText), \(quoteCategoryName), \(quoteFav), \(authorFileName) from quote,author where \(authorName) = \(quoteAuthorName) and \(quoteCategoryName) = '\(category)' order by \(quoteText);"
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next() {
                    let quote = Quote()
                    quote.id = Int(results.int(forColumn: quoteId))
                    quote.author_name = results.string(forColumn: quoteAuthorName)
                    quote.category_name = results.string(forColumn: quoteCategoryName)
                    quote.text = results.string(forColumn: quoteText)
                    quote.favorite = Int(results.int(forColumn: quoteFav))

                    quotes.append(quote)
                }
            }catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        
        completion(quotes)
    }
    
    func getQuotesByAuthor(author: String, completion: ([Quote]) -> Void) {
        var quotes: [Quote]! = []
        
        if openDatabase() {
            let query = "select \(quoteId), \(quoteAuthorName), \(quoteText), \(quoteCategoryName), \(quoteFav), \(authorFileName) from quote, author where \(authorName) = \(quoteAuthorName) and \(authorName) = '\(author)' order by \(authorName);"
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next() {
                    let quote = Quote()
                    quote.id = Int(results.int(forColumn: quoteId))
                    quote.author_name = results.string(forColumn: quoteAuthorName)
                    quote.category_name = results.string(forColumn: quoteCategoryName)
                    quote.text = results.string(forColumn: quoteText)
                    quote.favorite = Int(results.int(forColumn: quoteFav))
                    
                    quotes.append(quote)
                }
            }catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        
        completion(quotes)
    }
    
    func getRandomQuote(completion: (Quote) -> ()) {
        if openDatabase() {
            let randomId = arc4random_uniform(UInt32(1000)) + 1
            
            let query = "select * from quote where \(quoteId) = '\(randomId)';"
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next() {
                    let quote = Quote()
                    quote.id = Int(results.int(forColumn: quoteId))
                    quote.author_name = results.string(forColumn: quoteAuthorName)
                    quote.category_name = results.string(forColumn: quoteCategoryName)
                    quote.text = results.string(forColumn: quoteText)
                    quote.favorite = Int(results.int(forColumn: quoteFav))

                    completion(quote)
                }
            }catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    
    func updateWith(Quote quote: Quote) {
        if openDatabase() {
            let query = "update quote set \(quoteFav) = \(quote.favorite!) where \(quoteId)=\(quote.id!)"
            do {
                try database.executeUpdate(query, values: nil)
            } catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    
    // MARK: - Categories
    
    func getCategories(completion: @escaping ([Category]) -> ()) {
        var categories: [Category]! = []
        
        if openDatabase() {
            let query = "select \(categoryId), \(categoryName), \(categoryFileName), COUNT(\(quoteAuthorName)) AS count from category left join quote on \(categoryName) = \(quoteCategoryName) group by \(categoryName) order by \(categoryName) asc;"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let category = Category()
                    category.id = Int(results.int(forColumn: categoryId))
                    category.name = results.string(forColumn: categoryName)
                    category.fileName = results.string(forColumn: categoryFileName)
                    category.count = Int(results.int(forColumn: "count"))
                    
                    categories.append(category)
                }
            }catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        completion(categories)
    }
    
    // MARK: - Authors
    
    func getAllAuthors(charSequence: String, completion: ([Author]!) -> Void) {
        var authors: [Author]! = []
        
        if openDatabase() {
            let query = "select \(authorId), \(authorName), \(authorFileName), count(\(authorName)) as count from author left join quote on \(authorName) = \(quoteAuthorName) where \(authorName) like '%\(charSequence)%'  group by \(authorName) order by \(authorName) asc;"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next() {
                    let author = Author()
                    author.id = Int(results.int(forColumn: authorId))
                    author.name = results.string(forColumn: authorName)
                    author.fileName = results.string(forColumn: authorFileName)
                    author.count = Int(results.int(forColumn: "count"))
                    
                    authors.append(author)
                }
            }catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        
        completion(authors)
    }
    
    // MARK: - Favorites
    
    func getAllFavoriteQuotes(completion: ([Quote]!) -> Void) {
        var quotes: [Quote]! = []
        
        if openDatabase() {
            
            let query = "select \(quoteId), \(quoteAuthorName), \(quoteText), \(quoteCategoryName), \(quoteFav), \(authorFileName) from quote, author where \(authorName) = \(quoteAuthorName) and \(quoteFav) = '1' order by \(authorName);"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let quote = Quote()
                    quote.id = Int(results.int(forColumn: quoteId))
                    quote.author_name = results.string(forColumn: quoteAuthorName)
                    quote.category_name = results.string(forColumn: quoteCategoryName)
                    quote.text = results.string(forColumn: quoteText)
                    quote.favorite = Int(results.int(forColumn: quoteFav))
                    
                    quotes.append(quote)
                }
            }catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        completion(quotes)
    }
}
