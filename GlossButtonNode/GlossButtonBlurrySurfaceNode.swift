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

import AsyncDisplayKit
import Foundation

public struct GlossButtonBlurryStyle {
  
  public var blurStyle: UIBlurEffect.Style
  public var cornerRound: GlossButtonCornerRound?
  public var color: UIColor?
  
  public init(
    blurStyle: UIBlurEffect.Style,
    cornerRound: GlossButtonCornerRound?,
    color: UIColor?
  ) {
    self.blurStyle = blurStyle
    self.cornerRound = cornerRound
    self.color = color
  }
}

public final class _GlossButtonBlurrySurfaceNode: ASDisplayNode {
  
  public typealias Style = GlossButtonBlurryStyle
  
  private let backgroundNode = ASDisplayNode()
  private let surfaceMaskNode = GlossButtonContinousCornerRoundedNode()
  
  private var currentStyle: Style?
  
  private let visualEffectNode: ASDisplayNode = .init { () -> UIView in
    UIVisualEffectView(effect: nil)
  }
  
  private var visualEffectView: UIVisualEffectView {
    visualEffectNode.view as! UIVisualEffectView
  }
  
  public override init() {
    super.init()
    addSubnode(backgroundNode)
    addSubnode(visualEffectNode)
  }
  
  public override func didLoad() {
    super.didLoad()
    layer.mask = surfaceMaskNode.layer
  }
  
  public override func layout() {
    
    // TODO: Duplicated with FilledSurface
    func __cornerRadius(for layer: CALayer, from cornerRound: GlossButtonCornerRound?) -> CGFloat {
      switch cornerRound {
      case .none:
        return 0
      case let .radius(radius)?:
        return radius
      case .circle?:
        let radius = (min(layer.bounds.width, layer.bounds.height))
        return radius / 2
      }
    }
        
    super.layout()
    
    guard let currentStyle = currentStyle else { return }
    
    surfaceMaskNode.frame = visualEffectNode.bounds
            
    visualEffectView.effect = UIBlurEffect(style: currentStyle.blurStyle)
    backgroundNode.backgroundColor = currentStyle.color
              
    if #available(iOS 13, *) {
      let radius = __cornerRadius(
        for: visualEffectView.layer,
        from: currentStyle.cornerRound
      )
      surfaceMaskNode.setRadius(radius)
    } else {
      let path = UIBezierPath(
        roundedRect: visualEffectView.layer.bounds,
        cornerRadius: __cornerRadius(for: visualEffectView.layer, from: currentStyle.cornerRound)
      )
      surfaceMaskNode.setPath(path)
    }
  }
    
  public func setStyle(_ filledStyle: Style) {
    
    self.currentStyle = filledStyle
    setNeedsLayout()
  }
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASBackgroundLayoutSpec(child: visualEffectNode, background: backgroundNode)
  }
}
