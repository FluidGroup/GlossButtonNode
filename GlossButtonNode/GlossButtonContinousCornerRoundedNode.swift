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
  
  private var layerBackingNode: ShapeRenderingNode = .init()
  
  override init() {
    super.init()
    automaticallyManagesSubnodes = true
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      WrapperLayout { layerBackingNode }
    }
  }
  
  override func layout() {
    super.layout()
    _updateCornerCurve()
  }
  
  func setPath(_ path: UIBezierPath) {
    layerBackingNode.layer.cornerRadius = 0.0
    layerBackingNode.shapePath = path
  }
  
  @available(iOS 13, *)
  func setRadius(_ radius: CGFloat) {
    ASPerformBlockOnMainThread {
      self.layerBackingNode.shapePath = nil
      self.layerBackingNode.backgroundColor = .black
      self.layerBackingNode.layer.cornerRadius = radius
      self._updateCornerCurve()
    }
  }
  
  // TODO: Pathの場合はどうするか
  private func _updateCornerCurve() {
    if #available(*, iOS 13) {
      let _bounds = bounds
      if _bounds.width == _bounds.height {
        layerBackingNode.layer.cornerCurve = .circular
      } else {
        layerBackingNode.layer.cornerCurve = .continuous
      }
    }
  }
}
