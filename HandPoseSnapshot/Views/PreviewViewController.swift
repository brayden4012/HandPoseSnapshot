//
//  PreviewViewController.swift
//  HandPoseSnapshot
//
//  Created by Brayden Harris on 11/8/21.
//

import UIKit

/// A `ViewController` to display a captured image
class PreviewViewController: UIViewController {

    private lazy var previewImageView = UIImageView()

    init(previewImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.previewImageView.image = previewImage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.contentMode = .scaleAspectFit
        self.view.addSubview(previewImageView)
        NSLayoutConstraint.activate([
            previewImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            previewImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
