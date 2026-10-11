# Linux build of UTV. macOS uses the cask (Casks/utv.rb): brew install --cask openutv/utv/utv
#
# Like the macOS app, the Linux build doesn't bundle Qt, FFmpeg, OpenColorIO, OpenImageIO or the other
# libraries: it loads them from Homebrew, so they are installed from Homebrew, not redistributed by us.
# The GPU driver (libGL, libGLX, libEGL) always comes from the system.
class Utv < Formula
  desc "Lightweight and distributable framecycler and sequence viewer"
  homepage "https://github.com/OpenUTV/utv"
  url "https://github.com/OpenUTV/utv/releases/download/2026.13/UTV-2026.13-linux-x64.tar.gz"
  version "2026.13" # This will be automatically updated by GitHub Actions
  sha256 "29c1ca96d388b58c39d768cbaf3898136e40d4f15f7599558a48074b24c359d1"
  license "Apache-2.0"

  depends_on arch: :x86_64
  depends_on :linux

  depends_on "boost"
  depends_on "ffmpeg"
  depends_on "glew"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libspng"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "openimageio"
  depends_on "openjpeg"
  depends_on "openjph"
  depends_on "pyside"
  depends_on "python@3.14"
  depends_on "qt"
  depends_on "spdlog"
  depends_on "webp"
  depends_on "yaml-cpp"

  def install
    # The release tarball is the app's own tree (bin, lib, plugins, ...). Its launchers find the app from
    # their own location and Homebrew's libraries from HOMEBREW_PREFIX.
    libexec.install Dir["*"]
    %w[utv utvio utvls utvpush utvpkg utvshell].each do |cmd|
      bin.install_symlink libexec/"bin"/cmd if (libexec/"bin"/cmd).exist?
    end
  end

  def caveats
    <<~EOS
      UTV uses your system's OpenGL driver. On a desktop install that is normally already present
      (on Ubuntu/Debian: libgl1 libglx0 libopengl0 libegl1).
    EOS
  end

  test do
    assert_match "UTV", shell_output("#{bin}/utvls -help 2>&1")
  end
end
