//
//  NoteTableViewCell.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/29/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import UIKit
import SnapKit

class NoteTableViewCell: UITableViewCell {
    
    private let noteImageView = UIImageView()
    private let captionLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let syncStatusView = UIView()
    private let syncStatusDot = UIView()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    func updateUI(viewModel: NotesCellViewModel) {
        captionLabel.text = viewModel.caption
        syncStatusDot.backgroundColor =  viewModel.syncStatus.color
    }
    
    private func configureView() {
        selectionStyle = .none
        backgroundColor = AppColors.lightGray
        configureImageView()
        configureSyncStatusView()
        configureSyncStatusDot()
        configureCaptionLabel()
        configureLoadingIndicator()
    }

    private func configureImageView() {
        addSubview(noteImageView)
        noteImageView.contentMode = .scaleAspectFill
        noteImageView.clipsToBounds = true
        noteImageView.backgroundColor = AppColors.darkGray
        noteImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.height.equalTo(80)
        }
    }
    
    private func configureSyncStatusView() {
        addSubview(syncStatusView)
        syncStatusView.backgroundColor = AppColors.darkGray
        syncStatusView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.height.equalTo(80)
        }
    }
    
    private func configureSyncStatusDot() {
        syncStatusView.addSubview(syncStatusDot)
        syncStatusDot.snp.makeConstraints { (make) in
            make.center.equalTo(syncStatusView)
            make.width.height.equalTo(22)
        }
    }
    
    private func configureCaptionLabel() {
        addSubview(captionLabel)
        captionLabel.textColor = .black
        captionLabel.font = UIFont(name: "SFProText-Semibold", size: 17)
        captionLabel.numberOfLines = 0
        captionLabel.lineBreakMode = .byWordWrapping
        captionLabel.textAlignment = .center
        captionLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(noteImageView.snp.right)
            make.right.equalTo(syncStatusView.snp.left)
        }
    }
    
    private func configureLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(noteImageView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        syncStatusDot.layer.cornerRadius = syncStatusDot.frame.size.height / 2
        syncStatusDot.layer.masksToBounds = true
    }

    
    func updateAppearanceFor(_ image: UIImage?) {
        DispatchQueue.main.async { [unowned self] in
            self.displayImage(image)
        }
    }
    
    private func displayImage(_ image: UIImage?) {
        if let _image = image {
            noteImageView.image = _image
            loadingIndicator.stopAnimating()
        } else {
            loadingIndicator.startAnimating()
            noteImageView.image = .none
        }
    }
}
