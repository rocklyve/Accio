class Accio < Formula
  desc "Dependency manager driven by SwiftPM for iOS & Co."
  homepage "https://github.com/JamitLabs/Accio"
  url "https://github.com/JamitLabs/Accio.git", :tag => "0.1.0", :revision => "???"
  head "https://github.com/JamitLabs/Accio.git"

  depends_on :xcode => ["10.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end