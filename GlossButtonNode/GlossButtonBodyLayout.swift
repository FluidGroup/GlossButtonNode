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

public struct GlossButtonBodyStyle {
  
  public var layout: GlossButtonBodyLayout
  public var highlightAnimation: GlossButtonHighlightAnimation<_GlossButtonBodyNode.Components>

  public init(
    layout: GlossButtonBodyLayout,
    highlightAnimation: GlossButtonHighlightAnimation<_GlossButtonBodyNode.Components> = .basic
  ) {
    
    self.layout = layout
    self.highlightAnimation = highlightAnimation
  }
}

public struct GlossButtonBodyLayout {
  
  public typealias Compose<T: ASDisplayNode> = (T) -> ASLayoutElement
  
  private let _layoutSpecFactory: (_ imageNode: ASLayoutElement?, _ titleNode: ASLayoutElement?) -> ASLayoutSpec
  
  private var composeImageNode: Compose<ASImageNode> = { $0 }
  private var composeTitleNode: Compose<ASTextNode> = { $0 }
  
  public init(_ layoutSpecFactory: @escaping (_ imageNode: ASLayoutElement?, _ titleNode: ASLayoutElement?) -> ASLayoutSpec) {
    self._layoutSpecFactory = layoutSpecFactory
  }
  
  public func set(composeImageNode: @escaping Compose<ASImageNode>) -> GlossButtonBodyLayout {
    
    var _self = self
    _self.composeImageNode = composeImageNode
    return _self
  }
  
  public func set(composeTitleNode: @escaping Compose<ASTextNode>) -> GlossButtonBodyLayout {
    
    var _self = self
    _self.composeTitleNode = composeTitleNode
    return _self
  }
  
  func makeLayoutSpec(imageNode: ASImageNode?, titleNode: ASTextNode?) -> ASLayoutSpec {
    
    return _layoutSpecFactory(imageNode.map(composeImageNode), titleNode.map(composeTitleNode))
  }
  
}

extension GlossButtonBodyLayout {
  
  public static func vertical(imageEdgeInsets: UIEdgeInsets = .zero, titleEdgeInsets: UIEdgeInsets = .zero) -> GlossButtonBodyLayout {
    
    return GlossButtonBodyLayout.init { imageNode, titleNode in
      return _axisLayout(direction: .vertical, imageNode: imageNode, titleNode: titleNode, imageEdgeInsets: imageEdgeInsets, titleEdgeInsets: titleEdgeInsets)
    }
  }
    
  /// Horizontal layout
  /// - Parameters:
  ///   - imageEdgeInsets: default .zero
  ///   - titleEdgeInsets: default .zero
  /// - Returns: 
  public static func horizontal(imageEdgeInsets: UIEdgeInsets = .zero, titleEdgeInsets: UIEdgeInsets = .zero) -> GlossButtonBodyLayout {
    
    return GlossButtonBodyLayout.init { imageNode, titleNode in
      return _axisLayout(direction: .horizontal, imageNode: imageNode, titleNode: titleNode, imageEdgeInsets: imageEdgeInsets, titleEdgeInsets: titleEdgeInsets)
    }
  }
  
  private static func _axisLayout(
    direction: ASStackLayoutDirection,
    imageNode: ASLayoutElement?,
    titleNode: ASLayoutElement?,
    imageEdgeInsets: UIEdgeInsets,
    titleEdgeInsets: UIEdgeInsets
  ) -> ASLayoutSpec {
    
    let bodyLayoutSpec: ASStackLayoutSpec
    
    let titleNodeInsetSpec = titleNode.map { ASInsetLayoutSpec(insets: titleEdgeInsets, child: $0) }
    let imageNodeInsetSpec = imageNode.map { ASInsetLayoutSpec(insets: imageEdgeInsets, child: $0) }
    
    titleNodeInsetSpec?.style.flexShrink = 1
    
    switch (imageNodeInsetSpec, titleNodeInsetSpec) {
    case let (imageNode?, titleNode?):
      
      bodyLayoutSpec = ASStackLayoutSpec(
        direction: direction,
        spacing: 2,
        justifyContent: .center,
        alignItems: .center,
        children: [
          imageNode,
          titleNode,
        ]
      )
      
      bodyLayoutSpec.horizontalAlignment = .middle
      bodyLayoutSpec.verticalAlignment = .center
      
    case let (nil, titleNode?):
      
      bodyLayoutSpec = ASStackLayoutSpec(
        direction: direction,
        spacing: 0,
        justifyContent: .center,
        alignItems: .center,
        children: [
          titleNode,
        ]
      )
      
      bodyLayoutSpec.horizontalAlignment = .middle
      bodyLayoutSpec.verticalAlignment = .center
      
    case let (imageNode?, nil):
      
      bodyLayoutSpec = ASStackLayoutSpec(
        direction: direction,
        spacing: 0,
        justifyContent: .center,
        alignItems: .center,
        children: [
          imageNode,
        ]
      )
      
      bodyLayoutSpec.horizontalAlignment = .middle
      bodyLayoutSpec.verticalAlignment = .center
      
    case (nil, nil):
      bodyLayoutSpec = ASStackLayoutSpec.horizontal()
    }
    
    bodyLayoutSpec.style.flexGrow = 1
    
    return bodyLayoutSpec
  }
}
