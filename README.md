# Sentiment of Pull Request comments

This uses Microsoft's Text Analytics v2.1 API to analyze the sentiment of comments in a GitHub pull request. 

The scores are the APIs best guess at a sentiment reading. Scores closer to 1 == "friendly".

## Getting Started

- First, sign up for the [trial of Microsoft's Cognitive Services](https://azure.microsoft.com/en-us/free/cognitive-services/)
- Get your `TEXT_ANALYTICS_SUBSCRIPTION_KEY` and your `TEXT_ANALYTICS_ENDPOINT`.
- Generate a GitHub access token with repo permissions: https://github.com/settings/tokens

### Install dependencies

`bundle install`

### Run

To analyze PR #1 in `seanknox/the_repo_name`:

```
TEXT_ANALYTICS_SUBSCRIPTION_KEY=your_key \
TEXT_ANALYTICS_ENDPOINT=your_msft_cognitive_api_endpoint \
GITHUB_ACCESS_TOKEN=your_github_access_token \
REPO="seanknox/the_repo_name" \
PR_NUMBER=1 \
bundle exec ruby -W0 senti.rb; done
```

You'll get something like this:

```
===== SENTIMENT ANALYSIS =====
Comment: LGTM!: Sentiment Score: 0.7526739239692688
Comment: :shipit: : Sentiment Score: 0.7526739239692688
Comment: Exciting!!! Looks good! : Sentiment Score: 0.9921272993087769
Comment: Nice! If I'm understanding this correctly, this lazy loads/builds the extraction? I.e. it's not built until it's accessed?: Sentiment Score: 0.7758610248565674

...

Overall sentiment average: 0.6727201962471008 / median 0.7758610248565674
```
