defmodule QueueWrapper.MixProject do
  use Mix.Project

  def project do
    [
      app: :queue_wrapper,
      name: "queue_wrapper",
      package: package(),
      description: description(),
      version: "1.0.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "QueueWrapper",
        extras: [
          "README.md",
          "CHANGELOG.md",
          "CONTRIBUTING.md"
        ]
      ]
    ]
  end

  def application,
    do: [
      extra_applications: [:logger]
    ]

  defp description do
    "A module which extends the erlang queue module."
  end

  defp package() do
    [
      name: "queue_wrapper",
      files: ~w(
        lib mix.exs README.md CONTRIBUTING.md LICENSE
        CHANGELOG.md test
      ),
      maintainers: ["Angus Karl Stewart Thomsen"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/AKST/queue-wrapper"
      }
    ]
  end

  def deps do
    [
      {:ex_doc, "~> 0.19.1", only: :dev}
    ]
  end
end
