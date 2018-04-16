//
//  TakeNewPhotoViewController.swift
//  Tag_The_Bus
//
//  Created by Elyes DOUDECH on 15/04/2018.
//  Copyright © 2018 Elyes DOUDECH. All rights reserved.
//

import UIKit

class TakeNewPhotoViewController: UIViewController, 	UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var imageTaken: UIImageView!
   
    @IBOutlet weak var imageTitleTextField: UITextField!
    
    var imagePickerController: UIImagePickerController!
    
    @IBAction func confirmButton(_ sender: Any) {
        
        if (imageTitleTextField.text?.isEmpty)! //if the user typed the title
        {
            DialogBoxHelper.alert(view: self, withTitle: "Error", andMessage: "Missing Title")
        }
        else
        {
            saveImage(imageName: imageTitleTextField.text!)
            performSegue(withIdentifier: "unwindToSationImages", sender: self)
        }
        
        
        
       
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        

        // Do any additional setup after loading the view.
        
    }
    
    //this funcition will be called once so that the user can take a picture
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //this test is to ensure that the page is loaded for the first time
         if self.isBeingPresented || self.isMovingToParentViewController
         {
            
            present(imagePickerController,animated: true,completion: nil)
        }
      
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //this function is called after a photo is taken, it will dismiss the imagePickerController and display the photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        imageTaken.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Save image -
    
    func saveImage(imageName: String){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the image we took with camera
        let image = imageTaken.image!
        //get the PNG data for this image
        let data = UIImagePNGRepresentation(image)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    
    
    
    //MARK: - Textfield Delegate -
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // Start Editing The Text Field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
    }
    
    // Move the text field on the keyboard
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    

}
