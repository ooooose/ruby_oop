require_relative "config/dependencies"

app = Config::Dependencies.build
app.run
