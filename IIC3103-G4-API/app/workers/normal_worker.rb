class NormalWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3, backtrace: true, queue: :default

  def perform(*args)
    # Do something
  end
end
