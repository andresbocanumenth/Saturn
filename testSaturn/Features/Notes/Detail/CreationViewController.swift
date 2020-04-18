//
//  CreationViewController.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/29/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {

    private let captionTextField = UITextField()
    private let imageView = UIImageView()
    private let imagePickerButton = UIButton()
    private let navigationBar = UINavigationBar()
    private var notesListViewModel = NotesListViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureCaptionTextField()
        configureImageView()
        configureImagePickerButton()
    }
    
    private func configureNavigationBar() {
        view.addSubview(navigationBar)
                
        let navItem = UINavigationItem(title: "")
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelTapped))

        navigationBar.setItems([navItem], animated: false)
        navigationBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func configureCaptionTextField() {
        view.addSubview(captionTextField)
        captionTextField.textColor = .black
        captionTextField.placeholder = "write your text"
        captionTextField.font = UIFont(name: "SFProText-Regular", size: 17)
        captionTextField.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom).offset(38)
            make.left.equalToSuperview().offset(17)
            make.right.equalTo(view.snp.right).offset(-27)
            make.height.equalTo(35)
        }
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        imageView.backgroundColor = AppColors.gray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(captionTextField.snp.bottom).offset(27)
            make.width.height.equalTo(82)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    private func configureImagePickerButton() {
        view.addSubview(imagePickerButton)
        imagePickerButton.backgroundColor = AppColors.gray
        imagePickerButton.setTitle("Choose Image", for: .normal)
        imagePickerButton.addTarget(self, action: #selector(imagePickerTapped), for: .touchUpInside)
        imagePickerButton.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(28)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
            make.height.equalTo(46)
        }
    }
    
    @objc func imagePickerTapped() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        
        present(pickerController, animated: true, completion: nil)
    }
    
    @objc func doneTapped() {
        guard let image = imageView.image else {
            return
        }
        notesListViewModel.createNote(caption: captionTextField.text ?? "",
                                      image: image) { (success) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CreationViewController: UINavigationControllerDelegate {
    
}

extension CreationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true, completion: nil)
        imageView.image = image
    }
}
