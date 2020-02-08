//
//  UIAlert.swift
//  PropositoClient
//
//  Created by Matheus Silva on 06/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

struct UIAlert {
    static func show(controller: UIViewController,
                     title: String,
                     message: String,
                     alertAction1: String,
                     withComplete complete: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: alertAction1,
                                      style: .destructive, handler: { (_) in
            complete(true)
        }))

        alert.addAction(UIAlertAction(title: "Cancelar",
                                      style: .cancel, handler: { (_) in
            complete(false)
        }))

        controller.present(alert, animated: true, completion: nil)
    }
}
