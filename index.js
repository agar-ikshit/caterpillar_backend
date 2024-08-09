const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json()); // To parse JSON request bodies

// Simple GET route
app.get('/', (req, res) => {
  res.send('Hello, World!');
});

// POST route to receive data from Flutter app
app.post('/users', (req, res) => {
  const userData = req.body; // Extract the data sent from the Flutter app
  console.log('Received user data:', userData);

  // Respond back to the Flutter app
  res.status(200).json({ message: 'User data received successfully', data: userData });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

module.exports = app;
