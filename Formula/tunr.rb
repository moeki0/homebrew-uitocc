class Tunr < Formula
  desc "Screen & audio context provider for Claude Code via MCP"
  homepage "https://github.com/moeki0/tunr"
  url "https://github.com/moeki0/tunr/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "55afbb233e151075e4a4d28743023fed21f082f8b522f154864ef191ca36b9d7"
  license "MIT"

  resource "bun" do
    on_arm do
      url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-darwin-aarch64.zip"
      sha256 "5467e3f65dba526b9fea98f0cce04efafc0c63e169733ec27b876a3ad32da190"
    end
    on_intel do
      url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-darwin-x64.zip"
      sha256 :no_check
    end
  end

  def install
    resource("bun").stage do
      bun_bin = Dir["bun-*/bun"].first || "bun"
      buildpath.install bun_bin => "bun"
    end
    chmod 0755, buildpath/"bun"
    bun = (buildpath/"bun").to_s

    system bun, "install", "--frozen-lockfile"
    system bun, "build", "--compile", "cli.ts", "--outfile", "tunr"
    system "swiftc", "ax_text.swift", "-o", "tunr-ax-text", "-O"
    system "swiftc", "send.swift", "-o", "tunr-send", "-O"
    system "swiftc", "embed.swift", "-o", "tunr-embed", "-O"
    system "swiftc", "audio_capture.swift", "-o", "tunr-audio-capture", "-O",
           "-framework", "AVFoundation", "-framework", "CoreAudio"
    system "swiftc", "event_monitor.swift", "-o", "tunr-event-monitor", "-O"
    bin.install "tunr"
    bin.install "tunr-ax-text"
    bin.install "tunr-send"
    bin.install "tunr-embed"
    bin.install "tunr-audio-capture"
    bin.install "tunr-event-monitor"
  end

  def caveats
    <<~EOS
      Grant Accessibility permission to your terminal app (System Settings > Privacy & Security).

      Register the MCP server with Claude Code:
        claude mcp add -s user tunr -- #{bin}/tunr mcp

      Start Claude Code with channels enabled:
        claude --dangerously-load-development-channels server:tunr

      Start the watch daemon to observe screen context:
        tunr watch

      For Chrome web content capture, enable in Chrome:
        View > Developer > Allow JavaScript from Apple Events

      For audio capture, install BlackHole and set up a multi-output device:
        brew install --cask blackhole-2ch
      Then configure a multi-output device in Audio MIDI Setup.
    EOS
  end

  test do
    assert_match "tunr", shell_output("#{bin}/tunr 2>&1", 0)
  end
end
