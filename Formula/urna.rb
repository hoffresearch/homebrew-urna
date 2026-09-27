class Urna < Formula
  desc "sovereign embedded vector database: single-file .urna container with content-addressable citations, offline-first"
  homepage "https://urna.dev"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.1/urna-aarch64-apple-darwin.tar.xz"
      sha256 "66ac06f7e05356a8bda400cca534d76b2c5136b28f4409e8d11a7ac1538a07c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.1/urna-x86_64-apple-darwin.tar.xz"
      sha256 "7bc27b8001bae4c762cae88898622690e65d73a78e9a2d3a655c4c3f393a42fe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.1/urna-aarch64-unknown-linux-musl.tar.xz"
      sha256 "cbb76aabf10e47e4cafa14bc282360c40d6142c236b08a3324655c47175cfda4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.1/urna-x86_64-unknown-linux-musl.tar.xz"
      sha256 "1fbe35dc9b88ba9ab46ed5a4d0304511780fc94d73fbea8797ce62d975dca8e8"
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
