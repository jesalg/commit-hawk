require 'sinatra'
require 'json'
require 'pry-remote'
require 'slack-notifier'

post '/payload' do
  request.body.rewind
  payload_body = request.body.read
  
  verify_signature(payload_body)
  
  push = JSON.parse(params[:payload])
  watching = params[:watching]

  if (commits = watched_changes(watching, push['commits'])).length > 0
    notify(watching, commits)
    ids = commits.map{ |c| c['id'] }.join(', ')
    "Wow things changed in: #{ids}"
  else
    "Meh I don't care"
  end
end

def watched_changes(watching, commits)
  commits.select do |commit|
    commit['modified'].any?{ |added| added.start_with?(watching) } 
  end
end

def notify(watching, commits)
  if ENV['SLACK_WEBHOOK_URL']
    notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
    attachments = commits.map do |commit|
      {
        "fallback": commit['message'],
        "author_name": commit['author']['name'],
        "author_link": "https://github.com/#{commit['author']['username']}",
        "title": commit['message'],
        "title_link": commit['url'],
        "footer": 'Commit Hawk',
        "footer_icon": 'https://platform.slack-edge.com/img/default_application_icon.png',
        "ts": Date.strptime(commit['timestamp']).to_time.to_i
      }
    end
    notifier.ping "Contents of #{watching} were changed in:", attachments: attachments, icon_emoji: ":eagle:"
  end
end

def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['WEBHOOK_SECRET_TOKEN'], payload_body)
  return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
end
