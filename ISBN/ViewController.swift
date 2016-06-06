//
//  ViewController.swift
//  ISBN
//
//  Created by Jesús de Villar on 21/5/16.
//  Copyright © 2016 JdeVillar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var isbn: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var titulo: UILabel!
    
    @IBOutlet weak var labelAutores: UILabel!
    @IBOutlet weak var autores: UILabel!
    
    @IBOutlet weak var imagenView: UIImageView!
    
    var detallesISBN: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isbn.delegate = self
        activityIndicator.hidden = true
        self.autores.text?.removeAll()
        labelTitulo.hidden = true
        labelAutores.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* limia el campo ISBN */
    @IBAction func clearISBN(sender: AnyObject) {
        self.isbn.text = nil
        self.autores.text?.removeAll()
        self.titulo.text = nil
        self.imagenView.image = nil
        
        labelTitulo.hidden = true
        labelAutores.hidden = true
    }

    @IBAction func BuscarISBN(sender: AnyObject) {
        self.isbn.resignFirstResponder()
        self.startActiviy()
        
        if (!((isbn.text?.isEmpty)!)){
            let isbnAux = self.isbn.text
            self.isbn.text = isbnAux!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(self.isbn.text!)"
            let url = NSURL(string: urls)
            let session = NSURLSession.sharedSession()
            let bloque = {
                (datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
                if error != nil {
                /* se ha producido un error, lanzamos una alerta*/
                    self.stopActiviy()
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in print("Handle Ok logic")}))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                } else {
                    dispatch_sync(dispatch_get_main_queue()) {
                        //self.textView.text = texto as! String
                        let datos = NSData(contentsOfURL: url!)
                        self.muestraDatos(datos!)
                        self.stopActiviy()
                        self.labelTitulo.hidden = false
                        self.labelAutores.hidden = false
                    }
                }
            }
            let dataTask = session.dataTaskWithURL(url!, completionHandler:bloque)
            dataTask.resume()
        } else {
            stopActiviy()
            let texto = "indique un ISBN"
            let alert2 = UIAlertController(title: "Error", message: texto, preferredStyle: UIAlertControllerStyle.Alert)
            alert2.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in print("Handle Ok logic")}))
            self.presentViewController(alert2, animated: true, completion: nil)
        }
    }
    
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    func textFieldShouldReturn(sender: UITextField) -> Bool {
        startActiviy()
        sender.resignFirstResponder()
        BuscarISBN(self)
        return true
    }
    
    func startActiviy(){
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
    }
    
    func stopActiviy(){
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
    }
    
    func muestraDatos(datos : NSData){
        do {
            self.autores.text?.removeAll()
            let json = try NSJSONSerialization.JSONObjectWithData(datos, options: NSJSONReadingOptions.MutableLeaves)
            let dico1 = json as! NSDictionary
            let isbn = "ISBN:\(self.isbn.text!)"
            let dico2 = dico1[isbn] as! NSDictionary
            self.titulo.text = dico2["title"] as! NSString as String
            if let authors = dico2["authors"] as? [[String: AnyObject]] {
                for author in authors {
                    if let autor = author["name"] as? String{
                       //names.append(autor)
                        if ((self.autores.text?.isEmpty) != nil){
                            self.autores.text! = autor as String
                        } else {
                            self.autores.text = "\(self.autores.text), \(autor)"
                        }
                    }
                }
            }
            
            if let cover = dico2["cover"] as? NSDictionary {
                let urlCover = cover["medium"] as! NSString as String
                let url2 = NSURL(string: urlCover)
                let data:NSData = NSData(contentsOfURL: url2!)!
                imagenView.image = UIImage(data: data)
            }
            
        } catch _ {
            print("error ")
        }
    }
}

