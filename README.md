# Coinfalcon Limit Bot

This project allows a user to create "batches" of limit orders that are a specific percentage above/below the current price for a specific market. A background job retrieves new prices from trades on Coinfalcon and then updates and batches where the price has gotten closer to the limit. 

It will then delete the orders in a batch and create new ones using the percentage specified at by the batch. 

It will also push any updates to batch prices / order_ids to the client browser using actioncable and websockets. 

## Dependencies

- Ruby >= 2.3
- Rails 5
- Redis (locally)
- ActiveJob
- ActionCable

## Architecture

Batches have many orders which use the batch percent and type to create the orders on coinfalcon. In the database an order is just a reference to a batch and a coinfalcon_id.

### DelayedJobs

On the delayed jobs side of things, there is a background job called [PriceUpdateJob](app/jobs/price_update_job.rb) that will:
  1. get latest prices
  2. enqueue a job for batches if there is a new price for their market using [BatchUpdateJob](app/jobs/batch_update_job.rb)
  3. Enqueue a new PriceUpdateJob for 15 seconds from now (this means the prices and batches will stay up to date) with the old prices so that the job can determine which markets have changed price. 

Locally it is using Redis for the ActionCable pub/sub in order to allow testing updates with new prices from a seperate rails console instance. 

### ActionCable

When a batch is updated for a new market price (which I've called ["balancing orders"](app/models/batch.rb#L53)) it will broadcast the new order_ids and new batch price to an ActionCable stream called "batches" on the frontend there is some [plain js](app/assets/javascripts/channels/batches_channel.rb) to update the view when a batch is "balanced". 

### Notes
 
##### Rate Limits
  - Any Coinfalcon requests are limited to 3 requests per 2 seconds (the Coinfalcon API limits requets to 3 / 1 second). 

##### Price formatting
  - Due to the api requiring prices for limit orders to be no more than 5 units after the decimal (precision '%.5f') all orders are priced using [this convention](app/models/order.rb#L6). 


## install

1. `git clone https://github.com/NickPapacostas/coinfalcon-demo`
2. `cd coinfalcon-demo`
3. `bundle install`
4. `rake db:create`
5. `rake db:migrate`
6. `redis-server &` 
7. set coinfalcon api key and secret as `CF_KEY` and `CF_SECRET`
8. `rails s` 


## Testing

`rspec` 

