require "spec_helper"

RSpec.describe "DELETE /ratingQuestions/:id" do
  context "with an existing question" do
    it "returns a 204 No Content" do
      post("/ratingQuestions", {title: "Hello World"}.to_json)
      question = JSON.parse(last_response.body)
      delete("/ratingQuestions/#{question["id"]}")

      expect(last_response.status).to eq(204)
    end

    it "returns nothing" do
      post("/ratingQuestions", {title: "Hello World"}.to_json)
      question = JSON.parse(last_response.body)
      delete("/ratingQuestions/#{question["id"]}")

      expect(last_response.body.to_s).to eq("")
    end
  end

  context "asking to delete a question that doesn't exist" do
    it "returns a 404 Not Found" do
      delete("/ratingQuestions/i-will-never-exist")
      expect(last_response.status).to eq(404)
    end
  end
end
