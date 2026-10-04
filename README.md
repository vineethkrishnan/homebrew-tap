# VineLab Homebrew tap

Homebrew formulae and release binaries for VineLab tools.

## ReGrow

Read-only recovery of deleted files on macOS. Regrow what you lost.

```
brew install vineethkrishnan/tap/regrow
```

Without Homebrew:

```
curl -fsSL https://raw.githubusercontent.com/vineethkrishnan/homebrew-tap/main/install.sh | sh
```

Then:

```
regrow devices
regrow scan disk4s1          # a USB drive or memory card
regrow scan ~/Documents      # Trash and Time Machine snapshots for a folder
regrow ui                    # browse and restore in the browser
```

macOS 14 or later, Apple Silicon and Intel. Releases are tagged `regrow-v<version>` and each carries the binary and its SHA-256.
