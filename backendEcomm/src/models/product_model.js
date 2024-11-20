const { Schema, model } = require('mongoose');

const productSchema = new Schema({
    chargerId: { type: String, required: true },
    chargerType: { type: String, required: true },
    maxCurrent: { type: Number, required: true },
    price: { type: Number, required: true },
    images: { type: [String], default: [] },
    brand: { type: String, required: true },
    chargingSpeed: { type: String, required: true },
    compatibility: { type: [String], required: true },
    warranty: { type: String, required: true },
    connectorType: { type: String, required: true },
    installationIncluded: { type: Boolean, required: true },
    stockAvailability: { type: Number, required: true },
    description: { type: String, default: "" },
    updatedOn: { type: Date },
    createdOn: { type: Date }
});

// Middleware to set timestamps before saving or updating
productSchema.pre('save', function(next) {
    this.updatedOn = new Date();
    this.createdOn = new Date();
    next();
});

productSchema.pre(['update', 'findOneAndUpdate', 'updateOne'], function(next) {
    const update = this.getUpdate();
    delete update._id;
    this.updatedOn = new Date();
    next();
});

const ProductModel = model('Product', productSchema);

module.exports = ProductModel;
