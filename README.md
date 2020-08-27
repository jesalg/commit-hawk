# Commit Hawk 🦅

### WHY?

Watching a repository on GitHub tells you about social activity (e.g. PRs, issues, etc.), but it doesn't notify you about file-level changes that you and your team might care about. 

For example, when an external vendor merges in their work, or when a critical part of the codebase is changed, or when new dependencies are added, etc 

Commit Hawk fills that gap. 

### INSTALLATION

#### GitHub Action (Recommended)

Commit Hawk is now available as a GitHub Action: https://github.com/marketplace/actions/commithawk

If you still want to self-host, follow the instructions below. Although this self-hosted version will be eventually deprecated.

#### Self-Hosted

<a href="https://heroku.com/deploy?env[SLACK_WEBHOOK_URL]=changeme&env[WEBHOOK_SECRET_TOKEN]=changeme">
  <img src="https://www.herokucdn.com/deploy/button.svg" alt="Deploy">
</a>

1. Deploy this project to Heroku or your platform of choice. 
2. Install the [Incoming Slack Webhook](https://slack.com/apps/A0F7XDUAZ-incoming-webhooks) app to your Slack workspace. Add the webhook URL to this deployment's `SLACK_WEBHOOK_URL` environment variable
3. Add this deployment URL as a webhook in the GitHub repository you want to track under it's `Settings` -> `Webhooks` with the following URL & params:
    - Payload URL host: `http://your-deployment.heroku.com/payload`
    - Payload URL params: 
        - `watching`: Dir or name of the files you want to watch eg: `path/to/some/dir/or/file`
        - `branch` (_optional_): Branch name you want to watch eg: `master`
        - `ignore_commit_msg` (_optional_): Ignore certain commits by the message eg: `Merge branch master`
    - Generate and take a note of the secret and add it to your deploy's `WEBHOOK_SECRET_TOKEN` environment variable
    - Content Type: `application/x-www-form-urlencoded`
    - Which events would you like to trigger this webhook? `Just the push event.`

4. That's it! When the files you are watching change, you will get a Slack notification. For example:
![Example Slack Message](https://raw.githubusercontent.com/jesalg/commit-hawk/master/example.png)

### CONTRIBUTE!

If you like what this does, feel free to improve upon code. Just follow these steps to contribute:

1. Fork it
2. Create your feature branch (``git checkout -b my-new-feature``)
3. Commit your changes (``git commit -am 'Add some feature'``)
4. Push to the branch (``git push origin my-new-feature``)
5. Issue a [pull request](https://help.github.com/articles/using-pull-requests)

