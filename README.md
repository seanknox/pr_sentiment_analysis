# Sentiment of Pull Request comments

This uses Microsoft's Text Analytics v2.1 API to analyze the sentiment of comments in a GitHub pull request.

The scores are the APIs best guess at a sentiment reading. Scores closer to 1 == "friendly".

`senti.rb` does its best to remove GitHub's code suggestion blocks from comments (\`\`\`suggestion\`\`\`), as it tends to confuse the sentiment analysis.

## Getting Started

- First, sign up for the [trial of Microsoft's Cognitive Services](https://azure.microsoft.com/en-us/free/cognitive-services/)
- Get your `TEXT_ANALYTICS_SUBSCRIPTION_KEY` and your `TEXT_ANALYTICS_ENDPOINT`.
- Generate a GitHub access token with repo permissions: <https://github.com/settings/tokens>

### Install dependencies

`senti.rb` is written in Ruby; you'll need to have a Ruby and `bundler` installed on your system. Macs have Ruby installed by default.

`bundle install`

### Run

You'll need to set these environment variables in your shell, with an `export` or at runtime.

To analyze PR #1 in this repo:

```shell
export TEXT_ANALYTICS_SUBSCRIPTION_KEY=your_key TEXT_ANALYTICS_ENDPOINT=https://westcentralus.api.cognitive.microsoft.com GITHUB_ACCESS_TOKEN=your_github_access_token GITHUB_REPO="seanknox/pr_sentiment_analysis" PR_NUMBER=1

bundle exec ruby -W0 senti.rb
===== SENTIMENT ANALYSIS =====
Comment: Looks great! I love it. You are the best. : Sentiment Score: 0.9979691505432129
Comment: I don't like this! And I don't like YOU!!!: Sentiment Score: 0.002584695816040039
Comment: This is an ambiguous comment? Maybe?: Sentiment Score: 0.7764753699302673
Comment: I don't like you but I put a smiley so thanks to machine learning not knowing passive aggressiveness it'll think this is nice 😄 : Sentiment Score: 0.9964126944541931

Overall sentiment average: 0.6933604776859283 / median 0.8864440321922302

GITHUB_REPO="seanknox/another_repo" \
PR_NUMBER=93 \
bundle exec ruby -W0 senti.rb

```
