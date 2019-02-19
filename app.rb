require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pry-byebug'


before do
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, Accept"
    response.headers['Access-Control-Allow-Origin'] = 'http://localhost:3000'
    response.headers["Access-Control-Allow-Methods"] = "POST", "OPTIONS", "PUT", "DELETE", "GET"
    content_type :json
end

def rating_questions
     JSON.parse(File.read('db.json'))['ratingQuestions']
end

def write_json(updated_rating_questions)
    File.open('db.json', "w") do |file|
        file.write(JSON.pretty_generate({ratingQuestions: updated_rating_questions}))
    end
end

def delete_item(id)
    rating_questions.reject{|e| e["id"] == id}
end

options "*" do
end

get '/ratingQuestions' do
    rating_questions.to_json
end

get '/ratingQuestions/:id' do
    id = params["id"].to_i
    unless rating_questions.find {|q| q["id"] == id}
        response.status = 404
        return response
    end
    question = rating_questions.find {|q| q["id"] == id}
    response.status = 200
    response.body = {"question" => question}.to_json
    response
end

post '/ratingQuestions' do
    body_content = request.body.read
    return status 400 if body_content == ''
    json_params = JSON.parse(body_content)

    title = json_params["title"]
    tag = json_params["tag"]
    if title == ""
        response.status = 422
        response.body = {"errors" => {"title" => ["cannot be blank"]}}.to_json
        return response
    end
    
    new_question = {"title" => title, "tag" => tag, "id" => rating_questions.any? ? (rating_questions.last["id"] + 1) : 1}
    updated_rating_questions = rating_questions << new_question
    #save in Json file
    write_json(updated_rating_questions)
    #return the question for React app
    status 201
    new_question.to_json
       
end

delete  '/ratingQuestions/:id' do
    id = params["id"].to_i
    unless rating_questions.find {|q| q["id"] == id}
        response.status = 404
        return response
    end
    updated_rating_questions = delete_item(id)
    write_json(updated_rating_questions)
    response.status = 204   
    response.body = {}.to_json
    response
end

put '/ratingQuestions/:id' do
    id = params["id"].to_i
    unless rating_questions.find {|q| q["id"] == id}
        response.status = 404
        return response
    end
    json_params = JSON.parse(request.body.read)
    
    title_update = json_params["title"]
    id = params["id"].to_i
    new_questions = rating_questions
    question = new_questions.find{ |question| question["id"] == params["id"].to_i}
    question["title"] = title_update
    write_json(new_questions)
    question.to_json
    response.status = 200
    response.body = question.to_json
    response
end

patch '/ratingQuestions/:id' do
    id = params["id"].to_i
    unless rating_questions.find {|q| q["id"] == id}
        response.status = 404
        return response
    end
    json_params = JSON.parse(request.body.read)
    
    title_update = json_params["title"]
    id = params["id"].to_i
    new_questions = rating_questions
    question = new_questions.find{ |question| question["id"] == params["id"].to_i}
    question["title"] = title_update
    write_json(new_questions)
    question.to_json
    response.status = 200
    response.body = question.to_json
    response
end