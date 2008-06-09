class Voicemail < Object
  attr_reader :caller_id, :orig_date, :orig_time, :context, :duration, :new, :sound_file, :filename
  
  def initialize(filename)
    
    # Using this path (which points to a text file), create the object
    @filename = filename
    @sound_file = filename.gsub(/txt/,"wav")
    desc = File.new(filename)
    while line = desc.gets do
      next if line =~ /^\s*;/     # skip comments 
      next if line =~ /^\s*\[/    # skip the header block
      if line.include? "="
        line.strip
        setting = line.split(/\=/)
        setting[1].chomp!
        case setting[0]
        when  "context"
          @context = setting[1]
        when "callerid"
          @caller_id = setting[1]
        when "origdate"
          @orig_date = setting[1]
        when "origtime"
          @orig_time = setting[1]
        when "duration"
          @duration = setting[1].to_i
        end
      end
    end
  end
end