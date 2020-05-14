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
import UIKit

import AsyncDisplayKit

extension GlossButtonHighlightAnimation where Components == _GlossButtonFilledSurfaceNode.Components {
  
  public static var basic: GlossButtonHighlightAnimation {
    return .init { (isHighlighted, components) in
      
      let animationKey = "highlight.animation"
      
      if isHighlighted {
        
        let duration: CFTimeInterval = 0.1
        
        do {
          let animation = CABasicAnimation(keyPath: "opacity")
          animation.toValue = 0.5
          animation.duration = duration
          animation.fillMode = CAMediaTimingFillMode.forwards
          animation.isRemovedOnCompletion = false
          
          components.shadowLayer.add(animation, forKey: animationKey)
        }
        
        do {
          let animation = CABasicAnimation(keyPath: "opacity")
          animation.toValue = 0.5
          animation.duration = duration
          animation.fillMode = CAMediaTimingFillMode.forwards
          animation.isRemovedOnCompletion = false
          
          components.surfaceLayer.add(animation, forKey: animationKey)
        }
                
      } else {
                
        do {
                    
          let animation = CAAnimationGroup()
          
          animation.animations = [
            {
              let a = CABasicAnimation(keyPath: "opacity")
              a.fromValue = components.shadowLayer.presentation()?.opacity ?? 1
              a.toValue = 1
              return a
            }()
          ]
          animation.duration = 0.2
          animation.fillMode = CAMediaTimingFillMode.forwards
          animation.isRemovedOnCompletion = false
          
          components.shadowLayer.add(animation, forKey: animationKey)
        }
        
        do {
          let animation = CAAnimationGroup()
          
          animation.animations = [
            {
              let a = CABasicAnimation(keyPath: "opacity")
              a.fromValue = components.surfaceLayer.presentation()?.opacity ?? 1
              a.toValue = 1
              return a
            }()
          ]
          animation.duration = 0.2
          animation.fillMode = CAMediaTimingFillMode.forwards
          animation.isRemovedOnCompletion = false
          components.surfaceLayer.add(animation, forKey: animationKey)
        }
      }
            
    }
  }
}

public struct GlossButtonFilledStyle {
  
  public struct DropShadow {
    public let applier: (CALayer) -> Void
    public let isModern: Bool
    
    public init(color: UIColor, offset: CGSize, radius: CGFloat, opacity: CGFloat, isModern: Bool) {
      
      self.init(applier: { (layer) in
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = Float(opacity)
      }, isModern: isModern)
      
    }
    
    public init(applier: @escaping (CALayer) -> Void, isModern: Bool) {
      self.applier = applier
      self.isModern = isModern
    }
    
    @available(*, deprecated, renamed: "nil")
    public static var invisible: DropShadow? {
      return nil
    }
  }
  
  public var cornerRound: FilledGlossButtonCornerRound?
  public var backgroundColor: GlossButtonColor?
  public var dropShadow: DropShadow?
  public var highlightAnimation: GlossButtonHighlightAnimation<_GlossButtonFilledSurfaceNode.Components>
  
  public init(
    cornerRound: FilledGlossButtonCornerRound?,
    backgroundColor: GlossButtonColor?,
    dropShadow: DropShadow?,
    highlightAnimation: GlossButtonHighlightAnimation<_GlossButtonFilledSurfaceNode.Components> = .basic
  ) {
    
    self.cornerRound = cornerRound
    self.backgroundColor = backgroundColor
    self.dropShadow = dropShadow
    self.highlightAnimation = highlightAnimation
  }
}

public final class _GlossButtonFilledSurfaceNode: ASDisplayNode, _GlossButtonSurfaceNodeType {
  
  public typealias Style = GlossButtonFilledStyle
  
  public typealias Components = (
    surfaceLayer: CALayer,
    shadowLayer: CALayer,
    overlayLayer: CALayer
  )
  
  public var isHighlighted: Bool = false {
    didSet {
      
      let components: Components = (surfaceGradientLayer, shadowShapeLayer, overlayLayer)
      currentStyle?.highlightAnimation.runChangedHighlight(isHighlighted: isHighlighted, components: components)
    }
  }
  
  private lazy var shadowShapeLayer = CAShapeLayer()
  
  private lazy var shadowLayerNode: ASDisplayNode = .init { [unowned self] () -> CALayer in
    return self.shadowShapeLayer
  }
  
  private let surfaceMaskNode = GlossButtonContinousCornerRoundedNode()
  
  private lazy var surfaceGradientLayer = CAGradientLayer()
  private lazy var surfaceLayerNode: ASDisplayNode = .init { [unowned self] () -> CALayer in
    return self.surfaceGradientLayer
  }
  
  private lazy var overlayLayer = CALayer()
  private lazy var overlayLayerNode: ASDisplayNode = .init { [unowned self] () -> CALayer in
    return self.overlayLayer
  }
  
  private var currentStyle: Style?
  
  public override init() {
    super.init()
    
    isUserInteractionEnabled = false
    automaticallyManagesSubnodes = true
  }
  
  public override func didLoad() {
    super.didLoad()
    surfaceGradientLayer.mask = surfaceMaskNode.layer
    shadowShapeLayer.fillColor = UIColor.clear.cgColor
    overlayLayer.backgroundColor = UIColor.clear.cgColor
    surfaceGradientLayer.addSublayer(overlayLayer)
  }
  
  public override func layout() {
    super.layout()

    lock(); defer { unlock() }
    
    overlayLayer.frame = surfaceGradientLayer.bounds
    
    guard let currentStyle = currentStyle else { return }
    
    func __cornerRadius(for layer: CALayer, from cornerRound: FilledGlossButtonCornerRound?) -> CGFloat {
      switch cornerRound {
      case .none:
        return 0
      case .radius(let topRight, let topLeft, let bottomRight, let bottomLeft)?:
        guard topRight == topLeft && topRight == bottomRight && topRight == bottomLeft else {
          assertionFailure()
          return 0
        }
        return topRight
      case .circle?:
        let radius = (min(layer.bounds.width, layer.bounds.height))
        return radius / 2
      }
    }
    
    func setBackgroundforegroundColor(_ layer: CAGradientLayer, _ b: GlossButtonColor?) {
      switch b {
      case .none:
        
        layer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        
      case let .fill(color)?:
        
        layer.colors = [color.cgColor, color.cgColor]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        
      case let .gradient(colorAndLocations, startPoint, endPoint)?:
        
        layer.colors = colorAndLocations.map { $0.1.cgColor }
        layer.locations = colorAndLocations.map { NSNumber(value: Double($0.0)) }
        layer.startPoint = startPoint
        layer.endPoint = endPoint
      }
    }
    
    func makeIndividualRadiusPath(topRight: CGFloat, topLeft: CGFloat, bottomRight: CGFloat, bottomLeft: CGFloat, for rect: CGRect) -> UIBezierPath {
      var list: [CGFloat: UIRectCorner] = [:]
      
      list[topRight] = list[topRight] ?? .init()
      list[topRight]?.insert(.topRight)

      list[topLeft] = list[topLeft] ?? .init()
      list[topLeft]?.insert(.topLeft)

      list[bottomRight] = list[bottomRight] ?? .init()
      list[bottomRight]?.insert(.bottomRight)

      list[bottomLeft] = list[bottomLeft] ?? .init()
      list[bottomLeft]?.insert(.bottomLeft)

      let path = UIBezierPath(rect: rect)
      
      for l in list {
        path.append(.init(
          roundedRect: rect,
          byRoundingCorners: l.value,
          cornerRadii: .init(width: l.key, height: l.key)
          ))
      }
      
      path.usesEvenOddFillRule = true
      
      return path
    }
    
    surfaceMaskNode.frame = surfaceGradientLayer.bounds
    
    if case .radius(let topRight, let topLeft, let bottomRight, let bottomLeft) = currentStyle.cornerRound,
      !(topRight == topLeft && topLeft == bottomRight && topRight == bottomLeft) {
      
      let path = makeIndividualRadiusPath(
        topRight: topRight,
        topLeft: topLeft,
        bottomRight: bottomRight,
        bottomLeft: bottomLeft,
        for: surfaceGradientLayer.bounds
      )

      surfaceMaskNode.setPath(path)
      shadowShapeLayer.path = path.cgPath

    } else {
      
      let radius = __cornerRadius(
        for: surfaceGradientLayer,
        from: currentStyle.cornerRound
      )

      if #available(iOS 13, *) {
        
        surfaceMaskNode.setRadius(radius)
        
      } else {
        
        surfaceMaskNode.setPath(UIBezierPath(
          roundedRect: surfaceGradientLayer.bounds,
          cornerRadius: radius
        ))
      }
      
      shadowShapeLayer.path = UIBezierPath(
        roundedRect: shadowShapeLayer.bounds,
        cornerRadius: radius
      ).cgPath
      
    }
    
    setBackgroundforegroundColor(surfaceGradientLayer, currentStyle.backgroundColor)
    
    if let dropShadow = currentStyle.dropShadow {
      dropShadow.applier(shadowShapeLayer)
      shadowShapeLayer.shadowPath = shadowShapeLayer.path
    } else {
      shadowShapeLayer.shadowOpacity = 1
      shadowShapeLayer.shadowColor = UIColor.clear.cgColor
      shadowShapeLayer.shadowOffset = .zero
      shadowShapeLayer.shadowRadius = 0
      shadowShapeLayer.shadowPath = nil
    }
  }
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    guard let fillStyle = self.currentStyle else { return ASLayoutSpec() }
    
    let shadowSpec: ASLayoutElement
    
    if let _ = fillStyle.dropShadow?.isModern {
      shadowSpec = ASInsetLayoutSpec(insets: .init(top: 6, left: 6, bottom: 6, right: 6), child: shadowLayerNode)
    } else {
      shadowSpec = shadowLayerNode
    }
    
    return ASWrapperLayoutSpec(
      layoutElements: [
        shadowSpec,
        surfaceLayerNode,
      ]
    )
  }
  
  public func setStyle(_ filledStyle: Style) {
    lock(); defer { unlock() }
    self.currentStyle = filledStyle
    setNeedsLayout()
  }
  
}
