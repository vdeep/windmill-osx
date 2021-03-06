//
//  SummaryViewController.swift
//  windmill
//
//  Created by Markos Charatzas (markos@qnoid.com) on 4/3/18.
//  Copyright © 2014-2020 qnoid.com. All rights reserved.
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation is required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source distribution.
//

import AppKit

extension NSTextView {
    
    func lineRange(for summary: Summary) -> NSRange? {
        
        guard summary.characterRangeLoc >= 0 else {
            return nil
        }
        
        let string = (self.string as NSString)
        
        return string.lineRange(for: NSRange(location: summary.characterRangeLoc, length: 0))
    }

    /**
 
     - parameter line: 0 based.
    */
    func lineRange(startingLineNumber: Int) -> NSRange {
        
        let string = (self.string as NSString)
        
        let length = string.length
        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange()
        while (index < length && numberOfLines < startingLineNumber) {
            
            lineRange = string.lineRange(for: NSMakeRange(index, 0))
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        
        return lineRange
    }
}

class SummaryViewController: NSViewController {

    @IBOutlet weak var pathControl: NSPathControl! {
        didSet{
            pathControl.isHidden = true
            pathControl.isEditable = false
            pathControl.controlSize = .regular
        }
    }

    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var textView: NSTextView! {
        didSet{
            let rulerView = TextViewRuler<NSTextView>(scrollView: textView.enclosingScrollView, orientation: .verticalRuler)
            rulerView.clientView = textView
            rulerView.ruleThickness = 36
            rulerView.accessoryView = nil
            
            textView.usesRuler = true
            textView.isRulerVisible = true
            textView.enclosingScrollView?.horizontalRulerView = nil
            textView.enclosingScrollView?.verticalRulerView = rulerView

            textView.textColor = NSColor.textColor
            textView.layerContentsPlacement = .left
            textView.layerContentsRedrawPolicy = .onSetNeedsDisplay
            textView.layoutManager?.allowsNonContiguousLayout = true
            textView.isEditable = false
            textView.isRichText = true
            textView.allowsUndo = false
            textView.isContinuousSpellCheckingEnabled = false
            textView.isAutomaticSpellingCorrectionEnabled = false
            textView.isAutomaticQuoteSubstitutionEnabled = false
            textView.isAutomaticDashSubstitutionEnabled = false
            textView.isAutomaticTextReplacementEnabled = false
            textView.smartInsertDeleteEnabled = false
            textView.usesFontPanel = false
            textView.usesFindPanel = false
        }
    }
    
    var textStorage: NSTextStorage?
    
    var locations: Windmill.Locations?
    
    var summary: Summary? {
        didSet{
            guard let summary = summary, let documentURL = summary.documentURL else {
                return
            }
                        
            guard let data = try? Data(contentsOf: documentURL), let source = String(data: data, encoding: .utf8) else {
                return
            }
            
            if let pathControl = self.pathControl {
                pathControl.isHidden = false
                
                if let locations = self.locations {
                    let string = documentURL.path.replacingOccurrences(of: locations.sources.URL.path, with: "")
                    pathControl.url = URL(string: string)
                }
                
                pathControl.pathItems.forEach { path in
                    path.image = #imageLiteral(resourceName: "NavGroup")
                }
                pathControl.pathItems.first?.image = #imageLiteral(resourceName: "xcode-project_icon")
                pathControl.pathItems.last?.image = #imageLiteral(resourceName: "swift-source_Icon")
            }

            guard let textView = self.textView else {
                return
            }
            
            textView.string = source
            
            guard let textStorage = textView.textStorage else {
                return
            }

            textView.toolTip = "In Xcode, \"Jump Line In “\(documentURL.lastPathComponent)“... ⌘L\" \(summary.lineNumber)"
            
            if let characterRange = summary.characterRange {
                textStorage.addAttributes([.underlineColor : NSColor.systemRed, .underlineStyle: NSUnderlineStyle.single.rawValue], range: characterRange)
            }
            
            let lineRange: NSRange
            
            if let range = textView.lineRange(for: summary) {
                lineRange = range
            } else {
                lineRange = textView.lineRange(startingLineNumber: summary.lineNumber)
            }
            
            textStorage.addAttributes([NSAttributedString.Key.backgroundColor : NSColor.selectedTextBackgroundColor ], range: lineRange)
            
            textView.scrollRangeToVisible(lineRange)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
}
