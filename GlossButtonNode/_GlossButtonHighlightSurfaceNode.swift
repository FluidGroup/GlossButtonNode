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

extension GlossButtonHighlightAnimation where Components == _GlossButtonHighlightSurfaceNode.Components {
  
  // TODO:
}

public struct GlossButtonHighlightSurfaceStyle {
  
  public var cornerRound: GlossButtonCornerRound?
  public var highlightAnimation: GlossButtonHighlightAnimation<_GlossButtonHighlightSurfaceNode.Components>
  
  public init(
    cornerRound: GlossButtonCornerRound?,
    highlightAnimation: GlossButtonHighlightAnimation<_GlossButtonHighlightSurfaceNode.Components>
  ) {
    
    self.cornerRound = cornerRound
    self.highlightAnimation = highlightAnimation
  }
}

public final class _GlossButtonHighlightSurfaceNode: ASDisplayNode, _GlossButtonSurfaceNodeType {
  
  public typealias Components = (CAShapeLayer)
  
  public var isHighlighted: Bool = false {
    didSet {
      let components: Components = (overlayShapeLayer)
      surfaceStyle?.highlightAnimation.runChangedHighlight(isHighlighted: isHighlighted, components: components)
    }
  }
  
  private lazy var overlayShapeLayer = CAShapeLayer()
  private lazy var overlayShapeLayerNode: ASDisplayNode = .init { [unowned self] () -> CALayer in
    return self.overlayShapeLayer
  }
  
  private var surfaceStyle: GlossButtonHighlightSurfaceStyle?
  
  public override init() {
    super.init()
    
    isUserInteractionEnabled = false
    automaticallyManagesSubnodes = true
  }
  
  public override func layout() {
    super.layout()
    
    guard let surfaceStyle = surfaceStyle else { return }
    
    func __cornerRadius(for layer: CALayer, from cornerRound: GlossButtonCornerRound?) -> CGFloat {
      switch cornerRound {
      case .none:
        return 0
      case let .radius(radius)?:
        return radius
      case .circle?:
        return .infinity// round(min(layer.frame.width, layer.frame.height) / 2)
      }
    }
    
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: __cornerRadius(for: self.layer, from: surfaceStyle.cornerRound))
        
    overlayShapeLayer.path = path.cgPath
    overlayShapeLayer.lineWidth = 0
    overlayShapeLayer.fillColor = UIColor.clear.cgColor
    overlayShapeLayer.strokeColor = UIColor.clear.cgColor
  }
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASWrapperLayoutSpec(layoutElements: [
      overlayShapeLayerNode,
    ])
  }
  
  public func setStyle(_ strokedStyle: GlossButtonHighlightSurfaceStyle) {
    
    self.surfaceStyle = strokedStyle
    setNeedsLayout()
  }
  
}
