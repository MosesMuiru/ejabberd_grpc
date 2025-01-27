[
  %{
    reaction_name: "smile",
    reaction_code: "😊"
  },
  %{
    reaction_name: "chonjo",
    reaction_code: "👍"
  },
  %{
    reaction_name: "clap",
    reaction_code: "👏"
  },
  %{
    reaction_name: "heart", # Corrected typo
    reaction_code: "❤️"
  },
  %{
    reaction_name: "100",
    reaction_code: "💯"
  }
]
|> Enum.map(fn reaction ->
  %EjabberdRcp.Reactions{
    reaction_name: reaction[:reaction_name],
    reaction_code: reaction[:reaction_code]
  }
  |> EjabberdRcp.ReactionsRepo.insert_reactions()
end)
