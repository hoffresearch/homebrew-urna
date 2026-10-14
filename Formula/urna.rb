class Urna < Formula
  desc "Offline-first vector database in one file: a .urna container with content-addressable citations, and the urna CLI"
  homepage "https://urna.dev"
  version "0.5.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.5/urna-aarch64-apple-darwin.tar.xz"
      sha256 "bc0f4ef94b3bed107d11eb09741715a04c5aa76a14e34d13bbd776d8ae4f9da6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.5/urna-x86_64-apple-darwin.tar.xz"
      sha256 "61032ccbbe4791203c678e990203da68288e3a7041d42fb7cecc26b921a85c07"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.5/urna-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ce5bb8076868c31187980808e606139dfcb1b0d322390b9ca4df652120e6eb7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.5/urna-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5eed9ed0db132e778e4d6bbfb5fe8a8ea9743b1b9ea7d36cae631c7f4ea704c8"
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
