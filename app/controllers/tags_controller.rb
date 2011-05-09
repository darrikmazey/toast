class TagsController < ApplicationController
	before_filter :load_account, :only => [:index, :show]

	def index
		@tags = @account.tags.all.sort {|a,b| b.rank <=> a.rank }.paginate :page => params[:page], :per_page => 25
		@key_tags = @tags.select { |t| t.rank > 5 }.sort {|a,b| a.transactions.sum(:amount) <=> b.transactions.sum(:amount) }
		top = @key_tags.slice(0,6)
		bottom = @key_tags.slice(6,@key_tags.count)
		bottom_data = ["Other", bottom.map {|t| t.transactions.sum(:amount).round(2).abs}.sum]

		@expense_chart = HighChart.new do |f|
			f.options[:legend] = { :enabled => false }
			f.options[:title][:text] = "Expense Categories"
			f.series(
				:type => 'pie',
				:data => top.map { |t| [t.name, t.transactions.sum(:amount).round(2).abs] } << bottom_data
			)
		end
	end

	def show
		@tag = @account.tags.find(params[:id])
		@transactions = @tag.transactions.order("transaction_date asc, id asc").paginate :page => params[:page], :per_page => 25
		@projected_data = []
		@projected_diff = []
		datum = 0
		d = @transactions.first.transaction_date - @tag.frequency
		#b = @tag.balance_on(d)
		b = 0
		i = 0
		while d <= @tag.next_occurrence
			datum = @tag.expenditure_for_frequency * i + b
			@projected_data << [d.utc.to_i * 1000, datum]
			@projected_diff << [d.utc.to_i * 1000, datum - @tag.balance_on(d)]
			d = d + @tag.frequency
			i = i + 1
		end
		@trans_chart = HighChart.new do |f|
			f.options[:legend] = { :enabled => true }
			f.options[:title][:text] = "Daily Totals & Balances"
			f.options[:x_axis] = { :type => :datetime, :plotLines => [
				{ :color => '#000000', :label => 'Today', :value => Date.today.to_datetime.utc.to_i * 1000, :width => 2, :zIndex => 3 },
				{ :color => '#5555ff', :label => 'Next', :value => @tag.next_occurrence.utc.to_i * 1000, :width => 1, :dashStyle => 'ShortDash', :zIndex => 3 }
			] }
			f.options[:y_axis] = { :title => { :text => "$" } }
			f.series(
				:name => "Balance",
				:data => @transactions.group_by(&:transaction_date).map { |k,v| [k.utc.to_i * 1000, @tag.balance_on(k)] } << [Date.today.to_datetime.utc.to_i * 1000, @tag.balance_on(Date.today)]
				#:type => 'line'
			)
			f.series(
				:name => "Projected",
				:data => @projected_data,
				:type => 'line'
			)
			f.series(
				:name => "Projected Difference",
				:data => @projected_diff,
				:type => 'areaspline',
				:visible => false
			)
			f.series(
				:name => "Expense",
				:data => @tag.taggings.select { |t| t.amount < 0 }.map { |t| [t.transaction.transaction_date.utc.to_i * 1000, t.amount] },
				:type => 'column',
				:visible => false
			)
			f.series(
				:name => "Income",
				:data => @tag.taggings.select { |t| t.amount >= 0}.map { |t| [t.transaction.transaction_date.utc.to_i * 1000, t.amount] },
				:type => 'column',
				:visible => false
			)
		end
		@transactions.reverse!
	end
end
