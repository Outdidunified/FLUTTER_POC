const OrderModel = require('./../models/order_model');
const CartModel = require('./../models/cart_model');
const razorpay = require('../razorpay');

const OrderController = {

    createOrder: async function(req, res) {
        try {
            const { user, items, status, totalAmount } = req.body;

            // Log the totalAmount to verify it's correct
            console.log('Total Amount:', totalAmount);

            // Ensure totalAmount is in INR and multiply by 100 to convert to paise
            const amountInPaise = totalAmount * 100;

            // Create Order in RazorPay
            const razorPayOrder = await razorpay.orders.create({
                amount: amountInPaise, // Amount in paise (1 INR = 100 paise)
                currency: "INR"
            });

            const newOrder = new OrderModel({
                user: user,
                items: items,
                status: status,
                totalAmount: totalAmount,
                razorPayOrderId: razorPayOrder.id
            });
            await newOrder.save();

            // Update the cart by clearing items
            await CartModel.findOneAndUpdate(
                { user: user._id },
                { items: [] }
            );

            return res.json({ success: true, data: newOrder, message: "Order created!" });
        }
        catch(ex) {
            // If Razorpay returns a specific error, extract the message
            if (ex.response && ex.response.body && ex.response.body.error) {
                return res.json({
                    success: false,
                    message: ex.response.body.error.description || 'Error while creating the order'
                });
            }

            // Return generic error message if not Razorpay-specific
            return res.json({ success: false, message: ex.message });
        }
    },

    fetchOrdersForUser: async function(req, res) {
        try {
            const userId = req.params.userId;
            const foundOrders = await OrderModel.find({
                "user._id": userId
            }).sort({ createdOn: -1 });
            return res.json({ success: true, data: foundOrders });
        }
        catch(ex) {
            return res.json({ success: false, message: ex.message });
        }
    },

    updateOrderStatus: async function(req, res) {
        try {
            const { orderId, status, razorPayPaymentId, razorPaySignature } = req.body;
            const updatedOrder = await OrderModel.findOneAndUpdate(
                { _id: orderId },
                {
                    status: status,
                    razorPayPaymentId: razorPayPaymentId,
                    razorPaySignature: razorPaySignature
                },
                { new: true }
            );
            return res.json({ success: true, data: updatedOrder });
        }
        catch(ex) {
            return res.json({ success: false, message: ex.message });
        }
    }

};

module.exports = OrderController;
