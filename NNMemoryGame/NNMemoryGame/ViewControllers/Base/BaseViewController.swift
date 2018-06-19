//
//  BaseViewController.swift
//  Swap App
//
//  Created by Anton Klysa on 6/8/18.
//  Copyright © 2018 Anton Klysa. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var topLogoImage: UIImageView!
    var fumerTueView: UIView!
    public var backgroundImage: UIImageView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    
    //MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup controller props
        navigationController?.isNavigationBarHidden = true
        setupBackgroundImage()
        setupFumerTueView()
    }
    
    
    //MARK: functions
    
    fileprivate func setupBackgroundImage() {
        backgroundImage = UIImageView(frame: .zero)
        view.insertSubview(backgroundImage, at: 0)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImage.image = UIImage(named: "main_background")
    }
    
    fileprivate func setupFumerTueView() {
        fumerTueView = UIView(frame: .zero)
        fumerTueView.backgroundColor = .white
        view.insertSubview(fumerTueView, at: 1)
        fumerTueView.translatesAutoresizingMaskIntoConstraints = false
        fumerTueView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        fumerTueView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        fumerTueView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        fumerTueView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        let separatorView: UIView = UIView(frame: .zero)
        fumerTueView.addSubview(separatorView)
        
        separatorView.backgroundColor = .black
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.topAnchor.constraint(equalTo: fumerTueView.topAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: fumerTueView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: fumerTueView.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        let fumerTueLabel: UILabel = UILabel(frame: .zero)
        fumerTueLabel.textColor = .black
        fumerTueLabel.text = "Fumer Tue"
        fumerTueLabel.font = UIFont.systemFont(ofSize: 36)
        fumerTueView.addSubview(fumerTueLabel)
        
        fumerTueLabel.translatesAutoresizingMaskIntoConstraints = false
        fumerTueLabel.centerXAnchor.constraint(equalTo: fumerTueView.centerXAnchor).isActive = true
        fumerTueLabel.centerYAnchor.constraint(equalTo: fumerTueView.centerYAnchor).isActive = true
    }
}
