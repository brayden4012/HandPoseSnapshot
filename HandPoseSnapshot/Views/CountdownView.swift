//
//  CountdownView.swift
//  HandPoseSnapshot
//
//  Created by Brayden Harris on 11/11/21.
//

import UIKit

class CountdownView: UIView {
    private lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 100, weight: .heavy)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var count = 3
    var countdownCompletion = { }

    override func awakeFromNib() {
        backgroundColor = .clear
        addSubview(countdownLabel)
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if self.count > 0 {
                self.countdownLabel.text = String(self.count)
                self.count -= 1
            } else {
                self.countdownCompletion()
                self.countdownLabel.text?.removeAll()
                timer.invalidate()
                self.count = 3
            }
        }
    }
}
