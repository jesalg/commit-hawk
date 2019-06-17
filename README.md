# Commit Hawk 🦅

### WHY?

Watching a repository on GitHub tells you about social activity (e.g. PRs, issues, etc.), but it doesn't notify you about file-level changes that you and your team might care about. 

For example, when an external vendor merges in their work, or when a critical part of the codebase is changed, or when new dependencies are added, etc 

Commit Hawk fills that gap. 

### INSTALLATION

1. Deploy this project to Heroku or your platform of choice. 
2. Creat a Slack Webhook. Add the webhook URL to this deployment's environment variables as `SLACK_WEBHOOK_URL`
3. Add this deployment URL as a webhook in the GitHub repository you want to track. 
4. That's it! When the files you are watching change, you will get a Slack notification.

### CONTRIBUTE!

If you like what this does, feel free to improve upon code. Just follow these steps to contribute:

1. Fork it
2. Create your feature branch (``git checkout -b my-new-feature``)
3. Commit your changes (``git commit -am 'Add some feature'``)
4. Push to the branch (``git push origin my-new-feature``)
5. Issue a [pull request](https://help.github.com/articles/using-pull-requests)

