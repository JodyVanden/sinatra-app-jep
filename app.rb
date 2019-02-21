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

def send_response(status,body)
  response.status = status
  response.body = body
  response
end

def get_valid_question(id)
  question = RatingQuestion.find(id)
  halt 404 if question.nil?
  question
end

def delete_item(id)
  RatingQuestion.remove({"_id": id})
end

options "*" do
end

get "/ratingQuestions" do
  RatingQuestion.all.map do |question|
    serialize_question(question)
  end.to_json
end

get "/ratingQuestions/:id" do
  question = get_valid_question(params["id"])
  send_response(200,serialize_question(question).to_json)
end

post "/ratingQuestions" do
  body_content = request.body.read
  return status 400 if body_content.empty?
  json_params = JSON.parse(body_content)

  title = json_params["title"]
  tag = json_params["tag"]

  new_question = {"title": title, "tag": tag}
  question = RatingQuestion.create(new_question)
  if question.save
    send_response(201,serialize_question(question).to_json)
  else
    errors = {"errors" => {"title" => ["can't be blank"]}}.to_json
    send_response(422,errors)
  end
end

delete "/ratingQuestions/:id" do
  question = get_valid_question(params["id"])
  question.destroy
  send_response(204,{}.to_json)
end

put "/ratingQuestions/:id" do
  question = get_valid_question(params["id"])
  json_params = JSON.parse(request.body.read)
  title_update = json_params["title"]
  question.update({"title": title_update})
  send_response(200,serialize_question(question).to_json)
end

patch "/ratingQuestions/:id" do
  question = get_valid_question(params["id"])
  json_params = JSON.parse(request.body.read)
  question.update(json_params)
  send_response(200,serialize_question(question).to_json)
end
