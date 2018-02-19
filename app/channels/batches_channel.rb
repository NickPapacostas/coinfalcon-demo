class BatchesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "batches"
  end

  def unsubscribed
    stop_all_streams
  end
end