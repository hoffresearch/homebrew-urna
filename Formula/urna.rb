class Urna < Formula
  desc "sovereign embedded vector database: single-file .urna container with content-addressable citations, offline-first"
  homepage "https://urna.dev"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.0/urna-aarch64-apple-darwin.tar.xz"
      sha256 "ce58dac912d8101d4b2e386cf32d6cd2d866bb95af3adcc19872688a1655667e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.0/urna-x86_64-apple-darwin.tar.xz"
      sha256 "1d912dc0109cf316647e333dfa7bf9809faf36c411ff4d70055e5fe8469a40bf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.0/urna-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d686c096157379fbb3bd2f4e935bf7ee8c8102771d0132e522aaf526cd79c9ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hoffresearch/urna/releases/download/v0.5.0/urna-x86_64-unknown-linux-musl.tar.xz"
      sha256 "94856483afdd402d4c358186a8b3f4613ae193f991206fdfe62a064c6dcd9d0f"
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
