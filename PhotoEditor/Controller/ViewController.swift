//
//  ViewController.swift
//  PhotoEditor
//
//  Created by Devank on 02/07/24.
//

import UIKit
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
       
       let context = CIContext()
       var originalImage: UIImage?
       var filteredImage: UIImage?
       var currentFilter: CIFilter = CIFilter.sepiaTone()
       var filters: [CIFilter] = [
        CIFilter.sepiaTone(),
            CIFilter.photoEffectChrome(),
            CIFilter.comicEffect(),
            CIFilter.gaussianBlur(),
            CIFilter.colorMonochrome(),
            CIFilter.bloom(),
            CIFilter.pixellate(),
            CIFilter.vignette(),
            CIFilter.unsharpMask(),
            CIFilter.lineOverlay(),
            CIFilter.gloom(),
            CIFilter.highlightShadowAdjust(),
            CIFilter.photoEffectFade(),
            CIFilter.photoEffectInstant(),
            CIFilter.photoEffectMono(),
            CIFilter.photoEffectNoir(),
            CIFilter.photoEffectProcess(),
            CIFilter.photoEffectTonal(),
            CIFilter.photoEffectTransfer(),
            CIFilter.sharpenLuminance(),
            CIFilter.zoomBlur(),
            CIFilter.colorInvert(),
            CIFilter.colorMap(),
            CIFilter.colorPosterize(),
            CIFilter.falseColor(),
            CIFilter.exposureAdjust(),
            CIFilter.gammaAdjust(),
            CIFilter.temperatureAndTint(),
            CIFilter.colorCrossPolynomial(),
            CIFilter.colorCube(),
            CIFilter.colorCubeWithColorSpace(),
            CIFilter.colorPolynomial(),
            CIFilter.colorControls(),
            CIFilter.colorMatrix(),
            CIFilter.whitePointAdjust(),
            CIFilter.colorMonochrome(),
            CIFilter.sepiaTone(),
            CIFilter.colorClamp(),
            CIFilter.colorCrossPolynomial(),
            CIFilter.colorCube(),
            CIFilter.colorCubeWithColorSpace(),
            CIFilter.colorPolynomial(),
            CIFilter.colorControls(),
            CIFilter.colorMatrix(),
            CIFilter.whitePointAdjust(),
            CIFilter.colorMonochrome(),
            CIFilter.sepiaTone(),
            CIFilter.colorClamp(),
            CIFilter.colorCrossPolynomial(),
            CIFilter.colorCube(),
            CIFilter.colorCubeWithColorSpace(),
            CIFilter.colorPolynomial(),
            CIFilter.colorControls(),
            CIFilter.colorMatrix(),
            CIFilter.whitePointAdjust(),
            CIFilter.colorMonochrome(),
            CIFilter.sepiaTone(),
            CIFilter.colorClamp(),
        
       ]
    
       // MARK: - IBOutlets
       
       lazy var imageView: UIImageView = {
           let imageView = UIImageView()
           imageView.contentMode = .scaleAspectFit
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
       }()
           
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Right-to-Left support
        if #available(iOS 11.0, *) {
            layout.sectionInsetReference = .fromSafeArea
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.semanticContentAttribute = .forceRightToLeft // Set RTL direction
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        return collectionView
    }()

       
       // MARK: - Lifecycle Methods
       
       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .white
           setupNavigationBar()
           setupUI()
       }
       
       // MARK: - Setup Methods
       

    
    func setupNavigationBar() {
        navigationItem.title = "Photo Editor"
        
        let pickImageBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pickImage))
        let saveImageBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePhoto))
        
        navigationItem.rightBarButtonItems = [pickImageBtn, saveImageBtn]
    }

    
       
       func setupUI() {
           view.addSubview(imageView)
           view.addSubview(collectionView)
           
           NSLayoutConstraint.activate([
               imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4), // Adjust image height as needed
               
               collectionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
               collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
           ])
       }
       
       // MARK: - Image Handling
       
       @objc func pickImage() {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           present(imagePicker, animated: true, completion: nil)
       }
       
       func applyFilter() {
           guard let originalImage = originalImage else { return }
           
           let ciImage = CIImage(image: originalImage)
           currentFilter.setValue(ciImage, forKey: kCIInputImageKey)
           
           if let outputImage = currentFilter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
               filteredImage = UIImage(cgImage: cgImage)
               imageView.image = filteredImage
           }
       }
    
    
    @objc func savePhoto() {
        guard let filteredImage = filteredImage else {
            // Handle case where no filtered image is available
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(filteredImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Error saving image
            print("Error saving image: \(error.localizedDescription)")
        } else {
            // Image saved successfully
            print("Image saved successfully.")
        }
    }
       
       // MARK: - UIImagePickerControllerDelegate
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           picker.dismiss(animated: true, completion: nil)
           
           if let pickedImage = info[.originalImage] as? UIImage {
               originalImage = pickedImage
               applyFilter()
           }
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
   
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        let filter = filters[indexPath.item]
        cell.configureCell(name: filter.name, image: applyFilter(to: originalImage, with: filter))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filters[indexPath.item]
        currentFilter = filter
        applyFilter()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 100)
    }
    
    func applyFilter(to image: UIImage?, with filter: CIFilter) -> UIImage? {
        guard let originalImage = image else { return nil }
        
        let ciImage = CIImage(image: originalImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
