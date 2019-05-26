//
//  CurrencyTableViewCell.swift
//  Revolut
//
//  Created by Igor Shvetsov on 04/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation
import UIKit

struct CurrencyTableViewCellVM {
    var imageName: String
    var title: String
    var subtitle: String
    var value: String
    var action: CellAction
}

typealias CellAction = ((String) -> Void)

class CurrencyTableViewCell: UITableViewCell {
        
    @IBOutlet private weak var countryImageView: UIImageView!    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var valueTextField: UITextField!
    @IBOutlet private weak var tfBottomBorder: UIView!
    
    private var action: CellAction?
    
    // MARK: Cell lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countryImageView.makeRounded()
        valueTextField.delegate = self
        valueTextField.isEnabled = false
        tfBottomBorder.backgroundColor = UIColor.tintGrayColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        action = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        valueTextField.isEnabled = selected
        if selected {
            valueTextField.becomeFirstResponder()
        }
    }
    
    // MARK: VM binding
    
    func configureWith(cellVM: CurrencyTableViewCellVM) {
        if let image = UIImage(named: cellVM.imageName) {
            countryImageView.image = image
        }
        titleLabel.text = cellVM.title
        subtitleLabel.text = cellVM.subtitle
        valueTextField.text = cellVM.value
        
        action = cellVM.action
    }
}

// MARK: UITextFieldDelegate

extension CurrencyTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == valueTextField else { return true }
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let enteredText = text.replacingCharacters(in: textRange, with: string)
            action?(enteredText)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tfBottomBorder.backgroundColor = UIColor.tintBlueColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tfBottomBorder.backgroundColor = UIColor.tintGrayColor
    }
}
