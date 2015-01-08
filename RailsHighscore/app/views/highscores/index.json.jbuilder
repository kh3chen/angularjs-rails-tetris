json.array!(@highscores) do |highscore|
  json.extract! highscore, :id, :name, :score
end
