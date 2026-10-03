set_param general.maxThreads 1
puts "INFO: general.maxThreads forced to [get_param general.maxThreads]"
catch { config_webtalk -user off }
catch { config_webtalk -install off }
