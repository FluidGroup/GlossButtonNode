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
import TextureSwiftSupport

/// To use continuous curve on CALayer only iOS13
final class GlossButtonContinousCornerRoundedNode: ASDisplayNode {

  private let passBasedMaskNode: ShapeRenderingNode
  private let layerBasedMaskNode: ASDisplayNode

  override init() {

    self.layerBasedMaskNode = .init(layerBlock: { CALayer() })
    self.passBasedMaskNode = .init()

    super.init()
    automaticallyManagesSubnodes = true
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASWrapperLayoutSpec(layoutElements: [
      passBasedMaskNode,
      layerBasedMaskNode
      ]
    )
  }

  override func layout() {
    super.layout()
    _updateCornerCurve()
  }

  func setPath(_ path: UIBezierPath) {
    passBasedMaskNode.alpha = 1
    layerBasedMaskNode.alpha = 0
    passBasedMaskNode.shapePath = path
  }

  @available(iOS 13, *)
  func setRadius(_ radius: CGFloat) {
    ASPerformBlockOnMainThread {
      self.layerBasedMaskNode.alpha = 1
      self.passBasedMaskNode.alpha = 0
      self.layerBasedMaskNode.backgroundColor = .black
      self.layerBasedMaskNode.layer.cornerRadius = radius
      self._updateCornerCurve()
    }
  }

  private func _updateCornerCurve() {
    if #available(*, iOS 13) {

      if bounds.width == bounds.height {
        layerBasedMaskNode.layer.cornerCurve = .circular
      } else {
        layerBasedMaskNode.layer.cornerCurve = .continuous
      }

    }
  }
}
