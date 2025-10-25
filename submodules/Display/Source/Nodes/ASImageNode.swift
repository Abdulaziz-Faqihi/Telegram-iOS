import Foundation
import UIKit
import AsyncDisplayKit

open class ASImageNode: ASDisplayNode {
    public var image: UIImage? {
        didSet {
            if self.isNodeLoaded {
                if let image = self.image {
                    let capInsets = image.capInsets
                    if capInsets.left.isZero && capInsets.top.isZero && capInsets.right.isZero && capInsets.bottom.isZero {
                        self.contentsScale = image.scale
                        self.contents = image.cgImage
                    } else {
                        ASDisplayNodeSetResizableContents(self.layer, image)
                    }
                } else {
                    self.contents = nil
                }
                if self.image?.size != oldValue?.size {
                    self.invalidateCalculatedLayout()
                }
            }
            self.updateAccessibilityFromImage()
        }
    }
    
    public var customTintColor: UIColor? {
        didSet {
            self.layer.layerTintColor = self.customTintColor?.cgColor
        }
    }

    public var displayWithoutProcessing: Bool = true

    override public init() {
        super.init()
        // By default, images are not accessibility elements unless they convey important information
        // This can be overridden by callers when the image is decorative or informative
        self.isAccessibilityElement = false
    }
    
    /// Updates accessibility properties from the image's accessibility description if available
    private func updateAccessibilityFromImage() {
        if let image = self.image {
            // If the image has accessibility description, use it
            if #available(iOS 11.0, *) {
                if let accessibilityDescription = image.imageAsset?.value(forKey: "accessibilityDescription") as? String {
                    self.accessibilityLabel = accessibilityDescription
                    self.isAccessibilityElement = true
                }
            }
        }
    }
    
    override open func didLoad() {
        super.didLoad()
        
        if let image = self.image {
            let capInsets = image.capInsets
            if capInsets.left.isZero && capInsets.top.isZero {
                self.contentsScale = image.scale
                self.contents = image.cgImage
            } else {
                ASDisplayNodeSetResizableContents(self.layer, image)
            }
        }
        self.layer.layerTintColor = self.customTintColor?.cgColor
    }
    
    override public func calculateSizeThatFits(_ contrainedSize: CGSize) -> CGSize {
        return self.image?.size ?? CGSize()
    }
}
