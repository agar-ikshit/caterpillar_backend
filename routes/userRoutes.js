const express = require('express');
const User = require('../models/Users');
const router = express.Router();

router.post('/users', async (req, res) => {
  try {
    const userData = req.body;
    console.log('Received user data:', userData);

    const newUser = new User(userData);
    await newUser.save();

    res.status(200).json({ message: 'User data received and saved successfully', data: userData });
  } catch (err) {
    console.error('Error saving user data:', err);
    res.status(500).json({ message: 'Error saving user data', error: err });
  }
});

module.exports = router;
