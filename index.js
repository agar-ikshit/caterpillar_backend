const express = require('express');
const mongoose = require('mongoose');
const app = express();
const PORT = process.env.PORT || 3000
require('dotenv').config();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));


mongoose.connect(process.env.MONGO_URI, {
 
}).then(() => {
  console.log('Connected to MongoDB');
}).catch((err) => {
  console.error('Error connecting to MongoDB', err);
});





const userRoutes = require('./routes/userRoutes');
const inspectionRoutes = require('./routes/inspectionRoutes');

app.use('/api/inspections', inspectionRoutes); // Route for inspections
app.use('/api/users', userRoutes); // Route for users


app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

module.exports = app;
