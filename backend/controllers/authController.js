const db = require('../database');


// ========================
// Signup Controller
// ========================
exports.signup = (req, res) => {
  const { fname, lname, username, phone, email, pw } = req.body;

  if (!fname || !lname || !username || !phone || !email || !pw) {
    return res.status(400).json({ success: false, message: 'All fields are required.' });
  }

  const checkQuery = 'SELECT * FROM Users WHERE Email = ? OR Username = ?';
  db.query(checkQuery, [email, username], (err, result) => {
    if (err) {
      console.error('Database check error:', err);
      return res.status(500).json({ success: false, message: 'Database error.' });
    }

    if (result.length > 0) {
      return res.status(400).json({ success: false, message: 'Email or username already exists.' });
    }

    const insertQuery = `
      INSERT INTO Users (FirstName, LastName, Username, PhoneNumber, Email, Password)
      VALUES (?, ?, ?, ?, ?, ?)
    `;

    db.query(insertQuery, [fname, lname, username, phone, email, pw], (err, results) => {
      if (err) {
        console.error('Signup error:', err);
        return res.status(500).json({ success: false, message: 'Signup failed.' });
      }

      return res.redirect('/home.html');
    });
  });
};

// ========================
// Login Controller
// ========================
exports.login = (req, res) => {
  const { email, pw } = req.body;

  if (!email || !pw) {
    return res.status(400).json({ success: false, message: 'Email and password are required.' });
  }

  const query = 'SELECT * FROM Users WHERE Email = ? AND Password = ?';

  db.query(query, [email, pw], (err, results) => {
    if (err) {
      console.error('Login error:', err);
      return res.status(500).json({ success: false, message: 'Login failed due to server error.' });
    }

    if (results.length > 0) {
      return res.status(200).json({ success: true, redirect: '/home.html' });
    } else {
      return res.status(401).json({ success: false, message: 'Invalid email or password.' });
    }
  });
};
