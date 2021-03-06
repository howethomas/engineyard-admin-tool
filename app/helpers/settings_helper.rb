module SettingsHelper
  
  def global_setting(setting)
    override = setting.global_setting_override
    id = "global_#{override.id}"
    %<<h5><label for="#{id}">#{setting.human_name}</label></h5>> +
    send(setting.kind, id, override) +
    '<p>' + h(setting.description) + '</p>'
  end
  
  def group_setting(setting, group)    
    override = setting.group_setting_overrides.find_by_foreign_id group.id
    id = "group_#{group.id}_#{setting.id}"
    '<h5>' + check_box_tag("enabled_#{id}", '1', override ? override.enabled : false) + %< <label for="#{id}">#{setting.human_name}</label></h5>> +
    send(setting.kind, id, override) +
    '<p>' + h(setting.description) + '</p>'
  end
  
  def highlight_errors(save_errors)
    "<script type=\"text/javascript\">\n" + @save_errors.map do |hash|
      id, errors = hash.values_at :id, :errors
      errors.map do |error|
        <<-JAVASCRIPT
        tmp_victim = document.getElementById("#{id}");
        tmp_victim.className = 'setting-error';
        new Insertion.After(tmp_victim, "<span class='setting-error-description'>#{error.gsub('"', '\"')}</span>");
        JAVASCRIPT
      end
    end.flatten.join("\n") + "</script>"
  end

  private
  
  def string(id, override)
    text_field_tag(id, override ? override.value : '')
  end
  
  
  def integer(id, override)
    string id, override
  end
  
  def boolean(id, override)
    option_value_translations = {'true' => 'enabled', 'false' => 'disabled'}
    option_value_translations.default = ''
    value = override ? override.value.to_s : ''
    available_options = ['true', 'false']
    available_options.unshift '' if override.type != "GlobalSettingOverride"
    options = available_options.map { |valid| %<<option #{valid == value ? "selected='selected'" : ''} value="#{valid}">#{option_value_translations[valid]}</option>> }
    select_tag(id, options.to_s)
  end
  
end
