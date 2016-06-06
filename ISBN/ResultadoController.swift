//
//  ResultadoController.swift
//  ISBN
//
//  Created by Jesús de Villar on 21/5/16.
//  Copyright © 2016 JdeVillar. All rights reserved.
//

import UIKit

class ResultadoController: UIViewController {

    var detalleIBSN: String = ""
    
    @IBOutlet weak var ResultadoDetalle: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        ResultadoDetalle.text = String(detalleIBSN)
    }

}
