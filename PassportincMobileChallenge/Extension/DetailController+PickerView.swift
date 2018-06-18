//
//  DetailController+PickerView.swift
//  PassportincMobileChallenge
//
//  Created by Steven Roseman on 6/18/18.
//  Copyright © 2018 Steven Roseman. All rights reserved.
//

import UIKit

extension DetailViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == firstHobbyPickerView{
            return hobbies.count
        } else if pickerView == secondHobbyPickerView{
            return hobbies.count
        }
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == firstHobbyPickerView{
            return hobbies[row]
        } else if pickerView == secondHobbyPickerView{
            return hobbies[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == firstHobbyPickerView{
            firstHobbyChosen = hobbies[row]
        } else {
            secondHobbyChosen = hobbies[row]
        }
        
    }
    
}
