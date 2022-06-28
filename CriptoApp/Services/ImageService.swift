//
//  sd.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 8/06/22.
//

import SwiftUI
import Combine

class ImageService {
    
    @Published var image: UIImage? = nil
    
    private var subscription: AnyCancellable?
    private let coin: Coin
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        getImages()
    }
    
    private func getImages() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            self.image = savedImage
        } else {
            downloadImages()
        }
    }
    
    private func downloadImages() {
        guard let url = URL(string: coin.image) else { return }
        
        subscription = NetworkManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] image in
                guard let self = self,
                      let image = image
                      else { return }
                self.image = image
                self.subscription?.cancel()
                self.fileManager.saveImage(image: image,
                                           imageName: self.imageName,
                                           folderName: self.folderName)
            })
    }
    
}
