class Scraper < ActiveRecord::Base

	def exists?
		File.exists?(self.filename)
	end

	def filename
		File.join(Rails.root, 'app', 'scrapers', self.name.underscore + '.rb')
	end

end
