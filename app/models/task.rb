
class Task
	def initialize(dj)
		@dj = dj
	end

	def to_s
		o = YAML.load(@dj.handler)
		case o.method_name.to_s
		when "load_posting"
			"#{o.object.class}##{o.method_name.to_s}"
		when "scrape_page"
			"#{o.object.class}##{o.method_name.to_s}"
		else
			"#{o.object.class}##{o.method_name.to_s}(#{o.args.join(', ')})"
		end
	end

	def retries
		@dj.attempts
	end

	def error_html
		@dj.last_error.gsub(/\\n/, '<br>') rescue ''
	end

	def formatted_run_at
		@dj.run_at.localtime.strftime("%Y.%m.%d %H:%M:%S")
	end

	def relevant_object
		o = YAML.load(@dj.handler)
		case o.method_name.to_s
		when "load_posting"
			Posting.find(o.args.first)
		when "scrape_page"
			Page.find(o.args.first)
		else
			nil
		end
	end
end
