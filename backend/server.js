const express = require('express');
const path = require('path');
const cors = require('cors');
const authRoutes = require('./routes/auth');

const app = express();
const PORT = 3002;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve everything from /public correctly
app.use(express.static(path.join(__dirname, '../public')));

// Routes
app.use('/api', authRoutes);

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/html/login.html'));
});

app.get('/signup.html', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/html/signup.html'));
});

app.get('/home.html', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/html/home.html'));
});

app.use(express.static(path.join(__dirname, '../frontend')));

const feedbackRoutes = require('./routes/feedback');
app.use('/api/feedback', feedbackRoutes);
app.get('/feedback.html', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/html/feedback.html'));
});


app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
