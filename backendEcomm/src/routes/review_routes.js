const express = require('express');
const router = express.Router();
const ReviewController = require('../controllers/review_controller');


// Add a review (POST request)
router.post('/add', ReviewController.addReview);

// Get reviews for a product (GET request)
router.get('/:productId', ReviewController.getProductReviews);

// Delete a review (DELETE request)
//router.delete('/:reviewId', ReviewController.deleteReview);


module.exports = router;
