class Sigil < Formula
  desc "Autonomous evaluation and merge policy engine for agent-generated PRs"
  homepage "https://runsigil.com"
  version "0.34.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bobisme/sigil-releases/releases/download/v0.34.0/sigil-aarch64-apple-darwin.tar.xz"
    sha256 "bc62acf0b86a2337d97a87e5e22a6ca56710548f26ae82f7750cc5fb0255999a"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bobisme/sigil-releases/releases/download/v0.34.0/sigil-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2c718525a7c63f6f58cd61cd88335716ca42917ee8605a616c830b45996098bb"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-unknown-linux-gnu": {},
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
      bin.install "sigil"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sigil"
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
