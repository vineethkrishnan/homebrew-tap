class Regrow < Formula
  desc "Read-only recovery of deleted files on macOS"
  homepage "https://github.com/vineethkrishnan/homebrew-tap"
  url "https://github.com/vineethkrishnan/homebrew-tap/releases/download/regrow-v0.8.0/regrow-0.8.0-macos-universal.tar.gz"
  sha256 "842b64131bd327a28406a1e59c3627da016dea8a5744dc683b0eb07750ff0139"
  license :cannot_represent

  depends_on macos: :sonoma

  def install
    bin.install "regrow"
  end

  def caveats
    <<~EOS
      Scanning a USB drive or memory card asks for your password once: only a small
      helper runs as root, and it only opens the device read-only.
      If macOS blocks it, give your terminal app Full Disk Access in
      System Settings > Privacy & Security > Full Disk Access, then reopen the terminal.
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/regrow --version").strip
  end
end
