class Urna < Formula
  desc "Offline-first vector database in one file: a .urna container with content-addressable citations, and the urna CLI"
  homepage "https://urna.dev"
  version "0.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.4/urna-aarch64-apple-darwin.tar.xz"
      sha256 "c6bbbf991c4a37b0e91082bdae6a513cbc73bfb0b4949f3e4b18951285cf1662"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.4/urna-x86_64-apple-darwin.tar.xz"
      sha256 "7d937b32f36a2c9ed5fbcbaedac099514a2be777dc1161bb0458a6cfe76037e7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.4/urna-aarch64-unknown-linux-musl.tar.xz"
      sha256 "4263840f54b2865dcd74051f389d2d5e7dc55799be4a5601de5e8dda7872ce3b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.4/urna-x86_64-unknown-linux-musl.tar.xz"
      sha256 "6df332f46f2ddb9c4de27bb2772869418d453622ea9ea7f319a3d269ef6055db"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "urna"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "urna"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "urna"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "urna"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
