//
//  ViewController.swift
//  ISBN
//
//  Created by Jesús de Villar on 21/5/16.
//  Copyright © 2016 JdeVillar. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var isbn: UITextField!
    
    var detallesISBN: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* limia el campo ISBN */
    @IBAction func clearISBN(sender: AnyObject) {
        self.isbn.text = nil
    }

    @IBAction func BuscarISBN(sender: AnyObject) {
        if (!((isbn.text?.isEmpty)!)){
            let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(self.isbn.text!)"
            let url = NSURL(string: urls)
            if (url != nil){
                let datos:NSData? = NSData(contentsOfURL: url!)
                if (datos != nil){
                    var texto = String(data: datos!, encoding: NSUTF8StringEncoding)
                    if (texto == "{}"){
                        texto = "No se ha encontrado la Publicación"
                    }
                    detallesISBN = texto!
                } else {
                    let texto = "No ha sido posible conectar con el servicio"
                    detallesISBN = texto
                }
            } else {
                let texto = "No ha sido posible conectar con el servicio"
                detallesISBN = texto
            }
        } else {
            let texto = "indique un ISBN"
            detallesISBN = texto
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let resultado = detallesISBN
        let sigVista=segue.destinationViewController as! ResultadoController
        sigVista.detalleIBSN = resultado
    }
}

