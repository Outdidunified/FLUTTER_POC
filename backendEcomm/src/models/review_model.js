const { Schema, model } = require('mongoose');

const reviewSchema = new Schema({
    productId: { type: String, required: true },  // Use String instead of ObjectId
    userId: { type: String, required: true },     // Use String instead of ObjectId
    rating: { type: Number, min: 1, max: 5, required: true },
    comment: { type: String, default: "" },
    createdOn: { type: Date, default: Date.now },
    updatedOn: { type: Date, default: Date.now }
});

// Middleware to handle timestamps
reviewSchema.pre('save', function (next) {
    this.createdOn = new Date();
    this.updatedOn = new Date();
    next();
});

reviewSchema.pre(['update', 'findOneAndUpdate', 'updateOne'], function (next) {
    const update = this.getUpdate();
    delete update._id;
    update.updatedOn = new Date();
    next();
});

const ReviewModel = model('Review', reviewSchema);

module.exports = ReviewModel;
