class Sigil < Formula
  desc "Autonomous evaluation and merge policy engine for agent-generated PRs"
  homepage "https://runsigil.com"
  version "0.33.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bobisme/sigil-releases/releases/download/v0.33.0/sigil-aarch64-apple-darwin.tar.xz"
      sha256 "24e144f4f86578bde6b117e0e8e3e3852908e19f9c902c1814f1a3b193a367fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bobisme/sigil-releases/releases/download/v0.33.0/sigil-x86_64-apple-darwin.tar.xz"
      sha256 "8e4284b2139d47c241d5df78ca4a34503d4cc2800aad7bb707c4afe531b3afd4"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/bobisme/sigil-releases/releases/download/v0.33.0/sigil-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e0b2392d091e87bc4c136394e505d406c17cb4972c486f502580e223167d7712"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.intel?
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
