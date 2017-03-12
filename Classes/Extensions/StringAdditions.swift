//
//  StringAdditions.swift
//  QuoteBook
//
//  Created by yusuf_kildan on 11/03/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import Foundation

extension String {
    public func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}
