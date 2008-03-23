module EmployeesHelper
  def select_timezone
    time_zone_select 'employee', 'time_zone', TZInfo::Timezone.us_zones + (TZInfo::Timezone.all_data_zones - TZInfo::Timezone.us_zones).sort, :model => TZInfo::Timezone, :default => "America/Los_Angeles"
  end
  
  def alert!
    image_tag "alert.gif"
  end

  def click_to_dial(mobile_number, options={})
    link_text = options.delete(:link_text) || format_phone_number(mobile_number)
    link_to_remote(
      link_text,
      :url => {
        :controller => "employees", :action => "call",
        :source => @logged_in_user.mobile_number,
        :destination => @employee.mobile_number
      },
      :complete => "callRequestSent();",
      :html => {:id => "click_to_call_link"}
    )
  end
  
end
