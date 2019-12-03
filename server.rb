# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'cgi'
require 'pry-remote'
require 'slack-notifier'

post '/payload' do
  request.body.rewind
  payload_body = request.body.read

  verify_signature(payload_body)
  
  push = JSON.parse(params[:payload])
  watch_files = params[:watching]
  watch_branch = params[:branch]
  ignore_commit_msg = params[:ignore_commit_msg] ? CGI.unescape(params[:ignore_commit_msg]) : nil

  if !(commits = watched_changes(watch_files, watch_branch, ignore_commit_msg, push['ref'], push['commits'])).empty?
    notify(watch_files, commits)
    ids = commits.map { |c| c['id'] }.join(', ')
    "Files changed in: #{ids}"
  else
    'No relevant changes detected'
  end
end

def watched_changes(watch_files, watch_branch, ignore_commit_msg, branch, commits = nil)
  commits ||= []
  return [] if watch_branch && !branch.end_with?(watch_branch)

  commits.select do |commit|
    (!ignore_commit_msg || !commit['message'].include?(ignore_commit_msg)) &&
      commit['modified'].any? { |modified| modified.start_with?(watch_files) }
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
        "ts": DateTime.parse(commit['timestamp']).to_time.to_i
      }
    end
    notifier.ping "Contents of #{watching} were changed in:", attachments: attachments, icon_emoji: ':eagle:'
  end
end

def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['WEBHOOK_SECRET_TOKEN'], payload_body)
  unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
    return halt 500, "Signatures didn't match!"
  end
end
