//
// Copyright (c) 2020 Hiroshi Kimura(Muukii) <muuki.app@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Foundation

import AsyncDisplayKit

extension GlossButtonHighlightAnimation where Components == _GlossButtonBodyNode.Components {
  
  public static var noAnimation: GlossButtonHighlightAnimation {
    return .init { (isHighlighted, components) in }
  }
  
  public static var basic: GlossButtonHighlightAnimation {
    return .init { (isHighlighted, components) in
            
      if isHighlighted {
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState], animations: {
          components.imageNode.alpha = 0.5
          components.titleNode.alpha = 0.5
        }, completion: nil)
        
      } else {
        
        UIView.animate(withDuration: 0.16, delay: 0, options: [.beginFromCurrentState], animations: {
          components.imageNode.alpha = 1
          components.titleNode.alpha = 1
        }, completion: nil)
        
      }
      
    }
  }
}

public final class _GlossButtonBodyNode: ASDisplayNode {
  
  public typealias Components = (imageNode: ASDisplayNode, titleNode: ASDisplayNode)
  
  public var isHighlighted: Bool = false {
    didSet {
      let components: Components = (imageNode, titleNode)
      bodyStyle?.highlightAnimation.runChangedHighlight(isHighlighted: isHighlighted, components: components)
    }
  }
  
  private let imageNode = ASImageNode()
  private let titleNode = ASTextNode()
  
  private var bodyStyle: GlossButtonBodyStyle?
  
  public override init() {
    super.init()
    
    imageNode.contentMode = .center
    isUserInteractionEnabled = false
    automaticallyManagesSubnodes = true
  }
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    guard let bodyLayout = bodyStyle?.layout else {
      return ASLayoutSpec()
    }
    
    let _imageNode = imageNode.image != nil ? imageNode : nil
    let _titleNode = titleNode.attributedText.map({ $0.string.isEmpty == false }) ?? false ? titleNode : nil
    
    return bodyLayout.makeLayoutSpec(imageNode: _imageNode, titleNode: _titleNode)
  }
  
  public func setBodyStyle(_ bodyStyle: GlossButtonBodyStyle) {
    self.bodyStyle = bodyStyle
    setNeedsLayout()
  }
  
  public func setImage(_ image: UIImage?) {
    self.imageNode.image = image
    setNeedsLayout()
  }
  
  public func setTitle(_ title: NSAttributedString?) {
    self.titleNode.attributedText = title
    setNeedsLayout()
  }
  
  public func setTruncateStyle(_ truncateStyle: GlossButtonTruncateStyle) {
    self.titleNode.truncationMode = truncateStyle.truncateMode
    self.titleNode.pointSizeScaleFactors = truncateStyle.pointSizeScaleFactors?.map({ NSNumber(value: Float($0)) })
    setNeedsLayout()
  }
}
