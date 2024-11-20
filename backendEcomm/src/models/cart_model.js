const { Schema, model } = require('mongoose');

const cartItemSchema = new Schema({
    product: { type: Schema.Types.ObjectId, ref: 'Product', required: true },
    quantity: { type: Number, default: 1 }
});

const cartSchema = new Schema({
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    items: { type: [cartItemSchema], default: [] },
    createdOn: { type: Date, default: Date.now },
    updatedOn: { type: Date, default: Date.now }
});


cartSchema.pre('save', function(next) {
    if (this.isNew) {
        this.createdOn = new Date();
    }
    this.updatedOn = new Date();
    next();
});


cartSchema.pre(['updateOne', 'findOneAndUpdate', 'update'], function(next) {
    const update = this.getUpdate();
    if (update) {
        delete update._id; 
        this.setUpdate({ ...update, updatedOn: new Date() });
    }
    next();
});

const CartModel = model('Cart', cartSchema);
module.exports = CartModel;
