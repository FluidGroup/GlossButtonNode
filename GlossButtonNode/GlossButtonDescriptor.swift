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
import CoreGraphics

/**
 Configurations for creating ``GlossButtonNode``
 */
public struct GlossButtonDescriptor {

  public struct ActivityIndicatorStyle {
    public let color: UIColor?
    public let style: UIActivityIndicatorView.Style

    /// Provide static types for easy migration, covering most used styles
    ///
    @available(iOS 13.0, *)
    public static let gray: ActivityIndicatorStyle = .init(color: .gray, style: .medium)
    @available(iOS 13.0, *)
    public static let white: ActivityIndicatorStyle = .init(color: .white, style: .medium)


    public init(color: UIColor? = nil, style: UIActivityIndicatorView.Style = .white) {
      self.color = color
      self.style = style
    }
  }
    
  public var image: UIImage?
  public var imageTintColor: UIColor?
  public var title: NSAttributedString?
  
  public var boundPadding: UIEdgeInsets = .zero
  // Body padding
  public var insets: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)

  public var truncateStyle: GlossButtonTruncateStyle
  public var bodyStyle: GlossButtonBodyStyle
  public var surfaceStyle: GlossButtonSurfaceStyle

  public var activityIndicatorStyle: ActivityIndicatorStyle
  public var bodyOpacity: CGFloat

  public init(
    title: NSAttributedString? = nil,
    image: UIImage? = nil,
    imageTintColor: UIColor? = nil,
    truncateStyle: GlossButtonTruncateStyle = .init(),
    bodyStyle: GlossButtonBodyStyle,
    surfaceStyle: GlossButtonSurfaceStyle,
    bodyOpacity: CGFloat = 1,
    insets: UIEdgeInsets? = nil,
    activityIndicatorStyle: ActivityIndicatorStyle = .init()
  ) {
    
    self.title = title
    self.image = image
    self.imageTintColor = imageTintColor
    self.bodyOpacity = bodyOpacity
    if let insets = insets {
      self.insets = insets
    }
    self.truncateStyle = truncateStyle
    self.surfaceStyle = surfaceStyle
    self.bodyStyle = bodyStyle
    self.activityIndicatorStyle = activityIndicatorStyle
  }
  
}

// MARK: - Modifying Method Chain
extension GlossButtonDescriptor {
  
  @inline(__always)
  private func _chain(_ modify: (inout Self) -> Void) -> Self {
    var m = self
    modify(&m)
    return m
  }
  
  public func title(_ title: NSAttributedString?) -> Self {
    _chain { $0.title = title }
  }
  
  public func image(_ image: UIImage?) -> Self {
    _chain { $0.image = image }
  }
  
  public func insets(_ insets: UIEdgeInsets) -> Self {
    _chain { $0.insets = insets }
  }
  
  public func boundPadding(_ boundPadding: UIEdgeInsets) -> Self {
    _chain { $0.boundPadding = boundPadding }
  }
  
  public func bodyOpacity(_ opacity: CGFloat) -> Self {
    _chain { $0.bodyOpacity = opacity }
  }
  
  public func surfaceStyle(_ sufaceStyle: GlossButtonSurfaceStyle) -> Self {
    _chain { $0.surfaceStyle = sufaceStyle }
  }
  
}

public enum GlossButtonColor {
  case fill(UIColor)
  case gradient(colorAndLocations: [(CGFloat, UIColor)], startPoint: CGPoint, endPoint: CGPoint)
}

public enum GlossButtonCornerRound {
  case circle
  case radius(CGFloat)
}

public enum FilledGlossButtonCornerRound {
  case circle
  case radius(topRight: CGFloat, topLeft: CGFloat, bottomRight: CGFloat, bottomLeft: CGFloat)
  
  public static func radius(all: CGFloat) -> Self {
    return .radius(topRight: all, topLeft: all, bottomRight: all, bottomLeft: all)
  }
  
  public static func radius(left: CGFloat, right: CGFloat) -> Self {
    return .radius(topRight: right, topLeft: left, bottomRight: right, bottomLeft: left)
  }
}

public struct GlossButtonTruncateStyle {
  public let truncateMode: NSLineBreakMode
  public let pointSizeScaleFactors: [CGFloat]?
  
  public init(
    truncateMode: NSLineBreakMode = .byWordWrapping,
    pointSizeScaleFactors: [CGFloat]? = nil
  ) {
    self.truncateMode = truncateMode
    self.pointSizeScaleFactors = pointSizeScaleFactors
  }
}

public enum GlossButtonSurfaceStyle {
  
  /// workaround
  public static var bodyOnly: GlossButtonSurfaceStyle {
    return .stroke(.init(cornerRound: nil, borderColor: .clear, borderWidth: 0))
  }
  
  /// workaround
  public static var translucentHighlight: GlossButtonSurfaceStyle {
    return .stroke(.init(cornerRound: nil, borderColor: .clear, borderWidth: 0))
  }
  
  @available(*, deprecated)
  public static var highlightOnly: GlossButtonSurfaceStyle {
    return .stroke(.init(cornerRound: nil, strokeColor: .clear, borderWidth: 0))
  }
  
  /// Fills specified Style
  case fill(GlossButtonFilledStyle)
  
  /// Strokes outline with specifide style
  case stroke(GlossButtonStrokedStyle)
  
  /// It should have better name.
  case highlight(GlossButtonHighlightSurfaceStyle)
  
  case blur(GlossButtonBlurryStyle)
 
}
