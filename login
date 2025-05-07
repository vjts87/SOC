<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.20.0/cdn/themes/light.css" />
    <script type="module"
        src="https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.20.0/cdn/shoelace-autoloader.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://js.jotform.com/JotFormCustomWidget.min.js"></script>
    <style>
        body {
            margin: 0;
            font-family: "Inter", sans-serif;
            background: #f9f9f9;
        }

        #main {
            padding: 16px;
            max-width: 320px;
            margin: auto;
        }

        h3 {
            text-align: center;
            margin-bottom: 24px;
        }

        sl-input::part(base),
        sl-button::part(base) {
            transition: all 0.2s ease-in-out;
        }

        sl-input:hover::part(base) {
            border-color: #3b82f6;
        }

        sl-button::part(base):hover {
            background-color: #2563eb;
        }

        sl-button::part(base):active {
            transform: scale(0.98);
        }

        sl-alert {
            margin-top: 16px;
            animation: fade-in 0.4s ease forwards;
        }

        @keyframes fade-in {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        #counter {
            margin-top: 10px;
            text-align: center;
            font-size: 14px;
            color: #b91c1c;
        }
    </style>
</head>

<body>
    <div id="main">
        <!-- <h3 id="widgetTitle">Prihlásenie</h3> -->

        <sl-input id="codeInput" placeholder="Zadajte svoj prístupový kód" size="large" clearable
            style="width: 100%;"></sl-input>

        <sl-button id="submitBtn" variant="primary" size="large" style="width: 100%; margin-top: 12px;">
            Prihlásiť sa
        </sl-button>

        <div id="alertContainer"></div>
        <p id="counter" style="display: none;"></p>
    </div>

<script type="text/javascript">
    const successMessage = "Prihlásenie úspešné.";
    const errorMessage = "Neplatný kód. <br \> Skúste znova.";
    const serverErrorMessage = "Server error. <br \> S kúste znova neskôr.";

    const codeInput = document.getElementById("codeInput");
    const submitBtn = document.getElementById("submitBtn");
    const counter = document.getElementById("counter");
    const alertContainer = document.getElementById("alertContainer");

    function showAlert(message, type = "danger") {
        alertContainer.innerHTML = `
            <sl-alert variant="${type}" open closable>
            <sl-icon slot="icon" name="${type === 'success' ? 'check2-circle' : 'exclamation-triangle'}"></sl-icon>
            ${message}
            </sl-alert>`;
    }

    function startCooldown(duration) {
        let remainingTime = duration;
        counter.style.display = "block";
        submitBtn.disabled = true;

        const interval = setInterval(() => {
            remainingTime--;
            counter.textContent = `Počkajte ${remainingTime} sekúnd pred ďalším pokusom...`;

            if (remainingTime <= 0) {
                clearInterval(interval);
                counter.style.display = "none";
                submitBtn.disabled = false;
            }
        }, 1000);
    }

    JFCustomWidget.subscribe("ready", function () {
        const widgetSettings = JFCustomWidget.getWidgetSettings();

        // GENERAL SETTINGS
        const loginURL = widgetSettings.loginURL || "https://marketeam.up.railway.app/webhook/jfw/login";
        const codeLength = parseInt(widgetSettings.codeLength) || 6;
        const forceUppercase = widgetSettings.forceUppercase !== false;
        const cooldownTime = parseInt(widgetSettings.cooldownTime) || 5;
        const outputType = widgetSettings.outputType || "BOOL";
        
        // SHEET SETTINGS
        const sheetId = widgetSettings.sheetId || "NONE";
        const subsheetId = widgetSettings.subsheetId || "NONE";
        const ColName_CODE = widgetSettings.ColNameCODE || "KOD";
        const ColName_USERNAME = widgetSettings.ColNameUSERNAME || "MENO";
        const ColName_PERMISSION = widgetSettings.ColNamePERMISSION || "NONE";

        codeInput.setAttribute("maxlength", codeLength);
        const invalidLengthMessage = `Kód musí mať ${codeLength} znakov.`;

        function formatOutput(response, success) {
            switch (outputType) {
                case "JSON": return JSON.stringify(response);
                case "BOOL": return success;
                case "TEXT": return response.message || (success ? successMessage : errorMessage);
                default: return success;
            }
        }

        if (forceUppercase) {
            codeInput.addEventListener("input", function () {
                this.value = this.value.toUpperCase();
            });
        }

        submitBtn.addEventListener("click", async function () {
            const code = codeInput.value.trim();

            if (code.length !== codeLength) {
                showAlert(invalidLengthMessage, "warning");
                return;
            }

            submitBtn.loading = true;

            try {
                const url = new URL(loginURL);
                url.searchParams.set("code", code);
                url.searchParams.set("sheetId", sheetId || "NONE");
                url.searchParams.set("subsheetId", subsheetId || "NONE");
                url.searchParams.set("ColName_CODE", ColName_CODE || "NONE");
                url.searchParams.set("ColName_USERNAME", ColName_USERNAME || "NONE");
                url.searchParams.set("ColName_PERMISSION", ColName_PERMISSION || "NONE");

                const response = await axios.post(url.toString(), null, {
                    validateStatus: function (status) {
                        return true; // nondefault
                    },
                });

                const success = response.status === 200; /*&& response.data.authorized === "TRUE";*/

                submitBtn.loading = false;
                if (success) {
                    showAlert(successMessage, "success");

                    JFCustomWidget.sendData({
                        valid: true,
                        value: formatOutput(response.data, true)
                    });
                } else {
                    startCooldown(cooldownTime);

                    if (response.status === 401 ) {
                        showAlert("Neplatný kód. <br \> Skúste znova.", "danger");
                    } else if (response.status === 403) {
                        showAlert("Prístup zamietnutý. <br \> Skúste znova.", "danger");
                    } else if (response.status === 400 || response.status === 500 || response.status === 404) {
                        showAlert(serverErrorMessage, "danger");
                    } else {
                        showAlert("Neznáma chyba. <br \> Skúste znova.", "danger");
                    }

                    JFCustomWidget.sendData({
                        valid: false,
                        value: formatOutput(response.data || { error: "Request failed" }, false)
                    });
                }
            } catch (error) {
                console.error("Login error:", error);
                showAlert(errorMessage, "danger");

                submitBtn.loading = false;
                startCooldown(cooldownTime);

                JFCustomWidget.sendData({
                    valid: false,
                    value: formatOutput(error.response?.data || { error: "Request failed" }, false)
                });
            }
        });
    });
</script>
</body>

</html>
