//
//  main.swift
//  fontwrangler
//
//  Created by Mark Knowles on 14/1/19.
//  Copyright © 2019 Mark Knowles. All rights reserved.
//

import Foundation
import AppKit


class FontWrangler {
    
    // the collection name as displayed in Font Book
    private var newCollectionName: String = ""
    // the string to search for when enumerating fonts
    private var searchKeyword: String = ""
    
    private func err(_ error_string:String) {
        FileHandle.standardError.write(error_string.data(using: .utf8)!)
    }
    
    private func parse_args() {
        
        if CommandLine.argc < 3 {
            self.err("usage: fontwrangler new_collection_name search_keyword\n")
            self.err("example: fontwrangler Powerline powerline\n")
            exit(1)
        }

        self.newCollectionName = CommandLine.arguments[1]
        self.searchKeyword = CommandLine.arguments[2]
    }
    
    public func main() {
        
        self.parse_args()
        
        // the new font collection we're creating
        var new_descriptors: [NSFontDescriptor] = []
        
        if NSFontCollection(name: NSFontCollection.Name(self.newCollectionName)) != nil {
            self.err("Font collection already defined\n")
            exit(1)
        }
        
        guard let all_fonts = NSFontCollection(name: NSFontCollection.Name.allFonts) else {
            self.err("Couldn't get all the fonts\n")
            exit(1)
        }

        // enumerate all fonts, looking for the word in searchKeyword.
        // Append matching fonts to new_descriptors
        for descriptor in all_fonts.matchingDescriptors! {

            // find the name of the font
            if let name:String = descriptor.fontAttributes[NSFontDescriptor.AttributeName.name] as? String {
                if name.range(of: searchKeyword, options: .caseInsensitive) != nil {
                    print("Added", name)
                    new_descriptors.append(descriptor)
                }
            }
        }

        // make the collection visible

        do {
            let nc = NSFontCollection(descriptors: new_descriptors)
            try NSFontCollection.show(nc, withName:NSFontCollection.Name(self.newCollectionName), visibility: .user)
        } catch {
            self.err("Couldn't create the collection. Sorry...\n")
        }
    }
}

FontWrangler().main()
