require "spec_helper"

RSpec.describe "PUT /ratingQuestions/:id" do
  context "when the question exists" do
    # let(:question) do
    #   response =
    #     response.parse
    # end

    # let(:response) { }

    it "returns a 200 OK" do
      post("/ratingQuestions", {title: "Hello World", tag: "greetings"}.to_json)
      question = JSON.parse(last_response.body)
      put("/ratingQuestions/#{question["id"]}", {title: "Hello Mars"}.to_json)

      expect(last_response.status).to eq(200)
    end

    it "changes just the title attribute" do
      post("/ratingQuestions", {title: "Hello World", tag: "greetings"}.to_json)
      question = JSON.parse(last_response.body)
      put("/ratingQuestions/#{question["id"]}", {title: "Hello Mars"}.to_json)
      question = JSON.parse(last_response.body)
      expect(question.is_a?(Hash)).to eq(true)
      expect(question["title"]).to eq("Hello Mars")
      expect(question.key?("tag")).to be true
    end
  end

  context "asking to PUT a question that doesn't exist" do
    it "returns a 404 Not Found" do
      put("/ratingQuestions/i-will-never-exist", json: {title: "hello"})
      expect(last_response.status).to eq(404)
    end
  end
end
