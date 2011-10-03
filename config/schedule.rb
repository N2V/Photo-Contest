every 1.day, :at => '12:01 am' do 
  runner "Contest.close_done"
  runner "Contest.notify_demo_owners"
  runner "Contest.pause_demo"
end