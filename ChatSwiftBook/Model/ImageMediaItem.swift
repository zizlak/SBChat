//
//  ImageMediaItem.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 05.08.21.
//

import Foundation
import MessageKit

struct ImageMediaItem: MediaItem {
    /// The url where the media is located.
    var url: URL?

    /// The image.
    var image: UIImage?

    /// A placeholder image for when the image is obtained asychronously.
    var placeholderImage: UIImage

    /// The size of the media item.
    var size: CGSize 
}
