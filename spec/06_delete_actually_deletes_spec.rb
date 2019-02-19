require "spec_helper"

RSpec.describe "DELETE /ratingQuestions/:id" do
  context "with an existing question" do
    # let(:question) do
    #   response = HTTP.
    #     response.parse
    # end

    it "actually deletes the question" do
      post("/ratingQuestions", {title: "Hello World"}.to_json)
      question = JSON.parse(last_response.body)
      route = "/ratingQuestions/#{question["id"]}"
      delete(route)
      get(route)
      expect(last_response.status).to eq(404)
    end
  end
end
