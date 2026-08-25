class TimerCli < Formula
  desc "Run clear and reliable countdown timers from the terminal"
  homepage "https://onlinealarmkur.com/timer/en/"
  url "https://github.com/onlinealarmkur/timer-cli/releases/download/v1.0.0/timer-cli_1.0.0_source.tar.gz"
  sha256 "ec5bb55c9fd13bb619635c31a432518307e1a359c8556ef545bccc94c0379276"
  license all_of: ["MIT", "BSD-3-Clause"]

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -buildid=
      -X github.com/onlinealarmkur/timer-cli/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor", "./cmd/timer-cli"
    generate_completions_from_executable(bin/"timer-cli", "completion")
    pkgshare.install "LICENSE", "THIRD_PARTY_LICENSES"
  end

  test do
    assert_match "timer-cli #{version}", shell_output("#{bin}/timer-cli version")
    assert_match "duration must be greater than zero", shell_output("#{bin}/timer-cli 0 --lang en 2>&1", 2)
    output = shell_output("#{bin}/timer-cli 1 segundo --lang es --final-only --no-bell")
    assert_equal "¡Se acabó el tiempo!\n", output
    assert_path_exists pkgshare/"LICENSE"
    assert_path_exists pkgshare/"THIRD_PARTY_LICENSES"
  end
end
