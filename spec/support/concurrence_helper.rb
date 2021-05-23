module ConcurrenceHelper
  def concurrence(thread_number, counts)
    threads = []
    thread_number.times {
      threads << Thread.new {
        counts.times {
          yield
          sleep 0.0001
        }
      }
    }
    threads.each { |thread| thread.join }
  end
end
