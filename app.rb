require "sinatra"
require "sinatra/reloader"
require "json"
require "pry-byebug"

require_relative "environment"

before do
  response.headers["Access-Control-Allow-Headers"] = "Content-Type, Accept"
  response.headers["Access-Control-Allow-Origin"] = "http://localhost:3000"
  response.headers["Access-Control-Allow-Methods"] = "POST", "OPTIONS", "PUT", "DELETE", "GET"
  content_type :json
end

def serialize_question(question)
  {
    id: question.id.to_s,
    title: question.title,
    tag: question.tag,
  }
end

def write_json(updated_rating_questions)
  File.open("db.json", "w") do |file|
    file.write(JSON.pretty_generate({ratingQuestions: updated_rating_questions}))
  end
end

def delete_item(id)
  #   rating_questions.reject { |e| e["id"] == id }
  RatingQuestion.remove({"_id": id})
end

options "*" do
end

get "/ratingQuestions" do
  #   rating_questions.to_json
  RatingQuestion.all.map do |question|
    serialize_question(question)
  end.to_json
end

get "/ratingQuestions/:id" do
  id = params["id"]
  unless RatingQuestion.find(id)
    response.status = 404
    return response
  end
  question = RatingQuestion.find(id)
  response.status = 200
  response.body = serialize_question(question).to_json
  response
end

post "/ratingQuestions" do
  body_content = request.body.read
  return status 400 if body_content.empty?
  json_params = JSON.parse(body_content)

  title = json_params["title"]
  tag = json_params["tag"]
  if title.empty?
    response.status = 422
    response.body = {"errors" => {"title" => ["can't be blank"]}}.to_json
    return response
  end

  new_question = {"title": title, "tag": tag}
  question = RatingQuestion.create(new_question)
  response.status = 201
  response.body = serialize_question(question).to_json
end

delete "/ratingQuestions/:id" do
  id = params["id"]
  question = RatingQuestion.find(id)
  unless question
    response.status = 404
    return response
  end
  question.destroy
  response.status = 204
  response.body = {}.to_json
  response
end

put "/ratingQuestions/:id" do
  id = params["id"]
  question = RatingQuestion.find(id)
  unless question
    response.status = 404
    return response
  end
  json_params = JSON.parse(request.body.read)

  title_update = json_params["title"]
  id = params["id"]
  question.update({"title": title_update})
  response.status = 200
  response.body = serialize_question(question).to_json
  response
end

patch "/ratingQuestions/:id" do
  id = params["id"]
  question = RatingQuestion.find(id)
  unless question
    response.status = 404
    return response
  end
  json_params = JSON.parse(request.body.read)
  question.update(json_params)
  response.status = 200
  response.body = serialize_question(question).to_json
  response
end
