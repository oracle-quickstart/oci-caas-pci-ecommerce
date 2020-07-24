let token = document.querySelector('input[name="_csrf"]').value;
let loginForm = document.getElementById("login-form");
document.getElementById("submit-btn").addEventListener("click", authenticate);
document.getElementById("logout-btn").addEventListener("click", logout);

function authenticate() {
    fetch("/authenticate", {
        method: "POST",
        headers: {
            // "Content-Type": "multipart/form-data",
            'X-CSRF-Token': token
        },
        body: new FormData(loginForm)
    }).then(
        function (result) {
            console.log('res:' +JSON.stringify(result, null, 2));
    });
}
function logout() {
    fetch("/logout", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            'X-CSRF-Token': token
        },
    }).then(
        function (result) {
            console.log('res:' +JSON.stringify(result, null, 2));
        });
}
