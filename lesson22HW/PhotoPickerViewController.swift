

import UIKit
import Photos
import Vision
import AVFoundation

class PhotoPickerViewController: UIViewController {
    
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemGray6
        return image
    }()
    
    private let buttonSelectImage: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Image", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(buttonSelectImage)
        
        buttonSelectImage.addAction(for: .touchUpInside) { _ in
            self.openImagePicker()
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            buttonSelectImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            buttonSelectImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonSelectImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
        
    }
        
        func openImagePicker() {
            let alert = UIAlertController(title: "Choose your sourse", message: "pick image or make photo from your camera", preferredStyle: .actionSheet)
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self]  _ in
                    self?.checkPhotoGalleryPermission()
                })
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alert.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                    self?.checkCameraPermission()
                })
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
        
        func checkPhotoGalleryPermission() {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                openImagePicker(sourseType: .photoLibrary)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { [weak self] _ in
                    if status == .authorized {
                        self?.openImagePicker(sourseType: .photoLibrary)
                    }
                }
            default:
                break
            }
        }
        
        func checkCameraPermission() {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
                case .authorized:
                self.openImagePicker(sourseType: .camera)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                    DispatchQueue.main.async {
                        if granted {
                            self?.openImagePicker(sourseType: .camera)
                        }
                    }
                }
            default:
                break
            }
        }
        
        func openImagePicker(sourseType: UIImagePickerController.SourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = sourseType
            picker.allowsEditing = true
            present(picker, animated: true)
        }
}

extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}





