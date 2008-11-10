
def pause_game
  queue = Rubygame::EventQueue.new
  keyup = false
  until keyup do
    queue.each do |e|
      if (e.kind_of?(KeyUpEvent) and  e.key == K_ESCAPE) then
        keyup=true
      end
    end
  end
  paused = true
  while paused do
    queue.each do |e|
      if (e.kind_of?(KeyDownEvent) and  e.key == K_ESCAPE) then
        paused = false
      end
    end
  end
end
