//
//  ProfileController+UIPickerView.swift
//  PassportincMobileChallenge
//
//  Created by Steven Roseman on 6/17/18.
//  Copyright © 2018 Steven Roseman. All rights reserved.
//

import UIKit

extension ProfileController{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aprofile.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cell, for: indexPath) as! ProfileCell
        
        let profileX = aprofile[indexPath.row]
        
        if profileX.gender == "male"{
            cell.backgroundColor = .blue
            
        } else {
            cell.backgroundColor = UIColor(red: 0.88, green: 0.15, blue: 0.64, alpha: 1)
        }
        cell.profile = profileX
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let profileX = aprofile[indexPath.row]
        //pass data to detail view
        controllerNav(profileX: profileX)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == firstHobbyPickerView{
            return hobbies.count
        } else if pickerView == secondHobbyPickerView{
            return hobbies.count
        } else if pickerView == filterPickerView{
            return sortOptions.count
            
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == firstHobbyPickerView{
            return hobbies[row]
        } else if pickerView == secondHobbyPickerView{
            return hobbies[row]
        } else if pickerView == filterPickerView{
            return sortOptions[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == firstHobbyPickerView{
            firstHobbyChosen = hobbies[row]
        } else if pickerView == secondHobbyPickerView{
            secondHobbyChosen = hobbies[row]
        } else if pickerView == filterPickerView{
            pickerViewOptionChose = sortOptions[row]
            loadProfiles(withOptionChosen: pickerViewOptionChose)
            
        }
        
    }
    
}

