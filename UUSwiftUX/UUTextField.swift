//
//  UUTextField
//  Useful Utilities - Simple UITextField subclass to support a few IBDesignable additions
//
//	License:
//  You are free to use this code for whatever purposes you desire.
//  The only requirement is that you smile everytime you use it.
//

#if os(iOS)

import UIKit
import UUSwiftCore

@IBDesignable class UUTextField: UITextField
{
    @IBInspectable public var leftPadding : CGFloat = 0
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var rightPadding : CGFloat = 0
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var topPadding : CGFloat = 0
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var bottomPadding : CGFloat = 0
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var placeholderColor : UIColor = UIColor(white: 1.0, alpha: 0.7)
    {
        didSet
        {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor : placeholderColor])
            self.setNeedsDisplay()
        }
    }
    
    private var paddingRect : UIEdgeInsets
    {
        return UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: paddingRect)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: paddingRect)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
		return bounds.inset(by: paddingRect)
    }
}

extension UITextField
{
    public func uuSetPlaceholderColor(_ color : UIColor)
    {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor : color])
    }
}



public class UUTextFieldDelegate : NSObject, UITextFieldDelegate
{
    public class Configuration : NSObject
    {
        public init(forceCapitalization : Bool = false, autoDismissKeyboard : Bool = true, maximumTextLength : Int? = nil, dismissKeyboardWhenComplete : Bool = true, allowedCharacterSet : CharacterSet? = nil)
        {
            super.init()
            self.forceCapitalization = forceCapitalization
            self.autoDismissKeyboard = autoDismissKeyboard
            self.allowedCharacterSet = allowedCharacterSet
            self.maxiumumTextLength = maximumTextLength
            self.dismissKeyboardWhenComplete = dismissKeyboardWhenComplete
        }
        
        public var allowedCharacterSet : CharacterSet? = nil
        public var forceCapitalization = false
        public var autoDismissKeyboard = true
        public var maxiumumTextLength : Int? = nil
        public var dismissKeyboardWhenComplete = true
    }
    
    public var configuration : UUTextFieldDelegate.Configuration = Configuration()
    
    public convenience init(configuration : UUTextFieldDelegate.Configuration)
    {
        self.init()
        self.configuration = configuration
    }
    
    public convenience init(textFields : [UITextField], configuration : UUTextFieldDelegate.Configuration)
    {
        self.init()
        self.configuration = configuration
        self.addManagedTextFields(textFields)
    }
    
    public convenience init(textFields : [UITextField])
    {
        self.init()
        self.addManagedTextFields(textFields)
    }
    
    public func addManagedTextFields(_ textFields : [UITextField])
    {
        for textField in textFields
        {
            textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
            textField.delegate = self
        }
        
        self.fields = textFields
    }
    
    public func allFieldsHaveText() -> Bool
    {
        var allComplete = true
        for textField in self.fields
        {
            if (textField.text?.count ?? 0) <= 0
            {
                allComplete = false
            }
        }
        
        return allComplete
    }
    
    public var firstResponder : UITextField?
    {
        get {
            for textField in self.fields
            {
                if textField.isFirstResponder
                {
                    return textField
                }
            }
            
            return nil
        }
    }
    
    public func advanceToNextField()
    {
        if let textField = self.firstResponder,
           let index = self.fields.firstIndex(of: textField)
        {
            // If we are the last field, move to the first field...
            if index == self.fields.count - 1
            {
                self.fields.first?.becomeFirstResponder()
            }
            else
            {
                self.fields[index + 1].becomeFirstResponder()
            }
        }
    }
    
    public func resignFirstResponder()
    {
        for field in self.fields
        {
            field.resignFirstResponder()
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // If all the fields have text in them and we are set to dismiss when all complete...
        if self.configuration.dismissKeyboardWhenComplete && self.allFieldsHaveText()
        {
            textField.resignFirstResponder()
            return false
        }
        
        // If autoDismiss is true and we have 1 or fewer fields...
        if self.fields.count < 2 && self.configuration.autoDismissKeyboard
        {
            textField.resignFirstResponder()
        }
        else {
            self.advanceToNextField()
        }
        
        return false
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if let text = textField.text,
           let stringRange = Range(range, in:  text),
           let maxLength = self.configuration.maxiumumTextLength
        {
            let insertedText = text.replacingCharacters(in: stringRange, with: string)
            return insertedText.count <= maxLength
        }

        return true
    }
    
    @objc public func textFieldChanged(_ textField: UITextField)
    {
        if let rawString = textField.text
        {
            var finalString = rawString
            
            if let characterSet = self.configuration.allowedCharacterSet
            {
                finalString = rawString.trimmingCharacters(in: characterSet.inverted)
            }
            
            if self.configuration.forceCapitalization
            {
                finalString = finalString.uppercased()
            }
            
            textField.text = finalString
        }
    }

    
    private var fields : [UITextField] = []

}
#endif
