//
//  NHKEasyNews.swift
//  libnhk
//
//  Created by Michael Herring on 2014/06/03.
//  Copyright (c) 2014年 Michael Herring. All rights reserved.
//
import Cocoa
import Foundation

typealias ArticleCatalog = Dictionary<String,ArticleEntry[]>
typealias ArticleEntry = Dictionary<String,String>

class NHKEasyNews: NSObject {
    var dataCache: NSData
    var articleStore: Array<NHKArticle>?
    init(data:NSData) {
        dataCache = data
        articleStore = Array<NHKArticle>()
        super.init()
        if data != nil {
            self.processData(dataCache)
        }
        else {
            println("Inited NHKEasyNews with nil data.")
        }
    }
    convenience init(URL url:NSURL) {
        self.init(data: NSData(contentsOfURL:url))
    }
    convenience init() {
        let easyURL:NSURL = NSURL(string: "http://www3.nhk.or.jp/news/easy/news-list.json")
        self.init(URL:easyURL)
    }
    func processData(data:NSData) {
        let err:NSErrorPointer = nil
        let newsArrayWrapper:NSArray = NSJSONSerialization.JSONObjectWithData(data,options: .MutableLeaves, error: err) as Array<ArticleCatalog>
        let innerDict:ArticleCatalog = newsArrayWrapper[0] as ArticleCatalog
        var returnArray = NHKArticle[]()
        for (date, articleArray) in innerDict {
            println("in \(date) there are \(articleArray.count) articles...")
            for nextArticle:ArticleEntry in articleArray {
                var article:NHKArticle = NHKArticle()
                article.permalink = NSURL(string:nextArticle["news_web_url"]!)
                article.title = nextArticle["title"]!
                article.publishDate = nextArticle["news_prearranged_time"]!
                article.identifier = nextArticle["news_id"]!
                returnArray.append(article)
                println(article.title)
            }
        }
        articleStore = returnArray
    }
}