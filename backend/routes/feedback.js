const express = require('express');
const router = express.Router();
const db = require('../database');

// POST feedback
router.post('/', (req, res) => {
  const { username, comment } = req.body;

  if (!comment) {
    return res.status(400).json({ success: false, message: 'Comment is required.' });
  }

  const query = 'INSERT INTO Feedback (Username, Comment) VALUES (?, ?)';
  db.query(query, [username || 'Anonymous', comment], (err) => {
    if (err) {
      console.error('Insert feedback error:', err);
      return res.status(500).json({ success: false, message: 'Failed to submit feedback.' });
    }
    return res.status(200).json({ success: true });
  });
});

// GET all feedback
router.get('/', (req, res) => {
  const query = 'SELECT * FROM Feedback ORDER BY SubmittedAt DESC';
  db.query(query, (err, results) => {
    if (err) {
      console.error('Fetch feedback error:', err);
      return res.status(500).json({ success: false, message: 'Failed to load feedback.' });
    }
    res.json(results);
  });
});

module.exports = router;
