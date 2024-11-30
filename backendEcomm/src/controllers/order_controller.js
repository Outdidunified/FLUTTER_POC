
const OrderModel = require('./../models/order_model');
const CartModel = require('./../models/cart_model');
const razorpay = require('../razorpay');

const OrderController = {

    // Create Order (Same as before)
    createOrder: async function(req, res) {
        try {
            const { user, items, status, totalAmount } = req.body;

            // Create Order in RazorPay
            const razorPayOrder = await razorpay.orders.create({
                amount: totalAmount * 100,
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

            // Update the cart
            await CartModel.findOneAndUpdate(
                { user: user._id },
                { items: [] }
            );

            return res.json({ success: true, data: newOrder, message: "Order created!" });
        }
        catch(ex) {
            return res.json({ success: false, message: ex });
        }
    },

    // Fetch Orders for User (Same as before)
    fetchOrdersForUser: async function(req, res) {
        try {
            const userId = req.params.userId;
            const foundOrders = await OrderModel.find({
                "user._id": userId
            }).sort({ createdOn: -1 });
            return res.json({ success: true, data: foundOrders });
        }
        catch(ex) {
            return res.json({ success: false, message: ex });
        }
    },

    // Update Order Status (Same as before)
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
            return res.json({ success: false, message: ex });
        }
    },

    // Handle Pending Payment and Allow Completion
    completePayment: async function(req, res) {
        try {
            const { orderId, userId } = req.body;

            // Find the order by ID
            const order = await OrderModel.findById(orderId);

            if (!order) {
                return res.json({ success: false, message: "Order not found!" });
            }

            if (order.status !== "pending") {
                return res.json({ success: false, message: "Payment is already completed or cancelled!" });
            }

            // Initiate Razorpay payment again for pending payment
            const razorPayOrder = await razorpay.orders.create({
                amount: order.totalAmount * 100,
                currency: "INR"
            });

            // Update the order with the new Razorpay order ID (to allow completion of payment)
            order.razorPayOrderId = razorPayOrder.id;
            await order.save();

            return res.json({
                success: true,
                data: { razorPayOrderId: razorPayOrder.id },
                message: "Payment can now be completed."
            });

        } catch (ex) {
            return res.json({ success: false, message: ex });
        }
    }

};

module.exports = OrderController;
