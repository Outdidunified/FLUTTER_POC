const OrderRoutes = require('express').Router();
const OrderController = require('./../controllers/order_controller');

OrderRoutes.get("/:userId", OrderController.fetchOrdersForUser);
OrderRoutes.post("/", OrderController.createOrder);
OrderRoutes.put("/updateStatus", OrderController.updateOrderStatus);
OrderRoutes.put("/completePayment", OrderController.completePayment);


module.exports = OrderRoutes;