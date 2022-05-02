//
//  UULinkTapGestureHandler.swift
//  Useful Utilities
//
//    License:
//  You are free to use this code for whatever purposes you desire.
//  The only requirement is that you smile everytime you use it.
//

import UIKit

/**
 Helper class that allows tapping on a portion of text in a UITextView
 
```
 class ExampleCell: UICollectionViewCell
 {
     @IBOutlet weak var textView: UITextView!
     
     // 1) Keep a strong reference to the gesture handler in your Cell or View Controller
     private var gestureHandler: UULinkTapGestureHandler? = nil
     
     override func awakeFromNib()
     {
         super.awakeFromNib()
         
         // 2) Instantiate the gesture handler with the text view
         let gr = UULinkTapGestureHandler(textView)
         
         // 3) Add actions that are triggered when a phrase is tapped on
         gr.addAction("somebody@email.com", handleEmailTapped)
         self.gestureHandler = gr // Keep a strong reference
     }
     
     private func handleEmailTapped()
     {
         // Do stuff
     }
 }
 ```
 
 */
public class UULinkTapGestureHandler: NSObject
{
    private(set) var actions: [String:(()->())] = [:]
    private(set) var defaultAction: (()->())? = nil
        
    required init(_ view: UITextView)
    {
        super.init()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func addAction(_ text: String, _ action: @escaping (()->()))
    {
        actions[text] = action
    }
    
    func reset()
    {
        actions.removeAll()
    }
    
    func setupDefaultAction(_ action: (()->())?)
    {
        self.defaultAction = action
    }
    
    func setup(_ attributedString: NSAttributedString?, _ linkTappedCallback: @escaping (URL)->())
    {
        reset()
        
        if let tmp = attributedString
        {
            tmp.enumerateAttribute(.link, in: NSMakeRange(0, tmp.length), options: [])
            { (valueOpt, range, stop) in
                
                if let url = valueOpt as? URL,
                   range.length > 0
                {
                    let text = tmp.string.uuSubString(range.location, range.length)
                    
                    let trimmed = text.uuTrimWhitespace()
                    if !trimmed.isEmpty
                    {
                        addAction(text)
                        {
                            linkTappedCallback(url)
                        }
                    }
                }
            }
        }
    }
    
    @objc
    func handleTapGesture(_ gr: UITapGestureRecognizer)
    {
        if let tv = gr.view as? UITextView
        {
            let p = gr.location(in: tv)
            if let tapPosition = tv.closestPosition(to: p)
            {
                if let range = tv.tokenizer.rangeEnclosingPosition(tapPosition, with: .word, inDirection: UITextDirection.layout(.right))
                {
                    if let word = tv.text(in: range)
                    {
                        for o in actions
                        {
                            if (didTapOnPhrase(word, o.key))
                            {
                                o.value()
                                return
                            }
                        }
                    }
                }
            }
        }
        
        defaultAction?()
    }
    
    private func didTapOnPhrase(_ word: String, _ target: String) -> Bool
    {
        // For handling taps on email and URL links.  The tokenizer will split things
        // up based on the puncuation, so this will loop over the textual words in the action
        var splitTarget = target.replacingOccurrences(of: "@", with: " ")
        splitTarget = splitTarget.replacingOccurrences(of: ".", with: " ")
        splitTarget = splitTarget.replacingOccurrences(of: ":", with: " ")
        splitTarget = splitTarget.replacingOccurrences(of: "/", with: " ")
        
        let parts = splitTarget.components(separatedBy: " ")
        for p in parts
        {
            if (p.lowercased() == word.lowercased())
            {
                return true
            }
        }
        
        return false
    }
}
