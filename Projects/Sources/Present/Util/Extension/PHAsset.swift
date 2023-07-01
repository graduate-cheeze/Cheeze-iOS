import Photos
import UIKit

extension PHAsset {
  func getAssetThumbnail() -> UIImage {
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    var thumbnail = UIImage()
    manager.requestImage(for: self,
                            targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                            contentMode: .aspectFit,
                            options: option,
                            resultHandler: {(result, _) -> Void in
      thumbnail = result!
    })
    return thumbnail
  }
}
