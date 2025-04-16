// === VALIDATION FUNCTIONS === //

function validName() {
  const nameFields = document.getElementsByClassName('name');
  const nameErrors = document.getElementsByClassName('nameError');
  let isValid = true;

  for (let i = 0; i < nameFields.length; i++) {
    const nameField = nameFields[i];
    const nameError = nameErrors[i];
    const name = nameField.value;
    const nameRegex = /^[a-zA-Z\s]+$/;

    if (name === "") {
      nameError.textContent = "Name is required.";
      isValid = false;
    } else if (!nameRegex.test(name)) {
      nameError.textContent = "Name must contain only letters and spaces.";
      isValid = false;
    } else {
      nameError.textContent = "";
    }
  }

  return isValid;
}

function validUser() {
  let userName = document.getElementById('username').value;
  let userError = document.getElementById("userError");
  const userVal = /^[A-Za-z0-9@#%$]{6,10}$/;

  if (/\s/.test(userName)) {
    userError.innerText = "Username cannot contain spaces.";
    userError.style.display = "inline";
    return false;
  }

  if (userName.trim() === "") {
    userError.textContent = "Username is required.";
    userError.style.display = "inline";
    return false;
  } else if (!userVal.test(userName)) {
    userError.innerText = "Username must be 6-10 characters with letters or @, #, %, $.";
    userError.style.display = "inline";
    return false;
  } else {
    userError.style.display = "none";
    return true;
  }
}

function validPhone() {
  const phone = document.getElementById("phone").value;
  const phoneError = document.getElementById("phoneError");
  const phoneRegex = /^[0-9]{10}$/;

  if (phone === "") {
    phoneError.textContent = "Phone number is required.";
    return false;
  } else if (!phoneRegex.test(phone)) {
    phoneError.textContent = "Phone number must be 10 digits and contain no letters or spaces.";
    return false;
  } else {
    phoneError.textContent = "";
    return true;
  }
}

// === SUBMIT HANDLER === //

document.getElementById('userForm').addEventListener('submit', function (e) {
  e.preventDefault();

  const isNameValid = validName();
  const isUserValid = validUser();
  const isPhoneValid = validPhone();

  if (!isNameValid || !isUserValid || !isPhoneValid) {
    return;
  }

  const formData = {
    fname: document.getElementById('fname').value,
    lname: document.getElementById('lname').value,
    username: document.getElementById('username').value,
    phone: document.getElementById('phone').value,
    email: document.getElementById('email').value,
    pw: document.getElementById('pw').value,
  };

  fetch('http://localhost:3002/api/signup', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    credentials: 'include',
    body: JSON.stringify(formData)
  })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        // ✅ This line redirects the browser to /home.html
        window.location.href = data.redirect;
      } else {
        alert(data.message);
      }
    })
    .catch(err => {
      console.error('Signup error:', err);
      alert('Something went wrong during signup.');
    });

});
