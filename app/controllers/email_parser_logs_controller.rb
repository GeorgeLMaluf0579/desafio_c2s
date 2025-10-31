class EmailParserLogsController < ApplicationController
  def index
    @email_parser_logs = EmailParserLog.order(created_at: :desc)
  end
end
