//
//  OnboardingViewController.swift
//  VacunaT
//
//  Created by Aldo on 16/01/18.
//  Copyright © 2018 Aldo. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController {
    
    //Onboarding
    let doneButton = UIButton(type: UIButtonType.system)
    let onboarding = PaperOnboarding(itemsCount: 3)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.addTarget(self, action: #selector(dismissOnboarding), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupPaperOnboardingView()
    }
    
    private func setupPaperOnboardingView() {
        
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    @objc func dismissOnboarding(){
        UserDefaults.standard.set(true, forKey: "DontShowAgain")
        onboarding.removeFromSuperview()
        doneButton.removeFromSuperview()
        dismiss(animated: true, completion: nil)
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


// MARK: PaperOnboardingDelegate
extension OnboardingViewController: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        
        if(index == 2){
            onboarding.addSubview(doneButton)
            doneButton.frame = CGRect(x: self.view.frame.width - 68, y: 70, width: 60, height: 32)
            doneButton.titleLabel?.textAlignment = .right
            doneButton.setTitle("Iniciar", for: .normal)
            
        } else {
            doneButton.removeFromSuperview()
        }
        
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        
        
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        //    item.titleLabel?.backgroundColor = .redColor()
        //    item.descriptionLabel?.backgroundColor = .redColor()
        //    item.imageView = ...
    }
    
}

// MARK: PaperOnboardingDataSource
extension OnboardingViewController: PaperOnboardingDataSource {
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        
        return [
            (UIImage(named: "record")!,
             "Registra",
             "Crea tu perfil o los perfiles de las personas que quieras estar",
             UIImage(),
             UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (UIImage(named: "vacina")!,
             "Consulta",
             "Las vacunas disponibles para ti y tus seres queridos",
             UIImage(),
             UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (UIImage(named: "push-notifications")!,
             "Recibe",
             "Notificaciones cuando sea tiempo de tener una nueva vacuna en tu historial",
             UIImage(),
             UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont)
            ][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
}
