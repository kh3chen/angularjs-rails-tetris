json.array!(@highscores) do |highscore|
  json.extract! highscore, :id, :name, :score
  # json.url highscore_url(highscore, format: :json)
end
