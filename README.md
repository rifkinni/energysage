# EnergySage Customer API


This guide assumes you have both Ruby >=3.0.0 and Rails >=6.0.6 installed. For installation support see the [Rails Guide](https://guides.rubyonrails.org/getting_started.html).

## Setup
### Clone the repo
`git clone git@github.com:rifkinni/energysage.git`


### Install the dependencies
`bundle install`


### Set up the sqlite database
`rake db:create`

`rake db:migrate`

### Run the tests
    Note: the testing framework should automatically seed the test database with mock data

`rake test`


### Start the Rails Server
`rails server`

### Test the interactive API specification at http://localhost:3000/
     The API spec can be found in /swagger/customers.yaml