<!DOCTYPE html>
<html lang="sk">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Prihlásenie</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }
    .login-container {
      background-color: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 0 15px rgba(0,0,0,0.1);
      width: 300px;
    }
    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 10px;
      margin: 10px 0;
      border: 1px solid #ccc;
      border-radius: 8px;
    }
    button {
      width: 100%;
      padding: 10px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 8px;
      cursor: pointer;
    }
    button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>

  <div class="login-container">
    <h2>Prihlásenie</h2>
    <form onsubmit="handleLogin(event)">
      <input type="text" id="username" placeholder="Používateľské meno" required>
      <input type="password" id="password" placeholder="Heslo" required>
      <button type="submit">Prihlásiť sa</button>
    </form>
    <p id="status" style="color: red; margin-top: 10px;"></p>
  </div>

  <script>
    function handleLogin(e) {
      e.preventDefault();
      const username = document.getElementById("username").value;
      const password = document.getElementById("password").value;

      // Demo kontrola (nahradiť backendom/Firebase)
      if (username === "admin" && password === "tajneheslo") {
        document.getElementById("status").style.color = "green";
        document.getElementById("status").innerText = "Úspešne prihlásený!";
      } else {
        document.getElementById("status").innerText = "Nesprávne údaje!";
      }
    }
  </script>

</body>
</html>

