
Pod::Spec.new do |spec|

  spec.name         = "GlossButtonNode"
  spec.version      = "1.2.0"
  spec.summary      = "A composable Button UI component for Texture"
  spec.description  = <<-DESC
  Bringing a button UI-Component with composable flexibility that fits your product.
                   DESC

  spec.homepage     = "https://github.com/TextureCommunity/GlossButtonNode"
  spec.license      = "MIT"
  spec.author       = "muukii", "yukkobay"
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/TextureCommunity/GlossButtonNode.git", :tag => "#{spec.version}" }
  spec.source_files  = "GlossButtonNode", "GlossButtonNode/**/*.swift"

  spec.swift_versions = ['5.2']
  spec.dependency "Texture/Core", "~> 2.8"
  spec.dependency "TextureSwiftSupport"

end
