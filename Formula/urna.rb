class Urna < Formula
  desc "Offline-first vector database in one file: a .urna container with content-addressable citations, and the urna CLI"
  homepage "https://urna.dev"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.3/urna-aarch64-apple-darwin.tar.xz"
      sha256 "6330eae533643572ff76767775392056a3cb33cdfe97eab6309293595ea0a0e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.3/urna-x86_64-apple-darwin.tar.xz"
      sha256 "0028b9a23970975017b6d300f9b6c271a3a34c40aa20a0b31498befaf2615534"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.3/urna-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1f611575801971944e1463f66c609529b3a3c463ed60fff92ead10a1be5f5987"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.3/urna-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7ce18056c9ca7dcc72a25d38dec20dc5634af02dd3ed3a7cd024f58a166138d5"
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
