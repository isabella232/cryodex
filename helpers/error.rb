def error(code, messages, exception = nil)
  
  logger.info %{
      User ID:    #{ @user ? @user.id : 'Not logged in.' }
      Timestamp:  #{ Time.now }
      Error:      #{ messages.inspect }
      More info:  #{ exception ? exception.message : 'No info provided.'}
      Trace:      #{ exception ? exception.backtrace.join("\n") : 'No exception.' }
  }
  
  halt code, messages.to_json

end