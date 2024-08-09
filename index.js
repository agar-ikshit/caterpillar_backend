const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json()); 


app.get('/', (req, res) => {
  res.send('Hello, World!');
});


app.post('/users', (req, res) => {
  const userData = req.body; 
  console.log('Received user data:', userData);

  res.status(200).json({ message: 'User data received successfully', data: userData });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

module.exports = app;
