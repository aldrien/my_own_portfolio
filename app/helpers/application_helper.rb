module ApplicationHelper
  def display_validation_errors(currRecord)
    errorDiv = 
    errMsg = ''
    if currRecord.errors.any?
      currRecord.errors.full_messages.each do |msg|
        errMsg += msg + '<br/>'   
      end
    end
    if errMsg != ''
     errorDiv =  %Q{
          <div class="alert alert-error">
            <button class="close" data-dismiss="alert"></button>
            <strong>Error!</strong><br/>
            #{errMsg}
          </div>
         }
    end
    return raw(errorDiv)
  end
end
