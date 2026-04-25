class Uitocc < Formula
  desc "Screen context provider for Claude Code via MCP"
  homepage "https://github.com/moeki0/uitocc"
  url "https://github.com/moeki0/uitocc/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ee724aae88aaeae67b6995b0d15ac4b9e24d9cd6a7f431bdc58a70cb3aebebee"
  license "MIT"

  depends_on :macos
  depends_on "bun" => :build

  def install
    system "bun", "install"
    system "bun", "build", "--compile", "cli.ts", "--outfile", "uitocc"
    system "swiftc", "ax_text.swift", "-o", "uitocc-ax-text", "-O"
    system "swiftc", "send.swift", "-o", "uitocc-send", "-O"
    bin.install "uitocc"
    bin.install "uitocc-ax-text"
    bin.install "uitocc-send"
  end

  def caveats
    <<~EOS
      Grant Accessibility and Screen Recording permissions to your terminal app.

      Register the MCP server with Claude Code:
        claude mcp add -s user uitocc -- #{bin}/uitocc mcp

      Enable channels in ~/.claude/settings.json:
        { "experimentalFeatures": { "channels": true } }

      Start the watch daemon to observe screen context:
        uitocc watch
    EOS
  end

  test do
    assert_match "uitocc", shell_output("#{bin}/uitocc 2>&1", 0)
  end
end
