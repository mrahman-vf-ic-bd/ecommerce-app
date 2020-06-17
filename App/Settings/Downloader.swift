//
//  Downloader.swift
//  App
//
//  Created by Siddiqur Rahmnan on 16/6/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import Foundation
import Firebase

let storage = Storage.storage()

func downloadImages(urls: String, withBlock: @escaping (_ images: [UIImage?]) -> Void) {
    let linkArray = seperateImageLinks(links: urls)
    var imageArray: [UIImage] = []
    var downloadCounter = 0
    
    for link in linkArray {
        let url = NSURL(string: link)
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        downloadQueue.async {
            downloadCounter += 1
            let data = NSData(contentsOf: url! as URL)
            if data != nil {
                let image = UIImage(data: data! as Data)!
                imageArray.append(image)
                
                if downloadCounter == imageArray.count {
                    DispatchQueue.main.async {
                        withBlock(imageArray)
                    }
                }
            } else {
                print("Couldn't download image")
                withBlock(imageArray)
            }
        }
    }
}


func uploadImages(images: [UIImage], userId: String, referenceNumber: String, withBlock: @escaping (_ linkString: String) -> Void) {
    
    convertImagesToData(images: images) { (pictures) in
        var uploadCounter = 0
        var nameSuffix = 0
        var linkString = ""
        
        for picture in pictures {
            let fileName = "PropertyImages/" + userId + "/" + referenceNumber + "/image\(nameSuffix).jpg"
            nameSuffix += 1
            let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
            
            var task: StorageUploadTask!
            task = storageRef.putData(picture, metadata: nil, completion: { (metadata, error) in
                
                storageRef.downloadURL { (url, error) in
                    uploadCounter += 1
                    if error != nil {
                        return
                    }
                    let link = url?.absoluteURL.absoluteString
                    linkString += link! + ","
                    print("=>>> " + linkString)
                    if uploadCounter == pictures.count {
                        task.removeAllObservers()
                        withBlock(linkString)
                    }
                }

                if error != nil {
                    print("Error uploading picture \(error!.localizedDescription)")
                    return
                }

            })
        }

    }
}

// MARK: Helpers

func convertImagesToData(images: [UIImage], withBlock: @escaping (_ datas: [Data]) -> Void) {
    
    var dataArray: [Data] = []
    
    for image in images {
        let imageData = image.jpegData(compressionQuality: 0.5)
        dataArray.append(imageData!)
    }
    
    withBlock(dataArray)
    
}

func seperateImageLinks(links: String) -> [String] {
    var linkArray = links.components(separatedBy: ",")
    linkArray.removeLast()
    return linkArray
}
