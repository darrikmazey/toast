Delayed::Worker.destroy_failed_jobs = true
silence_warnings do
	Delayed::Worker.max_attempts = 5
	Delayed::Worker.max_run_time = 3.minutes
end
