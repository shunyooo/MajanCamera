//
//  LandingViewController.swift
//  MajanCamera
//
//  Created by Syunyo Kawamoto on 2018/05/11.
//  Copyright © 2018年 Syunyo Kawamoto. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    let picker = UIImagePickerController()
    let indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        picker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(#function)
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        showIndicator()
        Api.detect(image: image, success: {
            (pis) in dump(pis)
            
            let vc:CollectionPiViewController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionPiViewController") as! CollectionPiViewController
            vc.piImage = image
            vc.pis = pis
            self.present(vc, animated: true, completion: nil)
            
            
        }, failure: {
            error in
            self.showSimpleAlert(title: "Error", message: error.debugDescription, ok_handler: nil, cancel_handler: nil)
        }, completion: {
            _ in
            self.stopIndicator()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func albumButtonTapped(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func showIndicator() {
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.center = self.view.center
        indicator.color = UIColor.gray
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        self.view.bringSubview(toFront: indicator)
        indicator.startAnimating()
    }
    
    func stopIndicator(){
        indicator.stopAnimating()
    }

}
