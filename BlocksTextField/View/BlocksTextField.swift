//
//  BlocksTextField.swift
//  BlocksTextField
//
//  Created by AllenCheung on 16/10/2017.
//  Copyright © 2017 com.temp. All rights reserved.
//

import UIKit
import SnapKit

protocol BlocksTextFieldDelegate: NSObjectProtocol {
    func blocksTextFieldEditingChanged(_ blocksTextField: BlocksTextField)
    func blocksTextFieldDidBeginEditing(_ blocksTextField: BlocksTextField)
    func blocksTextFieldDidEndEditing(_ blocksTextField: BlocksTextField)
}

extension BlocksTextFieldDelegate {
    func blocksTextFieldEditingChanged(_ blocksTextField: BlocksTextField) {}
    func blocksTextFieldDidBeginEditing(_ blocksTextField: BlocksTextField) {}
    func blocksTextFieldDidEndEditing(_ blocksTextField: BlocksTextField) {}
}

class BlocksTextField: UIView {
    weak var delegate: BlocksTextFieldDelegate?
    
    var count: UInt = 0 {
        didSet {
            updateView()
        }
    }
    
    var space: CGFloat = 9.0 {
        didSet {
            updateView()
        }
    }
    
    var font: UIFont = UIFont.systemFont(ofSize: 18) {
        didSet {
            guard subBlocks.count > 0 else { return () }
            
            for subBlock in subBlocks {
                subBlock.font = font
            }
        }
    }
    
    var textColor: UIColor = UIColor.black {
        didSet {
            guard subBlocks.count > 0 else { return () }
            
            for subBlock in subBlocks {
                subBlock.textColor = textColor
            }
        }
    }
    
    var bottomLineColor: UIColor = UIColor.black {
        didSet {
            guard subBlocks.count > 0 else { return () }
            
            for subBlock in subBlocks {
                subBlock.bottomLineColor = bottomLineColor
            }
        }
    }
    
    var keyboardType: UIKeyboardType = .default {
        didSet {
            guard subBlocks.count > 0 else { return () }
            
            for subBlock in subBlocks {
                subBlock.keyboardType = keyboardType
            }
        }
    }
    
    var text: String? {
        get {
            guard subBlocks.count > 0 else { return nil }
            
            var result = ""
            for subBlock in subBlocks {
                result = result + (subBlock.text ?? "")
            }
            
            return result
        }
        set {
            guard subBlocks.count > 0 else { return }
            
            for (index, subBlock) in subBlocks.enumerated() {
                if let value = newValue, value.characters.count > index {
                    subBlock.text = value[index]
                } else {
                    subBlock.text = nil
                }
            }
        }
    }
    
    var isInputValid: Bool {
        get {
            guard subBlocks.count > 0 else { return false }
            
            for subBlock in subBlocks {
                if subBlock.text == nil || subBlock.text?.characters.count == 0 {
                    return false
                }
            }
            
            return true
        }
    }
    
    fileprivate var subBlocks: [SubBlockTextField] = []
    fileprivate var textFieldDidEndAutoTriggered: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        updateView()
    }

    private func updateView() {
        while self.subviews.count > 0 {
            self.subviews.last?.removeFromSuperview()
        }
        
        guard count >= 2 else { return () }
        
        var leftBlock: SubBlockTextField? = nil
        for index in 0..<count {
            let subBlock = createSubBlock(tag: index)
            self.addSubview(subBlock)
            subBlock.snp.makeConstraints { (make) in
                if index == 0 {
                    make.leading.equalTo(self)
                } else {
                    make.leading.equalTo(leftBlock!.snp.trailing).offset(self.space)
                }
                let offset = self.space*(CGFloat(self.count-1)) / CGFloat(self.count)
                make.width.equalTo(self.snp.width).multipliedBy(CGFloat(1)/CGFloat(self.count)).offset(-offset)
                make.top.equalTo(self)
                make.bottom.equalTo(self)
            }
            
            leftBlock = subBlock
            subBlocks.append(subBlock)
        }
        self.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapGes)
    }
    
    private func createSubBlock(tag: UInt) -> SubBlockTextField {
        let subBlock = SubBlockTextField()
        subBlock.textField.tag = Int(tag)
        subBlock.textColor = textColor
        subBlock.font = font
        subBlock.bottomLineColor = bottomLineColor
        subBlock.keyboardType = keyboardType
        subBlock.isUserInteractionEnabled = false
        subBlock.textField.delegate = self
        
        return subBlock
    }
    
    @objc private func tapped() {
        guard count >= 2 else { return () }
        
        for (index, subBlock) in subBlocks.enumerated() {
            if subBlock.text == nil || subBlock.text?.isEmpty == true {
                subBlock.textField.becomeFirstResponder()
                
                delegate?.blocksTextFieldDidBeginEditing(self)
                break
            } else if UInt(index+1) == count {
                subBlock.textField.becomeFirstResponder()
                
                delegate?.blocksTextFieldDidBeginEditing(self)
            }
        }
    }
}

extension BlocksTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.characters.count > 1 {
            return false
        }
        if let oldText = textField.text, oldText.isEmpty == false {
            if string.isEmpty {
                textField.text = ""
                
                delegate?.blocksTextFieldEditingChanged(self)
            } else {
                
            }
        } else {
            if string.isEmpty {
                if textField.tag > 0 {
                    textFieldDidEndAutoTriggered = true
                    subBlocks[textField.tag - 1].textField.text = ""
                    subBlocks[textField.tag - 1].textField.becomeFirstResponder()
                    
                    delegate?.blocksTextFieldEditingChanged(self)
                }
            } else {
                textField.text = string
                if UInt(textField.tag + 1) < count {
                    textFieldDidEndAutoTriggered = true
                    subBlocks[textField.tag + 1].textField.becomeFirstResponder()
                }
                delegate?.blocksTextFieldEditingChanged(self)
            }
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textFieldDidEndAutoTriggered {
            textFieldDidEndAutoTriggered = false
        } else {
            delegate?.blocksTextFieldDidEndEditing(self)
        }
    }
}
