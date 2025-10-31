namespace :logs do
  desc "Remove processing logs older than x days"
  task cleanup: :environment do
    daysoff = (ENV["DAYS"] || 30).to_i
    EmailParserLog.where("created_at < ?", daysoff.days.ago).delete_all
    puts "Old Logs removed"
  end
end
