#
# Be sure to run `pod lib lint BAShimmerButton.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BAShimmerButton"
  s.version          = "0.1.0"
  s.summary          = "A call-to-action button that offers shimmer, movement, and off/on functionality"
  s.description      = <<-DESC
                        A call-to-action button that offers shimmer, movement, and off/on functionality. Great for getting a users attention in multiple ways!
                        more info at: [https://github.com/antiguab/BAShimmerButton(https://github.com/antiguab/BAShimmerButton)
                        DESC
  s.homepage         = "https://github.com/antiguab/BAShimmerButton"
  # s.screenshots     = "", ""
  s.license          = 'MIT'
  s.author           = { "Bryan Antigua" => "antigua.b@gmail.com" }
  s.source           = { :git => "https://github.com/antiguab/BAShimmerButton.git", :tag => s.version.to_s }
  s.platform     = :ios
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'BAShimmerButton' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
