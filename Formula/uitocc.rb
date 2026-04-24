class Uitocc < Formula
  desc "Screen context provider for Claude Code via MCP"
  homepage "https://github.com/moeki0/uitocc"
  url "https://github.com/moeki0/uitocc/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "60a941e8492a0b7bdf65205baef4c17ab5757f083a562529a832793c188b8f46"
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
    bin.install "transcribe.sh" => "uitocc-transcribe.sh"
  end

  def caveats
    <<~EOS
      Grant Accessibility and Screen Recording permissions to your terminal app.

      Register the MCP server with Claude Code:
        claude mcp add -s user uitocc -- #{bin}/uitocc mcp

      Enable channels in ~/.claude/settings.json:
        { "experimentalFeatures": { "channels": true } }

      For audio capture, install BlackHole and ffmpeg:
        brew install blackhole-2ch ffmpeg
      Then start the audio daemon: uitocc audio
    EOS
  end

  test do
    assert_match "uitocc", shell_output("#{bin}/uitocc 2>&1", 0)
  end
end
