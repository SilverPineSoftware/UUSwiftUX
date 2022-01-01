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
    func uuSetPlaceholderColor(_ color : UIColor)
    {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor : color])
    }
}



class UUTextFieldDelegate : NSObject, UITextFieldDelegate
{
    class Configuration : NSObject
    {
        init(forceCapitalization : Bool = false, autoDismissKeyboard : Bool = true, maximumTextLength : Int? = nil, dismissKeyboardWhenComplete : Bool = true, allowedCharacterSet : CharacterSet? = nil)
        {
            super.init()
            self.forceCapitalization = forceCapitalization
            self.autoDismissKeyboard = autoDismissKeyboard
            self.allowedCharacterSet = allowedCharacterSet
            self.maxiumumTextLength = maximumTextLength
            self.dismissKeyboardWhenComplete = dismissKeyboardWhenComplete
        }
        
        var allowedCharacterSet : CharacterSet? = nil
        var forceCapitalization = false
        var autoDismissKeyboard = true
        var maxiumumTextLength : Int? = nil
        var dismissKeyboardWhenComplete = true
    }
    
    var configuration : UUTextFieldDelegate.Configuration = Configuration()
    
    convenience init(configuration : UUTextFieldDelegate.Configuration)
    {
        self.init()
        self.configuration = configuration
    }
    
    convenience init(textFields : [UITextField], configuration : UUTextFieldDelegate.Configuration)
    {
        self.init()
        self.configuration = configuration
        self.addManagedTextFields(textFields)
    }
    
    convenience init(textFields : [UITextField])
    {
        self.init()
        self.addManagedTextFields(textFields)
    }
    
    func addManagedTextFields(_ textFields : [UITextField])
    {
        for textField in textFields
        {
            textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
            textField.delegate = self
        }
        
        self.fields = textFields
    }
    
    func allFieldsHaveText() -> Bool
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
    
    func advanceToNextField()
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
    
    func resignFirstResponder()
    {
        for field in self.fields
        {
            field.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
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
    
    @objc func textFieldChanged(_ textField: UITextField)
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
