class Hello
  def initialize(app)
    @app = app
  end

  def call(env)
    puts "YES IS WORKING"
    return [200, {"Content-Type" => "text/html"}, ["Hello, World!"]]
  end
end


