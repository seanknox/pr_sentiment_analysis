# frozen_string_literal: true

require "octokit"
require 'azure_cognitiveservices_textanalytics

TEXT_ANALYTICS_SUBSCRIPTION_KEY = ENV['TEXT_ANALYTICS_SUBSCRIPTION_KEY']
TEXT_ANALYTICS_ENDPOINT = ENV['TEXT_ANALYTICS_ENDPOINT'] || 'https://westcentralus.api.cognitive.microsoft.com'
GITHUB_ACCESS_TOKEN = ENV['GITHUB_ACCESS_TOKEN']
GITHUB_REPO = ENV['GITHUB_REPO']
PR_NUMBER = ENV['PR_NUMBER']

unless [TEXT_ANALYTICS_SUBSCRIPTION_KEY, TEXT_ANALYTICS_ENDPOINT, GITHUB_REPO, PR_NUMBER, GITHUB_ACCESS_TOKEN].all?
  raise 'Please set the following environment variables: TEXT_ANALYTICS_SUBSCRIPTION_KEY, TEXT_ANALYTICS_ENDPOINT, GITHUB_ACCESS_TOKEN, GITHUB_REPO, PR_NUMBER'
end

class AnalyzePullRequestCommentSentiment
  include Azure::CognitiveServices::TextAnalytics::V2_1::Models

  def initialize
    credentials = MsRestAzure::CognitiveServicesCredentials.new(TEXT_ANALYTICS_SUBSCRIPTION_KEY)

    @text_analytics_client = Azure::TextAnalytics::Profiles::Latest::Client.new({ credentials: credentials })
    @text_analytics_client.endpoint = TEXT_ANALYTICS_ENDPOINT
  end

  def self.call(*args)
    new(*args).call
  end

  def call
    access_token = GITHUB_ACCESS_TOKEN
    repo = GITHUB_REPO
    pr_number = PR_NUMBER

    gh = Octokit::Client.new(access_token: access_token)

    review_comments = gh.pull_request_reviews(repo, pr_number).map(&:body)
    pr_comments = gh.pull_request_comments(repo, pr_number).map(&:body)
    issue_comments = gh.issue_comments(repo, pr_number).map(&:body)

    all_comments_no_code = (review_comments + pr_comments + issue_comments).map do |comment|
      comment.gsub(/\r?\n/, '').gsub(/```suggestion.*```/, '')
    end

    all_comments_no_code.reject!(&:empty?)

    documents = all_comments_no_code.map.with_index do |comment, i|
      m = MultiLanguageInput.new
      m.id = i + 1
      m.language = 'en'
      m.text = comment
      m
    end

    input_documents = MultiLanguageBatchInput.new
    input_documents.documents = documents

    analyze_sentiment(input_documents)
  end

  private

  def analyze_sentiment(input_documents)
    result = @text_analytics_client.sentiment(multi_language_batch_input: input_documents)

    if !result.nil? && !result.documents.nil? && result.documents.length > 0
      puts '===== SENTIMENT ANALYSIS ====='
      result.documents.each do |document|
        text = input_documents.documents.select { |d| d.id.to_s == document.id }[0].text
        puts "Comment: '#{text}' / Sentiment Score: #{document.score}"
      end
    end

    scores = result.documents.map(&:score)
    average = scores.sum / scores.size

    sorted = scores.sort
    mid = (sorted.length - 1) / 2.0
    median = (sorted[mid.floor] + sorted[mid.ceil]) / 2.0

    puts "\nOverall sentiment average: #{average} / median #{median}"
  end
end

AnalyzePullRequestCommentSentiment.call
