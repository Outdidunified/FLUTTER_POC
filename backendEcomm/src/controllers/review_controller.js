const ReviewModel = require('../models/review_model');
const OrderModel = require('../models/order_model');
const ProductModel = require('../models/product_model');

const ReviewController = {
    // Add a review
    // Add a review
addReview: async function (req, res) {
    try {
        const { productId, userId, rating, comment } = req.body;

        // Check if product exists
        const product = await ProductModel.findOne({ _id: productId });
        if (!product) {
            return res.status(404).json({ success: false, message: "Product not found!" });
        }

        // Check if the user has purchased the product
        const purchase = await OrderModel.findOne({
            "user._id": userId,
            "items.product._id": productId,
            status: "order-placed"
        });

        if (!purchase) {
            return res.status(403).json({
                success: false,
                message: "You can only review products you have purchased."
            });
        }

        // Create and save the new review
        const newReview = new ReviewModel({
            productId,
            userId,
            rating,
            comment
        });

        await newReview.save();

        // Calculate the new average rating for the product
        const totalReviews = await ReviewModel.countDocuments({ productId });
        const allRatings = await ReviewModel.find({ productId }).select('rating');

        const newAverage = allRatings.reduce((acc, review) => acc + review.rating, 0) / totalReviews;
        product.averageRating = newAverage;

        await product.save();

        return res.status(201).json({ success: true, data: newReview, message: "Review added successfully!" });
    } catch (ex) {
        return res.status(500).json({ success: false, message: ex.message });
    }
}
,

    // Update a review
    updateReview: async function (req, res) {
        try {
            const { reviewId } = req.params;
            const { rating, comment } = req.body;

            const review = await ReviewModel.findById(reviewId);
            if (!review) {
                return res.status(404).json({ success: false, message: "Review not found!" });
            }

            const oldRating = review.rating;
            review.rating = rating;
            review.comment = comment;
            review.updatedOn = new Date();

            await review.save();

            // Incrementally update the average rating for the product
            const product = await ProductModel.findById(review.productId);
            const totalReviews = await ReviewModel.countDocuments({ productId: review.productId });

            const newAverage = (product.averageRating * totalReviews - oldRating + rating) / totalReviews;
            product.averageRating = newAverage;

            await product.save();

            return res.status(200).json({ success: true, data: review, message: "Review updated successfully!" });
        } catch (ex) {
            return res.status(500).json({ success: false, message: ex.message });
        }
    },

    // Get product reviews
    getProductReviews: async function (req, res) {
        try {
            const { productId } = req.params;

            const reviews = await ReviewModel.find({ productId });

            if (reviews.length === 0) {
                return res.status(404).json({ success: false, message: "No reviews found for this product!" });
            }

            // Calculate the average rating (if reviews exist)
            const averageRating = reviews.reduce((acc, review) => acc + review.rating, 0) / reviews.length;

            return res.status(200).json({
                success: true,
                data: {
                    reviews,
                    averageRating,
                },
                message: "Reviews fetched successfully!"
            });
        } catch (ex) {
            return res.status(500).json({ success: false, message: ex.message });
        }
    },

    // Delete a review
    deleteReview: async function (req, res) {
        try {
            const { reviewId } = req.params;

            const deletedReview = await ReviewModel.findByIdAndDelete(reviewId);
            if (!deletedReview) {
                return res.status(404).json({ success: false, message: "Review not found!" });
            }

            const product = await ProductModel.findById(deletedReview.productId);
            const totalReviews = await ReviewModel.countDocuments({ productId: deletedReview.productId });

            // Recalculate the average rating after deletion
            const newAverage = totalReviews > 0
                ? (product.averageRating * (totalReviews + 1) - deletedReview.rating) / totalReviews
                : 0;  // If no reviews remain, set average rating to 0

            product.averageRating = newAverage;
            await product.save();

            return res.status(200).json({ success: true, message: "Review deleted successfully!" });
        } catch (ex) {
            return res.status(500).json({ success: false, message: ex.message });
        }
    }
};

module.exports = ReviewController;
