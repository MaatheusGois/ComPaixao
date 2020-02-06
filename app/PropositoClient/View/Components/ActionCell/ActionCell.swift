//
//  ActionCell.swift
//  PropositoClient
//
//  Created by Matheus Silva on 03/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ActionCell: UICollectionViewCell {
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var fakeButton: UIButton!
    @IBOutlet weak var seeDetailButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func complete(duration: TimeInterval = 0.5,
                  delay: TimeInterval = 0.0,
                  completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.fakeButton.setImage(UIImage(named: "check_all"), for: .normal)
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseIn,
                       animations: {
                        self.alpha = 0.0
        }, completion: { finish in
            self.fakeButton.setImage(UIImage(named: "check_void"), for: .normal)
            completion(finish)
        })
    }

}
