//
//  VaccinateDetailViewController.swift
//  Vacuna-T
//
//  Created by Aldo on 04/11/17.
//  Copyright © 2017 Aldo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class VaccinateDetailViewController: UIViewController {
    
    
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblVaccinate: UILabel!
    
    @IBOutlet weak var banner: GADBannerView!
    
    var rawDescription = ""
    var vaccinate = ""
    var age = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblVaccinate.text = vaccinate
        
        let ageText = "Aplicar en: \(age) \n"
        
        let totalDescription = ageText + rawDescription
        //Get sections
        let separators = totalDescription.indexes(of: "\n")    // [7, 19, 31]
        //separators.insert(rawDescription.startIndex, at: 0)
        
        let finalDescription = totalDescription.replacingOccurrences(of: "•", with: "\n •")
        
        //: Initialize the mutable string
        let myMutableString = NSMutableAttributedString(
            string: finalDescription,
            attributes: [NSAttributedStringKey.font:
                UIFont(name: "Helvetica", size: 16.0)!])
        
        //Bold for age
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: UIFont(name: "Helvetica-Bold",size: 16.0)!,
                                     range: NSRange(location: 12, length: age.count))
        
        let sections = separators.count / 2
        
        for index in 0..<sections {
            //: Sections Format
            myMutableString.addAttribute(NSAttributedStringKey.font,
                value: UIFont(name: "Helvetica-Bold",size: 18.0)!,
                range: NSRange(location: separators[index * 2].encodedOffset, length: separators[index * 2 + 1].encodedOffset - separators[index * 2].encodedOffset))
            myMutableString.addAttribute(
                NSAttributedStringKey.foregroundColor,
                value: UIColor(red: 59/255, green: 109/255, blue: 199/255, alpha: 1.0),
                range: NSRange(location: separators[index * 2].encodedOffset, length: separators[index * 2 + 1].encodedOffset - separators[index * 2].encodedOffset))
            
            //: Add a Drop Shadow
            
            //: Make the Drop Shadow
            let shadow = NSShadow()
            shadow.shadowOffset = CGSize(width: 3, height: 3)
            shadow.shadowBlurRadius = 10
            shadow.shadowColor = UIColor.lightGray
            
            //: Add a drop shadow to the text
            myMutableString.addAttribute(
                NSAttributedStringKey.shadow,
                value: shadow,
                range: NSRange(location: separators[index * 2].encodedOffset, length: separators[index * 2 + 1].encodedOffset - separators[index * 2].encodedOffset))
        }
        
        //: Apply to the TextView
        txtDescription.attributedText = myMutableString
        txtDescription.textAlignment = .justified
        
        //Banner
        //Test ID: ca-app-pub-3940256099942544/2934735716
        //Real ID: ca-app-pub-3383512806298757/4946989400
        banner.adUnitID = "ca-app-pub-3383512806298757/4946989400"
        banner.rootViewController = self
        
        banner.load(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
}
