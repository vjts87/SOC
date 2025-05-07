<!DOCTYPE html>
<html lang="sk">
<head>
  <meta charset="UTF-8">
  <title>Prihlásenie</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f3f4f6;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }

    .login-box {
      background: white;
      padding: 24px;
      border-radius: 12px;
      box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
      width: 300px;
      text-align: center;
    }

    input {
      width: 100%;
      padding: 10px;
      margin-top: 12px;
      font-size: 16px;
      border: 1px solid #ccc;
      border-radius: 8px;
    }

    button {
      margin-top: 16px;
      padding: 10px;
      width: 100%;
      font-size: 16px;
      background: #3b82f6;
      color: white;
      border: none;
      border-radius: 8px;
      cursor: pointer;
    }

    .message {
      margin-top: 16px;
      font-size: 14px;
    }

    .success {
      color: green;
    }

    .error {
      color: red;
    }
  </style>
</head>
<body>

<div class="login-box">
  <h3>Prihlásenie</h3>
  <input type="password" id="passwordInput" placeholder="Zadaj heslo">
  <button onclick="checkPassword()">Prihlásiť sa</button>
  <div id="message" class="message"></div>
</div>

<script>
  const correctPassword = "1234";

  function checkPassword() {
    const input = document.getElementById("passwordInput").value.trim();
    const message = document.getElementById("message");

    if (input === correctPassword) {
      message.textContent = "Prihlásenie úspešné.";
      message.className = "message success";
    } else {
      message.textContent = "Nesprávne heslo. Skúste znova.";
      message.className = "message error";
    }
  }
</script>

</body>
</html>
