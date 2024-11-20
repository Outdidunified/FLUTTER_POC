const razorpay = require('razorpay');

const instance = new razorpay({
   key_id: 'rzp_test_oHoZ3Q1fF6pYEI',
    key_secret: 'Q9FQHLJGtA8knQPOmdTr7vpK'
});

module.exports = instance;