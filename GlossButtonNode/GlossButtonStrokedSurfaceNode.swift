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

extension GlossButtonHighlightAnimation where Components == _GlossButtonStrokedSurfaceNode.Components {
  
  public static var basic: GlossButtonHighlightAnimation {
    return .init { (isHighlighted, components) in
      
      let animationKey = "highlight.animation"
      
      if isHighlighted {
                        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [
          {
            let a = CABasicAnimation(keyPath: "opacity")
            a.toValue = 0.5
            return a
          }(),
        ]
        animationGroup.duration = 0.1
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.isRemovedOnCompletion = false
        
        components.borderLayer.add(animationGroup, forKey: animationKey)
        
      } else {
                        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [
          {
            let a = CABasicAnimation(keyPath: "opacity")
            a.fromValue = components.borderLayer.presentation()?.opacity ?? 0.5
            a.toValue = 1
            return a
          }(),
        ]
        animationGroup.duration = 0.2
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.isRemovedOnCompletion = false
        
        components.borderLayer.add(animationGroup, forKey: animationKey)
      }
      
    }
  }
}


public struct GlossButtonStrokedStyle {
  
  public var cornerRound: GlossButtonCornerRound?
  public var borderColor: UIColor
  public var borderWidth: CGFloat
  public var backgroundColor: UIColor?
  public var highlightAnimation: GlossButtonHighlightAnimation<_GlossButtonStrokedSurfaceNode.Components>
  
  public init(
    cornerRound: GlossButtonCornerRound?,
    borderColor: UIColor,
    borderWidth: CGFloat,
    backgroundColor: UIColor? = nil,
    highlightAnimation: GlossButtonHighlightAnimation<_GlossButtonStrokedSurfaceNode.Components> = .basic
  ) {
    self.cornerRound = cornerRound
    self.borderColor = borderColor
    self.borderWidth = borderWidth
    self.backgroundColor = backgroundColor
    self.highlightAnimation = highlightAnimation
  }
  
  @available(*, deprecated)
  public init(
    cornerRound: GlossButtonCornerRound?,
    strokeColor: UIColor,
    borderWidth: CGFloat,
    highlightAnimation: GlossButtonHighlightAnimation<_GlossButtonStrokedSurfaceNode.Components> = .basic
  ) {
    
    self.cornerRound = cornerRound
    self.borderColor = strokeColor
    self.borderWidth = borderWidth
    self.highlightAnimation = highlightAnimation
  }
}

public final class _GlossButtonStrokedSurfaceNode: ASDisplayNode, _GlossButtonSurfaceNodeType {
  
  public typealias Components = (borderLayer: CALayer, overlayShapeLayer: CAShapeLayer)
  
  public var isHighlighted: Bool = false {
    didSet {
      let components: Components = (borderShapeLayer, overlayShapeLayer)
      strokedStyle?.highlightAnimation.runChangedHighlight(isHighlighted: isHighlighted, components: components)
    }
  }
  
  private lazy var borderShapeLayer = CAShapeLayer()
  private lazy var borderShapeLayerNode: ASDisplayNode = .init { [unowned self] () -> CALayer in
    return self.borderShapeLayer
  }
  
  private lazy var overlayShapeLayer = CAShapeLayer()
  private lazy var overlayShapeLayerNode: ASDisplayNode = .init { [unowned self] () -> CALayer in
    return self.overlayShapeLayer
  }
  
  private var strokedStyle: GlossButtonStrokedStyle?
  
  public override init() {
    super.init()
    
    isUserInteractionEnabled = false
    automaticallyManagesSubnodes = true
  }
  
  public override func didLoad() {
    super.didLoad()
    borderShapeLayer.fillColor = UIColor.clear.cgColor
  }
  
  public override func layout() {
    super.layout()

    guard let strokeStyle = strokedStyle else { return }
    
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
    
    let path = UIBezierPath(roundedRect: bounds.insetBy(dx: strokeStyle.borderWidth / 2, dy: strokeStyle.borderWidth / 2), cornerRadius: __cornerRadius(for: self.layer, from: strokeStyle.cornerRound))
    
    borderShapeLayer.path = path.cgPath
    borderShapeLayer.lineWidth = strokeStyle.borderWidth
    borderShapeLayer.strokeColor = strokeStyle.borderColor.cgColor
    
    overlayShapeLayer.path = path.cgPath
    overlayShapeLayer.lineWidth = 0
    overlayShapeLayer.fillColor = strokeStyle.backgroundColor?.cgColor
    overlayShapeLayer.strokeColor = UIColor.clear.cgColor
  }
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASWrapperLayoutSpec(layoutElements: [
      overlayShapeLayerNode,
      borderShapeLayerNode,
    ])
  }
  
  public func setStyle(_ strokedStyle: GlossButtonStrokedStyle) {
    self.strokedStyle = strokedStyle
    setNeedsLayout()
  }
  
}
