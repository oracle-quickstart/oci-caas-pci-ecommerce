let token = document.querySelector('input[name="_csrf"]').value
document.getElementById("submit-btn").addEventListener("click", authenticate);
let uname;

function authenticate() {
    uname = document.getElementById("username").value;
    let psw = document.getElementById("password").value;
    let user_auth = {username: uname, password: psw};
    fetch("/register", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            'X-CSRF-Token': token
        },
        body: JSON.stringify(user_auth)
    })
    .then(r => r.json())
    .then(r => {
            //check if username is correct that is sent back or fail
            if (r.username == uname) {
                document.getElementById("success-alert").style.display = "block";
            } else {
                document.getElementById("fail-alert").style.display = "block";
            }
        });
}