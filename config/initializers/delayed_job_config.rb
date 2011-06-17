silence_warnings do
	Delayed::Worker.max_run_time = 3.minutes
end
