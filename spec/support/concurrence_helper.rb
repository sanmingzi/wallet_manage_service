module ConcurrenceHelper
  def concurrence(thread_number, counts, &block)
    threads = []
    thread_number.times {
      threads << Thread.new { counts.times(&block) }
    }
    threads.each { |thread| thread.join }
  end
end
